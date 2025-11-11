Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC514C97;
	Tue, 11 Nov 2025 00:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822510; cv=none; b=bPZp2pIqrDf80V2a2jndezQjLadd4/Tnj/Hv2Jl9ojDKfNvKmOkxlWw0UTpDpYCo8bpkNu+kupYWydtV53XvRZ6jiHP6XUpCQBS4yCH1KZ/Bw1XGevlVcyPsRfarHnd2aHAPeIA0Ns/saXKoF8gpV59VjYfKLCjos+R1pAT8ja8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822510; c=relaxed/simple;
	bh=4CX55yi0ODp96pavr/1dXLeUyewERS+zpdcJ0QWcMSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R57jamepY27Ysy1pYq30MF11L2V5LrxzHidi70TJeK5RqgDj0s9CyGZCKXi6iaLuqtFVtQGX3YbC2ImAD+4Z+Ff8YyLm1RBcE6JnqnPwlSs3AI5F/JhbaVk6/pVnwBDJxupfSc1zowb4kzdfUIx0LFQehSfp8S/ndgHxnLhYv/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPk1eSfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPk1eSfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7366FC16AAE;
	Tue, 11 Nov 2025 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822509;
	bh=4CX55yi0ODp96pavr/1dXLeUyewERS+zpdcJ0QWcMSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPk1eSfaeKcqodTyw4CQSG6VRtrQ88EZ0fn0lKHoHkDXPP8ALTBzpYwhmgXRhUok4
	 3Pj3ivs9mMxsgfTktD5yQBtYPGZcOqc/h1zvzDWUl8An/jhLlDpzhc7qrUbLwzRkAH
	 hxaJhe6Yr0Np980xCRZDWZO0Yih2ZllYnfbJQNuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 065/565] drm/xe: Do not wake device during a GT reset
Date: Tue, 11 Nov 2025 09:38:41 +0900
Message-ID: <20251111004528.404785642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit b3fbda1a630a9439c885b2a5dc5230cc49a87e9e upstream.

Waking the device during a GT reset can lead to unintended memory
allocation, which is not allowed since GT resets occur in the reclaim
path. Prevent this by holding a PM reference while a reset is in flight.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20251022005538.828980-3-matthew.brost@intel.com
(cherry picked from commit 480b358e7d8ef69fd8f1b0cad6e07c7d70a36ee4)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -746,17 +746,19 @@ static int gt_reset(struct xe_gt *gt)
 {
 	int err;
 
-	if (xe_device_wedged(gt_to_xe(gt)))
-		return -ECANCELED;
+	if (xe_device_wedged(gt_to_xe(gt))) {
+		err = -ECANCELED;
+		goto err_pm_put;
+	}
 
 	/* We only support GT resets with GuC submission */
-	if (!xe_device_uc_enabled(gt_to_xe(gt)))
-		return -ENODEV;
+	if (!xe_device_uc_enabled(gt_to_xe(gt))) {
+		err = -ENODEV;
+		goto err_pm_put;
+	}
 
 	xe_gt_info(gt, "reset started\n");
 
-	xe_pm_runtime_get(gt_to_xe(gt));
-
 	if (xe_fault_inject_gt_reset()) {
 		err = -ECANCELED;
 		goto err_fail;
@@ -803,6 +805,7 @@ err_fail:
 	xe_gt_err(gt, "reset failed (%pe)\n", ERR_PTR(err));
 
 	xe_device_declare_wedged(gt_to_xe(gt));
+err_pm_put:
 	xe_pm_runtime_put(gt_to_xe(gt));
 
 	return err;
@@ -824,7 +827,9 @@ void xe_gt_reset_async(struct xe_gt *gt)
 		return;
 
 	xe_gt_info(gt, "reset queued\n");
-	queue_work(gt->ordered_wq, &gt->reset.worker);
+	xe_pm_runtime_get_noresume(gt_to_xe(gt));
+	if (!queue_work(gt->ordered_wq, &gt->reset.worker))
+		xe_pm_runtime_put(gt_to_xe(gt));
 }
 
 void xe_gt_suspend_prepare(struct xe_gt *gt)


