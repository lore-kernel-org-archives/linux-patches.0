Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016132;
	b=jrcDr59aUXkt4B8crV577K8u4ODYy/Paec2BrFklwgTt0E5H7g0m5+IRgFn9ecZJMsg8
	 4rNJMhhVS91ZYJGooMdmET37f6DO84v/iZDiawHJMOs7B6otGCoMyepCH2fSfwYHvXmBM
	 lv+IzqCiU0j9AncqrCwouOaEoHfkF5wseDKN7bDhmL1Ti27p36kVFNMcjHcfUQ9i/+Hqr
	 ey+4aeSJWtP+VkM+FqabPldmE4W5FVF9fJVlqZfIbN+Jvuue9lkI9SAEV5LtRZKegB7Sq
	 cmDsGFDlbJ26Q/Ldylo8miQOLlDDB7x4jYjt9eWAIg/HThcvH8lK0EhJy5itIAZ+gMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xIEljlMgQ980jjvClofKHztsO+/BBVB35h4RS4k+1wI=;
	b=DQJHVmQVifRsB6muyNEOvytxI/slIxdphlVzlHeHB3LlyfeMJb8uhzZ773A1vPPbf81G
	 g277AXDMwhAC50tpiwbraz6EDnWwyUqWL5iQUkSvRzIjwKdRUBAvbTC/UMMsGLqGl4YH0
	 SJLzJDngSHksYsi14EaKJ35kz/zjUWlRnCF6fRgkBxVs30NYCzoiWSsH5/sIh49CNL4Ql
	 mldCeTjxaWzkyLD2D9JWJalKStU4MWit7/RXw2AlqlQv4PxOVtkRJf0tt9uCwpMQhqTQ9
	 CqhMzPhHsMW89N6OjWDkePn1TLWlhqe/8eLs9nbdyxGU0HRsENwWbrnutzcwBlLKDXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WShn7NwR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF5B606A320;
	Wed, 18 Nov 2026 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WShn7NwR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527BB1F000C4;
	Wed, 18 Nov 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016131;
	bh=xIEljlMgQ980jjvClofKHztsO+/BBVB35h4RS4k+1wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WShn7NwRVD0okBY1Zmdg3lBuILCPBaqAx7ePj/HeI8gKBciDxIWPJltOj65Jmfn7j
	 TDYIJD+ki89bZnuxfXnmqA27Gzg/H08gAhMkZwZs299fcAgNsiK7ADaU241Iiktw53
	 Ou9xr41SdMVYawsPIYrTMgEK/hNNmit1KJBL2EQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0419/2651] accel/amdxdna: Fix unsafe use of handle_mm_fault()
Date: Wed, 18 Nov 2026 15:27:39 +0100
Message-ID: <20261118150302.916270878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit df4d5352063ac48e1d3566f64ec94baa8b5af94f ]

handle_mm_fault() must not be called from the mmap callback because
the VMA has not yet been linked. The handle_mm_fault() API contract
assumes that the VMA is already linked.

Remove the handle_mm_fault() call from the mmap callback. For imported
BOs, mark the mapping as invalid and rely on the first command submission
to fault in the pages.

For shmem BOs, set the VM_MIXEDMAP flag and use vm_insert_pages().
Implement amdxdna_gem_mixed_vm_ops to handle the page faults.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260910211338.1102315-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 151 ++++++++++++++++++++++------
 1 file changed, 118 insertions(+), 33 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 1dd3c0014d5a5..5a1a2ee261b76 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -14,6 +14,7 @@
 #include <linux/dma-direct.h>
 #include <linux/iosys-map.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 #include <linux/vmalloc.h>
 
 #include "amdxdna_cbuf.h"
@@ -490,16 +491,16 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(to_gobj(abo)->dev);
 	unsigned long num_pages = vma_pages(vma);
-	unsigned long offset = 0;
 	int ret;
 
