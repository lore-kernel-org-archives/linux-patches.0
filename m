Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C629213540D;
	Tue, 14 May 2024 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682644; cv=none; b=uXVVBPJR0CKO/Wm4ANEygyrC3nILMu+MwoBVElKyBlFrJW29d7qlGtJJrqULzg10asELujDx6jt/HKsNkHAJxkWnNx252eqWrVhdP3Stb8qyYQ6qR484f1rr7EZlJB0JuWTHWxU87U5Uv7+XUpXUlW1tFepbeARceteLwyVuWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682644; c=relaxed/simple;
	bh=eTffmI0HWeHA5Iigx5Nv77D0R1rj8AkRf57oPQ3bIFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atWHs8k76ZBQOwwhwvMhbX/FEdgXz8yid+Desh5W1vx09FYGjSOU8xABwMWn8Cb/4hGduP/Zhk0lu/zWfe3gA186G+stG8J+L2e2Zh2ShcrixnnCMYiD+qwnzr+6bvCeOVyrK2lg/tpW5qb9M/rBfi7m5WwK9LNNOQ7iaqgrncA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWeMDdT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWeMDdT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87EAC2BD10;
	Tue, 14 May 2024 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682644;
	bh=eTffmI0HWeHA5Iigx5Nv77D0R1rj8AkRf57oPQ3bIFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWeMDdT5xRfL71Ty97YyXXGkJ5ygUUCazhl6i+gkqQgcxiBafGscsf9b3oOOnyYWA
	 VX67AwY9O4oGMh8zho5ryRBKydriI2oPP3mQsMwyDcA0qdhF6cPGZYh6ft2DLkFvNY
	 ZvfvgMdpv8luBauWw7tG39mLPvgB6zFz0Wre2wVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 075/336] net: core: reject skb_copy(_expand) for fraglist GSO skbs
Date: Tue, 14 May 2024 12:14:39 +0200
Message-ID: <20240514101041.437620565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 71dee435d549d..570269c477549 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2014,11 +2014,17 @@ static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 
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
 
@@ -2346,12 +2352,17 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
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



