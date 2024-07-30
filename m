Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C1E1A76AB;
	Tue, 30 Jul 2024 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360430; cv=none; b=H9v4QsjvrH8KJYmpuK5tZHkXq0GZFp/gSopcsPbdfjDUp7HW8xVMcGNsDRWlZC99iNo1EODzajcquf59OEsbLEA0jMsnEMpYNoB8v+wM4SbwDZzvy3IX7toJTx+9Kxx/m2WUoQctNGgzqO6K9HwBwJ/Jk1ISh/wVuQ4i67+IMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360430; c=relaxed/simple;
	bh=Bly6OdmGHzTxCsnmduWrx4shEiY+wwJkc/WBLbJnTx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/37DwPNlUOFVh42w2BPsS14q5Rb48Mzt6ZSn6jGha7VYEdOvmv8RHouhmiMF8j36e+OjTsDaaFkFyFg1y8MgHYW9+wc2lMqA1YvLVIHjSCCdD7eEtFQL16nodWmAuoQ7oI/xf2O0MhGzwLyYi+Iykp3fpLCzYpIecwTbXqJFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZm6eGff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZm6eGff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292F7C32782;
	Tue, 30 Jul 2024 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360430;
	bh=Bly6OdmGHzTxCsnmduWrx4shEiY+wwJkc/WBLbJnTx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZm6eGffWpiSZ4G67o1ayPyWxZqh0DIwpHHjaKsQFYniimVMoCctkdO/xs2zU+USg
	 mdqYUEP8yIWi+7A2tHNX9nzYaLXyrBF6lk5MWk4+NT33+fxiNdLO7jI5rgq4Yun3/x
	 1vWcFq2GZysw/bJwOORPo1IjFmbQAk+4JRy2BaG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	kernel test robot <lkp@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 666/809] alloc_tag: outline and export free_reserved_page()
Date: Tue, 30 Jul 2024 17:49:02 +0200
Message-ID: <20240730151751.207817777@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit b3bebe44306e23827397d0d774d206e3fa374041 upstream.

Outline and export free_reserved_page() because modules use it and it in
turn uses page_ext_{get|put} which should not be exported.  The same
result could be obtained by outlining {get|put}_page_tag_ref() but that
would have higher performance impact as these functions are used in more
performance critical paths.

Link: https://lkml.kernel.org/r/20240717212844.2749975-1-surenb@google.com
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407080044.DWMC9N9I-lkp@intel.com/
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   16 +---------------
 mm/page_alloc.c    |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3177,21 +3177,7 @@ extern void reserve_bootmem_region(phys_
 				   phys_addr_t end, int nid);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
-static inline void free_reserved_page(struct page *page)
-{
-	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
-
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
-		}
-	}
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	adjust_managed_page_count(page, 1);
-}
+void free_reserved_page(struct page *page);
 #define free_highmem_page(page) free_reserved_page(page)
 
 static inline void mark_page_reserved(struct page *page)
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5809,6 +5809,23 @@ unsigned long free_reserved_area(void *s
 	return pages;
 }
 
+void free_reserved_page(struct page *page)
+{
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			set_codetag_empty(ref);
+			put_page_tag_ref(ref);
+		}
+	}
+	ClearPageReserved(page);
+	init_page_count(page);
+	__free_page(page);
+	adjust_managed_page_count(page, 1);
+}
+EXPORT_SYMBOL(free_reserved_page);
+
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
 	struct zone *zone;


