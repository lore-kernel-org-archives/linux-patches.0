Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCC31D31A0;
	Tue,  8 Oct 2024 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391861; cv=none; b=QThXH5pOBiiblrVrJ/zZz5J7wi5WJv2hcRtWmcRy0VwQPPJZBRpm6Uo8JzwjferegDm1pDjukxvEH9mz9ef9nEYV3fpT0yKiAWG3mEdp7VI+vdH0ywSMeGMj+q8DhzgA9Y8y//q/ZKamhHSrk3ZO40+fWUGpZL/CD73pb3qxINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391861; c=relaxed/simple;
	bh=y1Ye9zmCaMBsiZsQb6k/Lb1csRvSQhE3bOnilMZ1RpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IufUgGt0UK673kDGDhtwhgric+3azzqxI5ouoSmBWMF2xyZ5EbjREg1XViK6Xf3uCCZMJ4TMtUEjpX/2croMw7cFc69+80KLl3o8TmD9qzwKs1AfrewyvBGCgZXnoUYk4d2QmmXrOpZjWjBjiikAlxHdAbGBGZi0d+egJUmuk54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5W5MVVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5W5MVVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E06C4CEC7;
	Tue,  8 Oct 2024 12:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391861;
	bh=y1Ye9zmCaMBsiZsQb6k/Lb1csRvSQhE3bOnilMZ1RpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5W5MVVbPVhALk1yNSAcS5JMQYvPc8vQ9n6GbnkV13MsxAyFu67xRphcSfaXgd01V
	 COIJN86AJ+38Wltlu6QlNw7DW7tRIKSYZxZzp6cPaZJOwHz/pV5bUr2fcoX7GjzMXG
	 vws52TttBX2PXgfPXj1Iq8Mt/qrbJdVIsqpRzXNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 214/558] drm/xe/hdcp: Check GSC structure validity
Date: Tue,  8 Oct 2024 14:04:04 +0200
Message-ID: <20241008115710.765717287@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit b4224f6bae3801d589f815672ec62800a1501b0d ]

Sometimes xe_gsc is not initialized when checked at HDCP capability
check. Add gsc structure check to avoid null pointer error.

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722064451.3610512-4-suraj.kandpal@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
index 990285aa9b261..0af667ebebf98 100644
--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -40,10 +40,14 @@ bool intel_hdcp_gsc_check_status(struct xe_device *xe)
 {
 	struct xe_tile *tile = xe_device_get_root_tile(xe);
 	struct xe_gt *gt = tile->media_gt;
+	struct xe_gsc *gsc = &gt->uc.gsc;
 	bool ret = true;
 
-	if (!xe_uc_fw_is_enabled(&gt->uc.gsc.fw))
+	if (!gsc && !xe_uc_fw_is_enabled(&gsc->fw)) {
+		drm_dbg_kms(&xe->drm,
+			    "GSC Components not ready for HDCP2.x\n");
 		return false;
+	}
 
 	xe_pm_runtime_get(xe);
 	if (xe_force_wake_get(gt_to_fw(gt), XE_FW_GSC)) {
@@ -53,7 +57,7 @@ bool intel_hdcp_gsc_check_status(struct xe_device *xe)
 		goto out;
 	}
 
-	if (!xe_gsc_proxy_init_done(&gt->uc.gsc))
+	if (!xe_gsc_proxy_init_done(gsc))
 		ret = false;
 
 	xe_force_wake_put(gt_to_fw(gt), XE_FW_GSC);
-- 
2.43.0



