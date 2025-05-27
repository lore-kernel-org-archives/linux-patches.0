Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A2842A9B;
	Tue, 27 May 2025 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367772; cv=none; b=jtCnjYMuOBXkv7yrXc8tl/CVnBS8daJ7A4/7mmyJdWmiDQNsLQySQtIaCk+gS0m2sGhqneFnwXBVxBW5EcFeX/Km0V2zNS/Wk0LczVYnuBaNlFmCUxziJeJqSPPMPxwCj9LBXvHazJao26hHSUnF4Qqa6Bo5u10pIT7aoQDKVoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367772; c=relaxed/simple;
	bh=2CyyaP5e0RcUQd0CVqae1m6RVAFAh+GYSGcNAcqqtic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acv39/ITywVxHb8R/FlmeaJzmKPfhX/foxqL+nxJI/Fp4Z4JZpw62XzXH+AkHCi1Yn5R6zh++68N5bJWEpqdat6vrEl60w1iGdDzp2ugK3hnIYX7XIJvs94DfSaToNEdB7gKDPR4hUn9YSVMHgI2JxmDnPv7E168A15D5OGYl+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV97H5Ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV97H5Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458CBC4CEE9;
	Tue, 27 May 2025 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367772;
	bh=2CyyaP5e0RcUQd0CVqae1m6RVAFAh+GYSGcNAcqqtic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kV97H5PhWYU+89HKUMVK7+TtnxYpwaNzD3Zl9FmuEpUBBQm2eD9pwSZpwJgS5uOXt
	 8Mpw3xlUIyfOO/8NyUa7ZxtG04ot6g/kZxjPcbgAKNA45hNc1Mmg33XjLbG9qb2DaQ
	 8lVlgFGXyNuXRbsYTk82BBfKNhhPnp4HiEe3BLmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiang Liu <gerry@linux.alibaba.com>,
	Shuo Liu <shuox.liu@linux.alibaba.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 495/783] amdgpu/soc15: enable asic reset for dGPU in case of suspend abort
Date: Tue, 27 May 2025 18:24:52 +0200
Message-ID: <20250527162533.293113463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <gerry@linux.alibaba.com>

[ Upstream commit 38e8ca3e4b6de1c6e49d0140264cfc8d314a5f70 ]

When GPU suspend is aborted, do the same for dGPU as APU to reset
soc15 asic. Otherwise it may cause following errors:
[  547.229463] amdgpu 0001:81:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring kiq_0.2.1.0 test failed (-110)

[  555.126827] amdgpu 0000:0a:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring kiq_0.2.1.0 test failed (-110)
[  555.126901] [drm:amdgpu_gfx_enable_kcq [amdgpu]] *ERROR* KCQ enable failed
[  555.126957] [drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <gfx_v9_4_3> failed -110
[  555.126959] amdgpu 0000:0a:00.0: amdgpu: amdgpu_device_ip_resume failed (-110).
[  555.126965] PM: dpm_run_callback(): pci_pm_resume+0x0/0xe0 returns -110
[  555.126966] PM: Device 0000:0a:00.0 failed to resume async: error -110

This fix has been tested on Mi308X.

Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Tested-by: Shuo Liu <shuox.liu@linux.alibaba.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/2462b4b12eb9d025e82525178d568cbaa4c223ff.1736739303.git.gerry@linux.alibaba.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index e98fb3fa36a88..6e09613de8cd2 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -604,12 +604,10 @@ soc15_asic_reset_method(struct amdgpu_device *adev)
 static bool soc15_need_reset_on_resume(struct amdgpu_device *adev)
 {
 	/* Will reset for the following suspend abort cases.
-	 * 1) Only reset on APU side, dGPU hasn't checked yet.
-	 * 2) S3 suspend aborted in the normal S3 suspend or
-	 *    performing pm core test.
+	 * 1) S3 suspend aborted in the normal S3 suspend
+	 * 2) S3 suspend aborted in performing pm core test.
 	 */
-	if (adev->flags & AMD_IS_APU && adev->in_s3 &&
-			!pm_resume_via_firmware())
+	if (adev->in_s3 && !pm_resume_via_firmware())
 		return true;
 	else
 		return false;
-- 
2.39.5



