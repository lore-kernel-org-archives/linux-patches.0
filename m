Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBF316423;
	Tue, 27 Feb 2024 14:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042646; cv=none; b=CnGAWO0X80V54MoORWgvdfXW1bhPK4vLbE/YOUPzcFfQxZmStP5eGwAdwyFJ6t6TFyvqNGIr37uUs++C+a61hnAIcEutjX+fzsR6ZpozChIh2fNTwLiWwbib+U+qfZqPJHaOvyYH3splolQFAf9m2MYyh0QHevh14qi3DiN9sbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042646; c=relaxed/simple;
	bh=UE5fvXEGZYX+XrgjFtcMMEP9UXy1fXIxMj+1akei+WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiLlsqt50Z04meikfjRdi7Ov5XdJjalTATwDIgBQlkYHpHxBNNeRuKLbYDX1laanfGlDKGGSYsZurBGvoGB1qL0E1N0liDnX5UpX+6mI12ir7rHcpkoL04V/l5ksQFh9U0bOkzF2Mi9NGp6I96yfuHL7idMOt5Clt2o+VFxBwhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYIfBZFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYIfBZFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B694C433F1;
	Tue, 27 Feb 2024 14:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042646;
	bh=UE5fvXEGZYX+XrgjFtcMMEP9UXy1fXIxMj+1akei+WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYIfBZFLmGsjBOfZs2DSRYE7RTgb9Y+cD1bRLnUtnXAcWvamh6/TwRdMYfOxHUtQz
	 ln1LCSV1M0ThpUq0j1b7NZTvSHTSsqN9p50fYgdSZUjdq5h60QI9CdX8RWEct7ZX99
	 wRWu7sYR7X5mDzNT+nO7figvAMQxox/O8eH8Uf/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/245] drm/amdgpu: skip to program GFXDEC registers for suspend abort
Date: Tue, 27 Feb 2024 14:24:18 +0100
Message-ID: <20240227131617.515531837@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 93bafa32a6918154aa0caf9f66679a32c2431357 ]

In the suspend abort cases, the gfx power rail doesn't turn off so
some GFXDEC registers/CSB can't reset to default value and at this
moment reinitialize GFXDEC/CSB will result in an unexpected error.
So let skip those program sequence for the suspend abort case.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h     | 2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 2 ++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   | 8 ++++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 1f1e7966beb51..dbef22f56482e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1045,6 +1045,8 @@ struct amdgpu_device {
 	bool				in_s3;
 	bool				in_s4;
 	bool				in_s0ix;
+	/* indicate amdgpu suspension status */
+	bool				suspend_complete;
 
 	atomic_t 			in_gpu_reset;
 	enum pp_mp1_state               mp1_state;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index deae92fde3b88..57943e9008710 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2252,6 +2252,7 @@ static int amdgpu_pmops_suspend(struct device *dev)
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
+	adev->suspend_complete = false;
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
 	else
@@ -2264,6 +2265,7 @@ static int amdgpu_pmops_suspend_noirq(struct device *dev)
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
+	adev->suspend_complete = true;
 	if (amdgpu_acpi_should_gpu_reset(adev))
 		return amdgpu_asic_reset(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index de1fab165041f..fb37c0d4b35b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3268,6 +3268,14 @@ static int gfx_v9_0_cp_gfx_start(struct amdgpu_device *adev)
 
 	gfx_v9_0_cp_gfx_enable(adev, true);
 
+	/* Now only limit the quirk on the APU gfx9 series and already
+	 * confirmed that the APU gfx10/gfx11 needn't such update.
+	 */
+	if (adev->flags & AMD_IS_APU &&
+			adev->in_s3 && !adev->suspend_complete) {
+		DRM_INFO(" Will skip the CSB packet resubmit\n");
+		return 0;
+	}
 	r = amdgpu_ring_alloc(ring, gfx_v9_0_get_csb_size(adev) + 4 + 3);
 	if (r) {
 		DRM_ERROR("amdgpu: cp failed to lock ring (%d).\n", r);
-- 
2.43.0



