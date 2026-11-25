Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622368;
	b=W9SELaokNG9vISYnBCooC3TZ0GTJldqH8CdI7EOMarColsALYJNXzqgz1fklrmZwMEv5
	 L1n9vWmmPiLwHSwLiQ219M+sVGZdNRUWmEiYlI609v66Xw/ofydpYGSAIhe1CXnVBN21i
	 fg2V49Eacp2e45CWAXUa585ozbFpL/sumJMeA8u7/tCVB4sJP9utpKl/1HfpMNlpjoVef
	 DeuEbGaSxXxOi7gnw7M6zCGHIEzoAW0uhDGBiBb3PVGAty409ezSncPUuX0zk6pJcHBwB
	 J0vITnLN6a/IfpF+Eh8e816KYWMTOiM1Sajodit+9rCcxEUyypalFAMaZUa4aPNBDgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=L3uPKcRYMBBwVtT/yvRD7897p4wkwR7WetviJVQXAvk=;
	b=4MeudGAtHcOv/E+BRYasp1vTJ1UYMVPNDps3GteFlFweL8t1hiAzd2ebcNlX8r2lfWVE
	 s6j+CTA9siB1sTxwCr9wc82lSiQ0lAfI2QodPKUS6sXnuVqageRrIL21q/tSIe2oUP9tW
	 sN8eJPcFuyUqeXs+oKIiosjmbSNWq+LCQS4NYtN362Bhf6I8MkklJchowIBClDapUA00b
	 xdMT5or5CuAQKIaFjLOrX96AdArtE44Q8vS99eEz6/6P4ZOX5MGZtnIM6lrSEAvn/9gjR
	 r7LNjKukWJME6B9qrMYDsxfF67O5nBxDWqEWTrpUDbjOgMnhoQZFMKjfQR44//6ZvYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsGTW3uH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9099F606A321;
	Wed, 25 Nov 2026 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsGTW3uH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937181F000CA;
	Wed, 25 Nov 2026 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622368;
	bh=L3uPKcRYMBBwVtT/yvRD7897p4wkwR7WetviJVQXAvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsGTW3uHBrnoArFgNiZhhkgbSmagl2w+6c83lWVcAMMA+Fp3B1q5Vd5c4kFzZjeI5
	 6GUK0n8D1/mffitWrA+sqJM4kdRO517mhvcOCIdksGu+Wz2uW8D4lK0c084pQj7j6n
	 i+aRVfzurHFUgVlop9hQMPDnvxAIQeFyzHxHpczg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 515/990] accel/amdxdna: Fix unsafe use of handle_mm_fault()
Date: Wed, 25 Nov 2026 15:31:22 +0100
Message-ID: <20261125143834.160541742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced linear_page_delta(vma, vmf->address) with its open-coded equivalent (vmf->address - vma->vm_start) >> PAGE_SHIFT, since that helper doesn't exist here, and adjusted surrounding context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 151 ++++++++++++++++++++++------
 1 file changed, 118 insertions(+), 33 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 69c9034fae78a..e416a6ef7304e 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -13,6 +13,7 @@
 #include <linux/dma-direct.h>
 #include <linux/iosys-map.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 #include <linux/vmalloc.h>
 
 #include "amdxdna_ctx.h"
@@ -333,16 +334,16 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
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
@@ -351,23 +352,28 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
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
@@ -379,6 +385,10 @@ static int amdxdna_gem_obj_mmap(struct drm_gem_object *gobj,
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
 	int ret;
 
+	XDNA_DBG(xdna, "BO map_offset 0x%llx type %d userptr 0x%lx size 0x%lx",
+		 drm_vma_node_offset_addr(&gobj->vma_node), abo->type,
+		 vma->vm_start, gobj->size);
+
 	ret = amdxdna_hmm_register(abo, vma);
 	if (ret)
 		return ret;
@@ -389,9 +399,6 @@ static int amdxdna_gem_obj_mmap(struct drm_gem_object *gobj,
 		goto hmm_unreg;
 	}
 
-	XDNA_DBG(xdna, "BO map_offset 0x%llx type %d userptr 0x%lx size 0x%lx",
-		 drm_vma_node_offset_addr(&gobj->vma_node), abo->type,
-		 vma->vm_start, gobj->size);
 	return 0;
 
 hmm_unreg:
@@ -399,14 +406,99 @@ static int amdxdna_gem_obj_mmap(struct drm_gem_object *gobj,
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
+	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
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
@@ -416,16 +508,9 @@ static int amdxdna_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struc
 
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
@@ -538,7 +623,7 @@ static const struct drm_gem_object_funcs amdxdna_gem_shmem_funcs = {
 	.vmap = drm_gem_shmem_object_vmap,
 	.vunmap = drm_gem_shmem_object_vunmap,
 	.mmap = amdxdna_gem_obj_mmap,
-	.vm_ops = &drm_gem_shmem_vm_ops,
+	.vm_ops = &amdxdna_gem_mixedmap_vm_ops,
 	.export = amdxdna_gem_prime_export,
 };
 
-- 
2.53.0



