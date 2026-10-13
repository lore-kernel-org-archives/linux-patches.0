Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583924FE2D1;
	Tue, 13 Oct 2026 12:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893605; cv=none; b=Qz62DbUmi151Q/IKP1NrGg1rXUCfSQWn8uBfnbXdWDj2DIvRjnaADm7q1XO/RIczvKNoEGHXP/9HG6RhDv/UYczTbD9IaMfA2inFwc63fCHfWIO8diAfk7vn5akIGth2kgYSLk+pmf6igImLaAI9kkEjlXnYsn1LU1R4mwLmFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893605; c=relaxed/simple;
	bh=NSHNcUjjcg5TKdn2LUPToPpGHF/7gzeYNF49X4LXEvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAWAkjBWXQTalQEvE8J8XDJlZJxyIs+o4pId2vhzqZyQ1m/QuveT1rYDdZPSARqPZmZRGvS92qhWYfrL7yqfoENpgxnBzLs64QN6Snna8UXsU8MGHBbQTApc2uwoV091WScRHCkKnkceVsUHKRA3PikBcYoNS5PCmuw+HlKea0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuNZxa4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuNZxa4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7371C1F000FF;
	Tue, 13 Oct 2026 12:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893604;
	bh=t3sljkYq9R33DE+J7YANMHiUUvHyWEKO1rn0fL4CtDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuNZxa4TEWYgDl6alDu734AaxAIgQQRup/2X0z//ZoofpWq00PKWJEqDOKhwrAG8E
	 GLifQNKJM7YYD+LbdbWD8km9MHOQXvVpwAy7/VSSs9SCgOpLINa3Wf2s6An2eF/GzB
	 O7g14CTvwcps0uP6zu2m3WYVBZhnlZUJIVlG0KTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/621] accel/amdxdna: Fix VMA access race
Date: Tue, 13 Oct 2026 13:34:35 +0200
Message-ID: <20261013112927.505179325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 6d8a79978c381..e92d671610afb 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -831,8 +831,6 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 
 	up_write(&xdna->notifier_lock);
 
-	XDNA_DBG(xdna, "populate memory range %lx %lx",
-		 mapp->vma->vm_start, mapp->vma->vm_end);
 	mm = mapp->notifier.mm;
 	if (!mmget_not_zero(mm)) {
 		amdxdna_umap_put(mapp);
diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 0e9f70c2fa515..9834b9199ef8c 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -108,7 +108,7 @@ static bool amdxdna_hmm_invalidate(struct mmu_interval_notifier *mni,
 
 	xdna = to_xdna_dev(to_gobj(abo)->dev);
 	XDNA_DBG(xdna, "Invalidating range 0x%lx, 0x%lx, type %d",
-		 mapp->vma->vm_start, mapp->vma->vm_end, abo->type);
+		 mapp->range.start, mapp->range.end, abo->type);
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -137,15 +137,23 @@ static const struct mmu_interval_notifier_ops amdxdna_hmm_ops = {
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
@@ -154,19 +162,16 @@ static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
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
@@ -205,6 +210,15 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
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
@@ -231,13 +245,10 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
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
index ae29db94a9d33..b3c814c0bb7e6 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.h
+++ b/drivers/accel/amdxdna/amdxdna_gem.h
@@ -9,7 +9,6 @@
 #include <linux/hmm.h>
 
 struct amdxdna_umap {
-	struct vm_area_struct		*vma;
 	struct mmu_interval_notifier	notifier;
 	struct hmm_range		range;
 	struct work_struct		hmm_unreg_work;
-- 
2.53.0



