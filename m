Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445CA27A477;
	Sat, 30 May 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162997; cv=none; b=unjYPNnFG4fFXFnpmcR60rx1SI5GFSLpYYLh6mPrmuEggRuNLG1pX1PAyILFkobyoK3Rm67PuUXDlewqCFEGCzhJHajmxlDkTw2sKwoCoUv+qks/CjBMKw3x4PWg2X++XJkPHvSCD62S9nj+iFXKpIPihZwAFPUJEB++6Qkt004=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162997; c=relaxed/simple;
	bh=JUa2KFXFFItBsQWs8wy+jVG++waJsitfg4f5eUN6BZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RasTGHuNv22bW2IuN2Dej47Nz0CpWqR38S+RLz9qEpNq7OLCdmR72Jpz8/ooyAXUyITKIQHsYtaxQs1SFtIxp7VdlZFfujCMd6x69Y7yKIHD2YQRZs/ZONeTmLLy/C6wphz2pXdzPg7koO9sBrmWetTKuZCXqSKj81VkekF/Bek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTilf98n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTilf98n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883C41F00893;
	Sat, 30 May 2026 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162996;
	bh=evwSfqe38RvyXN101sbBnfVQDerwndRCM6E8bPR1FcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTilf98nwdCL6ti/arbxjP+n0kCsjY0QupwuGO6QQFCytWc/lOH3Pf5A1JCz2vqW7
	 Jw4t5Xfwi6DsQd6lKVOgV0nbHL2e9G8A4rLP/rFgFgGBOAMSEivSn2rlxTqVbm18Tl
	 4JPWlzu2Y5dmry57m8X5rUHXqzyjVXysKKJHuxPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.15 126/776] net: add skb_header_pointer_careful() helper
Date: Sat, 30 May 2026 17:57:20 +0200
Message-ID: <20260530160243.633477123@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 include/linux/skbuff.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3869,6 +3869,18 @@ skb_header_pointer(const struct sk_buff
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


