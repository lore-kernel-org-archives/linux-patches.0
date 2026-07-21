Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A2C3E49EF;
	Tue, 21 Jul 2026 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653823; cv=none; b=Fn+cucAQmCVQmjxBVYBag4+xsmqen5uTDAxCKUrPtqDHm83gI1VV8B/LNK+yugB6GjqsWRNWJ85j7NZfma94jWImmwc0Vfy7Dy2+X99UBB4I43k2ZILNoSc02Wip9C5xU7fpNWs44ngL9n5jJ/1tQ8qOKTRcfufcqSRZkwnjuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653823; c=relaxed/simple;
	bh=c8UUE5Tg3JBRZrjUuhPfs+ee4Q00SHZs4eqVbawnoDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNFDvs2cAlaQSm83dRy8e5l1aejmVvevzYG6ZBqp4FHbShw2CCgyco72RMU7r22oZxZdm7SW+xtNRbQcHosc5+jF/F6vwG99kFfS4NcAB03JX5B3/Y0zVW4PNquDdSEqZSw3grgh41shWgkYab4vwE0f8aYewZ78xCzcJ8O0eXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lmklhe5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lmklhe5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7F21F000E9;
	Tue, 21 Jul 2026 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653822;
	bh=7qwLkB4juBFVxHVoWSP7iOKe843ux3q9BRI/GCLrU9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lmklhe5Mqox9xtWFSxupM4VOYI6tgj+NnQllp/k/uFKNSTASCrnh3e3XLM2USez34
	 wBIzUDaxscR+rsrtkhShJLqzj8HfjLxPVMEXMO/AG+aDNxbqtBfBy8Wse4zCujto08
	 nbR87AhRu0a/IshGJPe6tS0LuwCDd6wn3/pPOZx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1470/2077] accel/amdxdna: Fix VMA access race
Date: Tue, 21 Jul 2026 17:19:03 +0200
Message-ID: <20260721152627.466028620@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 1ba02717e821cf14ece642273958647e79698d3d ]

aie2_populate_range() and amdxdna_umap_release() access a saved VMA
pointer that may have already been freed, leading to a potential
use-after-free.

Remove the VMA accesses from these functions to avoid the race.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260609011242.2833740-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    |  2 --
 drivers/accel/amdxdna/amdxdna_gem.c | 31 +++++++++++++++++++----------
 drivers/accel/amdxdna/amdxdna_gem.h |  1 -
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index f5d247d65cb065..884a64fa3e4fac 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -977,8 +977,6 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	kref_get(&mapp->refcnt);
 	up_write(&xdna->notifier_lock);
 
-	XDNA_DBG(xdna, "populate memory range %lx %lx",
-		 mapp->vma->vm_start, mapp->vma->vm_end);
 	mm = mapp->notifier.mm;
 	if (!mmget_not_zero(mm)) {
 		amdxdna_umap_put(mapp);
diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 2ac12b49a70035..eb440bccd0cbd7 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -200,7 +200,7 @@ static bool amdxdna_hmm_invalidate(struct mmu_interval_notifier *mni,
 
 	xdna = to_xdna_dev(to_gobj(abo)->dev);
 	XDNA_DBG(xdna, "Invalidating range 0x%lx, 0x%lx, type %d",
-		 mapp->vma->vm_start, mapp->vma->vm_end, abo->type);
+		 mapp->range.start, mapp->range.end, abo->type);
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -229,15 +229,23 @@ static const struct mmu_interval_notifier_ops amdxdna_hmm_ops = {
 	.invalidate = amdxdna_hmm_invalidate,
 };
 
+static inline bool compare_range(struct amdxdna_umap *mapp,
+				 struct mm_struct *mm,
+				 unsigned long start, unsigned long end)
+{
+	return (!mapp->unmapped && mapp->notifier.mm == mm &&
+		mapp->range.start == start && mapp->range.end == end);
+}
+
 static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
 				   struct vm_area_struct *vma)
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(to_gobj(abo)->dev);
 	struct amdxdna_umap *mapp;
 
-	down_read(&xdna->notifier_lock);
+	down_write(&xdna->notifier_lock);
 	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
-		if (!vma || mapp->vma == vma) {
+		if (!vma || compare_range(mapp, vma->vm_mm, vma->vm_start, vma->vm_end)) {
 			if (!mapp->unmapped) {
 				queue_work(xdna->notifier_wq, &mapp->hmm_unreg_work);
 				mapp->unmapped = true;
@@ -246,19 +254,16 @@ static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
 				break;
 		}
 	}
-	up_read(&xdna->notifier_lock);
+	up_write(&xdna->notifier_lock);
 }
 
 static void amdxdna_umap_release(struct kref *ref)
 {
 	struct amdxdna_umap *mapp = container_of(ref, struct amdxdna_umap, refcnt);
 	struct amdxdna_gem_obj *abo = mapp->abo;
-	struct vm_area_struct *vma = mapp->vma;
 	struct amdxdna_dev *xdna;
 
 	mmu_interval_notifier_remove(&mapp->notifier);
-	if (is_import_bo(abo) && vma->vm_file && vma->vm_file->f_mapping)
-		mapping_clear_unevictable(vma->vm_file->f_mapping);
 
 	xdna = to_xdna_dev(to_gobj(mapp->abo)->dev);
 	down_write(&xdna->notifier_lock);
@@ -297,6 +302,15 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	if (!xdna->dev_info->ops->hmm_invalidate)
 		return 0;
 
+	down_read(&xdna->notifier_lock);
+	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
+		if (compare_range(mapp, current->mm, addr, addr + len)) {
+			up_read(&xdna->notifier_lock);
+			return 0;
+		}
+	}
+	up_read(&xdna->notifier_lock);
+
 	mapp = kzalloc_obj(*mapp);
 	if (!mapp)
 		return -ENOMEM;
@@ -322,13 +336,10 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	mapp->range.start = vma->vm_start;
 	mapp->range.end = vma->vm_end;
 	mapp->range.default_flags = HMM_PFN_REQ_FAULT;
-	mapp->vma = vma;
 	mapp->abo = abo;
 	kref_init(&mapp->refcnt);
 
 	INIT_WORK(&mapp->hmm_unreg_work, amdxdna_hmm_unreg_work);
-	if (is_import_bo(abo) && vma->vm_file && vma->vm_file->f_mapping)
-		mapping_set_unevictable(vma->vm_file->f_mapping);
 
 	down_write(&xdna->notifier_lock);
 	if (list_empty(&abo->mem.umap_list))
diff --git a/drivers/accel/amdxdna/amdxdna_gem.h b/drivers/accel/amdxdna/amdxdna_gem.h
index 957305ccb485af..10242f4a5ca983 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.h
+++ b/drivers/accel/amdxdna/amdxdna_gem.h
@@ -12,7 +12,6 @@
 #include "amdxdna_pci_drv.h"
 
 struct amdxdna_umap {
-	struct vm_area_struct		*vma;
 	struct mmu_interval_notifier	notifier;
 	struct hmm_range		range;
 	struct work_struct		hmm_unreg_work;
-- 
2.53.0



