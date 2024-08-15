Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BCB1AC8AE;
	Thu, 15 Aug 2024 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731841; cv=none; b=OOMLj5PCBq6zHHP+e1hNKxN/rEbSsqixjAtfo3tHgdL2PzMQzMUXXLva7cJrm8xxoDm4en9fylzcLUyVgYb0P6pi5ABXBXOV3U6FU/8304c4PE4u6pbxTnNlmdE7rj4ysXlwWLcTgRnVM16wr3vsNW9hSsU6UGEY6Q3wmUpch9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731841; c=relaxed/simple;
	bh=5mEhrvS7pS9kyD8l1v1yZYtTBQYtGOq972K8xAjwoo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHEOiNYoeER7XLR4//i9R2xTIZPFP3w86L8wf2UMF5yaw7xiDq2wwiSHeNFgY5TF2kYiARodmTw7hFeFumdnnKCwVMCYE95RCGTDXNCnycs2Ja0X4w338yO2O9FJdBK/qvZM1EA4CitCTG3bK/YkpeKvG2V2125dqP39Swy+13Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ/GjUdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ/GjUdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3901CC4AF0C;
	Thu, 15 Aug 2024 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731841;
	bh=5mEhrvS7pS9kyD8l1v1yZYtTBQYtGOq972K8xAjwoo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ/GjUdfbZLG5/5qEJ47h+VBh9kUsdBBf4PQEbHYJMowr2NmHvKHopPr1Y1IYh4Et
	 nB3ItTpV28qmpBjnL+8gHhtksMioleiOflOhj9OMJhO92GwsM9z1bNN81ri9nXNzPz
	 SaHz0cNkOxH6oik5ShfzKjEOZTjL4POFlkqHMCvk=
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
Subject: [PATCH 5.4 254/259] drm/i915/gem: Fix Virtual Memory mapping boundaries calculation
Date: Thu, 15 Aug 2024 15:26:27 +0200
Message-ID: <20240815131912.681155987@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |   47 +++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -196,6 +196,39 @@ compute_partial_view(const struct drm_i9
 	return view;
 }
 
+static void set_address_limits(struct vm_area_struct *area,
+			       struct i915_vma *vma,
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
 /**
  * i915_gem_fault - fault a page into the GTT
  * @vmf: fault info
@@ -224,9 +257,11 @@ vm_fault_t i915_gem_fault(struct vm_faul
 	struct intel_runtime_pm *rpm = &i915->runtime_pm;
 	struct i915_ggtt *ggtt = &i915->ggtt;
 	bool write = area->vm_flags & VM_WRITE;
+	unsigned long start, end; /* memory boundaries */
 	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	pgoff_t page_offset;
+	unsigned long pfn;
 	int srcu;
 	int ret;
 
@@ -295,12 +330,14 @@ vm_fault_t i915_gem_fault(struct vm_faul
 	if (ret)
 		goto err_unpin;
 
+	set_address_limits(area, vma, &start, &end);
+
+	pfn = (ggtt->gmadr.start + i915_ggtt_offset(vma)) >> PAGE_SHIFT;
+	pfn += (start - area->vm_start) >> PAGE_SHIFT;
+	pfn -= vma->ggtt_view.partial.offset;
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
 


