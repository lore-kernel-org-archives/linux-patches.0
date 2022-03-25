Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCFB1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27804C340EC;
	Fri, 25 Mar 2022 01:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170629;
	bh=MXZTNIIl7zXhqlzCB0MZ7cwuoq02eK+MYytIb6Xi+j0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=KIZwrPadw1Pc4aa56GmauR7qi134FQeFHV246VHLij/0xPCziH7OQIt42quRe88JW
	 ynEHAyqlXGcjNb5Ld5U8O2X8ogY1pyVXXFzea8dFH74Jz4IO9pdd3A50xIUEe5a9oA
	 oC7aRDhsukTwqmZFrenkBOcsoqn3Scex8EgAfAAY=
Date: Thu, 24 Mar 2022 18:10:28 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 038/114] kasan, page_alloc: refactor init checks in post_alloc_hook
Message-Id: <20220325011029.27804C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: refactor init checks in post_alloc_hook

Separate code for zeroing memory from the code clearing tags in
post_alloc_hook().

This patch is not useful by itself but makes the simplifications in the
following patches easier to follow.

This patch does no functional changes.

Link: https://lkml.kernel.org/r/2283fde963adfd8a2b29a92066f106cc16661a3c.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-refactor-init-checks-in-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -2368,19 +2368,21 @@ inline void post_alloc_hook(struct page
 		kasan_alloc_pages(page, order, gfp_flags);
 	} else {
 		bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
+		bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 
 		kasan_unpoison_pages(page, order, init);
 
-		if (init) {
-			if (gfp_flags & __GFP_ZEROTAGS) {
-				int i;
-
-				for (i = 0; i < 1 << order; i++)
-					tag_clear_highpage(page + i);
-			} else {
-				kernel_init_free_pages(page, 1 << order);
-			}
+		if (init_tags) {
+			int i;
+
+			for (i = 0; i < 1 << order; i++)
+				tag_clear_highpage(page + i);
+
+			init = false;
 		}
+
+		if (init)
+			kernel_init_free_pages(page, 1 << order);
 	}
 
 	set_page_owner(page, order, gfp_flags);
_
