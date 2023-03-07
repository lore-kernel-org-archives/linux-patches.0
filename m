Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933ABBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F96C433EF;
	Tue,  7 Mar 2023 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210186;
	bh=8nnujh0FK/mnQfDxio1/4msAJ3ck5PCxt+jkwOZH3ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T89vSZfgDShfpb6UGcs2ehhkmy0jtoOKZDfN78t0P8LefXVfPZDuFmC8fkEvmHLra
	 QD/s9UQvT+us069JHr6PDWSuys9HfFL8iAPBKa4nwLjTXg9f32he7+HjvHiXBK9wmL
	 Df8+pSG+e7H92CQyTZExV/xEBLYNaecVp3UGk7cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0430/1001] drm/amd/display: dont call dc_interrupt_set() for disabled crtcs
Date: Tue,  7 Mar 2023 17:53:22 +0100
Message-Id: <20230307170040.017337570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 4936458bf989d168f5a89015dd81067c4c2bdc64 ]

As made mention of in commit 4ea7fc09539b ("drm/amd/display: Do not
program interrupt status on disabled crtc"), we shouldn't program
disabled crtcs. So, filter out disabled crtcs in dm_set_vupdate_irq()
and dm_set_vblank().

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 589d2739332d ("drm/amd/display: Use crtc enable/disable_vblank hooks")
Fixes: d2574c33bb71 ("drm/amd/display: In VRR mode, do DRM core vblank handling at end of vblank. (v2)")
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 22125daf9dcfe..78c2ed59e87d2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -77,6 +77,9 @@ int dm_set_vupdate_irq(struct drm_crtc *crtc, bool enable)
 	struct amdgpu_device *adev = drm_to_adev(crtc->dev);
 	int rc;
 
+	if (acrtc->otg_inst == -1)
+		return 0;
+
 	irq_source = IRQ_TYPE_VUPDATE + acrtc->otg_inst;
 
 	rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;
@@ -152,6 +155,9 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	struct vblank_control_work *work;
 	int rc = 0;
 
+	if (acrtc->otg_inst == -1)
+		goto skip;
+
 	if (enable) {
 		/* vblank irq on -> Only need vupdate irq in vrr mode */
 		if (amdgpu_dm_vrr_active(acrtc_state))
@@ -169,6 +175,7 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
 		return -EBUSY;
 
+skip:
 	if (amdgpu_in_reset(adev))
 		return 0;
 
-- 
2.39.2



