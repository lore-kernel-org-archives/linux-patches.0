Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C86248BA1;
	Wed, 15 Jan 2025 10:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938236; cv=none; b=MZ6buOfFLldK5KsWN6jealYcLeKaPtZqXmJZhqCez9/Gnr9frhr/tLw8rBjt8FD0f8X5IvyL3yi0CuLtv12+w4mS2ISo4dOdG6N7q0997UYyLCrXUfHFMpZEcvWTc+0K5aLRpEOIpEelDM91JmxW22xezQVJmRRYvVr653bR1HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938236; c=relaxed/simple;
	bh=GMz60ypjJCNywqN6x/LakGf+vBbSQ5ZfRu1ALlEFoxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft5dz4bq+sdh8hgcSEyZxtrI9qHo/cPNCuGV5chjKJEJkF2IvJOioycjNFlFUBDEILh5hqyt/hGq+8QuQElS1547YilB+H0PVTyqZJt+sV+MwTwCyy/X9UlMmanDBtLf0PV8FDaHDdDjEe2flaYThsXGfVBOQECpkytNgYueMXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSGfdTxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSGfdTxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46749C4CEDF;
	Wed, 15 Jan 2025 10:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938236;
	bh=GMz60ypjJCNywqN6x/LakGf+vBbSQ5ZfRu1ALlEFoxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSGfdTxcq8L3J83NiLibveJGpyIxKUV1PxU8T1r8TLQAfeCxPDaCH4u2JCrw+23RI
	 3AinFqYmN4ABpiVyH+YWZ1cLLRpdvennYs/DlUUVvsYm/6D+aHI45IsUNBXbZQMe+q
	 NLHGO4WY0TdTdaYyBJdkoGO3Sm49oKoAMnyGWt1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Kun Liu <Kun.Liu2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 122/189] drm/amd/pm:  fix BUG: scheduling while atomic
Date: Wed, 15 Jan 2025 11:36:58 +0100
Message-ID: <20250115103611.321019972@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kun Liu <Kun.Liu2@amd.com>

commit 2a238b09bfd04e8155a7a323364bce1c38b28c0f upstream.

atomic scheduling will be triggered in interrupt handler for
AC/DC mode switch as following backtrace.
Call Trace:
 <IRQ>
 dump_stack_lvl
 __schedule_bug
 __schedule
 schedule
 schedule_preempt_disabled
 __mutex_lock
 smu_cmn_send_smc_msg_with_param
 smu_v13_0_irq_process
 amdgpu_irq_dispatch
 amdgpu_ih_process
 amdgpu_irq_handler
 __handle_irq_event_percpu
 handle_irq_event
 handle_edge_irq
 __common_interrupt
 common_interrupt
 </IRQ>
 <TASK>
 asm_common_interrupt

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Kun Liu <Kun.Liu2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 03cc84b102d1a832e8dfc59344346dedcebcdf42)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h         |    2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c       |   12 ++++++------
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    1 +
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -302,5 +302,7 @@ int smu_v13_0_set_wbrf_exclusion_ranges(
 int smu_v13_0_get_boot_freq_by_index(struct smu_context *smu,
 				     enum smu_clk_type clk_type,
 				     uint32_t *value);
+
+void smu_v13_0_interrupt_work(struct smu_context *smu);
 #endif
 #endif
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1320,11 +1320,11 @@ static int smu_v13_0_set_irq_state(struc
 	return 0;
 }
 
-static int smu_v13_0_ack_ac_dc_interrupt(struct smu_context *smu)
+void smu_v13_0_interrupt_work(struct smu_context *smu)
 {
-	return smu_cmn_send_smc_msg(smu,
-				    SMU_MSG_ReenableAcDcInterrupt,
-				    NULL);
+	smu_cmn_send_smc_msg(smu,
+			     SMU_MSG_ReenableAcDcInterrupt,
+			     NULL);
 }
 
 #define THM_11_0__SRCID__THM_DIG_THERM_L2H		0		/* ASIC_TEMP > CG_THERMAL_INT.DIG_THERM_INTH  */
@@ -1377,12 +1377,12 @@ static int smu_v13_0_irq_process(struct
 			switch (ctxid) {
 			case SMU_IH_INTERRUPT_CONTEXT_ID_AC:
 				dev_dbg(adev->dev, "Switched to AC mode!\n");
-				smu_v13_0_ack_ac_dc_interrupt(smu);
+				schedule_work(&smu->interrupt_work);
 				adev->pm.ac_power = true;
 				break;
 			case SMU_IH_INTERRUPT_CONTEXT_ID_DC:
 				dev_dbg(adev->dev, "Switched to DC mode!\n");
-				smu_v13_0_ack_ac_dc_interrupt(smu);
+				schedule_work(&smu->interrupt_work);
 				adev->pm.ac_power = false;
 				break;
 			case SMU_IH_INTERRUPT_CONTEXT_ID_THERMAL_THROTTLING:
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -3126,6 +3126,7 @@ static const struct pptable_funcs smu_v1
 	.is_asic_wbrf_supported = smu_v13_0_0_wbrf_support_check,
 	.enable_uclk_shadow = smu_v13_0_enable_uclk_shadow,
 	.set_wbrf_exclusion_ranges = smu_v13_0_set_wbrf_exclusion_ranges,
+	.interrupt_work = smu_v13_0_interrupt_work,
 };
 
 void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2704,6 +2704,7 @@ static const struct pptable_funcs smu_v1
 	.is_asic_wbrf_supported = smu_v13_0_7_wbrf_support_check,
 	.enable_uclk_shadow = smu_v13_0_enable_uclk_shadow,
 	.set_wbrf_exclusion_ranges = smu_v13_0_set_wbrf_exclusion_ranges,
+	.interrupt_work = smu_v13_0_interrupt_work,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)


