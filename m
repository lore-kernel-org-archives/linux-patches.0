Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533BD3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E97C4339C;
	Wed,  7 Jun 2023 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171474;
	bh=nUtwn1Z7kC3XfG1P+VdAVP3PCrcftdAWnDBPgsRheEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0R2c7C0hBzIhwREl+XBF8KzN7fWfkPVGrW0AqXc/AoDmAmHGPOormeYQXelbLxwQ
	 f2FH8oR6koxUQ/Bhqu+X1iQh5i+h0aYbU1iupLdeelPhVAK+YGWIiXl7ZIH+mums84
	 bELOPL852PtAQ0AX20GzeugF5ZR18R4L1xuVRH4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Efanov <VEfanov@ispras.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/159] udp6: Fix race condition in udp6_sendmsg & connect
Date: Wed,  7 Jun 2023 22:15:35 +0200
Message-ID: <20230607200904.719735977@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladislav Efanov <VEfanov@ispras.ru>

[ Upstream commit 448a5ce1120c5bdbce1f1ccdabcd31c7d029f328 ]

Syzkaller got the following report:
BUG: KASAN: use-after-free in sk_setup_caps+0x621/0x690 net/core/sock.c:2018
Read of size 8 at addr ffff888027f82780 by task syz-executor276/3255

The function sk_setup_caps (called by ip6_sk_dst_store_flow->
ip6_dst_store) referenced already freed memory as this memory was
freed by parallel task in udpv6_sendmsg->ip6_sk_dst_lookup_flow->
sk_dst_check.

          task1 (connect)              task2 (udp6_sendmsg)
        sk_setup_caps->sk_dst_set |
                                  |  sk_dst_check->
                                  |      sk_dst_set
                                  |      dst_release
        sk_setup_caps references  |
        to already freed dst_entry|

The reason for this race condition is: sk_setup_caps() keeps using
the dst after transferring the ownership to the dst cache.

Found by Linux Verification Center (linuxtesting.org) with syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2165,7 +2165,6 @@ void sk_setup_caps(struct sock *sk, stru
 {
 	u32 max_segs = 1;
 
-	sk_dst_set(sk, dst);
 	sk->sk_route_caps = dst->dev->features | sk->sk_route_forced_caps;
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
@@ -2180,6 +2179,7 @@ void sk_setup_caps(struct sock *sk, stru
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
+	sk_dst_set(sk, dst);
 }
 EXPORT_SYMBOL_GPL(sk_setup_caps);
 


