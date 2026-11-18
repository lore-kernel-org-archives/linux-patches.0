Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038981;
	b=WpBktuVTT2mpgEJPdFmAsbXNVMtRrxGWmRNQVLgxlwua9OFTk6+1EJtdMGL0doAE6E4A
	 cV9M3xZsVaA5tyQGxA6sw249RrS3Polwbr2JQeRb9b7L/GKIyq5dOnjJOvoUusbrAVMQd
	 X7mjHor3ZEXEtZ8hUYTiNq6y43ZMO1WgPN+krTwqoYDyTQV92JznaCqowVU7PFNZ43/rU
	 4DL+GDqud6McLQX/veCVTJw5fX1XFlo8wIFV50Ewbo10AW7qtyYL3THFVL80LQhSb0k9a
	 OW6XJFgCe1HWWL82FiQK1oHx6CVXzbh61gAh6XEaudbAsh/m/nRZFhim0i0N9S9B3kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TRhGbEiDON5VShd7B2RCpBQptSLs829hIWMklnDkP1M=;
	b=YURkK8sTnIspU5aIGmWScTYQggR3bt3y4fS2khk/4/Yztu853BpEXc7M7m0XI4Qjxp8L
	 E1rVx1fn6VjaUoYMtPFsQOxtAxkXVFIAAyFPKEh8ehxAIbQS2QmfGhsIIxZ0oYF36Z3gn
	 bgmiayU3LgfLh5NYMNWhpUJ4nDc3tAemti33BwihG96rd98n7Sc7XL10akHqt3c06Dozq
	 ZjvzcDx+orN2l7olq2BZoewSsoulYWbeemS2ZziAPZ8bqjMgA/P8Izw9fYtenuMHYXZxO
	 1gjKdhmHRLzpIkZEZxKtuDfwoscBkrC2l+2CNr1Y6H471aw9En8otdCYQfint895CoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPrUZ2Cs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F90606A31C;
	Wed, 18 Nov 2026 21:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPrUZ2Cs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C691F000C4;
	Wed, 18 Nov 2026 21:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038981;
	bh=TRhGbEiDON5VShd7B2RCpBQptSLs829hIWMklnDkP1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPrUZ2CsY8eRziP9t7YbzDKHFmpwjs9sJAAMvWWnw8IR3qpbiZc/JrJXuDbwzSlNV
	 l4UCqLGFeDpMAQZ5FTlaUq7e/Yn0iE6qvDJ8+JcOb5q8cn/9LFNAooV2C8+kH7+yf/
	 WP1l1ZNPnjvNif6ZQ2e5/aDU9SfMDrpKmUQiM6YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1937/3318] mm: call wp_page_copy() under the VMA lock
Date: Wed, 18 Nov 2026 15:42:39 +0100
Message-ID: <20261118150420.154610869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 164b06f238b986317131e6b61b2f22aabcbc2cc0 ]

It is usually safe to call wp_page_copy() under the VMA lock.  The only
unsafe situation is when no anon_vma has been allocated for this VMA, and
we have to look at adjacent VMAs to determine if their anon_vma can be
shared.  Since this happens only for the first COW of a page in this VMA,
the majority of calls to wp_page_copy() do not need to fall back to the
mmap_sem.

Add vmf_anon_prepare() as an alternative to anon_vma_prepare() which will
return RETRY if we currently hold the VMA lock and need to allocate an
anon_vma.  This lets us drop the check in do_wp_page().

Link: https://lkml.kernel.org/r/20231006195318.4087158-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 8db6921cc07b ("mm/memory: reject remote COW faults on PFN mappings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 853400f26159b..2ad125baa9504 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3050,6 +3050,21 @@ static inline void wp_page_reuse(struct vm_fault *vmf)
 	count_vm_event(PGREUSE);
 }
 
+static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (likely(vma->anon_vma))
+		return 0;
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+	if (__anon_vma_prepare(vma))
+		return VM_FAULT_OOM;
+	return 0;
+}
+
 /*
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
@@ -3077,27 +3092,29 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
-	int ret;
+	vm_fault_t ret;
 
 	delayacct_wpcopy_start();
 
 	if (vmf->page)
 		old_folio = page_folio(vmf->page);
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
+	ret = vmf_anon_prepare(vmf);
+	if (unlikely(ret))
+		goto out;
 
 	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
 		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
 		if (!new_folio)
 			goto oom;
 	} else {
+		int err;
 		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
 				vmf->address, false);
 		if (!new_folio)
 			goto oom;
 
-		ret = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
-		if (ret) {
+		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
+		if (err) {
 			/*
 			 * COW failed, if the fault was solved by other,
 			 * it's fine. If not, userspace would re-fault on
@@ -3110,7 +3127,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
-			return ret == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
+			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);
 	}
@@ -3220,11 +3237,13 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 oom_free_new:
 	folio_put(new_folio);
 oom:
+	ret = VM_FAULT_OOM;
+out:
 	if (old_folio)
 		folio_put(old_folio);
 
 	delayacct_wpcopy_end();
-	return VM_FAULT_OOM;
+	return ret;
 }
 
 /**
@@ -3449,12 +3468,6 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 		return 0;
 	}
 copy:
-	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma->anon_vma) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		vma_end_read(vmf->vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-- 
2.53.0



