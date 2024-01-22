Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F9A651A1;
	Tue, 23 Jan 2024 00:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971554; cv=none; b=mI5uBs+eiQDhE/KUYELGI9YKWdEWIi2Lv6MOu7uYCF1j5WBUPsh7GQLuPnZ3L4S4MmJEiTf9IwtFCLoCBzZ+2He9dWdeJSD//xV1KcF769SSKopPvP8z4TzmTNCncaGry5y35/GjweBcRaI6VViJuiQ0u23jFZdhU+lEcJGUBSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971554; c=relaxed/simple;
	bh=mMOyQomBlqu/VYgddwV515FyJ7v48h/CrDWMqCLwmj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrLZwKU7zebm1EbJxLgANRXVx9ta8d0pLRFv127DwAyBp5ezRepM1YfFGtSTlbWI2C4mnqsJDjBnR+3No6Bhzg2OSk8wsF5lc+iGMCIwh7v+oUyV5uVcPmkZLFumgw70bPg3MtV1z36ewFAvoBM9T8dB7D65nWXrH5iy+7Ar4U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5MQZVIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5MQZVIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19227C433C7;
	Tue, 23 Jan 2024 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971554;
	bh=mMOyQomBlqu/VYgddwV515FyJ7v48h/CrDWMqCLwmj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5MQZVIicgr3jbhlUAmynJSoCuVbyAxklSFRdaSxP2txh94oACKmxAbZuc/fvFzmM
	 RLuX5RIgJnzkp2gL/nuY9hdmk/mu1vOEKO9MiFktQJ5uPPvrB8NDmussGV/je+Xz/h
	 fULeSSI4XYC25ODmhYRe1x0uJuhgM2n54ZWwgnhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/286] drm/amd/pm: fix a double-free in si_dpm_init
Date: Mon, 22 Jan 2024 15:57:58 -0800
Message-ID: <20240122235738.796848771@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit ac16667237a82e2597e329eb9bc520d1cf9dff30 ]

When the allocation of
adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries fails,
amdgpu_free_extended_power_table is called to free some fields of adev.
However, when the control flow returns to si_dpm_sw_init, it goes to
label dpm_failed and calls si_dpm_fini, which calls
amdgpu_free_extended_power_table again and free those fields again. Thus
a double-free is triggered.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index d6544a6dabc7..6f0653c81f8f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -7349,10 +7349,9 @@ static int si_dpm_init(struct amdgpu_device *adev)
 		kcalloc(4,
 			sizeof(struct amdgpu_clock_voltage_dependency_entry),
 			GFP_KERNEL);
-	if (!adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries) {
-		amdgpu_free_extended_power_table(adev);
+	if (!adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries)
 		return -ENOMEM;
-	}
+
 	adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.count = 4;
 	adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries[0].clk = 0;
 	adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries[0].v = 0;
-- 
2.43.0



