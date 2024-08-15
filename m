Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A8B1A7060;
	Thu, 15 Aug 2024 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730651; cv=none; b=VFLwNIHdVbSAnhZ7hTvm6DeDuwFJw2pKm1ZaEAxffEHcGWueZNXcsFLFA0O/xCvRvmCJkptCJUhzORPqwQyW+Ds8UdJFInP5I6Ex5csX3WKiNSUlW+PJc3lsOJP3tM48eQeMiLFatyzxThPP8pQGTRh+kuUUdtKYugSy8hb/GTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730651; c=relaxed/simple;
	bh=9ATMyHnP5pVIdhXNmz8kbczuVUgzMJNc9JvsAINgza0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVjBHgf8LwG2Ul8QuC67cPgTYgPgoSyP3oeEDGjJhVsrE3OTXRve+Fp91BtamoML92tDxRwb6IK0WOYMA7i80kUrjVtAyjM5RdFti6Ghc7CmrOlCwWOMG9dU7nNLhNOBQ4bpQjWXJaB1OcEngS/JSGHwv5DRaBeKPFSzcgzQt4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fh3ityFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fh3ityFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E95C4AF0A;
	Thu, 15 Aug 2024 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730651;
	bh=9ATMyHnP5pVIdhXNmz8kbczuVUgzMJNc9JvsAINgza0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fh3ityFa/0CenRKxoijf82XWLVFzPoA9wP++poMZl14tYbmm3DVbgXK3YuK4e+ak6
	 ufECFSonJii6ICe7NJo8ft6uuLXMuN9YD5wZgj0AW2cx5/+4uKqN0seyhehbTwy0Og
	 C3TvJSF5X5QPVmDtVfOMz4VcgOvuc5O38H/vY3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jonathan Cavitt <Jonathan.cavitt@intel.com>
Subject: [PATCH 5.15 475/484] drm/i915/gem: Fix Virtual Memory mapping boundaries calculation
Date: Thu, 15 Aug 2024 15:25:33 +0200
Message-ID: <20240815131959.826627740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

commit 8bdd9ef7e9b1b2a73e394712b72b22055e0e26c3 upstream.

Calculating the size of the mapped area as the lesser value
between the requested size and the actual size does not consider
the partial mapping offset. This can cause page fault access.

Fix the calculation of the starting and ending addresses, the
total size is now deduced from the difference between the end and
start addresses.

Additionally, the calculations have been rewritten in a clearer
and more understandable form.

Fixes: c58305af1835 ("drm/i915: Use remap_io_mapping() to prefault all PTE in a single pass")
Reported-by: Jann Horn <jannh@google.com>
Co-developed-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v4.9+
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Jonathan Cavitt <Jonathan.cavitt@intel.com>
[Joonas: Add Requires: tag]
Requires: 60a2066c5005 ("drm/i915/gem: Adjust vma offset for framebuffer mmap offset")
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240802083850.103694-3-andi.shyti@linux.intel.com
(cherry picked from commit 97b6784753da06d9d40232328efc5c5367e53417)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |   53 +++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -286,6 +286,41 @@ out:
 	return i915_error_to_vmf_fault(err);
 }
 
+static void set_address_limits(struct vm_area_struct *area,
+			       struct i915_vma *vma,
+			       unsigned long obj_offset,
+			       unsigned long *start_vaddr,
+			       unsigned long *end_vaddr)
+{
+	unsigned long vm_start, vm_end, vma_size; /* user's memory parameters */
+	long start, end; /* memory boundaries */
+
+	/*
+	 * Let's move into the ">> PAGE_SHIFT"
+	 * domain to be sure not to lose bits
+	 */
+	vm_start = area->vm_start >> PAGE_SHIFT;
+	vm_end = area->vm_end >> PAGE_SHIFT;
+	vma_size = vma->size >> PAGE_SHIFT;
+
+	/*
+	 * Calculate the memory boundaries by considering the offset
+	 * provided by the user during memory mapping and the offset
+	 * provided for the partial mapping.
+	 */
+	start = vm_start;
+	start -= obj_offset;
+	start += vma->ggtt_view.partial.offset;
+	end = start + vma_size;
+
+	start = max_t(long, start, vm_start);
+	end = min_t(long, end, vm_end);
+
+	/* Let's move back into the "<< PAGE_SHIFT" domain */
+	*start_vaddr = (unsigned long)start << PAGE_SHIFT;
+	*end_vaddr = (unsigned long)end << PAGE_SHIFT;
+}
+
 static vm_fault_t vm_fault_gtt(struct vm_fault *vmf)
 {
 #define MIN_CHUNK_PAGES (SZ_1M >> PAGE_SHIFT)
@@ -298,14 +333,18 @@ static vm_fault_t vm_fault_gtt(struct vm
 	struct i915_ggtt *ggtt = &i915->ggtt;
 	bool write = area->vm_flags & VM_WRITE;
 	struct i915_gem_ww_ctx ww;
+	unsigned long obj_offset;
+	unsigned long start, end; /* memory boundaries */
 	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	pgoff_t page_offset;
+	unsigned long pfn;
 	int srcu;
 	int ret;
 
-	/* We don't use vmf->pgoff since that has the fake offset */
+	obj_offset = area->vm_pgoff - drm_vma_node_start(&mmo->vma_node);
 	page_offset = (vmf->address - area->vm_start) >> PAGE_SHIFT;
+	page_offset += obj_offset;
 
 	trace_i915_gem_object_fault(obj, page_offset, true, write);
 
@@ -376,12 +415,14 @@ retry:
 	if (ret)
 		goto err_unpin;
 
+	set_address_limits(area, vma, obj_offset, &start, &end);
+
+	pfn = (ggtt->gmadr.start + i915_ggtt_offset(vma)) >> PAGE_SHIFT;
+	pfn += (start - area->vm_start) >> PAGE_SHIFT;
+	pfn += obj_offset - vma->ggtt_view.partial.offset;
+
 	/* Finally, remap it using the new GTT offset */
-	ret = remap_io_mapping(area,
-			       area->vm_start + (vma->ggtt_view.partial.offset << PAGE_SHIFT),
-			       (ggtt->gmadr.start + vma->node.start) >> PAGE_SHIFT,
-			       min_t(u64, vma->size, area->vm_end - area->vm_start),
-			       &ggtt->iomap);
+	ret = remap_io_mapping(area, start, pfn, end - start, &ggtt->iomap);
 	if (ret)
 		goto err_fence;
 


