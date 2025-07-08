Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBABA2F37;
	Tue,  8 Jul 2025 16:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993619; cv=none; b=oaxXOEyKPcqA+ZT1IVRyRM2+z+x9kWsEGv8gZA3dXzA0/HVaF0/m+rNuegD31uDKRqRJDYFB32cJF2okHImUvZchZLDoNnjOUJvOzw7sn0wuen4x66JmMgJstvCNBOCai5Z1+I5OqyBbW/ujUFYe5T0dQYCOpYmEKoyiGisjonc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993619; c=relaxed/simple;
	bh=3SCRKxVvCP3N81r+4GHljlMAlEPxif0J6t3OtOYAPQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5Ui3yvz/WOFxehfZpE/saOBvaqjXdWf566PT8dnJu0DwILssW+j9YaPNgLzLi9fre4n87vR5f0dXhvXQbr+8VFSRGHRnyUhc3AI1Dzu9ZzHaJS4l8QpPmuZ+X2F9fS90UyoL/iLFELXAVDDJdFOWQMCNAY8/YCejiJi7q6Nybs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYI758dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYI758dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E9AC4CEED;
	Tue,  8 Jul 2025 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993619;
	bh=3SCRKxVvCP3N81r+4GHljlMAlEPxif0J6t3OtOYAPQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYI758dnlMXE2IfJf+hUm/GVy/j5XUDZLSdgnOvkL6OH59kS/pQRazCkbZivG4f44
	 u/QjP6eflaKRfsVATvqV2VU4Kzk5XFGXqCfpfxBzPIZmdKrXfjnQZQh8RP76NzwBN7
	 NXBzvYKhyxySemWjGx1PKZmhbJK/T7TYGDXhqSL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 106/178] drm/xe: Split xe_device_td_flush()
Date: Tue,  8 Jul 2025 18:22:23 +0200
Message-ID: <20250708162239.404993747@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit a1eec6cae95a1a0888cb8370338822ca81cd9436 ]

xe_device_td_flush() has 2 possible implementations: an entire L2 flush
or a transient flush, depending on WA 16023588340. Make this clear by
splitting the function so it calls each of them.

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250618-wa-22019338487-v5-3-b888388477f2@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 5e300ed8a545bdffc26b579c526b5fef7b2d5365)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 84c0b4a00610 ("drm/xe/bmg: Update Wa_22019338487")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 68 ++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 00191227bc95c..38fdddd7262aa 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -972,38 +972,15 @@ void xe_device_wmb(struct xe_device *xe)
 		xe_mmio_write32(xe_root_tile_mmio(xe), VF_CAP_REG, 0);
 }
 
-/**
- * xe_device_td_flush() - Flush transient L3 cache entries
- * @xe: The device
- *
- * Display engine has direct access to memory and is never coherent with L3/L4
- * caches (or CPU caches), however KMD is responsible for specifically flushing
- * transient L3 GPU cache entries prior to the flip sequence to ensure scanout
- * can happen from such a surface without seeing corruption.
- *
- * Display surfaces can be tagged as transient by mapping it using one of the
- * various L3:XD PAT index modes on Xe2.
- *
- * Note: On non-discrete xe2 platforms, like LNL, the entire L3 cache is flushed
- * at the end of each submission via PIPE_CONTROL for compute/render, since SA
- * Media is not coherent with L3 and we want to support render-vs-media
- * usescases. For other engines like copy/blt the HW internally forces uncached
- * behaviour, hence why we can skip the TDF on such platforms.
+/*
+ * Issue a TRANSIENT_FLUSH_REQUEST and wait for completion on each gt.
  */
-void xe_device_td_flush(struct xe_device *xe)
+static void tdf_request_sync(struct xe_device *xe)
 {
-	struct xe_gt *gt;
 	unsigned int fw_ref;
+	struct xe_gt *gt;
 	u8 id;
 
-	if (!IS_DGFX(xe) || GRAPHICS_VER(xe) < 20)
-		return;
-
-	if (XE_WA(xe_root_mmio_gt(xe), 16023588340)) {
-		xe_device_l2_flush(xe);
-		return;
-	}
-
 	for_each_gt(gt, xe, id) {
 		if (xe_gt_is_media_type(gt))
 			continue;
@@ -1013,6 +990,7 @@ void xe_device_td_flush(struct xe_device *xe)
 			return;
 
 		xe_mmio_write32(&gt->mmio, XE2_TDF_CTRL, TRANSIENT_FLUSH_REQUEST);
+
 		/*
 		 * FIXME: We can likely do better here with our choice of
 		 * timeout. Currently we just assume the worst case, i.e. 150us,
@@ -1043,15 +1021,49 @@ void xe_device_l2_flush(struct xe_device *xe)
 		return;
 
 	spin_lock(&gt->global_invl_lock);
-	xe_mmio_write32(&gt->mmio, XE2_GLOBAL_INVAL, 0x1);
 
+	xe_mmio_write32(&gt->mmio, XE2_GLOBAL_INVAL, 0x1);
 	if (xe_mmio_wait32(&gt->mmio, XE2_GLOBAL_INVAL, 0x1, 0x0, 500, NULL, true))
 		xe_gt_err_once(gt, "Global invalidation timeout\n");
+
 	spin_unlock(&gt->global_invl_lock);
 
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 }
 
+/**
+ * xe_device_td_flush() - Flush transient L3 cache entries
+ * @xe: The device
+ *
+ * Display engine has direct access to memory and is never coherent with L3/L4
+ * caches (or CPU caches), however KMD is responsible for specifically flushing
+ * transient L3 GPU cache entries prior to the flip sequence to ensure scanout
+ * can happen from such a surface without seeing corruption.
+ *
+ * Display surfaces can be tagged as transient by mapping it using one of the
+ * various L3:XD PAT index modes on Xe2.
+ *
+ * Note: On non-discrete xe2 platforms, like LNL, the entire L3 cache is flushed
+ * at the end of each submission via PIPE_CONTROL for compute/render, since SA
+ * Media is not coherent with L3 and we want to support render-vs-media
+ * usescases. For other engines like copy/blt the HW internally forces uncached
+ * behaviour, hence why we can skip the TDF on such platforms.
+ */
+void xe_device_td_flush(struct xe_device *xe)
+{
+	struct xe_gt *root_gt;
+
+	if (!IS_DGFX(xe) || GRAPHICS_VER(xe) < 20)
+		return;
+
+	root_gt = xe_root_mmio_gt(xe);
+	if (XE_WA(root_gt, 16023588340))
+		/* A transient flush is not sufficient: flush the L2 */
+		xe_device_l2_flush(xe);
+	else
+		tdf_request_sync(xe);
+}
+
 u32 xe_device_ccs_bytes(struct xe_device *xe, u64 size)
 {
 	return xe_device_has_flat_ccs(xe) ?
-- 
2.39.5



