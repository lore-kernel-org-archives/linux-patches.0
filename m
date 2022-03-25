Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6098E1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32936C340ED;
	Fri, 25 Mar 2022 01:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170641;
	bh=qIz/C/t4EfC/HU223EvVk9AEDn3luylBjZoApLDA8ko=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=k9iWopBZwl4ETytXkRtvCP4zwUsSnfk139iNZO3ekJmbnWioV2i2YywqSTtXByUf9
	 JhSxnpM3QeG+89SvA0QozjKv6hQLidW28y8WxqMxm5KqUyNBd3IHmC9SszYYXY5AI5
	 anAyc8p4uCaBMKlw7NHkn8JUSfnfsfYf6yFSYvTY=
Date: Thu, 24 Mar 2022 18:10:40 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 042/114] kasan, page_alloc: move kernel_init_free_pages in post_alloc_hook
Message-Id: <20220325011041.32936C340ED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: move kernel_init_free_pages in post_alloc_hook

Pull the kernel_init_free_pages() call in post_alloc_hook() out of the big
if clause for better code readability.  This also allows for more
simplifications in the following patch.

This patch does no functional changes.

Link: https://lkml.kernel.org/r/a7a76456501eb37ddf9fca6529cee9555e59cdb1.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-move-kernel_init_free_pages-in-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -2383,14 +2383,18 @@ inline void post_alloc_hook(struct page
 		init = false;
 	}
 	if (kasan_has_integrated_init()) {
-		if (!init_tags)
+		if (!init_tags) {
 			kasan_unpoison_pages(page, order, init);
+
+			/* Note that memory is already initialized by KASAN. */
+			init = false;
+		}
 	} else {
 		kasan_unpoison_pages(page, order, init);
-
-		if (init)
-			kernel_init_free_pages(page, 1 << order);
 	}
+	/* If memory is still not initialized, do it now. */
+	if (init)
+		kernel_init_free_pages(page, 1 << order);
 	/* Propagate __GFP_SKIP_KASAN_POISON to page flags. */
 	if (kasan_hw_tags_enabled() && (gfp_flags & __GFP_SKIP_KASAN_POISON))
 		SetPageSkipKASanPoison(page);
_
