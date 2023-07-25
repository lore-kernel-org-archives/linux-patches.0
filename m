Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AEF14270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDD6C433C8;
	Tue, 25 Jul 2023 10:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282516;
	bh=f1vbqa+D9mzOGpLHlkbKJ2Wy1jqMng1a7gIbOnRIygQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtSh2J9yXueqU82zxY8MiyKc3R8cLsHisK01UQULlzKyUVYHww64gWS+B3lE3OzRg
	 F2hfXLQapoajXFpkmIYcgcJ0wJaYMyARIy5+lX42H4h6OFlOBxyysj/2m+nKJJ566Q
	 q+5jaS7zjl4Hl1GGoG5JS0XihXAczhrnYWWnN8jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Yan Zhai <yan@cloudflare.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 156/227] gso: fix dodgy bit handling for GSO_UDP_L4
Date: Tue, 25 Jul 2023 12:45:23 +0200
Message-ID: <20230725104521.387791248@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yan Zhai <yan@cloudflare.com>

[ Upstream commit 9840036786d90cea11a90d1f30b6dc003b34ee67 ]

Commit 1fd54773c267 ("udp: allow header check for dodgy GSO_UDP_L4
packets.") checks DODGY bit for UDP, but for packets that can be fed
directly to the device after gso_segs reset, it actually falls through
to fragmentation:

https://lore.kernel.org/all/CAJPywTKDdjtwkLVUW6LRA2FU912qcDmQOQGt2WaDo28KzYDg+A@mail.gmail.com/

This change restores the expected behavior of GSO_UDP_L4 packets.

Fixes: 1fd54773c267 ("udp: allow header check for dodgy GSO_UDP_L4 packets.")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 16 +++++++++++-----
 net/ipv6/udp_offload.c |  3 +--
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 1f01e15ca24fd..4a61832e7f69b 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -273,13 +273,20 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	__sum16 check;
 	__be16 newlen;
 
-	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
-
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
 		return ERR_PTR(-EINVAL);
 
+	if (skb_gso_ok(gso_skb, features | NETIF_F_GSO_ROBUST)) {
+		/* Packet is from an untrusted source, reset gso_segs. */
+		skb_shinfo(gso_skb)->gso_segs = DIV_ROUND_UP(gso_skb->len - sizeof(*uh),
+							     mss);
+		return NULL;
+	}
+
+	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
+
 	skb_pull(gso_skb, sizeof(*uh));
 
 	/* clear destructor to avoid skb_segment assigning it to tail */
@@ -387,8 +394,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 		goto out;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-	    !skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST))
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		return __udp_gso_segment(skb, features, false);
 
 	mss = skb_shinfo(skb)->gso_size;
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index c39c1e32f9804..e0e10f6bcdc18 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -42,8 +42,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 			goto out;
 
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-		    !skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST))
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 			return __udp_gso_segment(skb, features, true);
 
 		mss = skb_shinfo(skb)->gso_size;
-- 
2.39.2



