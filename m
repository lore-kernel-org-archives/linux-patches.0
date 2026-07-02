Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A803438A9;
	Thu,  2 Jul 2026 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009338; cv=none; b=AcbfyJzGIEBwK/88GgjgSRvEuoN15n6esvMCciBnAOi2+RWPdnrt8rR62eb/4O7mRQWL02ju+qCimuZYdNvvCr2iQ3MrpgPwfpmE+XS3U6qA/DhYgETHcBTe1LyPO3jYFywS+BNhydAz8QsUi70M5MosRbDjGlXnc41smzYKhkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009338; c=relaxed/simple;
	bh=suokn4WRv9taXvfjlhzfSWKU2149gcZ9FJf56J9U9rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alP4UjtcuzWZXBDOFhq8S/i1D6Ab1jmV4+dpHooPq7T6KSAskaNK6mDYxSOwbz4FyAOs/WYplHncps1u4NlNDOHhQNkm746NkogOh+2ZNhRy/xk8Ur08D1AGw2g6KdETpntyAKMEwXsQQJIIE24SqG3QLdHDnbguROafTzTVSF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phUn3XrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phUn3XrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A671E1F000E9;
	Thu,  2 Jul 2026 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009337;
	bh=hXBw/BudTdb9VsSZhNJiPUO9fFFVlYSLtKRRc5LzBEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phUn3XrW14W8b1TvUY2/4Jz0yl41r6Fwqp4Wj1RpVc3NvtEzIXr3A33QyLxxXZ4ID
	 1afGn0XKsScJMNYDI6KMvnnzTb5kyQOBYXcNc4sSHbdNS05RRL2m9P+NqI79Fe1hgk
	 B0y8lnXYkDMdbakUL1+22eS7yg2Et7IjgUKTuljE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <lanbincn@139.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/96] net: add skb_header_pointer_careful() helper
Date: Thu,  2 Jul 2026 18:19:06 +0200
Message-ID: <20260702155109.284472553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 13e00fdc9236bd4d0bff4109d2983171fbcb74c4 ]

This variant of skb_header_pointer() should be used in contexts
where @offset argument is user-controlled and could be negative.

Negative offsets are supported, as long as the zone starts
between skb->head and skb->data.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260128141539.3404400-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Shivani: Modified to apply on 5.10.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4b5731245bf15b..667de403b2ebbd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3686,6 +3686,18 @@ skb_header_pointer(const struct sk_buff *skb, int offset, int len, void *buffer)
 				    skb_headlen(skb), buffer);
 }
 
+/* Variant of skb_header_pointer() where @offset is user-controlled
+ * and potentially negative.
+ */
+static inline void * __must_check
+skb_header_pointer_careful(const struct sk_buff *skb, int offset,
+			   int len, void *buffer)
+{
+	if (unlikely(offset < 0 && -offset > skb_headroom(skb)))
+		return NULL;
+	return skb_header_pointer(skb, offset, len, buffer);
+}
+
 /**
  *	skb_needs_linearize - check if we need to linearize a given skb
  *			      depending on the given device features.
-- 
2.53.0



