Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE810537FF;
	Sun,  1 Sep 2024 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208318; cv=none; b=jX8OlJrH3eFRmeNr4RKFGztFQnme5yZRpwcLe8S3cqKfnooFLPSb10ePuYIUyJDl+tr7GWLPdBSD/9zUjR/50jBbWcnxj6xv19UDoXpq5u+vBXaeF0NFRagQYUnpjN8/HgYPvt5fPbm67H03OMZT8DR4XF4XWLKVLEZlBW+rFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208318; c=relaxed/simple;
	bh=xf7+o2QFYARtfWLCp8t6zVGM+6EhAOQ1qVhIO3wG4PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiv1FNBxUwPpZitKzoU1GysEYMw3GPVVTSdqxstSP0bOnvB3bEK6r8Gv7HbopA9I5g2BVQQGZzDyAOgRxhSJ7oOnfzn+UfpFG0B+F+My4DzgMOpc6UJH90CpmG7lvJQo/sRalIISzyXZXJIZWLDVEWyhemX8Bq/QzhQqQdEQqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3X5OTHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3X5OTHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DF6C4CEC3;
	Sun,  1 Sep 2024 16:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208317;
	bh=xf7+o2QFYARtfWLCp8t6zVGM+6EhAOQ1qVhIO3wG4PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3X5OTHnuptpEqinp9z0WGP1tm9P7kBG4CMFA8h2nxLAocX4/h9vLUyZwlWtgEmr9
	 czlst0LaQ7hYLXEORpH88Li+Nr5fWwHRaNnegjezhszC4kTX81pDpql+jSBdpGCY5S
	 6rNiIrd/U38BG/HHTbe7YvZWgnbErZ57vRY2a05g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 045/149] drm/xe/display: Make display suspend/resume work on discrete
Date: Sun,  1 Sep 2024 18:15:56 +0200
Message-ID: <20240901160819.159982378@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit ddf6492e0e508b7c2b42c8d5a4ac82bd38ef0dd5 ]

We should unpin before evicting all memory, and repin after GT resume.
This way, we preserve the contents of the framebuffers, and won't hang
on resume due to migration engine not being restored yet.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240806105044.596842-3-maarten.lankhorst@linux.intel.com
Signed-off-by: Maarten Lankhorst,,, <maarten.lankhorst@linux.intel.com>
(cherry picked from commit cb8f81c1753187995b7a43e79c12959f14eb32d3)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display.c | 23 +++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_pm.c              | 11 ++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display.c b/drivers/gpu/drm/xe/display/xe_display.c
index 79d33d592093c..96835ffa5734e 100644
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -302,6 +302,27 @@ static bool suspend_to_idle(void)
 	return false;
 }
 
+static void xe_display_flush_cleanup_work(struct xe_device *xe)
+{
+	struct intel_crtc *crtc;
+
+	for_each_intel_crtc(&xe->drm, crtc) {
+		struct drm_crtc_commit *commit;
+
+		spin_lock(&crtc->base.commit_lock);
+		commit = list_first_entry_or_null(&crtc->base.commit_list,
+						  struct drm_crtc_commit, commit_entry);
+		if (commit)
+			drm_crtc_commit_get(commit);
+		spin_unlock(&crtc->base.commit_lock);
+
+		if (commit) {
+			wait_for_completion(&commit->cleanup_done);
+			drm_crtc_commit_put(commit);
+		}
+	}
+}
+
 void xe_display_pm_suspend(struct xe_device *xe, bool runtime)
 {
 	bool s2idle = suspend_to_idle();
@@ -319,6 +340,8 @@ void xe_display_pm_suspend(struct xe_device *xe, bool runtime)
 	if (!runtime)
 		intel_display_driver_suspend(xe);
 
+	xe_display_flush_cleanup_work(xe);
+
 	intel_dp_mst_suspend(xe);
 
 	intel_hpd_cancel_work(xe);
diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 07615acd2c299..cf80679ceb701 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -91,13 +91,13 @@ int xe_pm_suspend(struct xe_device *xe)
 	for_each_gt(gt, xe, id)
 		xe_gt_suspend_prepare(gt);
 
+	xe_display_pm_suspend(xe, false);
+
 	/* FIXME: Super racey... */
 	err = xe_bo_evict_all(xe);
 	if (err)
 		goto err;
 
-	xe_display_pm_suspend(xe, false);
-
 	for_each_gt(gt, xe, id) {
 		err = xe_gt_suspend(gt);
 		if (err) {
@@ -151,11 +151,11 @@ int xe_pm_resume(struct xe_device *xe)
 
 	xe_irq_resume(xe);
 
-	xe_display_pm_resume(xe, false);
-
 	for_each_gt(gt, xe, id)
 		xe_gt_resume(gt);
 
+	xe_display_pm_resume(xe, false);
+
 	err = xe_bo_restore_user(xe);
 	if (err)
 		goto err;
@@ -363,10 +363,11 @@ int xe_pm_runtime_suspend(struct xe_device *xe)
 	mutex_unlock(&xe->mem_access.vram_userfault.lock);
 
 	if (xe->d3cold.allowed) {
+		xe_display_pm_suspend(xe, true);
+
 		err = xe_bo_evict_all(xe);
 		if (err)
 			goto out;
-		xe_display_pm_suspend(xe, true);
 	}
 
 	for_each_gt(gt, xe, id) {
-- 
2.43.0



