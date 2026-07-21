Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62601F3D56;
	Tue, 21 Jul 2026 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653646; cv=none; b=OkxUp8Sz+JfwDcHMTqW2SrSo/GvpEdu07LiZGA7B44Z/gVZdTKHSpRayML2J8xGyhRqYUqihILBwbuHt4obJhccUe7BbaLSCyNXOGbg1HMl8NvbjQwRc+waVVDEUjNJE+hk0t8ov4K1l4aBKw5Qg8AOeGQ8NSPXm+kD54bNJXk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653646; c=relaxed/simple;
	bh=ijA7nw+81OUcWtXSrvxm7GHx0BiGEm0iW6grkKxAu4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YQ1FQMjJp4zixEzdXDmsCOstZWWP1NH+/WVjnjRRbdkiW7zrpkzLebSSmO2TAMD3r5ieGEIIT8PMUFtLeQABeBdoLDHyWJlzNevPpdOihJo+jahMXL+Z+l5vJloz000bZZywGlg8LIB+kMwBT0L3AhqC4lXpH6oQxR05ZPYM5sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks7AnH84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks7AnH84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512551F000E9;
	Tue, 21 Jul 2026 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653644;
	bh=dxqGRynMWoCTfT0NYPtt5VemaUSWXSxL9xsxV2PrS/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ks7AnH848T+75fSRIqsGdcHauglapipDhjk9T4qgMP7YeXkuI09ovwV/xbtrdEC4v
	 jJ4WwV1HwJKIW1SXS3OgR0yxB+9PWNn9OGLGDfTlPoSHJmg3wlsp5PZOK7b2Cye+hv
	 RKYWJbNMbGnkDYaU/HzXkTzlrCSmb4oKc//YDono=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1405/2077] drm/xe/pt: prevent invalid cursor access for purged BOs
Date: Tue, 21 Jul 2026 17:17:58 +0200
Message-ID: <20260721152625.947979886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 8a0fb57675be578c4db19deb4298ed08a70f0f1a ]

During a page table walk for binding, xe_pt_stage_bind() explicitly
skips initializing the xe_res_cursor for purged BOs, treating them
similarly to NULL VMAs by only setting the cursor size.

However, xe_pt_hugepte_possible() and xe_pt_scan_64K() did not check
if the BO was purged before attempting to walk the cursor using
xe_res_dma() and xe_res_next(). Because the cursor was left
uninitialized for purged BOs, this falls through and triggers
warnings like:

  WARNING: drivers/gpu/drm/xe/xe_res_cursor.h:274 at xe_res_next

Fix this by explicitly checking if the BO is purged in both
xe_pt_hugepte_possible() and xe_pt_scan_64K(), returning early just
as we do for NULL VMAs, avoiding the invalid cursor accesses entirely.

As a precaution, also zero-initialize the cursor in xe_pt_stage_bind()
to ensure we don't pass garbage data into the page table walkers
if we ever hit a similar edge case in the future.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8418
Fixes: ad9843aac91a ("drm/xe/madvise: Implement purgeable buffer object support")
Assisted-by: Copilot:gemini-3.1-pro-preview
Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Tested-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260625152054.450125-8-matthew.auld@intel.com
(cherry picked from commit 4c7b9c6ece32440e5a435a92076d049450cd2d2e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pt.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index 3e438a2799850a..4d8f0a8b072e52 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -432,6 +432,7 @@ xe_pt_insert_entry(struct xe_pt_stage_bind_walk *xe_walk, struct xe_pt *parent,
 static bool xe_pt_hugepte_possible(u64 addr, u64 next, unsigned int level,
 				   struct xe_pt_stage_bind_walk *xe_walk)
 {
+	struct xe_bo *bo = xe_vma_bo(xe_walk->vma);
 	u64 size, dma;
 
 	if (level > MAX_HUGEPTE_LEVEL)
@@ -445,8 +446,8 @@ static bool xe_pt_hugepte_possible(u64 addr, u64 next, unsigned int level,
 	if (next - xe_walk->va_curs_start > xe_walk->curs->size)
 		return false;
 
-	/* null VMA's do not have dma addresses */
-	if (xe_vma_is_null(xe_walk->vma))
+	/* null VMA's and purged BO's do not have dma addresses */
+	if (xe_vma_is_null(xe_walk->vma) || (bo && xe_bo_is_purged(bo)))
 		return true;
 
 	/* if we are clearing page table, no dma addresses*/
@@ -467,6 +468,7 @@ static bool xe_pt_hugepte_possible(u64 addr, u64 next, unsigned int level,
 static bool
 xe_pt_scan_64K(u64 addr, u64 next, struct xe_pt_stage_bind_walk *xe_walk)
 {
+	struct xe_bo *bo = xe_vma_bo(xe_walk->vma);
 	struct xe_res_cursor curs = *xe_walk->curs;
 
 	if (!IS_ALIGNED(addr, SZ_64K))
@@ -475,8 +477,8 @@ xe_pt_scan_64K(u64 addr, u64 next, struct xe_pt_stage_bind_walk *xe_walk)
 	if (next > xe_walk->l0_end_addr)
 		return false;
 
-	/* null VMA's do not have dma addresses */
-	if (xe_vma_is_null(xe_walk->vma))
+	/* null VMA's and purged BO's do not have dma addresses */
+	if (xe_vma_is_null(xe_walk->vma) || (bo && xe_bo_is_purged(bo)))
 		return true;
 
 	xe_res_next(&curs, addr - xe_walk->va_curs_start);
@@ -707,7 +709,7 @@ xe_pt_stage_bind(struct xe_tile *tile, struct xe_vma *vma,
 {
 	struct xe_device *xe = tile_to_xe(tile);
 	struct xe_bo *bo = xe_vma_bo(vma);
-	struct xe_res_cursor curs;
+	struct xe_res_cursor curs = {};
 	struct xe_vm *vm = xe_vma_vm(vma);
 	struct xe_pt_stage_bind_walk xe_walk = {
 		.base = {
-- 
2.53.0



