Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8475628369
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IT/dpcE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3300BC4E779;
	Wed, 15 Nov 2023 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081604;
	bh=pOoNoAbUeKvvdmUUGogP6x2c8L200QxAVwzI3mQfzvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IT/dpcE286Gr6t4Mx4nwFzZWs4ZT8jP09MZDDh5NjFDXh6h6TG3yhcvW/gcxaa7dN
	 pcwxutbnKsCa2KC7ScNqk4kwtK5aKpNQjHOdkz+0JXi4deit53wKp8lFlAQoOn2TO+
	 fXShW2E2GxJnO+ZBDMlpp2FEbuII5TP78Q7Iwc1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/191] udp: add missing WRITE_ONCE() around up->encap_rcv
Date: Wed, 15 Nov 2023 15:44:46 -0500
Message-ID: <20231115204645.188652078@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6d5a12eb91224d707f8691dccb40a5719fe5466d ]

UDP_ENCAP_ESPINUDP_NON_IKE setsockopt() writes over up->encap_rcv
while other cpus read it.

Fixes: 067b207b281d ("[UDP]: Cleanup UDP encapsulation code")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 913966e7703fc..476f79f1563a8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2645,10 +2645,12 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 #if IS_ENABLED(CONFIG_IPV6)
 			if (sk->sk_family == AF_INET6)
-				up->encap_rcv = ipv6_stub->xfrm6_udp_encap_rcv;
+				WRITE_ONCE(up->encap_rcv,
+					   ipv6_stub->xfrm6_udp_encap_rcv);
 			else
 #endif
-				up->encap_rcv = xfrm4_udp_encap_rcv;
+				WRITE_ONCE(up->encap_rcv,
+					   xfrm4_udp_encap_rcv);
 #endif
 			fallthrough;
 		case UDP_ENCAP_L2TPINUDP:
-- 
2.42.0



