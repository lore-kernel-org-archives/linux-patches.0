Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE235C1B7;
	Tue, 16 Jun 2026 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625619; cv=none; b=uaqgOlsB/naFMGG4z+fstR1vl/UdhN9UCvxiROurDWpB8yBxfxlciJ3jhnwpdlgjA2GmexiZLhZSXmzEtdm8FLIJOjR8bJP/clioTrflt7h2YTVomgA0HyyJwUVP9tWZ7q6mMPHXv88bjvpeAXug668DVDukEd71FW0pA9F64PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625619; c=relaxed/simple;
	bh=TyLuToc+dTS1EghUP0xQjZCNDXJishfd5P21hYiFmPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVqdg06eo952Wvhpaj9o8RDXxVLFbRK2B/MjK3044SF/4j6SA0izHQPjPdIzfE6JXOCObr6ksbwO+EQ/DzP8jJYBgMZR2WbD6/8rF+Wvdoeixds9vSXQUKTf56u8aYTGkStcQ3QNYOgCPdy8RnNvq75CHXz8By9V2rWHQLq3HbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQHp26As; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQHp26As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995EA1F00A3D;
	Tue, 16 Jun 2026 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625618;
	bh=ABlpOBlVeI6eTCwXKadYzv7g7MIQwQwrNPPHg9YbW0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQHp26AsIAzL+um0x4K34phDHTmQx3F3aPHIsJRJ68Y3BivHp/atd4j88opsIEnOi
	 uTKsi9WGrqPzx15T0c7faf4P7jZ2Il0/DNKz3wKBI1towV2UWZAIweKaX2EN6ZZ2Ir
	 wbIqwiiyut16MEXQXHsJqzNIYj3kPt4UpLiPKwiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.18 168/325] drm/i915/gem: Fix phys BO pread/pwrite with offset
Date: Tue, 16 Jun 2026 20:29:24 +0530
Message-ID: <20260616145106.186221070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

commit d21ad938398bca695a511307de38a65889e3b354 upstream.

sg_page() returns struct page pointer not (void *) so the scaling
of pread/pwrite is wrong for phys BO and wrong parts of BO would be
accessed if non-zero offset is used.

Last impacted platform with overlay or cursor planes using phys
mapping was Gen3/945G/Lakeport.

Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: c6790dc22312 ("drm/i915: Wean off drm_pci_alloc/drm_pci_free")
Cc: <stable@vger.kernel.org> # v4.5+
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patch.msgid.link/20260610060314.26111-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit 3e49a2f85070b2fb672c1e0fdba281a4ea3aebe6)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_phys.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_phys.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
@@ -17,6 +17,17 @@
 #include "i915_gem_tiling.h"
 #include "i915_scatterlist.h"
 
+/* Abuse scatterlist to store pointer instead of struct page. */
+static inline void __set_phys_vaddr(struct scatterlist *sg, void *vaddr)
+{
+	sg_assign_page(sg, (struct page *)vaddr);
+}
+
+static inline void *__get_phys_vaddr(struct scatterlist *sg)
+{
+	return (void *)sg_page(sg);
+}
+
 static int i915_gem_object_get_pages_phys(struct drm_i915_gem_object *obj)
 {
 	struct address_space *mapping = obj->base.filp->f_mapping;
@@ -57,7 +68,7 @@ static int i915_gem_object_get_pages_phy
 	sg->offset = 0;
 	sg->length = obj->base.size;
 
-	sg_assign_page(sg, (struct page *)vaddr);
+	__set_phys_vaddr(sg, vaddr);
 	sg_dma_address(sg) = dma;
 	sg_dma_len(sg) = obj->base.size;
 
@@ -98,7 +109,7 @@ i915_gem_object_put_pages_phys(struct dr
 			       struct sg_table *pages)
 {
 	dma_addr_t dma = sg_dma_address(pages->sgl);
-	void *vaddr = sg_page(pages->sgl);
+	void *vaddr = __get_phys_vaddr(pages->sgl);
 
 	__i915_gem_object_release_shmem(obj, pages, false);
 
@@ -138,7 +149,7 @@ i915_gem_object_put_pages_phys(struct dr
 int i915_gem_object_pwrite_phys(struct drm_i915_gem_object *obj,
 				const struct drm_i915_gem_pwrite *args)
 {
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	void *vaddr = __get_phys_vaddr(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 	int err;
@@ -169,7 +180,7 @@ int i915_gem_object_pwrite_phys(struct d
 int i915_gem_object_pread_phys(struct drm_i915_gem_object *obj,
 			       const struct drm_i915_gem_pread *args)
 {
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	void *vaddr = __get_phys_vaddr(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 	int err;
 


