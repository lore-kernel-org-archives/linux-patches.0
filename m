Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C271607AA;
	Mon,  6 Jan 2025 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178289; cv=none; b=bQqjrRaeHE8stgjWU6hoL6sFv1QDzIrdm4BxG8Ci7KGqmlFe+P91CVI7Ol6OAjy/g4G5RIfqtPWqQeKacXvsw5KScG+zMOdpR+TA0ZvbGHcUpRMbR6jdk2bPq45dIfxHiplA8Fnyf8mqrgCXCqQjJNxPPbaEahgSi4kNxENWP7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178289; c=relaxed/simple;
	bh=gO+AILaL3oTM1BFBnZ7bnGjn1O10Pnb6UEHrkOAdRAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx4cuwbg+xFCewLSYfJhlcMZKYp8i3Kva/Lzw/XBtPPXKopN4GFC49wWl/laOx3/hjQtYXh+Y8vFKNxH08Icf77Wl+GRKmzqdhCvySN7sGtRdi7HBog81Jt917pH7/UfoROu5nVWg0tDxsBd7M9OOC+WrrVhboJwf1HNXlV3Cx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcwY2GVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcwY2GVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3B5C4CED2;
	Mon,  6 Jan 2025 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178288;
	bh=gO+AILaL3oTM1BFBnZ7bnGjn1O10Pnb6UEHrkOAdRAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcwY2GVH/rju7BjVLw33SnAx8LAZzX9xS9zNIVFgkjyUD1h9VEP6EGsyAvBL6P59D
	 gTuzJr86w+7DM2QdsCNHUkDBl6BThiOpISXZ+4a8Rhkon6YxZP9pX/iDNhpJeFhzSY
	 BDnQPFN0Z5to+wmaWnp7OpCRGK6X57+d2kp1X2hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	"David S. Miller" <davem@davemloft.net>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/138] skbuff: introduce skb_expand_head()
Date: Mon,  6 Jan 2025 16:16:33 +0100
Message-ID: <20250106151135.845720870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit f1260ff15a71b8fc122b2c9abd8a7abffb6e0168 ]

Like skb_realloc_headroom(), new helper increases headroom of specified skb.
Unlike skb_realloc_headroom(), it does not allocate a new skb if possible;
copies skb->sk on new skb when as needed and frees original skb in case
of failures.

This helps to simplify ip[6]_finish_output2() and a few other similar cases.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit f1260ff15a71b8fc122b2c9abd8a7abffb6e0168)
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 31ae4b74d435..3248e4aeec03 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1166,6 +1166,7 @@ static inline struct sk_buff *__pskb_copy(struct sk_buff *skb, int headroom,
 int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail, gfp_t gfp_mask);
 struct sk_buff *skb_realloc_headroom(struct sk_buff *skb,
 				     unsigned int headroom);
+struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom);
 struct sk_buff *skb_copy_expand(const struct sk_buff *skb, int newheadroom,
 				int newtailroom, gfp_t priority);
 int __must_check skb_to_sgvec_nomark(struct sk_buff *skb, struct scatterlist *sg,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b0c2d6f01800..fa3ea287d6ec 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1732,6 +1732,48 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 }
 EXPORT_SYMBOL(skb_realloc_headroom);
 
+/**
+ *	skb_expand_head - reallocate header of &sk_buff
+ *	@skb: buffer to reallocate
+ *	@headroom: needed headroom
+ *
+ *	Unlike skb_realloc_headroom, this one does not allocate a new skb
+ *	if possible; copies skb->sk to new skb as needed
+ *	and frees original skb in case of failures.
+ *
+ *	It expect increased headroom and generates warning otherwise.
+ */
+
+struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
+{
+	int delta = headroom - skb_headroom(skb);
+
+	if (WARN_ONCE(delta <= 0,
+		      "%s is expecting an increase in the headroom", __func__))
+		return skb;
+
+	/* pskb_expand_head() might crash, if skb is shared */
+	if (skb_shared(skb)) {
+		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
+		if (likely(nskb)) {
+			if (skb->sk)
+				skb_set_owner_w(nskb, skb->sk);
+			consume_skb(skb);
+		} else {
+			kfree_skb(skb);
+		}
+		skb = nskb;
+	}
+	if (skb &&
+	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+		kfree_skb(skb);
+		skb = NULL;
+	}
+	return skb;
+}
+EXPORT_SYMBOL(skb_expand_head);
+
 /**
  *	skb_copy_expand	-	copy and expand sk_buff
  *	@skb: buffer to copy
-- 
2.39.5



