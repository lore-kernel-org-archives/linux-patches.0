Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2681812C46B;
	Tue, 30 Apr 2024 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474161; cv=none; b=Sz6tKvE8MapZ/OZXfw2tVLQXZh/Nlvqbqr4wLN2ui2ZzpyV++UxWCacpPaZ7MKUyvtAkWfr3hn9watugnym9P1v/DjA3l2drmgLwFgnAduT+28JSHNbUOr5Kifio7JEf5gbBuhcFBSVWmbUf5+h0q5kfcUNAiF5Fhwi0G0ggn8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474161; c=relaxed/simple;
	bh=u0BYwd5aq/m/RTUk81UL7kEJx65JZZL57r1Dh2PjgAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUg2M6fXen10iyW9UGKmbQbwqnxjyJN65H3QS9R8ETEZo+3NfD+5vqdySi0qGpFvsGT5gealZhZgrpiku9YEEnwpqGbz3RppOKsD7OHB2wHORZMcuUyW3fbtky6kJ7PlmwkD0O6UaT1YSq4h0llNcc21+m9QhNemn2hTsJkzfpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysu+xIJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysu+xIJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92835C2BBFC;
	Tue, 30 Apr 2024 10:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474161;
	bh=u0BYwd5aq/m/RTUk81UL7kEJx65JZZL57r1Dh2PjgAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysu+xIJi2Cbv3aUNpnaUcr4by155tZB2Af41P0aZWugyGgOosQe2HswEsMuvJHlQq
	 go3c8zZ6fvJ3pUGyIY+TWN5aFY7f1PIi9D0DS5VsVyVd9voJhpIQxihTXVJV7UKr4k
	 +9qG9WTJ0DVsGm4VbpZvSUpLJZToDwN1UaxZ+tEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 075/228] drm/xe: Remove sysfs only once on action add failure
Date: Tue, 30 Apr 2024 12:37:33 +0200
Message-ID: <20240430103105.969224762@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit d6dab9017b7cf155e73ba5c7f498de1beb5f8e24 ]

The drmm_add_action_or_reset function automatically invokes the action
(sysfs removal) in the event of a failure; therefore, there's no
necessity to call it within the return check.

Modify the return type of xe_gt_ccs_mode_sysfs_init to int, allowing the
caller to pass errors up the call chain. Should sysfs creation or
drmm_add_action_or_reset fail, error propagation will prompt a driver
load abort.

-v2
Edit commit message (Nikula/Lucas)
use err_force_wake label instead of new. (Lucas)
Avoid unnecessary warn/error messages. (Lucas)

Fixes: f3bc5bb4d53d ("drm/xe: Allow userspace to configure CCS mode")
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240412181211.1155732-3-himal.prasad.ghimiray@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit a99641e38704202ae2a97202b3d249208c9cda7f)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c          |  4 +++-
 drivers/gpu/drm/xe/xe_gt_ccs_mode.c | 19 +++++++------------
 drivers/gpu/drm/xe/xe_gt_ccs_mode.h |  2 +-
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 35474ddbaf97e..d23ee1397cf07 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -384,7 +384,9 @@ static int gt_fw_domain_init(struct xe_gt *gt)
 			 err);
 
 	/* Initialize CCS mode sysfs after early initialization of HW engines */
-	xe_gt_ccs_mode_sysfs_init(gt);
+	err = xe_gt_ccs_mode_sysfs_init(gt);
+	if (err)
+		goto err_force_wake;
 
 	err = xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
 	XE_WARN_ON(err);
diff --git a/drivers/gpu/drm/xe/xe_gt_ccs_mode.c b/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
index 529fc286cd06c..396aeb5b99242 100644
--- a/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
+++ b/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
@@ -167,25 +167,20 @@ static void xe_gt_ccs_mode_sysfs_fini(struct drm_device *drm, void *arg)
  * and it is expected that there are no open drm clients while doing so.
  * The number of available compute slices is exposed to user through a per-gt
  * 'num_cslices' sysfs interface.
+ *
+ * Returns: Returns error value for failure and 0 for success.
  */
-void xe_gt_ccs_mode_sysfs_init(struct xe_gt *gt)
+int xe_gt_ccs_mode_sysfs_init(struct xe_gt *gt)
 {
 	struct xe_device *xe = gt_to_xe(gt);
 	int err;
 
 	if (!xe_gt_ccs_mode_enabled(gt))
-		return;
+		return 0;
 
 	err = sysfs_create_files(gt->sysfs, gt_ccs_mode_attrs);
-	if (err) {
-		drm_warn(&xe->drm, "Sysfs creation for ccs_mode failed err: %d\n", err);
-		return;
-	}
+	if (err)
+		return err;
 
-	err = drmm_add_action_or_reset(&xe->drm, xe_gt_ccs_mode_sysfs_fini, gt);
-	if (err) {
-		sysfs_remove_files(gt->sysfs, gt_ccs_mode_attrs);
-		drm_warn(&xe->drm, "%s: drmm_add_action_or_reset failed, err: %d\n",
-			 __func__, err);
-	}
+	return drmm_add_action_or_reset(&xe->drm, xe_gt_ccs_mode_sysfs_fini, gt);
 }
diff --git a/drivers/gpu/drm/xe/xe_gt_ccs_mode.h b/drivers/gpu/drm/xe/xe_gt_ccs_mode.h
index f39975aaaab0d..f8779852cf0d2 100644
--- a/drivers/gpu/drm/xe/xe_gt_ccs_mode.h
+++ b/drivers/gpu/drm/xe/xe_gt_ccs_mode.h
@@ -12,7 +12,7 @@
 #include "xe_platform_types.h"
 
 void xe_gt_apply_ccs_mode(struct xe_gt *gt);
-void xe_gt_ccs_mode_sysfs_init(struct xe_gt *gt);
+int xe_gt_ccs_mode_sysfs_init(struct xe_gt *gt);
 
 static inline bool xe_gt_ccs_mode_enabled(const struct xe_gt *gt)
 {
-- 
2.43.0



