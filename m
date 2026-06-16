Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2723101A7;
	Tue, 16 Jun 2026 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631709; cv=none; b=RP1K4nXtx9yA30GnfXBXEgQN+qznSCU7wEeq6UuOLzAmXa7pq/uT2eFxKUmtDwhRgt2H9hONNhf7pAWsGfq6saA7MeLMdq1C2gqiRN/+nU3/IiuNJTsdWSdAGiIaxlHdzY3j73zQLTHvazGVyO9U/GUcvghaRo995VDExQNwHwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631709; c=relaxed/simple;
	bh=Q1lpmYRLAPI68r+S9mL8aTocRpnmO4gn/mm/82gJxds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIXi4UZSmUeQ2yGKvka+s6GYBm2pa4YEst3pHFaro/tqjQe6Iy+fftdDXVUonT+2DAJIwQkpKKZpsO3+KMOBmqKaVz5OANJpJg/iuUcoiwYk0G1d4OMw53AtNhfFBm5Jl6behpzLymSVQhqPHc4PvcXGPmeSc47KeKLe1JmGsnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipnEkZ0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipnEkZ0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB731F00A3A;
	Tue, 16 Jun 2026 17:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631705;
	bh=ppCKdnYNxlxN9kwK6RIs4BOSZr1mJT3XPcB/6yASsAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipnEkZ0SqIaHfqAOu2t3wcQW+8ZZlxubAsTN+ZOqfvODBK8RgtJIT9D8hsw+3WoKZ
	 BF3RiBtDL3v7rQ3Sym9YAbfV/HFkDi396pCFUEmMhbo200ICZsPN3xZfFeTIrgZpkj
	 I1UOl8baM1AsamEf9Zo42fa+4YTvG9p4zBBbcB1s=
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
Subject: [PATCH 6.1 271/522] drm/i915/gem: Fix phys BO pread/pwrite with offset
Date: Tue, 16 Jun 2026 20:26:58 +0530
Message-ID: <20260616145138.640788756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,7 +64,7 @@ static int i915_gem_object_get_pages_phy
 	sg->offset = 0;
 	sg->length = obj->base.size;
 
-	sg_assign_page(sg, (struct page *)vaddr);
+	__set_phys_vaddr(sg, vaddr);
 	sg_dma_address(sg) = dma;
 	sg_dma_len(sg) = obj->base.size;
 
@@ -97,7 +108,7 @@ i915_gem_object_put_pages_phys(struct dr
 			       struct sg_table *pages)
 {
 	dma_addr_t dma = sg_dma_address(pages->sgl);
-	void *vaddr = sg_page(pages->sgl);
+	void *vaddr = __get_phys_vaddr(pages->sgl);
 
 	__i915_gem_object_release_shmem(obj, pages, false);
 
@@ -140,7 +151,7 @@ i915_gem_object_put_pages_phys(struct dr
 int i915_gem_object_pwrite_phys(struct drm_i915_gem_object *obj,
 				const struct drm_i915_gem_pwrite *args)
 {
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	void *vaddr = __get_phys_vaddr(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 	int err;
@@ -171,7 +182,7 @@ int i915_gem_object_pwrite_phys(struct d
 int i915_gem_object_pread_phys(struct drm_i915_gem_object *obj,
 			       const struct drm_i915_gem_pread *args)
 {
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	void *vaddr = __get_phys_vaddr(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 	int err;
 


