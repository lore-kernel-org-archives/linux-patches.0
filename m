Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E8C431A22;
	Fri,  7 Aug 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117046; cv=none; b=Z1/DVUFg1qxgZc4gjkKjaCqiYvzIA6W2Z+GbFNnMaex/mTm7LhSFJwHMvUT2+uDS3Agk/ZNipM8sVb0an7rQxtYUSI50SUrNNHC586oo6x8dHz3Ax0jONnmy+wISTByvfDLgyVRBxCB82OtgbWAirI8VFDbpQp+3Ck5NYKuyZaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117046; c=relaxed/simple;
	bh=HZktA+RRD0YEDeWJ2iDZZvBYSyg/Rev/GletV/DXJXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=optbxCeAjv0xqnj4tFHoBcKP9Bi6uCBu0LSCMzzbmz62YMkxhIdFflNKDvzXCXcbrQobPv5PlB5pKIdViH7eDXFnHAoQfE0mzdIEUHFG7/CH/KiZxTUT/evc04iLsCeR8w6HdQValzwZn04lojQgtpTnpLZGaG3gEBQfAZIZq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B90D/vIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B90D/vIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6586D1F000E9;
	Fri,  7 Aug 2026 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117044;
	bh=ZHE13bUMPbrNW49XAH4KqG+1FSn7fTLZh7c4Rp5hspQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B90D/vICr0jOr8U5TjmM22SV7+AGs3yEwp0Ug0II9RL5GFCa1k7L6zkDXKuMcTaE6
	 rlTCUILh30W8NACkND/2WCd/LAJiTPnViUR8KpeETzWzTLeNXDf8puX6biPSYd5Q8F
	 eaC+bBZrCfC08UXZv0v7i7M1w7QTUi/cDNtbrUgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 164/438] drm/xe/pt: check no-DMA huge-pte cases before DMA segment test
Date: Fri,  7 Aug 2026 16:36:00 +0200
Message-ID: <20260807143431.528810539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit d94f82d57e7a86def6946f22b34eb53f96628f8a ]

On a non-range clear, curs.size is never set, so the segment test
(next - va_curs_start > curs->size) returns false for every level > 0
before the clear_pt short-circuit is reached. The clear then descends to
level 0 instead of forming a huge zero-leaf, wasting page tables and
risking -ENOMEM on unbind.

Move the null-VMA, purged-BO and clear_pt short-circuits above the
curs->size test. The bind path always sets curs.size, so it is unaffected.

v2
- Also set curs.size on the clear path so the cursor stays meaningful
during the walk. clear_pt is only reached with range == NULL, so assert
that invariant. (Matthew Brost)

Cc: Matthew Brost <matthew.brost@intel.com>
Fixes: 5b658b7e89c3 ("drm/xe: Clear scratch page on vm_bind")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260728055916.593707-2-himal.prasad.ghimiray@intel.com
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
(cherry picked from commit 04eeeb45cb61b8a3e9d785003457e550c920ba49)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index cf371c0d7b2bb..a4d0d9bf0c8eb 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -442,10 +442,6 @@ static bool xe_pt_hugepte_possible(u64 addr, u64 next, unsigned int level,
 	if (!xe_pt_covers(addr, next, level, &xe_walk->base))
 		return false;
 
-	/* Does the DMA segment cover the whole pte? */
-	if (next - xe_walk->va_curs_start > xe_walk->curs->size)
-		return false;
-
 	/* null VMA's and purged BO's do not have dma addresses */
 	if (xe_vma_is_null(xe_walk->vma) || (bo && xe_bo_is_purged(bo)))
 		return true;
@@ -454,6 +450,10 @@ static bool xe_pt_hugepte_possible(u64 addr, u64 next, unsigned int level,
 	if (xe_walk->clear_pt)
 		return true;
 
+	/* Does the DMA segment cover the whole pte? */
+	if (next - xe_walk->va_curs_start > xe_walk->curs->size)
+		return false;
+
 	/* Is the DMA address huge PTE size aligned? */
 	size = next - addr;
 	dma = addr - xe_walk->va_curs_start + xe_res_dma(xe_walk->curs);
@@ -774,8 +774,11 @@ xe_pt_stage_bind(struct xe_tile *tile, struct xe_vma *vma,
 	}
 
 	xe_walk.needs_64K = (vm->flags & XE_VM_FLAG_64K);
-	if (clear_pt)
+	if (clear_pt) {
+		xe_assert(xe, !range);
+		curs.size = xe_vma_size(vma);
 		goto walk_pt;
+	}
 
 	if (vma->gpuva.flags & XE_VMA_ATOMIC_PTE_BIT) {
 		xe_walk.default_vram_pte = xe_atomic_for_vram(vm, vma) ? XE_USM_PPGTT_PTE_AE : 0;
-- 
2.53.0



