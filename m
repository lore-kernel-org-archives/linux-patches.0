Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BAA168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD40C433EF;
	Mon,  8 May 2023 10:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541499;
	bh=9fFe8D1QCN+799LQY6Cq6tO7JAGOyOPweKsodJn8+/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1MD+LI/SWNtRvGavzu4/Qhmyi0lmGCPFAoGI8sDsQjYvqJmTr1OtvNTquYYiF/xB
	 Tf5igqKrmfyIcE5Zory25e3TVLN7sO66wJ+3GGB/BECD3e7B0cFq9DUnL7dETWGb4m
	 K/LmFNwLzva6RPwl4ofHHKJLWkp5Q4PfB9QXW9vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 100/663] drm/amd/pm: re-enable the gfx imu when smu resume
Date: Mon,  8 May 2023 11:38:46 +0200
Message-Id: <20230508094431.703018559@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit f7f28f268b861c29dd18086bb636abedf0ff59ff upstream.

If the gfx imu is poweroff when suspend, then
it need to be re-enabled when resume.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   40 +++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -161,10 +161,15 @@ int smu_get_dpm_freq_range(struct smu_co
 
 int smu_set_gfx_power_up_by_imu(struct smu_context *smu)
 {
-	if (!smu->ppt_funcs || !smu->ppt_funcs->set_gfx_power_up_by_imu)
-		return -EOPNOTSUPP;
+	int ret = 0;
+	struct amdgpu_device *adev = smu->adev;
 
-	return smu->ppt_funcs->set_gfx_power_up_by_imu(smu);
+	if (smu->ppt_funcs->set_gfx_power_up_by_imu) {
+		ret = smu->ppt_funcs->set_gfx_power_up_by_imu(smu);
+		if (ret)
+			dev_err(adev->dev, "Failed to enable gfx imu!\n");
+	}
+	return ret;
 }
 
 static u32 smu_get_mclk(void *handle, bool low)
@@ -195,6 +200,19 @@ static u32 smu_get_sclk(void *handle, bo
 	return clk_freq * 100;
 }
 
+static int smu_set_gfx_imu_enable(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->firmware.load_type != AMDGPU_FW_LOAD_PSP)
+		return 0;
+
+	if (amdgpu_in_reset(smu->adev) || adev->in_s0ix)
+		return 0;
+
+	return smu_set_gfx_power_up_by_imu(smu);
+}
+
 static int smu_dpm_set_vcn_enable(struct smu_context *smu,
 				  bool enable)
 {
@@ -1386,15 +1404,9 @@ static int smu_hw_init(void *handle)
 	}
 
 	if (smu->is_apu) {
-		if ((smu->ppt_funcs->set_gfx_power_up_by_imu) &&
-				likely(adev->firmware.load_type == AMDGPU_FW_LOAD_PSP)) {
-			ret = smu->ppt_funcs->set_gfx_power_up_by_imu(smu);
-			if (ret) {
-				dev_err(adev->dev, "Failed to Enable gfx imu!\n");
-				return ret;
-			}
-		}
-
+		ret = smu_set_gfx_imu_enable(smu);
+		if (ret)
+			return ret;
 		smu_dpm_set_vcn_enable(smu, true);
 		smu_dpm_set_jpeg_enable(smu, true);
 		smu_set_gfx_cgpg(smu, true);
@@ -1671,6 +1683,10 @@ static int smu_resume(void *handle)
 		return ret;
 	}
 
+	ret = smu_set_gfx_imu_enable(smu);
+	if (ret)
+		return ret;
+
 	smu_set_gfx_cgpg(smu, true);
 
 	smu->disable_uclk_switch = 0;