-	if (!is_import_bo(abo)) {
-		ret = drm_gem_shmem_mmap(&abo->base, vma);
-		if (ret) {
-			XDNA_ERR(xdna, "Failed shmem mmap %d", ret);
-			return ret;
-		}
-	} else {
+	/*
+	 * Until today there is not any use case to mmap with non-zero
+	 * offset. Put an explicit check here.
+	 */
+	if (vma->vm_pgoff - drm_vma_node_start(&to_gobj(abo)->vma_node))
+		return -EINVAL;
+
+	if (is_import_bo(abo)) {
 		vma->vm_private_data = NULL;
 		vma->vm_ops = NULL;
 		ret = dma_buf_mmap(abo->dma_buf, vma, 0);
@@ -508,23 +509,28 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 			return ret;
 		}
 
+		amdxdna_mark_mapp_invalid(abo, vma);
+
 		/* Drop the reference drm_gem_mmap_obj() acquired.*/
 		drm_gem_object_put(to_gobj(abo));
+		return 0;
 	}
 
-	do {
-		vm_fault_t fault_ret;
-
-		fault_ret = handle_mm_fault(vma, vma->vm_start + offset,
-					    FAULT_FLAG_WRITE, NULL);
-		if (fault_ret & VM_FAULT_ERROR) {
-			XDNA_ERR(xdna, "Fault in page failed");
-			amdxdna_mark_mapp_invalid(abo, vma);
-			break;
-		}
+	ret = drm_gem_shmem_mmap(&abo->base, vma);
+	if (ret) {
+		XDNA_ERR(xdna, "Failed shmem mmap %d", ret);
+		return ret;
+	}
 
-		offset += PAGE_SIZE;
-	} while (--num_pages);
+	vm_flags_mod(vma, VM_MIXEDMAP, VM_PFNMAP);
+	ret = vm_insert_pages(vma, vma->vm_start, abo->base.pages, &num_pages);
+	if (ret) {
+		XDNA_ERR(xdna, "Failed to insert pages %d", ret);
+		dma_resv_lock(to_gobj(abo)->resv, NULL);
+		drm_gem_shmem_put_pages_locked(&abo->base);
+		dma_resv_unlock(to_gobj(abo)->resv);
+		return ret;
+	}
 
 	return 0;
 }
