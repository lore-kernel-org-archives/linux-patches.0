Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86842A9B;
	Tue, 27 May 2025 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368191; cv=none; b=WeNMozryn6cv2Qo8UDU9ZfoyPSXX9plPvAn1iXm5HZIroDKrttqwaN0/XXr2Mu4ulY2ZNUHWLJWcQwCWlGdSOF5vWfzZ/evSrhE4V1aR5djxFZJySHILqliAgDV/2OSW093iYSp42yZJWlK7bRkk1P5qyEjmg6M2muZPPWzxGQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368191; c=relaxed/simple;
	bh=TsMvn1a3uyFs70ifyaPK22nINvXPAuPi4AYpW703t+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsLBhws2UTj+dQcHFPzOvGjTCoXZWnCVtl+5o4+h2cSOaca5XmRFwLd7VPodXMpHQjplyvev/iY+whjxFQcW5OgDx2UFSIXv34eaMRPe2i6x+SWoNjFj8f6zjiIulTFd7pDRs5PCH3HINbD4+DX07u9FHNW3iPV9cB9kW2x9KFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Un6n9Etq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Un6n9Etq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAD1C4CEE9;
	Tue, 27 May 2025 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368190;
	bh=TsMvn1a3uyFs70ifyaPK22nINvXPAuPi4AYpW703t+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un6n9EtqmMa4mPmUGsifZsbf4/7mMEOzZe4yFsXBWlrTDjKbraCwRy3DTDalUpbbd
	 ASVcvuUuxPrDv8XhMckSM8PL7MyMjj+6RrelgxDRHVVeluTBqBrQlv/xMtCFQd6eeF
	 LOchZsnpUvYs+arBmcHDhWuKLQwANz+kqPKVnA6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 627/783] drm/xe: Add locks in gtidle code
Date: Tue, 27 May 2025 18:27:04 +0200
Message-ID: <20250527162538.683470736@linuxfoundation.org>
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

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit d160dc6f53914d729be7fcb7afbd0e9e6a3725b2 ]

The update of the residency values needs to be protected by a lock to
avoid multiple entrypoints, for example when multiple userspace clients
read the sysfs file. Other in-kernel clients are going to be added to
sample these values, making the problem worse. Protect those updates
with a raw_spinlock so it can be called by future integration with perf
pmu.

Suggested-by: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250110173308.2412232-2-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_idle.c       | 23 ++++++++++++++++++++---
 drivers/gpu/drm/xe/xe_gt_idle.h       |  1 +
 drivers/gpu/drm/xe/xe_gt_idle_types.h |  3 +++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_idle.c b/drivers/gpu/drm/xe/xe_gt_idle.c
index ffd3ba7f66561..fbbace7b0b12a 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -69,6 +69,8 @@ static u64 get_residency_ms(struct xe_gt_idle *gtidle, u64 cur_residency)
 {
 	u64 delta, overflow_residency, prev_residency;
 
+	lockdep_assert_held(&gtidle->lock);
+
 	overflow_residency = BIT_ULL(32);
 
 	/*
@@ -275,8 +277,21 @@ static ssize_t idle_status_show(struct device *dev,
 
 	return sysfs_emit(buff, "%s\n", gt_idle_state_to_string(state));
 }
-static DEVICE_ATTR_RO(idle_status);
 
+u64 xe_gt_idle_residency_msec(struct xe_gt_idle *gtidle)
+{
+	struct xe_guc_pc *pc = gtidle_to_pc(gtidle);
+	u64 residency;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&gtidle->lock, flags);
+	residency = get_residency_ms(gtidle, gtidle->idle_residency(pc));
+	raw_spin_unlock_irqrestore(&gtidle->lock, flags);
+
+	return residency;
+}
+
+static DEVICE_ATTR_RO(idle_status);
 static ssize_t idle_residency_ms_show(struct device *dev,
 				      struct device_attribute *attr, char *buff)
 {
@@ -285,10 +300,10 @@ static ssize_t idle_residency_ms_show(struct device *dev,
 	u64 residency;
 
 	xe_pm_runtime_get(pc_to_xe(pc));
-	residency = gtidle->idle_residency(pc);
+	residency = xe_gt_idle_residency_msec(gtidle);
 	xe_pm_runtime_put(pc_to_xe(pc));
 
-	return sysfs_emit(buff, "%llu\n", get_residency_ms(gtidle, residency));
+	return sysfs_emit(buff, "%llu\n", residency);
 }
 static DEVICE_ATTR_RO(idle_residency_ms);
 
@@ -331,6 +346,8 @@ int xe_gt_idle_init(struct xe_gt_idle *gtidle)
 	if (!kobj)
 		return -ENOMEM;
 
+	raw_spin_lock_init(&gtidle->lock);
+
 	if (xe_gt_is_media_type(gt)) {
 		snprintf(gtidle->name, sizeof(gtidle->name), "gt%d-mc", gt->info.id);
 		gtidle->idle_residency = xe_guc_pc_mc6_residency;
diff --git a/drivers/gpu/drm/xe/xe_gt_idle.h b/drivers/gpu/drm/xe/xe_gt_idle.h
index 4455a6501cb07..591a01e181bcc 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.h
+++ b/drivers/gpu/drm/xe/xe_gt_idle.h
@@ -17,5 +17,6 @@ void xe_gt_idle_disable_c6(struct xe_gt *gt);
 void xe_gt_idle_enable_pg(struct xe_gt *gt);
 void xe_gt_idle_disable_pg(struct xe_gt *gt);
 int xe_gt_idle_pg_print(struct xe_gt *gt, struct drm_printer *p);
+u64 xe_gt_idle_residency_msec(struct xe_gt_idle *gtidle);
 
 #endif /* _XE_GT_IDLE_H_ */
diff --git a/drivers/gpu/drm/xe/xe_gt_idle_types.h b/drivers/gpu/drm/xe/xe_gt_idle_types.h
index b8b297a3f8848..a3667c567f8a7 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_idle_types.h
@@ -6,6 +6,7 @@
 #ifndef _XE_GT_IDLE_SYSFS_TYPES_H_
 #define _XE_GT_IDLE_SYSFS_TYPES_H_
 
+#include <linux/spinlock.h>
 #include <linux/types.h>
 
 struct xe_guc_pc;
@@ -31,6 +32,8 @@ struct xe_gt_idle {
 	u64 cur_residency;
 	/** @prev_residency: previous residency counter */
 	u64 prev_residency;
+	/** @lock: Lock protecting idle residency counters */
+	raw_spinlock_t lock;
 	/** @idle_status: get the current idle state */
 	enum xe_gt_idle_state (*idle_status)(struct xe_guc_pc *pc);
 	/** @idle_residency: get idle residency counter */
-- 
2.39.5



