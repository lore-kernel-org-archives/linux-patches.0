Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C21D364E89;
	Wed, 20 May 2026 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296989; cv=none; b=mZ7ZK/EAujZshuYxxEYkEwLUvHmybA5EPARv44P8nl6uMIBTuW417R75xH5CS/omZ23Nmq81SMWq60Wy9Em5oKHp/ObgUOI/IfgquB9jFK44v3XCjBLGd8oxGON/XkbtyyC1A36MdlHncafHD/Pud8P8y7yBuVLHarfEXUd9aK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296989; c=relaxed/simple;
	bh=TXKYppm6K8OLgxHAhhnI+/QXmL2xNuYkWuBjBHF2AeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s40pe+U6WEWE8rFfq335noHtsaDU+LwBjNORbRN7rUCaRDI92rYm7FAOGQ+PRxlLRVbsWM5v8llgirMjH/Xtnpjdc6stQ9Bf+f/BQ/m47w9N7Rlj43QOZEo5npvroERG14H3nVHMsgaDpt6nwr6WG/cTUz02zVPQ+vo1GzJqibw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2Qs0O8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2Qs0O8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1891F000E9;
	Wed, 20 May 2026 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296988;
	bh=slC+UZKx09CAlM/HCDAAqldqeb57Wzck9eFjM/ji2BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2Qs0O8VrVLTXG8mZjf9fEOQf1hnJkItcVU9006TWn9XCeSh1bHno8JFDgx2/p7zM
	 EI5oX74RDGaStGd+tP/fV8VWa/OEAN5/PDNwpdEEPRx2r9q/IojMscwLY0cdhQIY19
	 9q1lr4T7c6foFzy924qziJlmslOqeHp7cV8FnMWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1009/1146] drm/xe: Drop registration of guc_submit_wedged_fini from xe_guc_submit_wedge()
Date: Wed, 20 May 2026 18:20:59 +0200
Message-ID: <20260520162211.067401941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit a0fc362f095330f7b3f68ac0c55ef8da18290c87 ]

xe_guc_submit_wedge() runs in the DMA-fence signaling path, where
GFP_KERNEL memory allocations are not permitted. However, registering
guc_submit_wedged_fini via drmm_add_action_or_reset() triggers such an
allocation.

Avoid this by moving the logic from guc_submit_wedged_fini() into
guc_submit_fini(), where wedged exec queue references are dropped during
normal teardown.

Fixes: 8ed9aaae39f3 ("drm/xe: Force wedged state and block GT reset upon any GPU hang")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260326210116.202585-3-matthew.brost@intel.com
(cherry picked from commit 4a706bd93c4fb156a13477e26ffdf2e633edeb10)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 33 ++++++++----------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 4867a97583903..82412c8dfd37d 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -260,24 +260,12 @@ static void guc_submit_sw_fini(struct drm_device *drm, void *arg)
 }
 
 static void guc_submit_fini(void *arg)
-{
-	struct xe_guc *guc = arg;
-
-	/* Forcefully kill any remaining exec queues */
-	xe_guc_ct_stop(&guc->ct);
-	guc_submit_reset_prepare(guc);
-	xe_guc_softreset(guc);
-	xe_guc_submit_stop(guc);
-	xe_uc_fw_sanitize(&guc->fw);
-	xe_guc_submit_pause_abort(guc);
-}
-
-static void guc_submit_wedged_fini(void *arg)
 {
 	struct xe_guc *guc = arg;
 	struct xe_exec_queue *q;
 	unsigned long index;
 
+	/* Drop any wedged queue refs */
 	mutex_lock(&guc->submission_state.lock);
 	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q) {
 		if (exec_queue_wedged(q)) {
@@ -287,6 +275,14 @@ static void guc_submit_wedged_fini(void *arg)
 		}
 	}
 	mutex_unlock(&guc->submission_state.lock);
+
+	/* Forcefully kill any remaining exec queues */
+	xe_guc_ct_stop(&guc->ct);
+	guc_submit_reset_prepare(guc);
+	xe_guc_softreset(guc);
+	xe_guc_submit_stop(guc);
+	xe_uc_fw_sanitize(&guc->fw);
+	xe_guc_submit_pause_abort(guc);
 }
 
 static const struct xe_exec_queue_ops guc_exec_queue_ops;
@@ -1272,10 +1268,8 @@ static void disable_scheduling_deregister(struct xe_guc *guc,
 void xe_guc_submit_wedge(struct xe_guc *guc)
 {
 	struct xe_device *xe = guc_to_xe(guc);
-	struct xe_gt *gt = guc_to_gt(guc);
 	struct xe_exec_queue *q;
 	unsigned long index;
-	int err;
 
 	xe_gt_assert(guc_to_gt(guc), guc_to_xe(guc)->wedged.mode);
 
@@ -1287,15 +1281,6 @@ void xe_guc_submit_wedge(struct xe_guc *guc)
 		return;
 
 	if (xe->wedged.mode == XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET) {
-		err = devm_add_action_or_reset(guc_to_xe(guc)->drm.dev,
-					       guc_submit_wedged_fini, guc);
-		if (err) {
-			xe_gt_err(gt, "Failed to register clean-up on wedged.mode=%s; "
-				  "Although device is wedged.\n",
-				  xe_wedged_mode_to_string(XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET));
-			return;
-		}
-
 		mutex_lock(&guc->submission_state.lock);
 		xa_for_each(&guc->submission_state.exec_queue_lookup, index, q)
 			if (xe_exec_queue_get_unless_zero(q))
-- 
2.53.0



