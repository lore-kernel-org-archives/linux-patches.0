Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE9A9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C90C433C9;
	Sun, 13 Aug 2023 21:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962716;
	bh=6zJ6Zzle7ZjsASV2cWQYABLXhNEGH5s7zQXMoKf/G6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9N1GhNY98ySyRqF0YU0UR9/IsVM9i9iJzKkshmxcksLN7dt2c3QevIVBbp7rI07w
	 1gpDU3YOrPcouJd5NBItegLG++1T5xploNhMy5THrvKYqcd9c7d76//auoGfRXbM19
	 y+AawDnLsrNIZVOKYxquEC/x9Dm4Zisvzf/b8HFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Kanner <andrew.kanner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 096/149] drivers: net: prevent tun_build_skb() to exceed the packet size limit
Date: Sun, 13 Aug 2023 23:19:01 +0200
Message-ID: <20230813211721.661432505@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Kanner <andrew.kanner@gmail.com>

commit 59eeb232940515590de513b997539ef495faca9a upstream.

Using the syzkaller repro with reduced packet size it was discovered
that XDP_PACKET_HEADROOM is not checked in tun_can_build_skb(),
although pad may be incremented in tun_build_skb(). This may end up
with exceeding the PAGE_SIZE limit in tun_build_skb().

Jason Wang <jasowang@redhat.com> proposed to count XDP_PACKET_HEADROOM
always (e.g. without rcu_access_pointer(tun->xdp_prog)) in
tun_can_build_skb() since there's a window during which XDP program
might be attached between tun_can_build_skb() and tun_build_skb().

Fixes: 7df13219d757 ("tun: reserve extra headroom only when XDP is set")
Link: https://syzkaller.appspot.com/bug?extid=f817490f5bd20541b90a
Signed-off-by: Andrew Kanner <andrew.kanner@gmail.com>
Link: https://lore.kernel.org/r/20230803185947.2379988-1-andrew.kanner@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1588,7 +1588,7 @@ static bool tun_can_build_skb(struct tun
 	if (zerocopy)
 		return false;
 
-	if (SKB_DATA_ALIGN(len + TUN_RX_PAD) +
+	if (SKB_DATA_ALIGN(len + TUN_RX_PAD + XDP_PACKET_HEADROOM) +
 	    SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) > PAGE_SIZE)
 		return false;
 


