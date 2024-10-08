Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA8B1CCB32;
	Tue,  8 Oct 2024 12:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392069; cv=none; b=FBa7EigNAKDM67EuSaW6cIQXCxN7zVWshZ7/Cu3Ld+tXTQq/VejRpe2KQED4YqjLv75YVboVA8ocwPXVvpzZ7hL1Z0yjErdHvd/wrBptPqAZR9SSFzWwQyOabJbZepUOkbyzutBkaVKNsJeRW83ADLaKQmW2iWvHBIGHABd06jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392069; c=relaxed/simple;
	bh=snErhnoyEtzeBRFaUbaRqc0ifgp9skSFBpvMMvvrhpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlLu2bLyyEUOw9Q+D7mysQHJj55rHk13l+xAU/K39+eMKH2Jw7wNjXIJRZxCWcpiq9IK8qQhAALyDocGuozPAame3dv4WVSVKY3Oy1zguzE9mya7r3aT1SVRBY/KKS0yCQaP0lpyB93kXvuy+wm/456hWKrI9gtu/KQU5rnjw0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTn1d64y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTn1d64y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F45C4CEC7;
	Tue,  8 Oct 2024 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392069;
	bh=snErhnoyEtzeBRFaUbaRqc0ifgp9skSFBpvMMvvrhpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTn1d64yZTHSQL7nS5k/xua7PttXhaoGMAEXV2cWrspj7V1yOYFrZrfEyLiP9O2tR
	 QeiFf3OVTVfIEQUS/BJa4NH9jvIXCDKTzdopuJiZRQclwrnd19ZcnIVbmqWQURrP2L
	 //oQOORTDMou+Z84hDmffGAtJR8NVyFGzVwakzFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 276/558] drm/amdgpu: fix unchecked return value warning for amdgpu_atombios
Date: Tue,  8 Oct 2024 14:05:06 +0200
Message-ID: <20241008115713.191040195@linuxfoundation.org>
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

From: Tim Huang <tim.huang@amd.com>

[ Upstream commit 92549780e32718d64a6d08bbbb3c6fffecb541c7 ]

This resolves the unchecded return value warning reported by Coverity.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 35 ++++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 7dc102f0bc1d3..0c8975ac5af9e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1018,8 +1018,9 @@ int amdgpu_atombios_get_clock_dividers(struct amdgpu_device *adev,
 		if (clock_type == COMPUTE_ENGINE_PLL_PARAM) {
 			args.v3.ulClockParams = cpu_to_le32((clock_type << 24) | clock);
 
-			amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-				sizeof(args));
+			if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+			    index, (uint32_t *)&args, sizeof(args)))
+				return -EINVAL;
 
 			dividers->post_div = args.v3.ucPostDiv;
 			dividers->enable_post_div = (args.v3.ucCntlFlag &
@@ -1039,8 +1040,9 @@ int amdgpu_atombios_get_clock_dividers(struct amdgpu_device *adev,
 			if (strobe_mode)
 				args.v5.ucInputFlag = ATOM_PLL_INPUT_FLAG_PLL_STROBE_MODE_EN;
 
-			amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-				sizeof(args));
+			if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+			    index, (uint32_t *)&args, sizeof(args)))
+				return -EINVAL;
 
 			dividers->post_div = args.v5.ucPostDiv;
 			dividers->enable_post_div = (args.v5.ucCntlFlag &
@@ -1058,8 +1060,9 @@ int amdgpu_atombios_get_clock_dividers(struct amdgpu_device *adev,
 		/* fusion */
 		args.v4.ulClock = cpu_to_le32(clock);	/* 10 khz */
 
-		amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-			sizeof(args));
+		if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+		    index, (uint32_t *)&args, sizeof(args)))
+			return -EINVAL;
 
 		dividers->post_divider = dividers->post_div = args.v4.ucPostDiv;
 		dividers->real_clock = le32_to_cpu(args.v4.ulClock);
@@ -1070,8 +1073,9 @@ int amdgpu_atombios_get_clock_dividers(struct amdgpu_device *adev,
 		args.v6_in.ulClock.ulComputeClockFlag = clock_type;
 		args.v6_in.ulClock.ulClockFreq = cpu_to_le32(clock);	/* 10 khz */
 
-		amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-			sizeof(args));
+		if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+		    index, (uint32_t *)&args, sizeof(args)))
+			return -EINVAL;
 
 		dividers->whole_fb_div = le16_to_cpu(args.v6_out.ulFbDiv.usFbDiv);
 		dividers->frac_fb_div = le16_to_cpu(args.v6_out.ulFbDiv.usFbDivFrac);
@@ -1113,8 +1117,9 @@ int amdgpu_atombios_get_memory_pll_dividers(struct amdgpu_device *adev,
 			if (strobe_mode)
 				args.ucInputFlag |= MPLL_INPUT_FLAG_STROBE_MODE_EN;
 
-			amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-				sizeof(args));
+			if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+			    index, (uint32_t *)&args, sizeof(args)))
+				return -EINVAL;
 
 			mpll_param->clkfrac = le16_to_cpu(args.ulFbDiv.usFbDivFrac);
 			mpll_param->clkf = le16_to_cpu(args.ulFbDiv.usFbDiv);
@@ -1211,8 +1216,9 @@ int amdgpu_atombios_get_max_vddc(struct amdgpu_device *adev, u8 voltage_type,
 		args.v2.ucVoltageMode = 0;
 		args.v2.usVoltageLevel = 0;
 
-		amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-			sizeof(args));
+		if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+		    index, (uint32_t *)&args, sizeof(args)))
+			return -EINVAL;
 
 		*voltage = le16_to_cpu(args.v2.usVoltageLevel);
 		break;
@@ -1221,8 +1227,9 @@ int amdgpu_atombios_get_max_vddc(struct amdgpu_device *adev, u8 voltage_type,
 		args.v3.ucVoltageMode = ATOM_GET_VOLTAGE_LEVEL;
 		args.v3.usVoltageLevel = cpu_to_le16(voltage_id);
 
-		amdgpu_atom_execute_table(adev->mode_info.atom_context, index, (uint32_t *)&args,
-			sizeof(args));
+		if (amdgpu_atom_execute_table(adev->mode_info.atom_context,
+		    index, (uint32_t *)&args, sizeof(args)))
+			return -EINVAL;
 
 		*voltage = le16_to_cpu(args.v3.usVoltageLevel);
 		break;
-- 
2.43.0



