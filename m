Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB0D1AD3FA;
	Mon, 23 Jun 2025 21:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715673; cv=none; b=KelUeHwl9RWVByrCG+fi7UF4pekEscqMEBS4glLcT4ONB1demDIgsuj6igiDItFjYn9fN2k3hmUI0sfCIxseG7XSb4X0SKogc2wNyllfMuYcCQT84YJZ0hfhl8ZYcQ2jZWt91Z0i6KrR8anz5Z440OGKYS7yz/pdkMSUITOv5mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715673; c=relaxed/simple;
	bh=FoAQvr+K6bPAdSGHG+CNvx/B06temFLtgTeZ+RQfvKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+K0/9HS6OZC0BBCbsMGbWmBjEut0oJAMuBbSwjEou928igxppRR1WKjSafLJUof5s63kP/RMokDY42uf6j/lz9tiABFwCtvNc3KGpUqA6GnXKyDUZXji3EF0FM95Xr3Rs/ZLWGUNMB4PC58PVTXrRLSfKj2W3e4cKEUqescBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVi2BCWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVi2BCWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB35AC4CEEA;
	Mon, 23 Jun 2025 21:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715673;
	bh=FoAQvr+K6bPAdSGHG+CNvx/B06temFLtgTeZ+RQfvKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVi2BCWazfdEbMdWeRfF5eGoVCgVRp1UtBZN1vzKA4grO/1BEifWObQf4bECNTClq
	 J8QuG58i10wSvqYxDndGowabvYmkyJfCFGFx7cNBXxKvalvvPFhBqJ9/pVuam2J50u
	 IHVLJ92nzy3fF0nkgNbCHdG1NoIg4Bbsy5RQgK1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 6.15 473/592] x86/its: move its_pages array to struct mod_arch_specific
Date: Mon, 23 Jun 2025 15:07:11 +0200
Message-ID: <20250623130711.683046009@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 0b0cae7119a0ec9449d7261b5e672a5fed765068 upstream.

The of pages with ITS thunks allocated for modules are tracked by an
array in 'struct module'.

Since this is very architecture specific data structure, move it to
'struct mod_arch_specific'.

No functional changes.

Fixes: 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches")
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250603111446.2609381-4-rppt@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/module.h |    8 ++++++++
 arch/x86/kernel/alternative.c |   19 ++++++++++---------
 include/linux/module.h        |    5 -----
 3 files changed, 18 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -5,12 +5,20 @@
 #include <asm-generic/module.h>
 #include <asm/orc_types.h>
 
+struct its_array {
+#ifdef CONFIG_MITIGATION_ITS
+	void **pages;
+	int num;
+#endif
+};
+
 struct mod_arch_specific {
 #ifdef CONFIG_UNWINDER_ORC
 	unsigned int num_orcs;
 	int *orc_unwind_ip;
 	struct orc_entry *orc_unwind;
 #endif
+	struct its_array its_pages;
 };
 
 #endif /* _ASM_X86_MODULE_H */
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -195,8 +195,8 @@ void its_fini_mod(struct module *mod)
 	its_page = NULL;
 	mutex_unlock(&text_mutex);
 
-	for (int i = 0; i < mod->its_num_pages; i++) {
-		void *page = mod->its_page_array[i];
+	for (int i = 0; i < mod->arch.its_pages.num; i++) {
+		void *page = mod->arch.its_pages.pages[i];
 		execmem_restore_rox(page, PAGE_SIZE);
 	}
 }
@@ -206,11 +206,11 @@ void its_free_mod(struct module *mod)
 	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
 		return;
 
-	for (int i = 0; i < mod->its_num_pages; i++) {
-		void *page = mod->its_page_array[i];
+	for (int i = 0; i < mod->arch.its_pages.num; i++) {
+		void *page = mod->arch.its_pages.pages[i];
 		execmem_free(page);
 	}
-	kfree(mod->its_page_array);
+	kfree(mod->arch.its_pages.pages);
 }
 #endif /* CONFIG_MODULES */
 
@@ -223,14 +223,15 @@ static void *its_alloc(void)
 
 #ifdef CONFIG_MODULES
 	if (its_mod) {
-		void *tmp = krealloc(its_mod->its_page_array,
-				     (its_mod->its_num_pages+1) * sizeof(void *),
+		struct its_array *pages = &its_mod->arch.its_pages;
+		void *tmp = krealloc(pages->pages,
+				     (pages->num+1) * sizeof(void *),
 				     GFP_KERNEL);
 		if (!tmp)
 			return NULL;
 
-		its_mod->its_page_array = tmp;
-		its_mod->its_page_array[its_mod->its_num_pages++] = page;
+		pages->pages = tmp;
+		pages->pages[pages->num++] = page;
 
 		execmem_make_temp_rw(page, PAGE_SIZE);
 	}
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -586,11 +586,6 @@ struct module {
 	atomic_t refcnt;
 #endif
 
-#ifdef CONFIG_MITIGATION_ITS
-	int its_num_pages;
-	void **its_page_array;
-#endif
-
 #ifdef CONFIG_CONSTRUCTORS
 	/* Constructor functions. */
 	ctor_fn_t *ctors;


