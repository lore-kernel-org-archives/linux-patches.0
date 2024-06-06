Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B58195FDF;
	Thu,  6 Jun 2024 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683068; cv=none; b=rYM+9tJmXdz3HZa2d04Cfm99mPy8nHSE0Tlb2XS9vt/0ME7RqqVLlmHiLRUj8/zrQpU2l79v0KqxCFn6Nn8ZFbVPE2lCfu8sRqM7i8ZbGNEFO+gbL7jImkvSNo7Q5kxvh94TShBHFIj56cW35hhBoazM9Hrz9fcKbRlDlDLyUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683068; c=relaxed/simple;
	bh=27xNQZiyRMpz3PEMcl5ECwLZbRlOmZipMmPWuSRcTzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gApHE+VOFokJuX+jr75rVtdiF/kLS2Tth0ij5oODvAewf2e+/Ay7V1m8ETvVIWHvnS3SBTwU5bFs1nQUu2Ul5n24CgIr7/VWHaYnBTTSbGAMKssNci+j4ct1b+l5le6bTlJrqieVsMPZRu69XULpW48Xpm6jDKQugRN0FGfV4K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFbFy9Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFbFy9Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF21C4AF0D;
	Thu,  6 Jun 2024 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683067;
	bh=27xNQZiyRMpz3PEMcl5ECwLZbRlOmZipMmPWuSRcTzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFbFy9HvwqmoPAt+8eDq5L57pjecqUzUAKM6FzFEqdU0DJR42nKN3brBvfpDUVgdk
	 Tom8IRxNsR0WnvGFWJl9GiAweQb0SQdy1xjcc/mWq5V3vDdP4kQuAFW6A4o61NN+UM
	 6UALvnJb9fKn51F0VJ8drL0kYoqDqULfUB3SjqYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 326/374] drm/xe: Add dbg messages on the suspend resume functions.
Date: Thu,  6 Jun 2024 16:05:05 +0200
Message-ID: <20240606131702.781002931@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit f7f24b7950af4b1548ad5075ddb13eeb333bb782 ]

In case of the suspend/resume flow getting locked up we
can get reports with some useful hints on where it might
get locked and if that has failed.

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240318180141.267458-2-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 77b79df0268b ("drm/xe: Change pcode timeout to 50msec while polling again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 53b3b0b019acd..669b626c06c22 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -54,13 +54,15 @@ int xe_pm_suspend(struct xe_device *xe)
 	u8 id;
 	int err;
 
+	drm_dbg(&xe->drm, "Suspending device\n");
+
 	for_each_gt(gt, xe, id)
 		xe_gt_suspend_prepare(gt);
 
 	/* FIXME: Super racey... */
 	err = xe_bo_evict_all(xe);
 	if (err)
-		return err;
+		goto err;
 
 	xe_display_pm_suspend(xe);
 
@@ -68,7 +70,7 @@ int xe_pm_suspend(struct xe_device *xe)
 		err = xe_gt_suspend(gt);
 		if (err) {
 			xe_display_pm_resume(xe);
-			return err;
+			goto err;
 		}
 	}
 
@@ -76,7 +78,11 @@ int xe_pm_suspend(struct xe_device *xe)
 
 	xe_display_pm_suspend_late(xe);
 
+	drm_dbg(&xe->drm, "Device suspended\n");
 	return 0;
+err:
+	drm_dbg(&xe->drm, "Device suspend failed %d\n", err);
+	return err;
 }
 
 /**
@@ -92,13 +98,15 @@ int xe_pm_resume(struct xe_device *xe)
 	u8 id;
 	int err;
 
+	drm_dbg(&xe->drm, "Resuming device\n");
+
 	for_each_tile(tile, xe, id)
 		xe_wa_apply_tile_workarounds(tile);
 
 	for_each_gt(gt, xe, id) {
 		err = xe_pcode_init(gt);
 		if (err)
-			return err;
+			goto err;
 	}
 
 	xe_display_pm_resume_early(xe);
@@ -109,7 +117,7 @@ int xe_pm_resume(struct xe_device *xe)
 	 */
 	err = xe_bo_restore_kernel(xe);
 	if (err)
-		return err;
+		goto err;
 
 	xe_irq_resume(xe);
 
@@ -120,9 +128,13 @@ int xe_pm_resume(struct xe_device *xe)
 
 	err = xe_bo_restore_user(xe);
 	if (err)
-		return err;
+		goto err;
 
+	drm_dbg(&xe->drm, "Device resumed\n");
 	return 0;
+err:
+	drm_dbg(&xe->drm, "Device resume failed %d\n", err);
+	return err;
 }
 
 static bool xe_pm_pci_d3cold_capable(struct xe_device *xe)
-- 
2.43.0



