Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697742A9B;
	Tue, 27 May 2025 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367652; cv=none; b=C/M/3Pyr0UCA0iV0q/wxpFbITL9cbJopBVM8MeLLgRMFCSdrGMQCh2mpSuq39w41ktLuHH29va2fi8TfZA0rk5n/UnudEuSTc7sJ0LdbfGeHiQrOMSoqbGXFFraOB2a2DWIlvbmLRPx1A89C0u49MAhBVHO17jgaLS3IYxrT6jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367652; c=relaxed/simple;
	bh=1mWvlingGunyXltjYdPsVgUgm7E1wZUTPrRxdklpRYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Myxyti7JH1PbHn4SYbz2sNcv0Tkny8V4r0KtDSaFsFZfvEyonEaQP+RX3a7hB7tQBjpD/Rxs/o+dtB8+ksiAC6gP7aytt1XwTd6rxln5YMJVzG5/p09veRiI0856RTmdH6HA8+BYuF3ydat7TE9nf/ofdVFY2IP4ahklR8Cvh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDNjB5o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDNjB5o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E025C4CEE9;
	Tue, 27 May 2025 17:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367652;
	bh=1mWvlingGunyXltjYdPsVgUgm7E1wZUTPrRxdklpRYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDNjB5o5Nz0IA6ZWnvH4zlsqvegg7bwPWttk9LlPk25Rzj2Y+46wmFlYys5u+UsES
	 2BAl2qdE2Nhv2kHVYBe5ZuYMwhG8bscpUsLelAFozJrkd2CkzAV6uBNOGQafe/97/Q
	 OPtmczHuIsMZogNhKUS2MQT6ovbBEfohpW2jmTmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 456/783] drm/xe: Stop ignoring errors from xe_ttm_stolen_mgr_init()
Date: Tue, 27 May 2025 18:24:13 +0200
Message-ID: <20250527162531.691714484@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit ff57025c358603555f1e0ae0d50282a460433594 ]

Make sure to differentiate normal behavior, e.g. there's no stolen, from
allocation errors or failure to initialize lower layers.

Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213192909.996148-5-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c         |  4 +++-
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c | 17 +++++++++--------
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.h |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 4e1839b483a00..e22f29ac96631 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -722,7 +722,9 @@ int xe_device_probe(struct xe_device *xe)
 	}
 
 	/* Allocate and map stolen after potential VRAM resize */
-	xe_ttm_stolen_mgr_init(xe);
+	err = xe_ttm_stolen_mgr_init(xe);
+	if (err)
+		return err;
 
 	/*
 	 * Now that GT is initialized (TTM in particular),
diff --git a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
index d414421f8c131..d9c9d2547aadf 100644
--- a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
@@ -207,17 +207,16 @@ static u64 detect_stolen(struct xe_device *xe, struct xe_ttm_stolen_mgr *mgr)
 #endif
 }
 
-void xe_ttm_stolen_mgr_init(struct xe_device *xe)
+int xe_ttm_stolen_mgr_init(struct xe_device *xe)
 {
-	struct xe_ttm_stolen_mgr *mgr = drmm_kzalloc(&xe->drm, sizeof(*mgr), GFP_KERNEL);
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+	struct xe_ttm_stolen_mgr *mgr;
 	u64 stolen_size, io_size;
 	int err;
 
-	if (!mgr) {
-		drm_dbg_kms(&xe->drm, "Stolen mgr init failed\n");
-		return;
-	}
+	mgr = drmm_kzalloc(&xe->drm, sizeof(*mgr), GFP_KERNEL);
+	if (!mgr)
+		return -ENOMEM;
 
 	if (IS_SRIOV_VF(xe))
 		stolen_size = 0;
@@ -230,7 +229,7 @@ void xe_ttm_stolen_mgr_init(struct xe_device *xe)
 
 	if (!stolen_size) {
 		drm_dbg_kms(&xe->drm, "No stolen memory support\n");
-		return;
+		return 0;
 	}
 
 	/*
@@ -246,7 +245,7 @@ void xe_ttm_stolen_mgr_init(struct xe_device *xe)
 				     io_size, PAGE_SIZE);
 	if (err) {
 		drm_dbg_kms(&xe->drm, "Stolen mgr init failed: %i\n", err);
-		return;
+		return err;
 	}
 
 	drm_dbg_kms(&xe->drm, "Initialized stolen memory support with %llu bytes\n",
@@ -254,6 +253,8 @@ void xe_ttm_stolen_mgr_init(struct xe_device *xe)
 
 	if (io_size)
 		mgr->mapping = devm_ioremap_wc(&pdev->dev, mgr->io_base, io_size);
+
+	return 0;
 }
 
 u64 xe_ttm_stolen_io_offset(struct xe_bo *bo, u32 offset)
diff --git a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.h b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.h
index 1777245ff8101..8e877d1e839bd 100644
--- a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.h
+++ b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.h
@@ -12,7 +12,7 @@ struct ttm_resource;
 struct xe_bo;
 struct xe_device;
 
-void xe_ttm_stolen_mgr_init(struct xe_device *xe);
+int xe_ttm_stolen_mgr_init(struct xe_device *xe);
 int xe_ttm_stolen_io_mem_reserve(struct xe_device *xe, struct ttm_resource *mem);
 bool xe_ttm_stolen_cpu_access_needs_ggtt(struct xe_device *xe);
 u64 xe_ttm_stolen_io_offset(struct xe_bo *bo, u32 offset);
-- 
2.39.5



