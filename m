Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDC41A9FAF;
	Mon,  4 May 2026 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904044; cv=none; b=FGFP+amjybxrhDBhzI8fTmLLVAWjtyNu2fyVSUAB+cu57XImZSZxzpX386hw8zR0QRvextiCq5ekSueZPoN7Rebj/iUzPVz67v08DqgstS2s72TwVwIlUoLNtMl5vm+N0SKqFW5SC6jyFTuDub6bXkX0N9N7CZZ1g4/HGuAWxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904044; c=relaxed/simple;
	bh=xw7KMhsEKdGllxZ3xEZdCDsiKozC28k4aEtdt7TcOVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtsFzqLD3l067nXah+5L8kaaNgaMzCbZ1OYHODPrqscyW2F7U+QF1oRnB7idOAXn3AtoFeHcRbS622171XlWl1NNHk7hAIL14FUKDaiPf8qFDf5yDX775GYwrY/Zm9wvgZmr0J2E5epPs2N/Zg4NcN08Jcngfuq9fOZ9my90vpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBgpJBw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBgpJBw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97689C2BCF4;
	Mon,  4 May 2026 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904043;
	bh=xw7KMhsEKdGllxZ3xEZdCDsiKozC28k4aEtdt7TcOVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBgpJBw8BhOfYLALNYHTkVok8kHRQ7wWTt81hUhLft1X+eFl4m+xWXlVomjzBkGfM
	 HFdyykIQPCYZgQlgNhk1pLpQXBjlTSwzOTqHkXjF7A6PkG7QIW0hemL42+L9cRDEiL
	 SbpB+w/TIaxHADnj08BqX3s2zBEcOtPQHcWHoZ/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 129/275] slub: fix data loss and overflow in krealloc()
Date: Mon,  4 May 2026 15:51:09 +0200
Message-ID: <20260504135147.695247263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

commit 082a6d03a2d685a83a332666b500ad3966349588 upstream.

Commit 2cd8231796b5 ("mm/slub: allow to set node and align in
k[v]realloc") introduced the ability to force a reallocation if the
original object does not satisfy new alignment or NUMA node, even when
the object is being shrunk.

This introduced two bugs in the reallocation fallback path:

1. Data loss during NUMA migration: The jump to 'alloc_new' happens
   before 'ks' and 'orig_size' are initialized. As a result, the
   memcpy() in the 'alloc_new' block would copy 0 bytes into the new
   allocation.

2. Buffer overflow during shrinking: When shrinking an object while
   forcing a new alignment, 'new_size' is smaller than the old size.
   However, the memcpy() used the old size ('orig_size ?: ks'), leading
   to an out-of-bounds write.

The same overflow bug exists in the kvrealloc() fallback path, where the
old bucket size ksize(p) is copied into the new buffer without being
bounded by the new size.

A simple reproducer:

	// e.g. add to lkdtm as KREALLOC_SHRINK_OVERFLOW
	while (1) {
		void *p = kmalloc(128, GFP_KERNEL);
		p = krealloc_node_align(p, 64, 256, GFP_KERNEL, NUMA_NO_NODE);
		kfree(p);
	}

demonstrates the issue:

  ==================================================================
  BUG: KFENCE: out-of-bounds write in memcpy_orig+0x68/0x130

  Out-of-bounds write at 0xffff8883ad757038 (120B right of kfence-#47):
   memcpy_orig+0x68/0x130
   krealloc_node_align_noprof+0x1c8/0x340
   lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
   lkdtm_do_action+0x3a/0x60 [lkdtm]
   ...

  kfence-#47: 0xffff8883ad756fc0-0xffff8883ad756fff, size=64, cache=kmalloc-64

  allocated by task 316 on cpu 7 at 97.680481s (0.021813s ago):
   krealloc_node_align_noprof+0x19c/0x340
   lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
   lkdtm_do_action+0x3a/0x60 [lkdtm]
   ...
  ==================================================================

Fix it by moving the old size calculation to the top of __do_krealloc()
and bounding all copy lengths by the new allocation size.

Fixes: 2cd8231796b5 ("mm/slub: allow to set node and align in k[v]realloc")
Cc: stable@vger.kernel.org
Reported-by: https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
Signed-off-by: Marco Elver <elver@google.com>
Link: https://patch.msgid.link/20260416132837.3787694-1-elver@google.com
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6999,16 +6999,6 @@ __do_krealloc(const void *p, size_t new_
 	if (!kasan_check_byte(p))
 		return NULL;
 
-	/*
-	 * If reallocation is not necessary (e. g. the new size is less
-	 * than the current allocated size), the current allocation will be
-	 * preserved unless __GFP_THISNODE is set. In the latter case a new
-	 * allocation on the requested node will be attempted.
-	 */
-	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
-		     nid != page_to_nid(virt_to_page(p)))
-		goto alloc_new;
-
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
@@ -7027,6 +7017,16 @@ __do_krealloc(const void *p, size_t new_
 		}
 	}
 
+	/*
+	 * If reallocation is not necessary (e. g. the new size is less
+	 * than the current allocated size), the current allocation will be
+	 * preserved unless __GFP_THISNODE is set. In the latter case a new
+	 * allocation on the requested node will be attempted.
+	 */
+	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+		     nid != page_to_nid(virt_to_page(p)))
+		goto alloc_new;
+
 	/* If the old object doesn't fit, allocate a bigger one */
 	if (new_size > ks)
 		goto alloc_new;
@@ -7061,7 +7061,7 @@ alloc_new:
 	if (ret && p) {
 		/* Disable KASAN checks as the object's redzone is accessed. */
 		kasan_disable_current();
-		memcpy(ret, kasan_reset_tag(p), orig_size ?: ks);
+		memcpy(ret, kasan_reset_tag(p), min(new_size, (size_t)(orig_size ?: ks)));
 		kasan_enable_current();
 	}
 
@@ -7288,7 +7288,7 @@ void *kvrealloc_node_align_noprof(const
 		if (p) {
 			/* We already know that `p` is not a vmalloc address. */
 			kasan_disable_current();
-			memcpy(n, kasan_reset_tag(p), ksize(p));
+			memcpy(n, kasan_reset_tag(p), min(size, ksize(p)));
 			kasan_enable_current();
 
 			kfree(p);


