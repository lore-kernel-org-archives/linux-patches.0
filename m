Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A66E4FD27C;
	Wed, 30 Sep 2026 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783996; cv=none; b=a/M5ppC3OOOB432sZICoEDEh7EgBgftuj9XVjvrexLkxRoPAhCDAsHS0+U3IBH6gcDOkddtiRISzN8Fj+x853R6jCLTAfL6G+HgLYHSqLtA5cLAEBPHhPooHJfkG6f9UCb5uhsnqUrJwh77MifwLRixsul/P+cCx0pds33P/F10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783996; c=relaxed/simple;
	bh=XdCm0UHdz7lgBP7iTTNZ+GJeeLa0CJCwuBYZm+VkGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K64QnJmm71QDe1WfIess23UyVOiEZ46ycBaLoeKUTdXolOW/Nhb3K32sWjTGk5Xe6tVykN8Rdv7O/vP2HoBj8LewUNN6J0QrnngdAxCa6wzEdpc9X057TU3IfABOvIqKDsAj+gBx2xFbnq8DPPmoiZYKjeAxDPu23ZeAlct1oG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WKqFYWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WKqFYWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F831F000FF;
	Wed, 30 Sep 2026 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783991;
	bh=WoBewaayb4zXyFfyh7an5CrqejKHgHMWGB9PDkjCvpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WKqFYWrotr+5DrQCoc3WcjOiW8Gw9yq4vrgPO6HSMvZ37Lm2SKskg7UruRN2rp1m
	 ASvGO4vw+7o48DgSZeUxb5P8WO94VO5XRZHOdrLq+VB9PKCTMJdI6qK9Aj7kX8UtrU
	 pQ6SiOBqvUcLPobYFQSuQbGm2Safj/cNaptVqYxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 549/595] net: add skb_set_end_offset() helper
Date: Wed, 30 Sep 2026 17:27:22 +0200
Message-ID: <20260930152359.523844457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

commit 763087dab97547230a6807c865a6a5ae53a59247 upstream.

We have multiple places where this helper is convenient,
and plan using it in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/core/skbuff.c      | 19 +++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 80de69bf9586a..34b6a7e3af8d8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1416,6 +1416,11 @@ static inline unsigned int skb_end_offset(const struct sk_buff *skb)
 {
 	return skb->end;
 }
+
+static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
+{
+	skb->end = offset;
+}
 #else
 static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
@@ -1426,6 +1431,11 @@ static inline unsigned int skb_end_offset(const struct sk_buff *skb)
 {
 	return skb->end - skb->head;
 }
+
+static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
+{
+	skb->end = skb->head + offset;
+}
 #endif
 
 /* Internal */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e20ecc44f7555..39ecb52f507c9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -278,7 +278,7 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
 	skb->head = data;
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
-	skb->end = skb->tail + size;
+	skb_set_end_offset(skb, size);
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 	skb->transport_header = (typeof(skb->transport_header))~0U;
 
@@ -1686,11 +1686,10 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	skb->head     = data;
 	skb->head_frag = 0;
 	skb->data    += off;
+
+	skb_set_end_offset(skb, size);
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end      = size;
 	off           = nhead;
-#else
-	skb->end      = skb->head + size;
 #endif
 	skb->tail	      += off;
 	skb_headers_offset_update(skb, nhead);
@@ -6115,11 +6114,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	skb->head = data;
 	skb->data = data;
 	skb->head_frag = 0;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end = size;
-#else
-	skb->end = skb->head + size;
-#endif
+	skb_set_end_offset(skb, size);
 	skb_set_tail_pointer(skb, skb_headlen(skb));
 	skb_headers_offset_update(skb, 0);
 	skb->cloned = 0;
@@ -6259,11 +6254,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	skb->head = data;
 	skb->head_frag = 0;
 	skb->data = data;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end = size;
-#else
-	skb->end = skb->head + size;
-#endif
+	skb_set_end_offset(skb, size);
 	skb_reset_tail_pointer(skb);
 	skb_headers_offset_update(skb, 0);
 	skb->cloned   = 0;
-- 
2.53.0



