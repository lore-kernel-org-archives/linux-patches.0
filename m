Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3121CFECF;
	Wed,  2 Oct 2024 13:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875774; cv=none; b=DL0SptDQWhXq9DHcw3pmdrXAfscWtHDr+4ofAH6nhG0cnt8oElaHaP2tDxEJn+L/m26gY02CAk9CbkfyjPTMFNeQlepjxXYk+J2BRTo3j9JYuPSOXRbNaoX0jEQiYSmBPkv6UKLoDYRHg8lTyGC4Rg6J6DcVNpegLAxOd9xpKTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875774; c=relaxed/simple;
	bh=1rOF8mxjt7UM511SoMNg9/zvCclpbmZ4fFsVhxnHF5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6uFI322F53fkv2gURqLhL+QYfUQYD45LXHy2KySbRLzDplBzKt6iXpyvzP0SNVajtWRU1/VZ/jzFKLq45pMR4OzcNcmQkqmYHo67v5wiudeluH7FuPnyoBNZoCWbOlSCj1tPYwBohdDJSPZ1HfZMzvvgIPftKmDw9Ffm8HYnwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLPs3oNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLPs3oNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5261AC4CEC5;
	Wed,  2 Oct 2024 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875774;
	bh=1rOF8mxjt7UM511SoMNg9/zvCclpbmZ4fFsVhxnHF5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLPs3oNrYlqPIAUo4szOJVX//cScgig1RR+RnsI7rq4ntC9m3eIQejB32Q/hpOn0C
	 +UIXzvppKcg2q1GOVS73Mn2AzEySoInls0Bbmfy+JhY/WKMQ1slLoyDhX62rMUpgG7
	 Oi7WiEziB5d7ZFKNJiSrMlZcJigOPtFqvpOu0dwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Grzegorzek <dominik.grzegorzek@intel.com>,
	Mika Kuoppala <mika.kuoppala@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 215/695] drm/xe: Move and export xe_hw_engine lookup.
Date: Wed,  2 Oct 2024 14:53:33 +0200
Message-ID: <20241002125831.045016361@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Grzegorzek <dominik.grzegorzek@intel.com>

[ Upstream commit 6f20fc09936e786a4ba18f5514fe185e0451ada9 ]

Move and export xe_hw_engine lookup. This is in preparation
to use this in eudebug code where we want to find active
engine.

v2: s/tile/gt due to uapi changes (Mika)

