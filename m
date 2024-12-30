Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A562AE68;
	Mon, 30 Dec 2024 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574248; cv=none; b=gMS2cWxad8A2161UkL0iqOpVROaxqIbHvvJw1xF4BQ+3R/PYJZWYNT1SnoP+By8VR/rAytw+t4cDZbYcdJ5Kjz9ZgRYKtQ5s+w8c/NA+IkqTBHzZRR/XoEjsJn8Y6RFEpXlzS1mn3WAEj0w27WWNimyGChFcKU3TDP0lAMujNEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574248; c=relaxed/simple;
	bh=i4UT3bK+cOACTd+BPvUAdme6n8ua7hSQlX7SqHgjW0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pugvVoxURUpSyNqavoddaSsEh7la6Zgjn62JzejVbAD4oaH6vUbfugPoybd3KVADZ4hsSJDP1RbF8jZv6FhjvyA8Kxl+gS7xNwpzAPIbIPPS/jd8qxg7BIt2s4pugDax+XfILjlsIjeukzFRgLcbEuK53mI5//BBnQmPdj6DoYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVtjNjzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVtjNjzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23A2C4CED2;
	Mon, 30 Dec 2024 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574246;
	bh=i4UT3bK+cOACTd+BPvUAdme6n8ua7hSQlX7SqHgjW0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVtjNjzEuxcNL4jHBwF8iZpwrd0jAwaT2t6WFGiX/J0+PnyjXEdegssPwJerM39E1
	 EJlYXD8ra3WVeZcWMIZbmRssDFIuxPIfppCzFKrAKnYDxWmqFtexeOMvOLZn6xc4ms
	 XKyMndyaSfaNO8H2IbpXvbdlEKcvqs6QGXxf15L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/114] drm/xe: Take PM ref in delayed snapshot capture worker
Date: Mon, 30 Dec 2024 16:43:16 +0100
Message-ID: <20241230154221.135573953@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit aef0b4a07277f715bfc2a0d76a16da2bc4e89205 ]

The delayed snapshot capture worker can access the GPU or VRAM both of
which require a PM reference. Take a reference in this worker.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: 4f04d07c0a94 ("drm/xe: Faster devcoredump")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241126174615.2665852-5-matthew.brost@intel.com
(cherry picked from commit 1c6878af115a4586a40d6c14d530fa9f93e0bd83)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Stable-dep-of: 5dce85fecb87 ("drm/xe: Move the coredump registration to the worker thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index 5221ee3f1214..c40c91e27f71 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -20,6 +20,7 @@
 #include "xe_guc_ct.h"
 #include "xe_guc_submit.h"
 #include "xe_hw_engine.h"
+#include "xe_pm.h"
 #include "xe_sched_job.h"
 #include "xe_vm.h"
 
@@ -147,8 +148,11 @@ static void xe_devcoredump_deferred_snap_work(struct work_struct *work)
 {
 	struct xe_devcoredump_snapshot *ss = container_of(work, typeof(*ss), work);
 	struct xe_devcoredump *coredump = container_of(ss, typeof(*coredump), snapshot);
+	struct xe_device *xe = coredump_to_xe(coredump);
 	unsigned int fw_ref;
 
+	xe_pm_runtime_get(xe);
+
 	/* keep going if fw fails as we still want to save the memory and SW data */
 	fw_ref = xe_force_wake_get(gt_to_fw(ss->gt), XE_FORCEWAKE_ALL);
 	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FORCEWAKE_ALL))
@@ -157,6 +161,8 @@ static void xe_devcoredump_deferred_snap_work(struct work_struct *work)
 	xe_guc_exec_queue_snapshot_capture_delayed(ss->ge);
 	xe_force_wake_put(gt_to_fw(ss->gt), fw_ref);
 
+	xe_pm_runtime_put(xe);
+
 	/* Calculate devcoredump size */
 	ss->read.size = __xe_devcoredump_read(NULL, INT_MAX, coredump);
 
-- 
2.39.5



