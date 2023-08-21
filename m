Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E9F1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA4C433C8;
	Mon, 21 Aug 2023 20:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648579;
	bh=CE46UrjLI89jK7OPIFEf+aCDPgDqvk+a44r8r6zt2hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjWmEPCgx/uV4BP2AMX4Jak7N8RMe1Nwe2dUnbiGde/ISI2NQWF5pt5VznmqEVy9/
	 hQEZz/NsYTrlqfx9N43EObqa/jvlDKF81Nv/MgNiyMMLFYfXA1AcRks5SiQ0FXKOYT
	 yPbW1DZhnAeWxJb/Ms9bYyI7Wj829jm5ZSEJGHls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 226/234] drm/amdgpu/pm: fix throttle_status for other than MP1 11.0.7
Date: Mon, 21 Aug 2023 21:43:09 +0200
Message-ID: <20230821194138.903792602@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Umio Yasuno <coelacanth_dream@protonmail.com>

commit 6a92761a86817ad15c9a562e2a809386237fae3e upstream.

Use the right metrics table version based on the firmware.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2720
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Umio Yasuno <coelacanth_dream@protonmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -588,7 +588,9 @@ err0_out:
 	return -ENOMEM;
 }
 
-static uint32_t sienna_cichlid_get_throttler_status_locked(struct smu_context *smu)
+static uint32_t sienna_cichlid_get_throttler_status_locked(struct smu_context *smu,
+							   bool use_metrics_v3,
+							   bool use_metrics_v2)
 {
 	struct smu_table_context *smu_table= &smu->smu_table;
 	SmuMetricsExternal_t *metrics_ext =
@@ -596,13 +598,11 @@ static uint32_t sienna_cichlid_get_throt
 	uint32_t throttler_status = 0;
 	int i;
 
-	if ((smu->adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-	     (smu->smc_fw_version >= 0x3A4900)) {
+	if (use_metrics_v3) {
 		for (i = 0; i < THROTTLER_COUNT; i++)
 			throttler_status |=
 				(metrics_ext->SmuMetrics_V3.ThrottlingPercentage[i] ? 1U << i : 0);
-	} else if ((smu->adev->ip_versions[MP1_HWIP][0] == IP_VERSION(11, 0, 7)) &&
-	     (smu->smc_fw_version >= 0x3A4300)) {
+	} else if (use_metrics_v2) {
 		for (i = 0; i < THROTTLER_COUNT; i++)
 			throttler_status |=
 				(metrics_ext->SmuMetrics_V2.ThrottlingPercentage[i] ? 1U << i : 0);
@@ -864,7 +864,7 @@ static int sienna_cichlid_get_smu_metric
 			metrics->TemperatureVrSoc) * SMU_TEMPERATURE_UNITS_PER_CENTIGRADES;
 		break;
 	case METRICS_THROTTLER_STATUS:
-		*value = sienna_cichlid_get_throttler_status_locked(smu);
+		*value = sienna_cichlid_get_throttler_status_locked(smu, use_metrics_v3, use_metrics_v2);
 		break;
 	case METRICS_CURR_FANSPEED:
 		*value = use_metrics_v3 ? metrics_v3->CurrFanSpeed :
@@ -4017,7 +4017,7 @@ static ssize_t sienna_cichlid_get_gpu_me
 	gpu_metrics->current_dclk1 = use_metrics_v3 ? metrics_v3->CurrClock[PPCLK_DCLK_1] :
 		use_metrics_v2 ? metrics_v2->CurrClock[PPCLK_DCLK_1] : metrics->CurrClock[PPCLK_DCLK_1];
 
-	gpu_metrics->throttle_status = sienna_cichlid_get_throttler_status_locked(smu);
+	gpu_metrics->throttle_status = sienna_cichlid_get_throttler_status_locked(smu, use_metrics_v3, use_metrics_v2);
 	gpu_metrics->indep_throttle_status =
 			smu_cmn_get_indep_throttler_status(gpu_metrics->throttle_status,
 							   sienna_cichlid_throttler_map);


