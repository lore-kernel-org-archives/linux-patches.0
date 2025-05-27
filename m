Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734BB1DB34C;
	Tue, 27 May 2025 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366574; cv=none; b=SV66LuWiRDYhJriLULFNBIqBwlPf0hTZcIajOSBC4TpH0tQEe4ZntwsL22Dg6d9ArkpoCbDjWsmjDkGOBhbmr0RwjDjscC+acioXnrgRJ9opNxX/XNznrK3h2VNeZTxxgIyDYRXQPaLRHNXZvo6izqWdzWj0DM9xIh6nVbrX40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366574; c=relaxed/simple;
	bh=IH9buxP3hslGjLq2CojXVVz6eSMKH5/UNU16bybpoEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iexaoT3I2a5Ogun5UdfZZ+QoY8bYFNDG+C36grA5+jlAxiYfLR3gR3FQWIu5pL+NZ5vYF/DgpPsi7OnKzyNZ8Q478/gKF5PEa476RcixE/6img+vUAWbv0titKo74/aB20bRGiHDxUyEzoEvtyYJDPPf0rNZz8ACTpMF38EjAH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Egg+/fJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Egg+/fJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5089C4CEE9;
	Tue, 27 May 2025 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366574;
	bh=IH9buxP3hslGjLq2CojXVVz6eSMKH5/UNU16bybpoEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Egg+/fJwPAK8qEfxImMh0UhjZokQtJIGrWfjkKkitgA1JsIOQRzDHpdvJvXAAMsSi
	 MyQxbRysSjFxkEx41KCrkmIziySIZwSupCU6/4WNhkYipTfpnd4f1oNCdEhV3aXdJZ
	 qnsPMvVjeXwqZc7ho36NDe90m+fYG9z+R9XKa6aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Skvortsov <victor.skvortsov@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 111/783] drm/amdgpu: Skip pcie_replay_count sysfs creation for VF
Date: Tue, 27 May 2025 18:18:28 +0200
Message-ID: <20250527162517.670774216@linuxfoundation.org>
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

From: Victor Skvortsov <victor.skvortsov@amd.com>

[ Upstream commit 9c05636ca72a2dbf41bf0900380f438a0de47319 ]

VFs cannot read the NAK_COUNTER register. This information is only
available through PMFW metrics.

Signed-off-by: Victor Skvortsov <victor.skvortsov@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 27 ++++++++++++++++------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 726c4854e6296..c00a01c62724a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -224,6 +224,24 @@ static ssize_t amdgpu_device_get_pcie_replay_count(struct device *dev,
 static DEVICE_ATTR(pcie_replay_count, 0444,
 		amdgpu_device_get_pcie_replay_count, NULL);
 
+static int amdgpu_device_attr_sysfs_init(struct amdgpu_device *adev)
+{
+	int ret = 0;
+
+	if (!amdgpu_sriov_vf(adev))
+		ret = sysfs_create_file(&adev->dev->kobj,
+					&dev_attr_pcie_replay_count.attr);
+
+	return ret;
+}
+
+static void amdgpu_device_attr_sysfs_fini(struct amdgpu_device *adev)
+{
+	if (!amdgpu_sriov_vf(adev))
+		sysfs_remove_file(&adev->dev->kobj,
+				  &dev_attr_pcie_replay_count.attr);
+}
+
 static ssize_t amdgpu_sysfs_reg_state_get(struct file *f, struct kobject *kobj,
 					  struct bin_attribute *attr, char *buf,
 					  loff_t ppos, size_t count)
@@ -4123,11 +4141,6 @@ static bool amdgpu_device_check_iommu_remap(struct amdgpu_device *adev)
 }
 #endif
 
-static const struct attribute *amdgpu_dev_attributes[] = {
-	&dev_attr_pcie_replay_count.attr,
-	NULL
-};
-
 static void amdgpu_device_set_mcbp(struct amdgpu_device *adev)
 {
 	if (amdgpu_mcbp == 1)
@@ -4572,7 +4585,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	} else
 		adev->ucode_sysfs_en = true;
 
-	r = sysfs_create_files(&adev->dev->kobj, amdgpu_dev_attributes);
+	r = amdgpu_device_attr_sysfs_init(adev);
 	if (r)
 		dev_err(adev->dev, "Could not create amdgpu device attr\n");
 
@@ -4709,7 +4722,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 		amdgpu_pm_sysfs_fini(adev);
 	if (adev->ucode_sysfs_en)
 		amdgpu_ucode_sysfs_fini(adev);
-	sysfs_remove_files(&adev->dev->kobj, amdgpu_dev_attributes);
+	amdgpu_device_attr_sysfs_fini(adev);
 	amdgpu_fru_sysfs_fini(adev);
 
 	amdgpu_reg_state_sysfs_fini(adev);
-- 
2.39.5



