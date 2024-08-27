Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B450D1C5793;
	Tue, 27 Aug 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771502; cv=none; b=SHSfRl7egc6RuPs2Yc4BayH+dvOVPNSSih0lv+f10u0k8ehViHVJOxRaBqSia7XfvJe6PtH97tNBEqNb2+c+8/gEOQhyzzfvuCO7/8KGytnl449IaHMr1TcWwOLnsPAjBlymya/14XzL5C31E4syAwrIEwHnZK/kvljmd+b7tI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771502; c=relaxed/simple;
	bh=u4WYhQEtwmafKO+9Oip/SfE66JqtekS+4w3R5lX32KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlJF7H7cpOcQLdOn2XAfxLMjuS1C7Lv3KpFR/a9k7K5LFmuNHsUBexFKa6HkWOE6Qxru9zxQpVB0a18bUN5DppCLi70MaoHy+nuU3FlzanQsLwrpyEZdx6ceOM5AZsBFtuAQkjf5z6LxxR7i4A9HJyoIAbPNvbIXAyBvrwBvNmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ma4IfzIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ma4IfzIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF30C4DE08;
	Tue, 27 Aug 2024 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771502;
	bh=u4WYhQEtwmafKO+9Oip/SfE66JqtekS+4w3R5lX32KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ma4IfzIf6Z2MRKUOib+/JUMqerF7b8H1hmvl+yIPlQqJC/sx8MkHkTXE+lThyb0Ll
	 7MBqarJ/mDsZUwMFvfFuzEJWTv+WvbV9/VyDM+Bfr9fuhfD/OkccESjfP/YppMHfkd
	 nJ4C3JYl/AIyRfpfnUcglANCQ79brhOcAnNPzae0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 208/273] drm/xe: reset mmio mappings with devm
Date: Tue, 27 Aug 2024 16:38:52 +0200
Message-ID: <20240827143841.325306362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit c7117419784f612d59ee565145f722e8b5541fe6 ]

Set our various mmio mappings to NULL. This should make it easier to
catch something rogue trying to mess with mmio after device removal. For
example, we might unmap everything and then start hitting some mmio
address which has already been unmamped by us and then remapped by
something else, causing all kinds of carnage.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240522102143.128069-33-matthew.auld@intel.com
Stable-dep-of: 15939ca77d44 ("drm/xe: Fix tile fini sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c |  4 +++-
 drivers/gpu/drm/xe/xe_mmio.c   | 35 ++++++++++++++++++++++++++++------
 drivers/gpu/drm/xe/xe_mmio.h   |  2 +-
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 5ef9b50a20d01..a1cbdafbff75e 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -551,7 +551,9 @@ int xe_device_probe(struct xe_device *xe)
 	if (err)
 		return err;
 
-	xe_mmio_probe_tiles(xe);
+	err = xe_mmio_probe_tiles(xe);
+	if (err)
+		return err;
 
 	xe_ttm_sys_mgr_init(xe);
 
diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 2ebb2f0d6874e..9d8fafdf51453 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -254,6 +254,21 @@ static int xe_mmio_tile_vram_size(struct xe_tile *tile, u64 *vram_size,
 	return xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
 }
 
+static void vram_fini(void *arg)
+{
+	struct xe_device *xe = arg;
+	struct xe_tile *tile;
+	int id;
+
+	if (xe->mem.vram.mapping)
+		iounmap(xe->mem.vram.mapping);
+
+	xe->mem.vram.mapping = NULL;
+
+	for_each_tile(tile, xe, id)
+		tile->mem.vram.mapping = NULL;
+}
+
 int xe_mmio_probe_vram(struct xe_device *xe)
 {
 	struct xe_tile *tile;
@@ -330,10 +345,20 @@ int xe_mmio_probe_vram(struct xe_device *xe)
 	drm_info(&xe->drm, "Available VRAM: %pa, %pa\n", &xe->mem.vram.io_start,
 		 &available_size);
 
-	return 0;
+	return devm_add_action_or_reset(xe->drm.dev, vram_fini, xe);
 }
 
-void xe_mmio_probe_tiles(struct xe_device *xe)
+static void tiles_fini(void *arg)
+{
+	struct xe_device *xe = arg;
+	struct xe_tile *tile;
+	int id;
+
+	for_each_tile(tile, xe, id)
+		tile->mmio.regs = NULL;
+}
+
+int xe_mmio_probe_tiles(struct xe_device *xe)
 {
 	size_t tile_mmio_size = SZ_16M, tile_mmio_ext_size = xe->info.tile_mmio_ext_size;
 	u8 id, tile_count = xe->info.tile_count;
@@ -384,6 +409,8 @@ void xe_mmio_probe_tiles(struct xe_device *xe)
 			regs += tile_mmio_ext_size;
 		}
 	}
+
+	return devm_add_action_or_reset(xe->drm.dev, tiles_fini, xe);
 }
 
 static void mmio_fini(void *arg)
@@ -391,10 +418,6 @@ static void mmio_fini(void *arg)
 	struct xe_device *xe = arg;
 
 	pci_iounmap(to_pci_dev(xe->drm.dev), xe->mmio.regs);
-	if (xe->mem.vram.mapping)
-		iounmap(xe->mem.vram.mapping);
-
-	xe->mem.vram.mapping = NULL;
 	xe->mmio.regs = NULL;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_mmio.h b/drivers/gpu/drm/xe/xe_mmio.h
index a3cd7b3036c73..a929d090bb2f1 100644
--- a/drivers/gpu/drm/xe/xe_mmio.h
+++ b/drivers/gpu/drm/xe/xe_mmio.h
@@ -21,7 +21,7 @@ struct xe_device;
 #define LMEM_BAR		2
 
 int xe_mmio_init(struct xe_device *xe);
-void xe_mmio_probe_tiles(struct xe_device *xe);
+int xe_mmio_probe_tiles(struct xe_device *xe);
 
 u8 xe_mmio_read8(struct xe_gt *gt, struct xe_reg reg);
 u16 xe_mmio_read16(struct xe_gt *gt, struct xe_reg reg);
-- 
2.43.0



