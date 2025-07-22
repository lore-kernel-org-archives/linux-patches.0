Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF622B9A5;
	Tue, 22 Jul 2025 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193621; cv=none; b=X7l3q/aZCUzXO1eib5VzAZkA4OjTNBro9Ssmz3IYziYOdug7BauEEMWLiVq7nqYZVrsSlp4+oey/GpJ5Qvstu0kpeeW2hH8/pv5Bwe7dJL1P3xBAClewhWMY6hyiS91rtewG46m6V6IU2gpXILdnPSxxwu6sXN+fKh1dI+9gmGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193621; c=relaxed/simple;
	bh=rROtZMTRamDjRtwM2zIUAH30ihMstzy8+qG5SzoBv3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U7Zrvd4Cqr1D5Oham7sJYRTz1mTaf1M2TBoy9tGIUzCiDrsK+QEtZTOoWmZ6F2IT1CfS9qUrvCF3EAe77wcIncD6kmKmEyIKl+uWxQTbtmXmO2VLgdsTZq3o+nGV50d7PQr/qKe2R/LOK3XyI4BEgyvAouSFk9+Jv/xUQ/ZuWKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jttLOEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jttLOEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2260C4CEEB;
	Tue, 22 Jul 2025 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193621;
	bh=rROtZMTRamDjRtwM2zIUAH30ihMstzy8+qG5SzoBv3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jttLOExRUVUk6bzPbxQdxMiocIBAgYRUZuxJujuptOz5EbgnbKSHEa7aBb37aOiT
	 YyYwKfnCKj+k6NoEKFM5vKsqWM6dPnYuPe5lt5ZzX+jEfVMyAHP9LcEwzevllgFeXg
	 RtR+WpQd8LBmXAknEe8QXkxuI9r6UQ8DfBUSn5Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 148/187] drm/xe/pf: Resend PF provisioning after GT reset
Date: Tue, 22 Jul 2025 15:45:18 +0200
Message-ID: <20250722134351.301676554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

[ Upstream commit 5c244eeca57ff4e47e1f60310d059346d1b86b9b ]

If we reload the GuC due to suspend/resume or GT reset then we
have to resend not only any VFs provisioning data, but also PF
configuration, like scheduling parameters (EQ, PT), as otherwise
GuC will continue to use default values.

Fixes: 411220808cee ("drm/xe/pf: Restart VFs provisioning after GT reset")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://lore.kernel.org/r/20250711193316.1920-3-michal.wajdeczko@intel.com
(cherry picked from commit 1c38dd6afa4a8ecce28e94da794fd1d205c30f51)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index 10be109bf357f..96289195a3d3e 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -2356,6 +2356,21 @@ int xe_gt_sriov_pf_config_restore(struct xe_gt *gt, unsigned int vfid,
 	return err;
 }
 
+static int pf_push_self_config(struct xe_gt *gt)
+{
+	int err;
+
+	err = pf_push_full_vf_config(gt, PFID);
+	if (err) {
+		xe_gt_sriov_err(gt, "Failed to push self configuration (%pe)\n",
+				ERR_PTR(err));
+		return err;
+	}
+
+	xe_gt_sriov_dbg_verbose(gt, "self configuration completed\n");
+	return 0;
+}
+
 static void fini_config(void *arg)
 {
 	struct xe_gt *gt = arg;
@@ -2379,9 +2394,17 @@ static void fini_config(void *arg)
 int xe_gt_sriov_pf_config_init(struct xe_gt *gt)
 {
 	struct xe_device *xe = gt_to_xe(gt);
+	int err;
 
 	xe_gt_assert(gt, IS_SRIOV_PF(xe));
 
+	mutex_lock(xe_gt_sriov_pf_master_mutex(gt));
+	err = pf_push_self_config(gt);
+	mutex_unlock(xe_gt_sriov_pf_master_mutex(gt));
+
+	if (err)
+		return err;
+
 	return devm_add_action_or_reset(xe->drm.dev, fini_config, gt);
 }
 
@@ -2399,6 +2422,10 @@ void xe_gt_sriov_pf_config_restart(struct xe_gt *gt)
 	unsigned int n, total_vfs = xe_sriov_pf_get_totalvfs(gt_to_xe(gt));
 	unsigned int fail = 0, skip = 0;
 
+	mutex_lock(xe_gt_sriov_pf_master_mutex(gt));
+	pf_push_self_config(gt);
+	mutex_unlock(xe_gt_sriov_pf_master_mutex(gt));
+
 	for (n = 1; n <= total_vfs; n++) {
 		if (xe_gt_sriov_pf_config_is_empty(gt, n))
 			skip++;
-- 
2.39.5



