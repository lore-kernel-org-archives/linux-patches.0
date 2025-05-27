Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B05542A9B;
	Tue, 27 May 2025 17:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367706; cv=none; b=LIdRoOxpTX2By6QZmplD4DPLpQTTG7/sdc9xLjcBFbRoebCiwfB3t7AVtDtNTm8RF299Pze40fLm/a0+2HED13CVD/zklCqY/zOs+Tqovr7Mp+h9MNBu2W+GekSqUgmA7Wuu1+jIbWwVU839knhmjUft22vdIfbDCmNoh7cB488=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367706; c=relaxed/simple;
	bh=eAx2UkyDsvqWeJuNhyWP3IwRUDK2US51Xn+1jywGvCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQ/b8uzbZ0gZTvYLJI50LMqrNz02zFP7v0r0exNq1lrehC/7Uq3wrl5Hp96WPNBJOPBD4kYzb/HLVvtrCrn+zT+nTrksYHJ95Ih0pFDinl5ZTZrp2Ax3oUgQ1e839KZYMs/TNqfwBova6ez0cOy1Yoe2nDhBUS+3ZhhWrsrr3FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq2fl1bO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq2fl1bO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC42C4CEE9;
	Tue, 27 May 2025 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367706;
	bh=eAx2UkyDsvqWeJuNhyWP3IwRUDK2US51Xn+1jywGvCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iq2fl1bOh3mff/5JI4XYD1jy9LgcN+wAr4zMmusrkpDmvi8yjn/1Fz3vJfjF1ep5M
	 OxmR8riLMqscwtC6VwdWnzCINnQFGOG4bN4aF/MIxYr3tqC39SBK2FcC2d/ugK8TT+
	 vVzJ3/isPvVvQHygY5ks9VCMWy9xllfxR6TYyeZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 446/783] drm/xe/pf: Release all VFs configs on device removal
Date: Tue, 27 May 2025 18:24:03 +0200
Message-ID: <20250527162531.297598523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 611160b02a40ce3f60ab94eea85b394dca1cafd2 ]

If we try to manually provision VFs using debugfs and then we
try to unload the driver, we will see complains like:

 [ ] Memory manager not clean during takedown.
 [ ] RIP: 0010:drm_mm_takedown+0x3f/0x100
 [ ] [drm:drm_mm_takedown] *ERROR* node [fedff000 + 00001000]: inserted at
      drm_mm_insert_node_in_range+0x2bd/0x520
      xe_ggtt_node_insert+0x52/0x90 [xe]
      pf_provision_vf_ggtt+0x1fa/0xac0 [xe]
      xe_gt_sriov_pf_config_set_ggtt+0x79/0x7a0 [xe]
      ggtt_set+0x53/0x80 [xe]
      simple_attr_write_xsigned.isra.0+0xd2/0x150
      simple_attr_write+0x14/0x30
      debugfs_attr_write+0x4e/0x80

 [ ] xe 0000:00:02.0: [drm] *ERROR* GT0: GUC ID manager unclean (1/65535)
 [ ] xe 0000:00:02.0: [drm] GT0:      total 65535
 [ ] xe 0000:00:02.0: [drm] GT0:      used 1
 [ ] xe 0000:00:02.0: [drm] GT0:      range 65534..65534 (1)

 [ ] xe 0000:00:02.0: [drm] *ERROR* GT0: GuC doorbells manager unclean (1/256)
 [ ] xe 0000:00:02.0: [drm] GT0:      count: 256
 [ ] xe 0000:00:02.0: [drm] GT0:      available range: 1..255 (255)
 [ ] xe 0000:00:02.0: [drm] GT0:      available total: 255
 [ ] xe 0000:00:02.0: [drm] GT0:      reserved range: 0..0 (1)
 [ ] xe 0000:00:02.0: [drm] GT0:      reserved total: 1

This could be easily fixed by adding config release action.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250211155034.1028-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c        |  6 +++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 29 ++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h |  1 +
 3 files changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index 6f906c8e8108b..b80930a6bc1a2 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -78,6 +78,12 @@ int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
  */
 int xe_gt_sriov_pf_init(struct xe_gt *gt)
 {
+	int err;
+
+	err = xe_gt_sriov_pf_config_init(gt);
+	if (err)
+		return err;
+
 	return xe_gt_sriov_pf_migration_init(gt);
 }
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index 4bd255adfb401..aaca54b40091f 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -2320,6 +2320,35 @@ int xe_gt_sriov_pf_config_restore(struct xe_gt *gt, unsigned int vfid,
 	return err;
 }
 
+static void fini_config(void *arg)
+{
+	struct xe_gt *gt = arg;
+	struct xe_device *xe = gt_to_xe(gt);
+	unsigned int n, total_vfs = xe_sriov_pf_get_totalvfs(xe);
+
+	mutex_lock(xe_gt_sriov_pf_master_mutex(gt));
+	for (n = 1; n <= total_vfs; n++)
+		pf_release_vf_config(gt, n);
+	mutex_unlock(xe_gt_sriov_pf_master_mutex(gt));
+}
+
+/**
+ * xe_gt_sriov_pf_config_init - Initialize SR-IOV configuration data.
+ * @gt: the &xe_gt
+ *
+ * This function can only be called on PF.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_config_init(struct xe_gt *gt)
+{
+	struct xe_device *xe = gt_to_xe(gt);
+
+	xe_gt_assert(gt, IS_SRIOV_PF(xe));
+
+	return devm_add_action_or_reset(xe->drm.dev, fini_config, gt);
+}
+
 /**
  * xe_gt_sriov_pf_config_restart - Restart SR-IOV configurations after a GT reset.
  * @gt: the &xe_gt
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
index f894e9d4abba2..513e6512a575b 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
@@ -63,6 +63,7 @@ int xe_gt_sriov_pf_config_restore(struct xe_gt *gt, unsigned int vfid,
 
 bool xe_gt_sriov_pf_config_is_empty(struct xe_gt *gt, unsigned int vfid);
 
+int xe_gt_sriov_pf_config_init(struct xe_gt *gt);
 void xe_gt_sriov_pf_config_restart(struct xe_gt *gt);
 
 int xe_gt_sriov_pf_config_print_ggtt(struct xe_gt *gt, struct drm_printer *p);
-- 
2.39.5



