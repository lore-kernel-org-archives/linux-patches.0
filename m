Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B991522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB747C433C7;
	Sun,  9 Jul 2023 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901906;
	bh=CeWq2Sf9QMRyOiVTZyEMY9ZJsIy9IKrB/6j3O0b7qIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUzskdYxs7bAo5WvzuKl9SzfgIJimLDzXd3sv8Ss8v7IASgk5+1SrbFvjpRMiOCtu
	 ly//w+KfxNsXjLQC9qAEhmsU3CWgGj9Cm8woIup2KlChtZHhW6lE3l2sI8yDwm5dbt
	 THDtkzQCnIoBPB7DssiNyo0Oh0dPt9Dmv1v5CGjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Natalia Petrova <n.petrova@fintech.ru>
Subject: [PATCH 6.3 159/431] radeon: avoid double free in ci_dpm_init()
Date: Sun,  9 Jul 2023 13:11:47 +0200
Message-ID: <20230709111454.892443174@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 20c3dffdccbd494e0dd631d1660aeecbff6775f2 ]

Several calls to ci_dpm_fini() will attempt to free resources that
either have been freed before or haven't been allocated yet. This
may lead to undefined or dangerous behaviour.

For instance, if r600_parse_extended_power_table() fails, it might
call r600_free_extended_power_table() as will ci_dpm_fini() later
during error handling.

Fix this by only freeing pointers to objects previously allocated.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: cc8dbbb4f62a ("drm/radeon: add dpm support for CI dGPUs (v2)")
Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 8ef25ab305ae7..b8f4dac68d850 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -5517,6 +5517,7 @@ static int ci_parse_power_table(struct radeon_device *rdev)
 	u8 frev, crev;
 	u8 *power_state_offset;
 	struct ci_ps *ps;
+	int ret;
 
 	if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset))
@@ -5546,11 +5547,15 @@ static int ci_parse_power_table(struct radeon_device *rdev)
 		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
-		if (!rdev->pm.power_state[i].clock_info)
-			return -EINVAL;
+		if (!rdev->pm.power_state[i].clock_info) {
+			ret = -EINVAL;
+			goto err_free_ps;
+		}
 		ps = kzalloc(sizeof(struct ci_ps), GFP_KERNEL);
-		if (ps == NULL)
-			return -ENOMEM;
+		if (ps == NULL) {
+			ret = -ENOMEM;
+			goto err_free_ps;
+		}
 		rdev->pm.dpm.ps[i].ps_priv = ps;
 		ci_parse_pplib_non_clock_info(rdev, &rdev->pm.dpm.ps[i],
 					      non_clock_info,
@@ -5590,6 +5595,12 @@ static int ci_parse_power_table(struct radeon_device *rdev)
 	}
 
 	return 0;
+
+err_free_ps:
+	for (i = 0; i < rdev->pm.dpm.num_ps; i++)
+		kfree(rdev->pm.dpm.ps[i].ps_priv);
+	kfree(rdev->pm.dpm.ps);
+	return ret;
 }
 
 static int ci_get_vbios_boot_values(struct radeon_device *rdev,
@@ -5678,25 +5689,26 @@ int ci_dpm_init(struct radeon_device *rdev)
 
 	ret = ci_get_vbios_boot_values(rdev, &pi->vbios_boot_state);
 	if (ret) {
-		ci_dpm_fini(rdev);
+		kfree(rdev->pm.dpm.priv);
 		return ret;
 	}
 
 	ret = r600_get_platform_caps(rdev);
 	if (ret) {
-		ci_dpm_fini(rdev);
+		kfree(rdev->pm.dpm.priv);
 		return ret;
 	}
 
 	ret = r600_parse_extended_power_table(rdev);
 	if (ret) {
-		ci_dpm_fini(rdev);
+		kfree(rdev->pm.dpm.priv);
 		return ret;
 	}
 
 	ret = ci_parse_power_table(rdev);
 	if (ret) {
-		ci_dpm_fini(rdev);
+		kfree(rdev->pm.dpm.priv);
+		r600_free_extended_power_table(rdev);
 		return ret;
 	}
 
-- 
2.39.2



