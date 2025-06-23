Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBCF1FECBA;
	Mon, 23 Jun 2025 21:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715687; cv=none; b=LEZDyujJ3wi6NtlA9wJEGPCTPFzIS9mW/VQkWSqSoNcG0IP94d/dwRLl65KWPRYeLCPsOxeWzEPhKKau+oVx3mB6qPik7vwhbctg7C1JPlsNTUU6vC8nFunML5oKAOxyGfQ/i52j31ZLUoJ5xiWfZS3yPLsdiQZzKMir0WMEVa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715687; c=relaxed/simple;
	bh=7FxE1X6750jXuUPQ8q8jBsULnx6ONtiLEx6yEHZFk4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClpZ868zloEer26yTT+OGC9g7gLBYy2mwRez+bh7iCi5W4ul2O5z7CaQVz1+eN4mNAW+jCAvAE9FkJls+J+Nw0biI6sxYhjsWJ7K5fSnmOZf/x95vsMSSiMoUoh5iqCViASnTvcG7XkyGAdpjHVuXg1uvZbTQmdaJBwDakDXF44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHlcxop1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHlcxop1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE45C4CEEA;
	Mon, 23 Jun 2025 21:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715687;
	bh=7FxE1X6750jXuUPQ8q8jBsULnx6ONtiLEx6yEHZFk4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHlcxop19xGq4fplEi3Ylq4L10292ZXklmf3XFEedFgVFOIG8B2obarOIbQ3Wh6tu
	 xoHeTDBZRlA9WD+IEwNw0FyBhsc9YRZktPkXzdUeDsKIcZMnT0JcrlLqikxI4t3I7c
	 USuG7DSxzFozO36uAMM10HKcMtdiSWNjf15tuqRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 6.15 474/592] x86/its: explicitly manage permissions for ITS pages
Date: Mon, 23 Jun 2025 15:07:12 +0200
Message-ID: <20250623130711.707223050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra (Intel) <peterz@infradead.org>

commit a82b26451de126a5ae130361081986bc459afe9b upstream.

execmem_alloc() sets permissions differently depending on the kernel
configuration, CPU support for PSE and whether a page is allocated
before or after mark_rodata_ro().

Add tracking for pages allocated for ITS when patching the core kernel
and make sure the permissions for ITS pages are explicitly managed for
both kernel and module allocations.

Fixes: 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250603111446.2609381-5-rppt@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   74 +++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -138,6 +138,24 @@ static struct module *its_mod;
 #endif
 static void *its_page;
 static unsigned int its_offset;
+struct its_array its_pages;
+
+static void *__its_alloc(struct its_array *pages)
+{
+	void *page __free(execmem) = execmem_alloc(EXECMEM_MODULE_TEXT, PAGE_SIZE);
+	if (!page)
+		return NULL;
+
+	void *tmp = krealloc(pages->pages, (pages->num+1) * sizeof(void *),
+			     GFP_KERNEL);
+	if (!tmp)
+		return NULL;
+
+	pages->pages = tmp;
+	pages->pages[pages->num++] = page;
+
+	return no_free_ptr(page);
+}
 
 /* Initialize a thunk with the "jmp *reg; int3" instructions. */
 static void *its_init_thunk(void *thunk, int reg)
@@ -173,6 +191,21 @@ static void *its_init_thunk(void *thunk,
 	return thunk + offset;
 }
 
+static void its_pages_protect(struct its_array *pages)
+{
+	for (int i = 0; i < pages->num; i++) {
+		void *page = pages->pages[i];
+		execmem_restore_rox(page, PAGE_SIZE);
+	}
+}
+
+static void its_fini_core(void)
+{
+	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		its_pages_protect(&its_pages);
+	kfree(its_pages.pages);
+}
+
 #ifdef CONFIG_MODULES
 void its_init_mod(struct module *mod)
 {
@@ -195,10 +228,8 @@ void its_fini_mod(struct module *mod)
 	its_page = NULL;
 	mutex_unlock(&text_mutex);
 
-	for (int i = 0; i < mod->arch.its_pages.num; i++) {
-		void *page = mod->arch.its_pages.pages[i];
-		execmem_restore_rox(page, PAGE_SIZE);
-	}
+	if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
+		its_pages_protect(&mod->arch.its_pages);
 }
 
 void its_free_mod(struct module *mod)
@@ -216,28 +247,23 @@ void its_free_mod(struct module *mod)
 
 static void *its_alloc(void)
 {
-	void *page __free(execmem) = execmem_alloc(EXECMEM_MODULE_TEXT, PAGE_SIZE);
+	struct its_array *pages = &its_pages;
+	void *page;
 
+#ifdef CONFIG_MODULE
+	if (its_mod)
+		pages = &its_mod->arch.its_pages;
+#endif
+
+	page = __its_alloc(pages);
 	if (!page)
 		return NULL;
 
-#ifdef CONFIG_MODULES
-	if (its_mod) {
-		struct its_array *pages = &its_mod->arch.its_pages;
-		void *tmp = krealloc(pages->pages,
-				     (pages->num+1) * sizeof(void *),
-				     GFP_KERNEL);
-		if (!tmp)
-			return NULL;
-
-		pages->pages = tmp;
-		pages->pages[pages->num++] = page;
+	execmem_make_temp_rw(page, PAGE_SIZE);
+	if (pages == &its_pages)
+		set_memory_x((unsigned long)page, 1);
 
-		execmem_make_temp_rw(page, PAGE_SIZE);
-	}
-#endif /* CONFIG_MODULES */
-
-	return no_free_ptr(page);
+	return page;
 }
 
 static void *its_allocate_thunk(int reg)
@@ -291,7 +317,9 @@ u8 *its_static_thunk(int reg)
 	return thunk;
 }
 
-#endif
+#else
+static inline void its_fini_core(void) {}
+#endif /* CONFIG_MITIGATION_ITS */
 
 /*
  * Nomenclature for variable names to simplify and clarify this code and ease
@@ -2368,6 +2396,8 @@ void __init alternative_instructions(voi
 	apply_retpolines(__retpoline_sites, __retpoline_sites_end);
 	apply_returns(__return_sites, __return_sites_end);
 
+	its_fini_core();
+
 	/*
 	 * Adjust all CALL instructions to point to func()-10, including
 	 * those in .altinstr_replacement.


