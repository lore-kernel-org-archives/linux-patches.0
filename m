Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856E712BEA5;
	Tue, 14 May 2024 11:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684693; cv=none; b=EVYtT7CMVlrJlMMOjl9P76/l9t2Ob3XRRa1YHmIqE3sGM3D1uLm3FDOsQssHjteDwrhXtYF55D3HNIHgKYB1htdf0mbiA+6LCXly+qU00QfzU4LiMl9TYIyWMXjFOvhdi72GsqNWvxnJjMjaJsr6HNJO4sk9yAABWL0S8Uk1Unc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684693; c=relaxed/simple;
	bh=noacSckRY1a96ZMhGBT54mfmE5kJY/vlD4gXD+MbZiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FphgnCqT0CTCgx+nXFDo9sJVo4Z4mQO5ttrpkT5Oqv0ufdc8WcOUeAJ29klq2V3D1KpRLx1JRdu6x8NI5Q/4GpqQiCrThfyu5ZJq2DNeIxBrzMktZwNyiiGfVNQlvEjYdJnj2F8XQqhS5W8kVp0iIQx36seVtiEZ4BsgbWebOBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Teac0xiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Teac0xiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C1BC2BD10;
	Tue, 14 May 2024 11:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684693;
	bh=noacSckRY1a96ZMhGBT54mfmE5kJY/vlD4gXD+MbZiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Teac0xiJWxtP5zCG6MnHyvF6LYATVJ92hjR3aw+zXjWOHcRgrqalX7Z7erbxBkcFl
	 sY7va0FWJzX7/ch21HVYT7Y7yZA/oElcFBrcLjvVG7VwFB7q+7QPdYILEUCryOe18d
	 ofVMFzgvaZtr15Y54Vb/7PgAR+OOEpKUW2FULHCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/301] net: core: reject skb_copy(_expand) for fraglist GSO skbs
Date: Tue, 14 May 2024 12:15:48 +0200
Message-ID: <20240514101035.156871034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d091e579b864fa790dd6a0cd537a22c383126681 ]

SKB_GSO_FRAGLIST skbs must not be linearized, otherwise they become
invalid. Return NULL if such an skb is passed to skb_copy or
skb_copy_expand, in order to prevent a crash on a potential later
call to skb_gso_segment.

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 60876262b3fb3..f0a9ef1aeaa29 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1971,11 +1971,17 @@ static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 
 struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 {
-	int headerlen = skb_headroom(skb);
-	unsigned int size = skb_end_offset(skb) + skb->data_len;
-	struct sk_buff *n = __alloc_skb(size, gfp_mask,
-					skb_alloc_rx_flag(skb), NUMA_NO_NODE);
+	struct sk_buff *n;
+	unsigned int size;
+	int headerlen;
+
+	if (WARN_ON_ONCE(skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST))
+		return NULL;
 
+	headerlen = skb_headroom(skb);
+	size = skb_end_offset(skb) + skb->data_len;
+	n = __alloc_skb(size, gfp_mask,
+			skb_alloc_rx_flag(skb), NUMA_NO_NODE);
 	if (!n)
 		return NULL;
 
@@ -2303,12 +2309,17 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
 	/*
 	 *	Allocate the copy buffer
 	 */
-	struct sk_buff *n = __alloc_skb(newheadroom + skb->len + newtailroom,
-					gfp_mask, skb_alloc_rx_flag(skb),
-					NUMA_NO_NODE);
-	int oldheadroom = skb_headroom(skb);
 	int head_copy_len, head_copy_off;
+	struct sk_buff *n;
+	int oldheadroom;
+
+	if (WARN_ON_ONCE(skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST))
+		return NULL;
 
+	oldheadroom = skb_headroom(skb);
+	n = __alloc_skb(newheadroom + skb->len + newtailroom,
+			gfp_mask, skb_alloc_rx_flag(skb),
+			NUMA_NO_NODE);
 	if (!n)
 		return NULL;
 
-- 
2.43.0



