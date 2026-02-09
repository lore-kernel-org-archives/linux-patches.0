Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3FB2690EC;
	Mon,  9 Feb 2026 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648604; cv=none; b=Mq3PHt33+fUL5PwIkh6YAZK+QhFbGOdIYVXxNB5LafmOInzdVfPOgnCoKtargAYvR/WEzjUpjjlgnxPR+JfCLYWVDnuUoWUoqDj4+mt0tfkoyRvx+zBIFNvuNTafeAxNWlv9gRm2FiPO3YoIe/+Ta8S9HO7e07aWazq7IAIGOy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648604; c=relaxed/simple;
	bh=qu8cYPKdLtEJLZlPEZ9cE6RSLCpeYdq+mT/9TZXzqaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZteEvjH+bBQuYMVG8OHT52hntQNraId/QB+JID8Vrx47pThZmKS16nE41vF0IxA56J6LP38t0E7k/emm5HuOJAVjGHd9L+bx9yrUtenfV+T/485YmaDbxdXa1lUTntl9dcyWqW7Lhz3aIsxrbTuOj6RbJB9SV4pIzPEx8uJcT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVI1vlfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVI1vlfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D91C116C6;
	Mon,  9 Feb 2026 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648604;
	bh=qu8cYPKdLtEJLZlPEZ9cE6RSLCpeYdq+mT/9TZXzqaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVI1vlfrkubmgd6FLxqMEHorg8hiqkgDDUjZ4snUVRhHDw89TB1m2pM1hi48F001h
	 cw+WFdFpALqsmuc4H7Ugj3hNm6i3oCSYvC/nMlrU96YEyxjBzloaNp6aEz2DedfCQX
	 N58rMJH0XZqbxi/yfhs+BD1l6lWOrh+GmWYGfNuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/86] net: add skb_header_pointer_careful() helper
Date: Mon,  9 Feb 2026 15:24:23 +0100
Message-ID: <20260209142306.937870777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: cabd1a976375 ("net/sched: cls_u32: use skb_header_pointer_careful()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3a558a3c2cca8..69b392dc10aa3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4114,6 +4114,18 @@ skb_header_pointer(const struct sk_buff *skb, int offset, int len, void *buffer)
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
 static inline void * __must_check
 skb_pointer_if_linear(const struct sk_buff *skb, int offset, int len)
 {
-- 
2.51.0



