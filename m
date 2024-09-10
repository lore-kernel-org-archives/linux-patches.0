Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D9317C22F;
	Tue, 10 Sep 2024 09:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962111; cv=none; b=odoW+5GLofo/kPUtbd48e6ER/fdP6RnMLaPCANGF5jzmDndZSqyjUNrZKXmORjIy1bpDPeZnDhn7/KkCO13QptvoNKh0hxuk7sLTwP/Ezo4BiTpDFP9A2vk1zVlR7J47P4o/lqjgAZAVtN8EzCi7t3EXFCdRpvD9IU1GIE3DZao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962111; c=relaxed/simple;
	bh=HAECwACYruzgMeyMlVOwoBvXK5M/6h/Vz2QNUOYvcPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Alja6AdUDXkGNysxrVWGbFvfQoxpQ3z+B1GIYGXlNtKnof455mO0mRTuXs3a0BcTGEA3VRsYJjAq7eo9lKYHk2wvcy5cV4CF3mr/mBDk9ykztEskvcrGmaJiOYlqo1NUMH/EqrZovJKjBat1A019p4QrO/N3iMq6IkCp+Z4XJH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtnfRUYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtnfRUYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A2C4CEC6;
	Tue, 10 Sep 2024 09:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962110;
	bh=HAECwACYruzgMeyMlVOwoBvXK5M/6h/Vz2QNUOYvcPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtnfRUYmHqdzFs6rP8X0Iq+Sb5taZGFpe1KxP/eTykexf9brhfkE0jucehkuYd18A
	 QyX0GL0BGk5Czv+Hvx1ArV5MGmNey7kqPQlrTnTOkPqk8KxItC3JgtAvg4FmOkhkv1
	 i0fm+WmmuEr1weMqd/jCLK+t5hSL1Ql8rGntY0LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Emily Deng <Emily.Deng@amd.com>,
	Zhigang Luo <zhigang.luo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 281/375] drm/amdgpu: Fix amdgpu_device_reset_sriov retry logic
Date: Tue, 10 Sep 2024 11:31:18 +0200
Message-ID: <20240910092631.999564594@linuxfoundation.org>
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

[ Upstream commit 6e4aa08fa9c6c0c027fc86f242517c925d159393 ]

The retry loop for SRIOV reset have refcount and memory leak issue.
Depending on which function call fails it can potentially call
amdgpu_amdkfd_pre/post_reset different number of times and causes
kfd_locked count to be wrong. This will block all future attempts at
opening /dev/kfd. The retry loop also leakes resources by calling
amdgpu_virt_init_data_exchange multiple times without calling the
corresponding fini function.

Align with the bare-metal reset path which doesn't have these issues.
This means taking the amdgpu_amdkfd_pre/post_reset functions out of the
reset loop and calling amdgpu_device_pre_asic_reset each retry which
properly free the resources from previous try by calling
amdgpu_virt_fini_data_exchange.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Zhigang Luo <zhigang.luo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 47 ++++++++++------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index bd6f2aba0662..e66546df0bc1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5067,10 +5067,6 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 {
 	int r;
 	struct amdgpu_hive_info *hive = NULL;
-	int retry_limit = 0;
-
-retry:
-	amdgpu_amdkfd_pre_reset(adev);
 
 	if (test_bit(AMDGPU_HOST_FLR, &reset_context->flags)) {
 		clear_bit(AMDGPU_HOST_FLR, &reset_context->flags);
@@ -5090,7 +5086,7 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 	/* Resume IP prior to SMC */
 	r = amdgpu_device_ip_reinit_early_sriov(adev);
 	if (r)
-		goto error;
+		return r;
 
 	amdgpu_virt_init_data_exchange(adev);
 
@@ -5101,38 +5097,35 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 	/* now we are okay to resume SMC/CP/SDMA */
 	r = amdgpu_device_ip_reinit_late_sriov(adev);
 	if (r)
-		goto error;
+		return r;
 
 	hive = amdgpu_get_xgmi_hive(adev);
 	/* Update PSP FW topology after reset */
 	if (hive && adev->gmc.xgmi.num_physical_nodes > 1)
 		r = amdgpu_xgmi_update_topology(hive, adev);
-
 	if (hive)
 		amdgpu_put_xgmi_hive(hive);
+	if (r)
+		return r;
 
-	if (!r) {
-		r = amdgpu_ib_ring_tests(adev);
-
-		amdgpu_amdkfd_post_reset(adev);
-	}
+	r = amdgpu_ib_ring_tests(adev);
+	if (r)
+		return r;
 
-error:
-	if (!r && adev->virt.gim_feature & AMDGIM_FEATURE_GIM_FLR_VRAMLOST) {
+	if (adev->virt.gim_feature & AMDGIM_FEATURE_GIM_FLR_VRAMLOST) {
 		amdgpu_inc_vram_lost(adev);
 		r = amdgpu_device_recover_vram(adev);
 	}
-	amdgpu_virt_release_full_gpu(adev, true);
+	if (r)
+		return r;
 
-	if (AMDGPU_RETRY_SRIOV_RESET(r)) {
-		if (retry_limit < AMDGPU_MAX_RETRY_LIMIT) {
-			retry_limit++;
-			goto retry;
-		} else
-			DRM_ERROR("GPU reset retry is beyond the retry limit\n");
-	}
+	/* need to be called during full access so we can't do it later like
+	 * bare-metal does.
+	 */
+	amdgpu_amdkfd_post_reset(adev);
+	amdgpu_virt_release_full_gpu(adev, true);
 
-	return r;
+	return 0;
 }
 
 /**
@@ -5694,6 +5687,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	int i, r = 0;
 	bool need_emergency_restart = false;
 	bool audio_suspended = false;
+	int retry_limit = AMDGPU_MAX_RETRY_LIMIT;
 
 	/*
 	 * Special case: RAS triggered and full reset isn't supported
@@ -5775,8 +5769,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 
 		cancel_delayed_work_sync(&tmp_adev->delayed_init_work);
 
-		if (!amdgpu_sriov_vf(tmp_adev))
-			amdgpu_amdkfd_pre_reset(tmp_adev);
+		amdgpu_amdkfd_pre_reset(tmp_adev);
 
 		/*
 		 * Mark these ASICs to be reseted as untracked first
@@ -5835,6 +5828,10 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	/* Host driver will handle XGMI hive reset for SRIOV */
 	if (amdgpu_sriov_vf(adev)) {
 		r = amdgpu_device_reset_sriov(adev, reset_context);
+		if (AMDGPU_RETRY_SRIOV_RESET(r) && (retry_limit--) > 0) {
+			amdgpu_virt_release_full_gpu(adev, true);
+			goto retry;
+		}
 		if (r)
 			adev->asic_reset_res = r;
 
-- 
2.43.0



