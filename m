Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116820F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708F6C433C8;
	Fri, 21 Jul 2023 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967181;
	bh=5SaG67XmFTXrKTZQScgKzqusmBoAXjU/NZCrO+LXlMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWRw0hjCzbaqA1asOPBw4XpaW94YTPyeuVnY9t5ucf0OBaa9YufmcfAdpV79Ti4k1
	 Z0wBGqP0s4/pXYRs7R15qzlKSDdg3Q5VhciHfLm4Y2FH3Q2vq8gSHFlqhuJgq15Fbq
	 Mt0tNhKZNqP0h+JF/tN29q2COpHphTsBHS+YszIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lyndonli <Lyndon.Li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 072/223] drm/amdgpu: add the fan abnormal detection feature
Date: Fri, 21 Jul 2023 18:05:25 +0200
Message-ID: <20230721160523.933546106@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: lyndonli <Lyndon.Li@amd.com>

commit ef5fca9f7294509ee5013af9e879edc5837c1d6c upstream.

Update the SW CTF limit from existing register
when there's a fan failure detected via SMU interrupt.

Signed-off-by: lyndonli <Lyndon.Li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h        |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c       |   28 +++++++++++++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    1 
 3 files changed, 30 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -168,6 +168,7 @@ struct smu_temperature_range {
 	int mem_crit_max;
 	int mem_emergency_max;
 	int software_shutdown_temp;
+	int software_shutdown_temp_offset;
 };
 
 struct smu_state_validation_block {
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1381,6 +1381,7 @@ static int smu_v13_0_irq_process(struct
 	 */
 	uint32_t ctxid = entry->src_data[0];
 	uint32_t data;
+	uint32_t high;
 
 	if (client_id == SOC15_IH_CLIENTID_THM) {
 		switch (src_id) {
@@ -1437,6 +1438,33 @@ static int smu_v13_0_irq_process(struct
 					schedule_work(&smu->throttling_logging_work);
 
 				break;
+			case 0x8:
+				high = smu->thermal_range.software_shutdown_temp +
+					smu->thermal_range.software_shutdown_temp_offset;
+				high = min(SMU_THERMAL_MAXIMUM_ALERT_TEMP, high);
+				dev_emerg(adev->dev, "Reduce soft CTF limit to %d (by an offset %d)\n",
+							high,
+							smu->thermal_range.software_shutdown_temp_offset);
+
+				data = RREG32_SOC15(THM, 0, regTHM_THERMAL_INT_CTRL);
+				data = REG_SET_FIELD(data, THM_THERMAL_INT_CTRL,
+							DIG_THERM_INTH,
+							(high & 0xff));
+				data = data & (~THM_THERMAL_INT_CTRL__THERM_TRIGGER_MASK_MASK);
+				WREG32_SOC15(THM, 0, regTHM_THERMAL_INT_CTRL, data);
+				break;
+			case 0x9:
+				high = min(SMU_THERMAL_MAXIMUM_ALERT_TEMP,
+					smu->thermal_range.software_shutdown_temp);
+				dev_emerg(adev->dev, "Recover soft CTF limit to %d\n", high);
+
+				data = RREG32_SOC15(THM, 0, regTHM_THERMAL_INT_CTRL);
+				data = REG_SET_FIELD(data, THM_THERMAL_INT_CTRL,
+							DIG_THERM_INTH,
+							(high & 0xff));
+				data = data & (~THM_THERMAL_INT_CTRL__THERM_TRIGGER_MASK_MASK);
+				WREG32_SOC15(THM, 0, regTHM_THERMAL_INT_CTRL, data);
+				break;
 			}
 		}
 	}
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1288,6 +1288,7 @@ static int smu_v13_0_7_get_thermal_tempe
 	range->mem_emergency_max = (pptable->SkuTable.TemperatureLimit[TEMP_MEM] + CTF_OFFSET_MEM)*
 		SMU_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	range->software_shutdown_temp = powerplay_table->software_shutdown_temp;
+	range->software_shutdown_temp_offset = pptable->SkuTable.FanAbnormalTempLimitOffset;
 
 	return 0;
 }


