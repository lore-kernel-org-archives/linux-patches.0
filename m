Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84F215956D;
	Mon, 29 Jan 2024 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548390; cv=none; b=pN9yFKxwLgB5PkF1EOxEd9+ULRsDPrC9F9Nh2q+zV1LpYNDs/ymHInBuXVL7cZaxEY9HTcLeI6B4EVLDTOGeRVmCm3e7tYNgazcsHIxp7CS4WlceBCiKh3A+cMs9f6cU102y9JyvkxDq4X/wP/WnmR2B/DX63S/jDSnTKonfDvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548390; c=relaxed/simple;
	bh=RST3cAKUq2wQ906JwjV52ODaAgp6rs1vcCjTvOmt9+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIikamXDvSFYJhNMo+iASL3npjZCF0AtNpz58Zo5EeCNSkrWLHKnHQXrHgcV3sqMYpdNdghjnNxWRR3fAPxipbGbwuOmo897l3vbx55NkfZndXIIfbacn5KSY4RTfpXlhDuc9l7EFq9yt7s/+8aiIJYkVLAT+Shjnlfd7b8ryko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzMGX1n5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzMGX1n5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C92C433F1;
	Mon, 29 Jan 2024 17:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548390;
	bh=RST3cAKUq2wQ906JwjV52ODaAgp6rs1vcCjTvOmt9+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzMGX1n59a6nmN8wEfpKIvyzIpQ1KFydXXkVDvhs9shCURcFT4TTXvkdXqjfdtR1G
	 sPWoa49S5eUvD7cQiuMj2g9cQTqh/S8nYfTsHB581/KV5NhO85LX1cxGRZLdb7FguM
	 fb46qE0GSixqyr0hkln9PMqnICAegBwdmjJPaDRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 140/185] drm/amdgpu/pm: Fix the power source flag error
Date: Mon, 29 Jan 2024 09:05:40 -0800
Message-ID: <20240129170003.088172598@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -731,16 +732,8 @@ static int smu_late_init(void *handle)
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
@@ -1467,10 +1467,12 @@ static int smu_v11_0_irq_process(struct
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
@@ -1415,10 +1415,12 @@ static int smu_v13_0_irq_process(struct
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


