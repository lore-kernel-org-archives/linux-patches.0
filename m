Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6F431DD81;
	Sat, 25 Oct 2025 16:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409728; cv=none; b=mDD0t3NVH3SNpTTqH8SyJdzqAix/YOBZ2ZHz+YKsuTsRhcvAKhqwh+f/jhcdLMrkw7iq1DgNRNqCHpRGH4vGLxxq5P3abOLXzMYKYAbJwx9dpO641XnUAVuhkETrbkfk7aYi10IySCcoDBpz1dM/LfnfLqOLG++HX2UthoCyMxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409728; c=relaxed/simple;
	bh=TfrFbL7AB1XylbjJq1W+p29Kf2IE5kP36er6lCkkHzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXRmwX0vv0ECFHsQ7QqcwyMDDXCsiOWfrXDj04GPnMbQzn6rG6GuW2t3KpqVtfZz0BdikJx2sve8N1BJy/gqzo7ynJpOvZ5+4N4+0/3usfulSUZ1UKthBU1hLIoyDh6Yf0r9SaW6Lf1aBM0xKzDxUe0ZxFqv08UklIjfr0XeBlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idr/AbxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idr/AbxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4AEC4CEF5;
	Sat, 25 Oct 2025 16:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409728;
	bh=TfrFbL7AB1XylbjJq1W+p29Kf2IE5kP36er6lCkkHzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idr/AbxFY4jC4MTkz8DrNG2UNh9r3Xz8rej9VRw/Ng70MaaaS8YQp+xqN+jDV7kGe
	 W2IbS8M/DLfn4PrAvsc4yulzFOgcIqRnSPZwjhxsrNtC2BkKBdM9jk6/WpDmMTie8Q
	 H4DrSjfbVpDoXlO7cw5MBPt3hyjG1btmz4NtuUpmEMRO7Cwz2wsUrJEZwjYuB56fkC
	 d4b4gAQ8RuJoc9vNO2ErrArZz+KJOkvIp8VR93vTPAAXaHiyBr0OoJLow2jFk9kHzp
	 BgiyIftfcLzPrIWjVUBOEGVrfuxLwpsIt7UlgGY5h8+5rvzG6q2WbODM2l5NN9fd2q
	 qmS5OQ1JE3p/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de
Subject: [PATCH AUTOSEL 6.17] drm/gpusvm: fix hmm_pfn_to_map_order() usage
Date: Sat, 25 Oct 2025 12:01:10 -0400
Message-ID: <20251025160905.3857885-439-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit c50729c68aaf93611c855752b00e49ce1fdd1558 ]

Handle the case where the hmm range partially covers a huge page (like
2M), otherwise we can potentially end up doing something nasty like
mapping memory which is outside the range, and maybe not even mapped by
the mm. Fix is based on the xe userptr code, which in a future patch
will directly use gpusvm, so needs alignment here.

v2:
  - Add kernel-doc (Matt B)
  - s/fls/ilog2/ (Thomas)

Reported-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://lore.kernel.org/r/20250828142430.615826-11-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The old code advanced through the HMM PFN array and chose DMA map
    sizes based solely on `hmm_pfn_to_map_order(pfns[i])`, which
    describes the CPU PTE size (e.g., 2 MiB) but explicitly warns that
    the PTE can extend past the `hmm_range_fault()` range. See
    include/linux/hmm.h:81-89.
  - This could cause overmapping on the GPU side: mapping memory outside
    the requested range and potentially not even mapped by the owning
    `mm`, exactly as described in the commit message.
  - The new helper clamps the map size so it never crosses either the
    current huge-CPU-PTE boundary or the end of the HMM range:
    - Added helper: `drm_gpusvm_hmm_pfn_to_order()` computes the maximum
      safe order from the current PFN index, adjusting for the offset
      into the huge PTE and clamping to the remaining range size. See
      drivers/gpu/drm/drm_gpusvm.c:666-679.
    - It does:
      - `size = 1UL << hmm_pfn_to_map_order(hmm_pfn);`
      - Subtracts the intra-PTE offset: `size -= (hmm_pfn &
        ~HMM_PFN_FLAGS) & (size - 1);`
      - Clamps to the remaining range pages: if `hmm_pfn_index + size >
        npages`, reduce `size` accordingly.
      - Returns `ilog2(size)` so callers continue to work in orders.

- Where it applies
  - Page validity checking loop now skips PFNs safely without
    overshooting the HMM range, using the new helper to compute how far
    to jump. See drivers/gpu/drm/drm_gpusvm.c:739.
  - The GPU DMA mapping loop now maps only within the range and within
    the current CPU PTE boundary:
    - Order is now `drm_gpusvm_hmm_pfn_to_order(pfns[i], i, npages)`.
      See drivers/gpu/drm/drm_gpusvm.c:1361.
    - Device-private mappings call `dpagemap->ops->device_map(..., page,
      order, ...)` with the clamped order. See
      drivers/gpu/drm/drm_gpusvm.c:1388-1391.
    - System memory mappings use `dma_map_page(..., PAGE_SIZE << order,
      ...)` with the clamped order. See
      drivers/gpu/drm/drm_gpusvm.c:1410-1413.
  - Together, this prevents mapping outside `[start, end)` even when the
    range only partially covers a huge PTE (e.g., 2 MiB).

