Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3424F3910;
	Tue, 13 Oct 2026 12:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893602; cv=none; b=n8LRoggXSEykEgugu0dezlUos0CkxVbh4vnVqjrIqneMaAj9yhBC3pdiJUultCmrZerSnghjCxbcMzkGmwBqqhaei9fxh0Vl4epBtk/7Ffbh+zSUQzbEdtDcWJCZ35UdwXLv2YkqgWNwJIrfBUJDqvq+pWEPxFBorTskscITLDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893602; c=relaxed/simple;
	bh=+0HtPojRgzO9Iy3zVfee53uDazo//JBlXPlkRvifOkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNLQ9a7DRJCzI0uWI0/K+53gWPaQ9ZwBPd1Rnx872ZwN0MdsgNYRF5tp8bD2fcTtfX8Lw5hOF/T7R+z1CjuHHrWdbUrX4Fuc4nkNZSFNtlJQXBe8rQFw2e4wDeatIaIs5lFyJHM6AO9B8VSTBgo1QmLKEbM3g2IsepeMoOGBc7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRxBAI7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRxBAI7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DFA1F000FF;
	Tue, 13 Oct 2026 12:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893601;
	bh=mKSlwrnqj2mnM06fZB/+BYdCJkKz8mdM8X258VRLy8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRxBAI7Yj7h6ef3bhDfn24s/dOQa6QC9olo9TZB35YjuXoyaX/5yhS9TjYCs7AiiP
	 zRY3vLhBtXqytG3xqBzVz5EiDQOMKRowowEZdrK4F/N719ATbXR/jiT10p1XAZjmDX
	 AuqQuHn3PK1b14UyRp4Zlc74lUZN+Ah7Tw9pdmDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/621] accel/amdxdna: Refactor GEM BO handling and add helper APIs for address retrieval
Date: Tue, 13 Oct 2026 13:34:34 +0200
Message-ID: <20261013112927.480430112@linuxfoundation.org>
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

From: Max Zhen <max.zhen@amd.com>

[ Upstream commit d76856beb4a4a6c42244054cd780c00f2d33de4e ]

Refactor amdxdna GEM buffer object (BO) handling to simplify address
management and unify BO type semantics.

Introduce helper APIs to retrieve commonly used BO addresses:
- User virtual address (UVA)
- Kernel virtual address (KVA)
- Device address (IOVA/PA)

These helpers centralize address lookup logic and avoid duplicating
BO-specific handling across submission and execution paths. This also
improves readability and reduces the risk of inconsistent address
handling in future changes.

As part of the refactor:
- Rename SHMEM BO type to SHARE to better reflect its usage.
- Merge CMD BO handling into SHARE, removing special-case logic for
  command buffers.
- Consolidate BO type handling paths to reduce code duplication and
  simplify maintenance.

No functional change is intended. The refactor prepares the driver for
future enhancements by providing a cleaner abstraction for BO address
management.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260320210615.1973016-1-lizhi.hou@amd.com

Only the user-mapping bookkeeping part of the refactor is carried here:
umap_release() resets the cached user address once the last mapping is
gone, and hmm_register() records it when the first mapping is added,
both under notifier_lock. The remaining address-helper, BO type and
UAPI changes are not needed by the follow-up fix and are dropped.

Stable-dep-of: 1ba02717e821 ("accel/amdxdna: Fix VMA access race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 95d04af2b9933..0e9f70c2fa515 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -160,16 +160,19 @@ static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
 static void amdxdna_umap_release(struct kref *ref)
 {
 	struct amdxdna_umap *mapp = container_of(ref, struct amdxdna_umap, refcnt);
+	struct amdxdna_gem_obj *abo = mapp->abo;
 	struct vm_area_struct *vma = mapp->vma;
 	struct amdxdna_dev *xdna;
 
 	mmu_interval_notifier_remove(&mapp->notifier);
-	if (is_import_bo(mapp->abo) && vma->vm_file && vma->vm_file->f_mapping)
+	if (is_import_bo(abo) && vma->vm_file && vma->vm_file->f_mapping)
 		mapping_clear_unevictable(vma->vm_file->f_mapping);
 
 	xdna = to_xdna_dev(to_gobj(mapp->abo)->dev);
 	down_write(&xdna->notifier_lock);
 	list_del(&mapp->node);
+	if (list_empty(&abo->mem.umap_list))
+		abo->mem.userptr = AMDXDNA_INVALID_ADDR;
 	up_write(&xdna->notifier_lock);
 
 	kvfree(mapp->range.hmm_pfns);
@@ -202,7 +205,7 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	if (!xdna->dev_info->ops->hmm_invalidate)
 		return 0;
 
-	mapp = kzalloc(sizeof(*mapp), GFP_KERNEL);
+	mapp = kzalloc_obj(*mapp);
 	if (!mapp)
 		return -ENOMEM;
 
@@ -232,13 +235,13 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	mapp->abo = abo;
 	kref_init(&mapp->refcnt);
 
-	if (abo->mem.userptr == AMDXDNA_INVALID_ADDR)
-		abo->mem.userptr = addr;
 	INIT_WORK(&mapp->hmm_unreg_work, amdxdna_hmm_unreg_work);
 	if (is_import_bo(abo) && vma->vm_file && vma->vm_file->f_mapping)
 		mapping_set_unevictable(vma->vm_file->f_mapping);
 
 	down_write(&xdna->notifier_lock);
+	if (list_empty(&abo->mem.umap_list))
+		abo->mem.userptr = addr;
 	list_add_tail(&mapp->node, &abo->mem.umap_list);
 	up_write(&xdna->notifier_lock);
 
-- 
2.53.0