Signed-off-by: Dominik Grzegorzek <dominik.grzegorzek@intel.com>
Signed-off-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240729130152.100130-1-mika.kuoppala@linux.intel.com
Stable-dep-of: 852856e3b6f6 ("drm/xe: Use reserved copy engine for user binds on faulting devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 37 ++++--------------------------
 drivers/gpu/drm/xe/xe_hw_engine.c  | 31 +++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_hw_engine.h  |  7 ++++++
 3 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 9731dcd0b1bde..ddc22a8d9bf5f 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -418,34 +418,6 @@ static int exec_queue_user_extensions(struct xe_device *xe, struct xe_exec_queue
 	return 0;
 }
 
-static const enum xe_engine_class user_to_xe_engine_class[] = {
-	[DRM_XE_ENGINE_CLASS_RENDER] = XE_ENGINE_CLASS_RENDER,
-	[DRM_XE_ENGINE_CLASS_COPY] = XE_ENGINE_CLASS_COPY,
-	[DRM_XE_ENGINE_CLASS_VIDEO_DECODE] = XE_ENGINE_CLASS_VIDEO_DECODE,
-	[DRM_XE_ENGINE_CLASS_VIDEO_ENHANCE] = XE_ENGINE_CLASS_VIDEO_ENHANCE,
-	[DRM_XE_ENGINE_CLASS_COMPUTE] = XE_ENGINE_CLASS_COMPUTE,
-};
-
-static struct xe_hw_engine *
-find_hw_engine(struct xe_device *xe,
-	       struct drm_xe_engine_class_instance eci)
-{
-	u32 idx;
-
-	if (eci.engine_class >= ARRAY_SIZE(user_to_xe_engine_class))
-		return NULL;
-
-	if (eci.gt_id >= xe->info.gt_count)
-		return NULL;
-
-	idx = array_index_nospec(eci.engine_class,
-				 ARRAY_SIZE(user_to_xe_engine_class));
-
-	return xe_gt_hw_engine(xe_device_get_gt(xe, eci.gt_id),
-			       user_to_xe_engine_class[idx],
-			       eci.engine_instance, true);
-}
-
 static u32 bind_exec_queue_logical_mask(struct xe_device *xe, struct xe_gt *gt,
 					struct drm_xe_engine_class_instance *eci,
 					u16 width, u16 num_placements)
@@ -467,8 +439,7 @@ static u32 bind_exec_queue_logical_mask(struct xe_device *xe, struct xe_gt *gt,
 		if (xe_hw_engine_is_reserved(hwe))
 			continue;
 
-		if (hwe->class ==
-		    user_to_xe_engine_class[DRM_XE_ENGINE_CLASS_COPY])
+		if (hwe->class == XE_ENGINE_CLASS_COPY)
 			logical_mask |= BIT(hwe->logical_instance);
 	}
 
@@ -497,7 +468,7 @@ static u32 calc_validate_logical_mask(struct xe_device *xe, struct xe_gt *gt,
 
 			n = j * width + i;
 
-			hwe = find_hw_engine(xe, eci[n]);
+			hwe = xe_hw_engine_lookup(xe, eci[n]);
 			if (XE_IOCTL_DBG(xe, !hwe))
 				return 0;
 
@@ -576,7 +547,7 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 			if (XE_IOCTL_DBG(xe, !logical_mask))
 				return -EINVAL;
 
-			hwe = find_hw_engine(xe, eci[0]);
+			hwe = xe_hw_engine_lookup(xe, eci[0]);
 			if (XE_IOCTL_DBG(xe, !hwe))
 				return -EINVAL;
 
@@ -613,7 +584,7 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 		if (XE_IOCTL_DBG(xe, !logical_mask))
 			return -EINVAL;
 
-		hwe = find_hw_engine(xe, eci[0]);
+		hwe = xe_hw_engine_lookup(xe, eci[0]);
 		if (XE_IOCTL_DBG(xe, !hwe))
 			return -EINVAL;
 
diff --git a/drivers/gpu/drm/xe/xe_hw_engine.c b/drivers/gpu/drm/xe/xe_hw_engine.c
index 07ed9fd28f195..00ace5fcc284e 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -5,7 +5,10 @@
 
 #include "xe_hw_engine.h"
 
+#include <linux/nospec.h>
+
 #include <drm/drm_managed.h>
+#include <drm/xe_drm.h>
 
 #include "regs/xe_engine_regs.h"
 #include "regs/xe_gt_regs.h"
@@ -1135,3 +1138,31 @@ enum xe_force_wake_domains xe_hw_engine_to_fw_domain(struct xe_hw_engine *hwe)
 {
 	return engine_infos[hwe->engine_id].domain;
 }
+
+static const enum xe_engine_class user_to_xe_engine_class[] = {
+	[DRM_XE_ENGINE_CLASS_RENDER] = XE_ENGINE_CLASS_RENDER,
+	[DRM_XE_ENGINE_CLASS_COPY] = XE_ENGINE_CLASS_COPY,
+	[DRM_XE_ENGINE_CLASS_VIDEO_DECODE] = XE_ENGINE_CLASS_VIDEO_DECODE,
+	[DRM_XE_ENGINE_CLASS_VIDEO_ENHANCE] = XE_ENGINE_CLASS_VIDEO_ENHANCE,
+	[DRM_XE_ENGINE_CLASS_COMPUTE] = XE_ENGINE_CLASS_COMPUTE,
+};
+
+struct xe_hw_engine *
+xe_hw_engine_lookup(struct xe_device *xe,
+		    struct drm_xe_engine_class_instance eci)
+{
+	unsigned int idx;
+
+	if (eci.engine_class > ARRAY_SIZE(user_to_xe_engine_class))
+		return NULL;
+
+	if (eci.gt_id >= xe->info.gt_count)
+		return NULL;
+
+	idx = array_index_nospec(eci.engine_class,
+				 ARRAY_SIZE(user_to_xe_engine_class));
+
+	return xe_gt_hw_engine(xe_device_get_gt(xe, eci.gt_id),
+			       user_to_xe_engine_class[idx],
+			       eci.engine_instance, true);
+}
diff --git a/drivers/gpu/drm/xe/xe_hw_engine.h b/drivers/gpu/drm/xe/xe_hw_engine.h
index 900c8c9914303..d227ffe557ebf 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.h
+++ b/drivers/gpu/drm/xe/xe_hw_engine.h
@@ -9,6 +9,8 @@
 #include "xe_hw_engine_types.h"
 
 struct drm_printer;
+struct drm_xe_engine_class_instance;
+struct xe_device;
 
 #ifdef CONFIG_DRM_XE_JOB_TIMEOUT_MIN
 #define XE_HW_ENGINE_JOB_TIMEOUT_MIN CONFIG_DRM_XE_JOB_TIMEOUT_MIN
@@ -62,6 +64,11 @@ void xe_hw_engine_print(struct xe_hw_engine *hwe, struct drm_printer *p);
 void xe_hw_engine_setup_default_lrc_state(struct xe_hw_engine *hwe);
 
 bool xe_hw_engine_is_reserved(struct xe_hw_engine *hwe);
+
+struct xe_hw_engine *
+xe_hw_engine_lookup(struct xe_device *xe,
+		    struct drm_xe_engine_class_instance eci);
+
 static inline bool xe_hw_engine_is_valid(struct xe_hw_engine *hwe)
 {
 	return hwe->name;
-- 
2.43.0



