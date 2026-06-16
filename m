Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3832E328610;
	Tue, 16 Jun 2026 17:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629498; cv=none; b=jpLn6LJPNqOfxkTA6XIRz3NXpy+Z2sDyL9Jkcurk0MIz/Pc5fWwhU+0uU5/iT9SSpM1V+T0+IkoPKUYVF7ZA5uzHBa78x87b1zXMSKlzzlvSuUvPtWCfo4XLWu/3wQSPpdlJwFcf8F9F5D9yuipBNBVQeybUUSr9gXZj502AGOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629498; c=relaxed/simple;
	bh=lruVkSVgtHAbUzp4e7cf2kvGFosFVfW4OqmHhi7fmoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOXailInAJBUlFocCOIVe721Tg69bmwdUk3ELQu9BpYczNUafY+CK14NCnolqBUsyKKzjlCNxmpB6OcRiJ1bfWPjj/QOVJOkabc2dXUU7qp2HtzXEFlY2ZU3igfGxuj/AJ0F8YD64jTcUyblZ5Fymb3NlzvutFe4RfXdp2Vtw24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jt/WONbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jt/WONbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0941F000E9;
	Tue, 16 Jun 2026 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629497;
	bh=rokjXT2dEMAmCA4TvXhwKsXwmsSSdLhqkEnmtg9zZAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jt/WONblqJpL3MbelaOgxJO08+aSAn5pPrrVbUKeI89LuvaPTStcbH+Tzqjmj+IZt
	 cqz+PRUjOwFnZLILnLw1n3xyatGRoj0NcoVstkU6CrVmlGR7DUGaVbNJIrAifC6bOE
	 ryvOy7Nw/ijsAcnrRa40u7V8RGp/pLEtFBwUdZ7g=
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
Subject: [PATCH 6.6 297/452] drm/i915/gem: Fix phys BO pread/pwrite with offset
Date: Tue, 16 Jun 2026 20:28:44 +0530
Message-ID: <20260616145133.128150349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -101,7 +112,7 @@ i915_gem_object_put_pages_phys(struct dr
 			       struct sg_table *pages)
 {
 	dma_addr_t dma = sg_dma_address(pages->sgl);
-	void *vaddr = sg_page(pages->sgl);
+	void *vaddr = __get_phys_vaddr(pages->sgl);
 
 	__i915_gem_object_release_shmem(obj, pages, false);
 
@@ -144,7 +155,7 @@ i915_gem_object_put_pages_phys(struct dr
 int i915_gem_object_pwrite_phys(struct drm_i915_gem_object *obj,
 				const struct drm_i915_gem_pwrite *args)
 {
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	void *vaddr = __get_phys_vaddr(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 	int err;
@@ -175,7 +186,7 @@ int i915_gem_object_pwrite_phys(struct d
 int i915_gem_object_pread_phys(struct drm_i915_gem_object *obj,
 			       const struct drm_i915_gem_pread *args)
 {
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	void *vaddr = __get_phys_vaddr(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 	int err;
 


