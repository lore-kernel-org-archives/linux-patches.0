Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F5188A1E;
	Tue, 10 Sep 2024 09:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962163; cv=none; b=X9qHIUeZDAbzhmJORE+alQJWOx4hi3cDM2g5IRxFZB71T7bSmC2swgvaKIufRTXrfLsPyBSp7pPgRnD53MOEsgd8yIl731h39E6AxGb/VapDoDqprwnvddCf06eFNSikXtuNdYFh+JK6g4OoJhno4dgZkk2JgPH3LAQUjTBUB+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962163; c=relaxed/simple;
	bh=4QCZZk37wFCErnCr3xT36rjH5Z5ZFSDLxcTvvu6mIHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeJaJYDxL72T6NiAaYfOcCbiswsHCeEXGEtuaAXknxgnINvUBY6yd9h9pYJbNHiUlP0a5D6d5oPOJpAZfj6RwHEzeuK9PavajQ567yygMG4a2S22IxUhOG2yZ81j3EZIYedwU4k8iuXYx4OsPlMNKaWy4Bf7y+tKuQGGChpsa1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FK+KOVPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FK+KOVPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251F3C4CEC3;
	Tue, 10 Sep 2024 09:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962163;
	bh=4QCZZk37wFCErnCr3xT36rjH5Z5ZFSDLxcTvvu6mIHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FK+KOVPOSvE90PObknbSBqWtA453+xKQtLICIhjIlP6toelPM1mCrowkYB67pacbu
	 K25da/yJ8suRPclu7u6WAaLV2o+3D2J+F95gB69DteeTnQ5dZEdZN2cPTUX5JCDGFX
	 S8s5ZLtlZTT43XcUPXeSe8QGlkIvT2qhTop7Ero8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 279/375] drm/amdgpu: Fix two reset triggered in a row
Date: Tue, 10 Sep 2024 11:31:16 +0200
Message-ID: <20240910092631.931695623@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit f4322b9f8ad5f9f62add288c785d2e10bb6a5efe ]

Some times a hang GPU causes multiple reset sources to schedule resets.
The second source will be able to trigger an unnecessary reset if they
schedule after we call amdgpu_device_stop_pending_resets.

Move amdgpu_device_stop_pending_resets to after the reset is done. Since
at this point the GPU is supposedly in a good state, any reset scheduled
after this point would be a legitimate reset.

Remove unnecessary and incorrect checks for amdgpu_in_reset that was
kinda serving this purpose.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6e4aa08fa9c6 ("drm/amdgpu: Fix amdgpu_device_reset_sriov retry logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 19 ++++++++++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c      |  2 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c      |  2 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c      |  2 +-
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d24d7a108624..9f7f96be1ac7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5072,8 +5072,6 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 retry:
 	amdgpu_amdkfd_pre_reset(adev);
 
-	amdgpu_device_stop_pending_resets(adev);
-
 	if (from_hypervisor)
 		r = amdgpu_virt_request_full_gpu(adev, true);
 	else
@@ -5828,13 +5826,6 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 				  r, adev_to_drm(tmp_adev)->unique);
 			tmp_adev->asic_reset_res = r;
 		}
-
-		if (!amdgpu_sriov_vf(tmp_adev))
-			/*
-			* Drop all pending non scheduler resets. Scheduler resets
-			* were already dropped during drm_sched_stop
-			*/
-			amdgpu_device_stop_pending_resets(tmp_adev);
 	}
 
 	/* Actual ASIC resets if needed.*/
@@ -5856,6 +5847,16 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			goto retry;
 	}
 
+	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
+		/*
+		 * Drop any pending non scheduler resets queued before reset is done.
+		 * Any reset scheduled after this point would be valid. Scheduler resets
+		 * were already dropped during drm_sched_stop and no new ones can come
+		 * in before drm_sched_start.
+		 */
+		amdgpu_device_stop_pending_resets(tmp_adev);
+	}
+
 skip_hw_reset:
 
 	/* Post ASIC reset for all devs .*/
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 26cea0076c9b..e12d179a451b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -601,7 +601,7 @@ static void amdgpu_virt_update_vf2pf_work_item(struct work_struct *work)
 	if (ret) {
 		adev->virt.vf2pf_update_retry_cnt++;
 		if ((adev->virt.vf2pf_update_retry_cnt >= AMDGPU_VF2PF_UPDATE_MAX_RETRY_LIMIT) &&
-		    amdgpu_sriov_runtime(adev) && !amdgpu_in_reset(adev)) {
+		    amdgpu_sriov_runtime(adev)) {
 			amdgpu_ras_set_fed(adev, true);
 			if (amdgpu_reset_domain_schedule(adev->reset_domain,
 							  &adev->kfd.reset_work))
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
index 0c7275bca8f7..c5ba9c4757a8 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
@@ -319,7 +319,7 @@ static int xgpu_ai_mailbox_rcv_irq(struct amdgpu_device *adev,
 
 	switch (event) {
 		case IDH_FLR_NOTIFICATION:
-		if (amdgpu_sriov_runtime(adev) && !amdgpu_in_reset(adev))
+		if (amdgpu_sriov_runtime(adev))
 			WARN_ONCE(!amdgpu_reset_domain_schedule(adev->reset_domain,
 								&adev->virt.flr_work),
 				  "Failed to queue work! at %s",
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index aba00d961627..fa9d1b02f391 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -358,7 +358,7 @@ static int xgpu_nv_mailbox_rcv_irq(struct amdgpu_device *adev,
 
 	switch (event) {
 	case IDH_FLR_NOTIFICATION:
-		if (amdgpu_sriov_runtime(adev) && !amdgpu_in_reset(adev))
+		if (amdgpu_sriov_runtime(adev))
 			WARN_ONCE(!amdgpu_reset_domain_schedule(adev->reset_domain,
 				   &adev->virt.flr_work),
 				  "Failed to queue work! at %s",
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
index 59f53c743362..14a065516ae4 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
@@ -560,7 +560,7 @@ static int xgpu_vi_mailbox_rcv_irq(struct amdgpu_device *adev,
 		r = xgpu_vi_mailbox_rcv_msg(adev, IDH_FLR_NOTIFICATION);
 
 		/* only handle FLR_NOTIFY now */
-		if (!r && !amdgpu_in_reset(adev))
+		if (!r)
 			WARN_ONCE(!amdgpu_reset_domain_schedule(adev->reset_domain,
 								&adev->virt.flr_work),
 				  "Failed to queue work! at %s",
-- 
2.43.0