- Why it matters for stable
  - User-visible bug: Overmapping beyond the requested user range can
    result in mapping pages not owned/mapped by the process. That risks
    correctness (DMA into the wrong memory) and could have security
    implications (DMA reading/writing unintended memory).
  - Small and contained: The change adds a small static helper and
    modifies two call sites in `drm_gpusvm.c`. No ABI/UAPI change. No
    architectural changes.
  - Matches HMM contract: The HMM API explicitly warns that `map_order`
    can extend past the queried range; this patch implements the
    necessary clamping.
  - Low regression risk: The helper is purely defensive. Worst case it
    results in additional smaller DMA mapping segments when starting in
    the middle of a huge PTE or near range end, which is safe. It
    mirrors proven logic used in Xe userptr code.
  - Scope: Limited to DRM GPU SVM memory acquisition and validation
    paths:
    - `drm_gpusvm_check_pages()` at
      drivers/gpu/drm/drm_gpusvm.c:693-745.
    - `drm_gpusvm_get_pages()` mapping loop at
      drivers/gpu/drm/drm_gpusvm.c:1358-1426.
  - No feature additions: Pure bugfix that tightens bounds.

- Stable backport criteria assessment
  - Fixes an important correctness (and potential security) bug that can
    affect users.
  - Change is minimal, self-contained, and localized to one file.
  - No broader side effects; does not alter subsystem architecture or
    interfaces.
  - Even though the commit message does not include “Cc: stable”, it
    clearly qualifies under stable rules as a targeted bugfix with low
    risk.

Conclusion: This is a clear, low-risk bugfix preventing out-of-range DMA
mappings when HMM ranges partially cover huge PTEs. It should be
backported to stable trees that contain GPU SVM.

 drivers/gpu/drm/drm_gpusvm.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 5bb4c77db2c3c..1dd8f3b593df6 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -708,6 +708,35 @@ drm_gpusvm_range_alloc(struct drm_gpusvm *gpusvm,
 	return range;
 }
 
+/**
+ * drm_gpusvm_hmm_pfn_to_order() - Get the largest CPU mapping order.
+ * @hmm_pfn: The current hmm_pfn.
+ * @hmm_pfn_index: Index of the @hmm_pfn within the pfn array.
+ * @npages: Number of pages within the pfn array i.e the hmm range size.
+ *
+ * To allow skipping PFNs with the same flags (like when they belong to
+ * the same huge PTE) when looping over the pfn array, take a given a hmm_pfn,
+ * and return the largest order that will fit inside the CPU PTE, but also
+ * crucially accounting for the original hmm range boundaries.
+ *
+ * Return: The largest order that will safely fit within the size of the hmm_pfn
+ * CPU PTE.
+ */
+static unsigned int drm_gpusvm_hmm_pfn_to_order(unsigned long hmm_pfn,
+						unsigned long hmm_pfn_index,
+						unsigned long npages)
+{
+	unsigned long size;
+
+	size = 1UL << hmm_pfn_to_map_order(hmm_pfn);
+	size -= (hmm_pfn & ~HMM_PFN_FLAGS) & (size - 1);
+	hmm_pfn_index += size;
+	if (hmm_pfn_index > npages)
+		size -= (hmm_pfn_index - npages);
+
+	return ilog2(size);
+}
+
 /**
  * drm_gpusvm_check_pages() - Check pages
  * @gpusvm: Pointer to the GPU SVM structure
@@ -766,7 +795,7 @@ static bool drm_gpusvm_check_pages(struct drm_gpusvm *gpusvm,
 			err = -EFAULT;
 			goto err_free;
 		}
-		i += 0x1 << hmm_pfn_to_map_order(pfns[i]);
+		i += 0x1 << drm_gpusvm_hmm_pfn_to_order(pfns[i], i, npages);
 	}
 
 err_free:
@@ -1342,7 +1371,7 @@ int drm_gpusvm_range_get_pages(struct drm_gpusvm *gpusvm,
 	for (i = 0, j = 0; i < npages; ++j) {
 		struct page *page = hmm_pfn_to_page(pfns[i]);
 
-		order = hmm_pfn_to_map_order(pfns[i]);
+		order = drm_gpusvm_hmm_pfn_to_order(pfns[i], i, npages);
 		if (is_device_private_page(page) ||
 		    is_device_coherent_page(page)) {
 			if (zdd != page->zone_device_data && i > 0) {
-- 
2.51.0

