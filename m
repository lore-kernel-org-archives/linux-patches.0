Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A450115B961;
	Mon, 29 Jan 2024 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548607; cv=none; b=OB4h/ayGYQoVkybvfJLUkxGTjzG9qnlmGPrzLeCkaFil/zAV0KLkvMxguUmBbGGRmdQBd4L55WqqGpm5wc6YQJBP7N7M0j+JWDI60Kwov8zh0+t/aquS6dhFSo6m2iP/qjrjbFf/NSYg0NGZG756bIZaZgWG24P31eDbhV8pK/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548607; c=relaxed/simple;
	bh=l4uyJO3Mjm1/BVQgDiv+4ld6vEC1v8t4A+VQcBl/vUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0Nandu/j3u8WGb91/hN0Plm9N5D3y16jeEt1kwVPFMmVdIkSoJtJPTlrFx5THKdy7LoGtH1D6wJQYkB5HYJrQ8R27LsAQbbEpZDXmCEEuJG7rByAfrBcficm2/I89/iJRXUNWRs0jBMVLCSMKFbAaol8Hb8IX2Qw7Jw5uc5BeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtNXl2c/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtNXl2c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7032BC433C7;
	Mon, 29 Jan 2024 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548607;
	bh=l4uyJO3Mjm1/BVQgDiv+4ld6vEC1v8t4A+VQcBl/vUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtNXl2c/2PIzWG4+68MkiL/bPM/YmwT8nyVN3qzUwOtMATQAR8bvUcZbUK+E9p2ui
	 nQbj+0X5BPXCMrJbRWW2smUN4AlR03HphodkR5lEXmsjokHJi5pOgL6DOnmYFHIe85
	 AGFxmaLQys2jVvddWrsJORBlalyBtF7b8e+SoVCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 271/331] drm/amdgpu/pm: Fix the power source flag error
Date: Mon, 29 Jan 2024 09:05:35 -0800
Message-ID: <20240129170022.796220002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

commit ca1ffb174f16b699c536734fc12a4162097c49f4 upstream.

The power source flag should be updated when
[1] System receives an interrupt indicating that the power source
has changed.
[2] System resumes from suspend or runtime suspend

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c      |   13 +++----------
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    2 ++
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -24,6 +24,7 @@
 
 #include <linux/firmware.h>
 #include <linux/pci.h>
+#include <linux/power_supply.h>
 #include <linux/reboot.h>
 
 #include "amdgpu.h"
@@ -741,16 +742,8 @@ static int smu_late_init(void *handle)
 	 * handle the switch automatically. Driver involvement
 	 * is unnecessary.
 	 */
-	if (!smu->dc_controlled_by_gpio) {
-		ret = smu_set_power_source(smu,
-					   adev->pm.ac_power ? SMU_POWER_SOURCE_AC :
-					   SMU_POWER_SOURCE_DC);
-		if (ret) {
-			dev_err(adev->dev, "Failed to switch to %s mode!\n",
-				adev->pm.ac_power ? "AC" : "DC");
-			return ret;
-		}
-	}
+	adev->pm.ac_power = power_supply_is_system_supplied() > 0;
+	smu_set_ac_dc(smu);
 
 	if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 1)) ||
 	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 3)))
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1441,10 +1441,12 @@ static int smu_v11_0_irq_process(struct
 			case 0x3:
 				dev_dbg(adev->dev, "Switched to AC mode!\n");
 				schedule_work(&smu->interrupt_work);
+				adev->pm.ac_power = true;
 				break;
 			case 0x4:
 				dev_dbg(adev->dev, "Switched to DC mode!\n");
 				schedule_work(&smu->interrupt_work);
+				adev->pm.ac_power = false;
 				break;
 			case 0x7:
 				/*
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1377,10 +1377,12 @@ static int smu_v13_0_irq_process(struct
 			case 0x3:
 				dev_dbg(adev->dev, "Switched to AC mode!\n");
 				smu_v13_0_ack_ac_dc_interrupt(smu);
+				adev->pm.ac_power = true;
 				break;
 			case 0x4:
 				dev_dbg(adev->dev, "Switched to DC mode!\n");
 				smu_v13_0_ack_ac_dc_interrupt(smu);
+				adev->pm.ac_power = false;
 				break;
 			case 0x7:
 				/*


