Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E61A8F79;
	Mon,  6 Jan 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179201; cv=none; b=YsnnH3SjMJsqFG7PFPLd++nXcq57ld0zJL6sSaOoPMr42LIqJee3dqPYDmkDAHg/prqpKi6vZ+yeGHaHwR/qaJSe8mCKwzVio3peXD/oeGTUjSop6vxZ+lgUbizxSP4/IARPmem6q5W3F+z0fKi/6SPRB8mGfR61Szoxnmj1mEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179201; c=relaxed/simple;
	bh=7H1HbcYDzFV9kqGBsKqlenWhj/o/Sfn3I5LHhEeQkXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAKMqCDLOzUOg2wTQfbIjT41lSn8YLE/Kw9bwrHTSLEdqqk6rCefqs8Sd2aiF6kj223YPE9ffWw84hZydaA5zgI4NqAxzEnFr0zIbXS9j2bz4qQ6tnySD+2BJ3TIatHw4Lm6M9YgvWijkFBNSrASem7XE4cKKjZzCNcKxlOE8xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjWQmbKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjWQmbKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC499C4CED2;
	Mon,  6 Jan 2025 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179201;
	bh=7H1HbcYDzFV9kqGBsKqlenWhj/o/Sfn3I5LHhEeQkXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjWQmbKYgrnMGyA7C0qMWtlvE8lcfsPUIUTxBND+MinTAh2rPPylpc11BU8iLxMb3
	 W8HLTV5zgjMC41NOZpD7cr56BXF5LidFiA+4ws5NZkdsmmymUyDqh3nldp2ZATaZWJ
	 VZudphmxYRIuVdFjyJKRuWm3Gx6hOCML322/EM1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <christoph.paasch@gmail.com>,
	Vasily Averin <vvs@virtuozzo.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 60/93] skb_expand_head() adjust skb->truesize incorrectly
Date: Mon,  6 Jan 2025 16:17:36 +0100
Message-ID: <20250106151130.971492292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@virtuozzo.com>

commit 7f678def99d29c520418607509bb19c7fc96a6db upstream.

Christoph Paasch reports [1] about incorrect skb->truesize
after skb_expand_head() call in ip6_xmit.
This may happen because of two reasons:
- skb_set_owner_w() for newly cloned skb is called too early,
before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
- pskb_expand_head() does not adjust truesize in (skb->sk) case.
In this case sk->sk_wmem_alloc should be adjusted too.

[1] https://lkml.org/lkml/2021/8/20/1082

Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
Fixes: 2d85a1b31dde ("ipv6: ip6_finish_output2: set sk into newly allocated nskb")
Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/644330dd-477e-0462-83bf-9f514c41edd1@virtuozzo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)
 create mode 100644 net/core/sock_destructor.h

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -77,6 +77,7 @@
 #include <linux/indirect_call_wrapper.h>
 
 #include "datagram.h"
+#include "sock_destructor.h"
 
 struct kmem_cache *skbuff_head_cache __ro_after_init;
 static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
@@ -1741,30 +1742,39 @@ EXPORT_SYMBOL(skb_realloc_headroom);
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
 	int delta = headroom - skb_headroom(skb);
+	int osize = skb_end_offset(skb);
+	struct sock *sk = skb->sk;
 
 	if (WARN_ONCE(delta <= 0,
 		      "%s is expecting an increase in the headroom", __func__))
 		return skb;
 
-	/* pskb_expand_head() might crash, if skb is shared */
-	if (skb_shared(skb)) {
+	delta = SKB_DATA_ALIGN(delta);
+	/* pskb_expand_head() might crash, if skb is shared. */
+	if (skb_shared(skb) || !is_skb_wmem(skb)) {
 		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
 
-		if (likely(nskb)) {
-			if (skb->sk)
-				skb_set_owner_w(nskb, skb->sk);
-			consume_skb(skb);
-		} else {
-			kfree_skb(skb);
-		}
+		if (unlikely(!nskb))
+			goto fail;
+
+		if (sk)
+			skb_set_owner_w(nskb, sk);
+		consume_skb(skb);
 		skb = nskb;
 	}
-	if (skb &&
-	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
-		kfree_skb(skb);
-		skb = NULL;
+	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC))
+		goto fail;
+
+	if (sk && is_skb_wmem(skb)) {
+		delta = skb_end_offset(skb) - osize;
+		refcount_add(delta, &sk->sk_wmem_alloc);
+		skb->truesize += delta;
 	}
 	return skb;
+
+fail:
+	kfree_skb(skb);
+	return NULL;
 }
 EXPORT_SYMBOL(skb_expand_head);
 


