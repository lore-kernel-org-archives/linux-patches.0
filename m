Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4E29BD9D;
	Tue, 12 Aug 2025 19:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026774; cv=none; b=rpILosbKx9ly0Qe8jzLD3Mm4QJ2RxfbX4K+5RJcx/wHFxyVakwnpezsadt46k0iDGcR3QMJ35v0/ZPraA66aDWWeZbHC5qANnTn4i+O1zS3zqvoUyKnQZpMHii64hZ1qeLWmHTu8SEtvh1PFHVEpLNoq1X6LKpmnPDf5tb1+/vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026774; c=relaxed/simple;
	bh=onoFtrb2n9icqsjVHl7cw9kuMjBJdBH1Tc7d/UGMB0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Du8KUYEOHnFmvVAtTOzrkikN2XglwqhlLVpWdR4FhCuVe0kmtuD9QvV4hWhMFrQrY1Y4eyVkpDkOVUBnYRTEnl3lphYNL/tg+BOS1EzyYGOu5oEBNagkFJZ9SJj3VL6ycNnu21ILa9Za9bfMu4QMbC5WNOLHj2hBWjRVT7Orzzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQQ3x5/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQQ3x5/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C0CC4CEF0;
	Tue, 12 Aug 2025 19:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026773;
	bh=onoFtrb2n9icqsjVHl7cw9kuMjBJdBH1Tc7d/UGMB0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQQ3x5/EeDGZ8DDp9Vjh3lMiVGANZxzRSVtC84Qf7xa17HkDR9mwqelmwWmXR5iEE
	 TJ+zTH9g8I6TVpw9n+PdTIPpDfLWy9WSNJ3tCPbS1Zq+/UatiGhbd6jBDEIWj6hJWA
	 OzyldyMOlwgHBmLVP9IiISscLJnhq6is+yHgVxWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 404/480] drm/xe/pf: Disable PF restart worker on device removal
Date: Tue, 12 Aug 2025 19:50:12 +0200
Message-ID: <20250812174414.096074338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit c286ce6b01f633806b4db3e4ec8e0162928299cd ]

We can't let restart worker run once device is removed, since other
data that it might want to access could be already released.
Explicitly disable worker as part of device cleanup action.

Fixes: a4d1c5d0b99b ("drm/xe/pf: Move VFs reprovisioning to worker")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://lore.kernel.org/r/20250801142822.180530-2-michal.wajdeczko@intel.com
(cherry picked from commit a424353937c24554bb242a6582ed8f018b4a411c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c | 32 ++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index 35489fa81825..2ea81d81c0ae 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -47,9 +47,16 @@ static int pf_alloc_metadata(struct xe_gt *gt)
 
 static void pf_init_workers(struct xe_gt *gt)
 {
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
 	INIT_WORK(&gt->sriov.pf.workers.restart, pf_worker_restart_func);
 }
 
+static void pf_fini_workers(struct xe_gt *gt)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+	disable_work_sync(&gt->sriov.pf.workers.restart);
+}
+
 /**
  * xe_gt_sriov_pf_init_early - Prepare SR-IOV PF data structures on PF.
  * @gt: the &xe_gt to initialize
@@ -79,6 +86,21 @@ int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
 	return 0;
 }
 
+static void pf_fini_action(void *arg)
+{
+	struct xe_gt *gt = arg;
+
+	pf_fini_workers(gt);
+}
+
+static int pf_init_late(struct xe_gt *gt)
+{
+	struct xe_device *xe = gt_to_xe(gt);
+
+	xe_gt_assert(gt, IS_SRIOV_PF(xe));
+	return devm_add_action_or_reset(xe->drm.dev, pf_fini_action, gt);
+}
+
 /**
  * xe_gt_sriov_pf_init - Prepare SR-IOV PF data structures on PF.
  * @gt: the &xe_gt to initialize
@@ -95,7 +117,15 @@ int xe_gt_sriov_pf_init(struct xe_gt *gt)
 	if (err)
 		return err;
 
-	return xe_gt_sriov_pf_migration_init(gt);
+	err = xe_gt_sriov_pf_migration_init(gt);
+	if (err)
+		return err;
+
+	err = pf_init_late(gt);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 static bool pf_needs_enable_ggtt_guest_update(struct xe_device *xe)
-- 
2.39.5



