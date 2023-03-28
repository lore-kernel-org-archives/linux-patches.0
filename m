Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C9B8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6FBC433D2;
	Tue, 28 Mar 2023 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015290;
	bh=stprJ4Ok6iOxRao5KYE4oaQuciwWQTRlYZK94PRhwNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9WxxO8lbzeRu4T7vPeJjoTl0jWdywHgz9gzx36yuV4ylRkIr/ojBwSVg0hY2fO/K
	 1bz4i+AJYqVWpjdiFh+VXKnvuzc8sgFRuSVY+9TZt+v3oSz3+dqbn6BaedF+gBQ9n/
	 vJVklK85Tbp73Bjv1Mqo5A/NtF/8Jlr0Bnxb1u/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.2 205/240] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
Date: Tue, 28 Mar 2023 16:42:48 +0200
Message-Id: <20230328142628.223011878@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Collingbourne <pcc@google.com>

commit f446883d12b8bfa486f7c98d403054d61d38c989 upstream.

This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.

should_skip_kasan_poison() reads the PG_skip_kasan_poison flag from
page->flags.  However, this line of code in free_pages_prepare():

	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;

clears most of page->flags, including PG_skip_kasan_poison, before calling
should_skip_kasan_poison(), which meant that it would never return true as
a result of the page flag being set.  Therefore, fix the code to call
should_skip_kasan_poison() before clearing the flags, as we were doing
before the reverted patch.

This fixes a measurable performance regression introduced in the reverted
commit, where munmap() takes longer than intended if HW tags KASAN is
supported and enabled at runtime.  Without this patch, we see a
single-digit percentage performance regression in a particular
mmap()-heavy benchmark when enabling HW tags KASAN, and with the patch,
there is no statistically significant performance impact when enabling HW
tags KASAN.

Link: https://lkml.kernel.org/r/20230310042914.3805818-2-pcc@google.com
Fixes: 487a32ec24be ("kasan: drop skip_kasan_poison variable in free_pages_prepare")
  Link: https://linux-review.googlesource.com/id/Ic4f13affeebd20548758438bb9ed9ca40e312b79
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com> [arm64]
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>	[6.1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1391,6 +1391,7 @@ static __always_inline bool free_pages_p
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
+	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -1463,7 +1464,7 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (!should_skip_kasan_poison(page, fpi_flags)) {
+	if (!skip_kasan_poison) {
 		kasan_poison_pages(page, order, init);
 
 		/* Memory is already initialized if KASAN did it internally. */


