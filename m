Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F58A1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B647C340EC;
	Fri, 25 Mar 2022 01:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170617;
	bh=/qgrU2rRSIjj069aMxmR+6XIKMhG3D36r1V3g/9jjhc=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=K5h1U6oqf9DPoEdAe+Qhtwnk3TKv50H2dlF0g/UAypb2wtdQdsjEVNX850fkJ8V5o
	 oHJ3ibNhQvF6J0IYBVmTNPCyHstZG/BBS1Q3CMdgY1MfpEGlPJQmNyuGSrXedYNhg6
	 n0Lp3qrqNe+fffwx7KpGPxxFAqX0KC+n4DcdL1/4=
Date: Thu, 24 Mar 2022 18:10:16 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 034/114] kasan, page_alloc: init memory of skipped pages on free
Message-Id: <20220325011017.1B647C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: init memory of skipped pages on free

Since commit 7a3b83537188 ("kasan: use separate (un)poison implementation
for integrated init"), when all init, kasan_has_integrated_init(), and
skip_kasan_poison are true, free_pages_prepare() doesn't initialize the
page.  This is wrong.

Fix it by remembering whether kasan_poison_pages() performed
initialization, and call kernel_init_free_pages() if it didn't.

Reordering kasan_poison_pages() and kernel_init_free_pages() is OK, since
kernel_init_free_pages() can handle poisoned memory.

Link: https://lkml.kernel.org/r/1d97df75955e52727a3dc1c4e33b3b50506fc3fd.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
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

 mm/page_alloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-init-memory-of-skipped-pages-on-free
+++ a/mm/page_alloc.c
@@ -1371,11 +1371,16 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (init && !kasan_has_integrated_init())
-		kernel_init_free_pages(page, 1 << order);
-	if (!skip_kasan_poison)
+	if (!skip_kasan_poison) {
 		kasan_poison_pages(page, order, init);
 
+		/* Memory is already initialized if KASAN did it internally. */
+		if (kasan_has_integrated_init())
+			init = false;
+	}
+	if (init)
+		kernel_init_free_pages(page, 1 << order);
+
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
 	 * does this.  So nothing which can access the page's contents should
_