@@ -536,6 +542,10 @@ static int amdxdna_gem_obj_mmap(struct drm_gem_object *gobj,
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
 	int ret;
 
+	XDNA_DBG(xdna, "BO map_offset 0x%llx type %d userptr 0x%lx size 0x%lx",
+		 drm_vma_node_offset_addr(&gobj->vma_node), abo->type,
+		 vma->vm_start, gobj->size);
+
 	ret = amdxdna_hmm_register(abo, vma);
 	if (ret)
 		return ret;
@@ -546,9 +556,6 @@ static int amdxdna_gem_obj_mmap(struct drm_gem_object *gobj,
 		goto hmm_unreg;
 	}
 
-	XDNA_DBG(xdna, "BO map_offset 0x%llx type %d userptr 0x%lx size 0x%lx",
-		 drm_vma_node_offset_addr(&gobj->vma_node), abo->type,
-		 vma->vm_start, gobj->size);
 	return 0;
 
 hmm_unreg:
@@ -556,14 +563,99 @@ static int amdxdna_gem_obj_mmap(struct drm_gem_object *gobj,
 	return ret;
 }
 
+/*
+ * VM operations for amdxdna shmem VMAs that use VM_MIXEDMAP.
+ *
+ * drm_gem_shmem_vm_ops cannot be used on VM_MIXEDMAP VMAs because its fault
+ * handler calls vmf_insert_pfn() → vmf_insert_pfn_prot() which contains:
+ *   BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn))
+ * All amdxdna shmem pages are ordinary struct pages so pfn_valid() is always
+ * true, making the combination fatal.
+ *
+ * These ops use vmf_insert_page() (struct-page based) instead, which is the
+ * correct API for VM_MIXEDMAP VMAs backed by real struct pages.  The open and
+ * close handlers replicate drm_gem_shmem_vm_open/close using only exported
+ * symbols.
+ */
+static vm_fault_t amdxdna_gem_mixedmap_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct drm_gem_object *gobj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(gobj);
+	loff_t num_pages = gobj->size >> PAGE_SHIFT;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+	pgoff_t page_offset;
+	struct page *page;
+
+	/*
+	 * Partial free of vma is unexpected. Otherwise, the wrong page
+	 * will be faulted in and the user application may crash itself.
+	 */
+	page_offset = linear_page_delta(vma, vmf->address);
+
+	dma_resv_lock(gobj->resv, NULL);
+
+	if (!shmem->pages || shmem->madv < 0 || page_offset >= num_pages)
+		goto out;
+
+	page = shmem->pages[page_offset];
+	if (WARN_ON_ONCE(!page))
+		goto out;
+
+	/*
+	 * Use vmf_insert_page() (struct-page path) not vmf_insert_pfn()
+	 * (PFN path) because this VMA carries VM_MIXEDMAP.
+	 */
+	ret = vmf_insert_page(vma, vmf->address, page);
+	if (ret == VM_FAULT_NOPAGE)
+		folio_mark_accessed(page_folio(page));
+
+out:
+	dma_resv_unlock(gobj->resv);
+	return ret;
+}
+
+static void amdxdna_gem_mixedmap_vm_open(struct vm_area_struct *vma)
+{
+	struct drm_gem_object *gobj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(gobj);
+
+	/*
+	 * Bump pages_use_count so the page array stays alive for the new
+	 * mapping copy created by fork().  Mirrors drm_gem_shmem_vm_open().
+	 */
+	dma_resv_lock(gobj->resv, NULL);
+	drm_WARN_ON_ONCE(gobj->dev, !refcount_inc_not_zero(&shmem->pages_use_count));
+	dma_resv_unlock(gobj->resv);
+
+	drm_gem_vm_open(vma);
+}
+
+static void amdxdna_gem_mixedmap_vm_close(struct vm_area_struct *vma)
+{
+	struct drm_gem_object *gobj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(gobj);
+
+	dma_resv_lock(gobj->resv, NULL);
+	drm_gem_shmem_put_pages_locked(shmem);
+	dma_resv_unlock(gobj->resv);
+
+	drm_gem_vm_close(vma);
+}
+
+static const struct vm_operations_struct amdxdna_gem_mixedmap_vm_ops = {
+	.fault  = amdxdna_gem_mixedmap_fault,
+	.open   = amdxdna_gem_mixedmap_vm_open,
+	.close  = amdxdna_gem_mixedmap_vm_close,
+};
+
 static int amdxdna_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
 {
 	struct drm_gem_object *gobj = dma_buf->priv;
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
-	unsigned long num_pages = vma_pages(vma);
 	int ret;
 
-	vma->vm_ops = &drm_gem_shmem_vm_ops;
+	vma->vm_ops = &amdxdna_gem_mixedmap_vm_ops;
 	vma->vm_private_data = gobj;
 
 	drm_gem_object_get(gobj);
@@ -573,16 +665,9 @@ static int amdxdna_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struc
 
 	/* The buffer is based on memory pages. Fix the flag. */
 	vm_flags_mod(vma, VM_MIXEDMAP, VM_PFNMAP);
-	ret = vm_insert_pages(vma, vma->vm_start, abo->base.pages,
-			      &num_pages);
-	if (ret)
-		goto close_vma;
 
 	return 0;
 
-close_vma:
-	vma->vm_ops->close(vma);
-	return ret;
 put_obj:
 	drm_gem_object_put(gobj);
 	return ret;
@@ -878,7 +963,7 @@ static const struct drm_gem_object_funcs amdxdna_gem_shmem_funcs = {
 	.vmap = amdxdna_gem_obj_vmap,
 	.vunmap = amdxdna_gem_obj_vunmap,
 	.mmap = amdxdna_gem_obj_mmap,
-	.vm_ops = &drm_gem_shmem_vm_ops,
+	.vm_ops = &amdxdna_gem_mixedmap_vm_ops,
 	.export = amdxdna_gem_prime_export,
 };
 
-- 
2.53.0



