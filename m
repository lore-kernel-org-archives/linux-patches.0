Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE6115EABF;
	Mon, 29 Jan 2024 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548259; cv=none; b=h2W2nU8l+cZGbYvQa4F26dayLtmdMA0cr/zRcEQJ+wDXvSyI8UQ6vFQWIklBloZ4Ic6pcZP+gEn3ggg1oeVEnobuPOJDP5SIBFI/it6THvqtS5bu5GXYV1yhjyTmerA9s7DkPnUbi3iOxZHGHXCcY95Lz6bd07s+ea7AZYFv7dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548259; c=relaxed/simple;
	bh=7nLratZOi863MIo4VqkxNe82KkNMjCZCDLXIq0H4SRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLD+hNiCRY5kFptK4SbanGk8RKeF8KM6Z3K7CRN1UN9YXwUFQp3g/+/S01rQOtnRbp+pFoIwgh7qCKX5CYASSuDTM9CjeEc0nD3jN9o6rItmrBtOjaZjpYpMm2iOvj79egIrgs10es9IkSEaqruYgce30y+/WOJf0yu00OqzX5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwiYUtTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwiYUtTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4729BC433F1;
	Mon, 29 Jan 2024 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548259;
	bh=7nLratZOi863MIo4VqkxNe82KkNMjCZCDLXIq0H4SRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwiYUtTOiXakt1eE4VkyrK6xhvDP67hCVaQ6/LK5SH14xWQ6GJO3DP/mGlSJXykMh
	 Ug9fcwGmWrCloFYO204EeTV986cVZ9pCeufMY5EiWlIEuOvTJgQ2O+pj0ADhHkxp0a
	 7bnKj67OyECL3OMV7Od6rfW4RDtq+OJBtTwTAaSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 278/346] drm/amdgpu/pm: Fix the power source flag error
Date: Mon, 29 Jan 2024 09:05:09 -0800
Message-ID: <20240129170024.556307135@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -817,16 +818,8 @@ static int smu_late_init(void *handle)
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
 
 	if ((amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 1)) ||
 	    (amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 3)))
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1442,10 +1442,12 @@ static int smu_v11_0_irq_process(struct
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
@@ -1379,10 +1379,12 @@ static int smu_v13_0_irq_process(struct
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


