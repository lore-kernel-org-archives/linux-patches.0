Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DED23C6;
	Tue, 23 Jan 2024 00:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969568; cv=none; b=ZIQJAPZR2MoNCuHnkIQ91MU0ZbFeir3I1Zbz670WUy3ZOaOFjsN4W7hakcIAtGFWhgtWnIFNIL9huzWuQCyRFmomZAMXieyprVLmcTWTs3t4gFrSk/DrqHeFmw/BVDn69aM3pCY8mRHweCKBsdoNMVYSFHsqZzT3TrSzn22f2D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969568; c=relaxed/simple;
	bh=J0NgGju+HTDbOMGuWiiQo89hrEARs/PkXBMfXQxeAiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj/NrxJ0gHXhOe/8X1PS/fnf5Qp6qKUkBP0e4r8A9THnk/HJV3qbOGF7t4BUCeJa2b7siYQ6SSaWW0oquTzslsYGlJPzQL7D+Nn9NcZYU2QNqIZYENkzqKxP/i8Xe1s0MJ39+K2+Bh0UYZAfM/eRdcPprJjH7eWs7ey0lFym9J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3GVqrdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3GVqrdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65A7C433F1;
	Tue, 23 Jan 2024 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969567;
	bh=J0NgGju+HTDbOMGuWiiQo89hrEARs/PkXBMfXQxeAiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3GVqrdX5I1iqKwmQvG/DkJzsZ9J21FK6aRc5zAY0b7LjiBoqpy1NmHYKKyryGxmF
	 dMzL5oiJftRpmWxS1mTeI5beo16D0ZMGwha0U3cTyzhVQ29MZxkVRx8cWKIu3wByUD
	 ix/AxKVJxM4EhyktbJxnzgoF6v4RQcGNUr6AnauE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 328/641] drm/amd/pm: fix a double-free in si_dpm_init
Date: Mon, 22 Jan 2024 15:53:52 -0800
Message-ID: <20240122235828.153657911@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index fc8e4ac6c8e7..df4f20293c16 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7379,10 +7379,9 @@ static int si_dpm_init(struct amdgpu_device *adev)
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



