Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4184752B1F7;
	Wed, 23 Sep 2026 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173255; cv=none; b=dDlhQvaNgJjKxXmU35ZeS+ETea84L/cepLiO7ABKlfh4kAxa0ytsGPvI29Y9v8f/ciNUIS3agIrQ1Oumz6bOcj6tHK8Oh7o1BASTRwVEGvD4IrqBRHm4jirg7gwKlagNMHR7WXa7FGpzOb3zf4/r5Nd8lzm9gHvBqL3V1lKMLAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173255; c=relaxed/simple;
	bh=hXLs16eDx5NVvD0Qy8+mSglFbcEIILhVC09j8a76aSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3z6narW86uzb5eZXCvo2gT4TBU0pC+0ZiNQcY5/GfLNVf07XYOfTW/V1rCWYDIWcwT+IZSt3dBfL6jAzgWwQSsA/zbq6Ax32a9fllDTd/WR0EzquaG4WW+GRxVKSu9lP2zi69upoNeXQMktkyUpG9M29Wni2soU0i/XZsDhcx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdfMvhtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdfMvhtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EA51F000FF;
	Wed, 23 Sep 2026 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173253;
	bh=739OqC81eRBF62d6Cf0eXvPq+7kosTkntT/QC4W01xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdfMvhttD8hHUlGUFaZXPSMaDCKwhoXkVhZ1EzxsEIjkRzT4NR/L7BpSKGZb2wvWn
	 egDPQuylJaGbsTmm4dvc+j9u+vk11ER3OBvuxdt51oGx06Cm/3A+85N5W/CSim02us
	 jVuYvmGv9dgAQ87ld5zGiRUR844S47q2JDcFw/yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ilia Levi <ilia.levi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 145/438] drm/xe/mmio_gem: use write-back mapping for dummy page
Date: Wed, 23 Sep 2026 16:02:46 +0200
Message-ID: <20260923140648.530194369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Levi <ilia.levi@intel.com>

[ Upstream commit 819f189265a5955da743e78e20a713a038982e89 ]

Currently vmf_insert_pfn() maps the dummy page as UC, inheriting the
VMA's page protection which was set for the real MMIO region. This
conflicts with the direct map's WB mapping of the same page, creating a
cache type alias which is architecturally undefined on some platforms.

Use vmf_insert_pfn_prot() with a WB pgprot instead. Also simplify to
fault in the requested page instead of the whole VMA.

Fixes: 1ffcf8b8ae8a ("drm/xe: Support for mmap-ing mmio regions")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525125801.975038-6-ilia.levi%40intel.com
Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Ilia Levi <ilia.levi@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260908165046.1393557-12-matthew.auld@intel.com
(cherry picked from commit 1e8e28e35df0e77ae1b22fc091c1f422f62fa5e9)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio_gem.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio_gem.c b/drivers/gpu/drm/xe/xe_mmio_gem.c
index f15a6a84af159..418a24bdfa4ed 100644
--- a/drivers/gpu/drm/xe/xe_mmio_gem.c
+++ b/drivers/gpu/drm/xe/xe_mmio_gem.c
@@ -172,14 +172,13 @@ static void xe_mmio_gem_release_dummy_page(struct drm_device *dev, void *res)
 	__free_page((struct page *)res);
 }
 
-static vm_fault_t xe_mmio_gem_vm_fault_dummy_page(struct vm_area_struct *vma)
+static vm_fault_t xe_mmio_gem_vm_fault_dummy_page(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *base = vma->vm_private_data;
 	struct drm_device *dev = base->dev;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
 	struct page *page;
 	unsigned long pfn;
-	unsigned long i;
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page)
@@ -190,16 +189,8 @@ static vm_fault_t xe_mmio_gem_vm_fault_dummy_page(struct vm_area_struct *vma)
 
 	pfn = page_to_pfn(page);
 
-	/* Map the entire VMA to the same dummy page */
-	for (i = 0; i < base->size; i += PAGE_SIZE) {
-		unsigned long addr = vma->vm_start + i;
-
-		ret = vmf_insert_pfn(vma, addr, pfn);
-		if (ret & VM_FAULT_ERROR)
-			break;
-	}
-
-	return ret;
+	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
+				   vm_get_page_prot(vma->vm_flags));
 }
 
 static vm_fault_t xe_mmio_gem_vm_fault(struct vm_fault *vmf)
@@ -219,7 +210,7 @@ static vm_fault_t xe_mmio_gem_vm_fault(struct vm_fault *vmf)
 		 * It is assumed the userspace will receive the notification via some
 		 * other channel (e.g. drm uevent).
 		 */
-		return xe_mmio_gem_vm_fault_dummy_page(vma);
+		return xe_mmio_gem_vm_fault_dummy_page(vmf);
 	}
 
 	for (i = 0; i < base->size; i += PAGE_SIZE) {
-- 
2.53.0



