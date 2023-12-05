Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B1E6FAF;
	Tue,  5 Dec 2023 03:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zG5r24QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF9EC433C7;
	Tue,  5 Dec 2023 03:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747002;
	bh=HT5Z33ryCMxFOmyfMXQU1KRXw7msm1uVhl/3ydDbVGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zG5r24QEjZgMfHo1KdA4sZQdRCbpOeO1WVF6Zb5SFmb+DK1uzQFll/sPa50ICER+6
	 9VBfDRLZqdZ/LLi/WRGihk08m9C/hDltOnL8srqYG3dxivdt4R6UaqRKBX7M/pvn6E
	 RyXmAK//5JXjVBO7ojLJX1VSnZNi4N1QYV4H14yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 023/107] drm/amd/display: Use DRAM speed from validation for dummy p-state
Date: Tue,  5 Dec 2023 12:15:58 +0900
Message-ID: <20231205031533.049326735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Alvin Lee <alvin.lee2@amd.com>

commit 9be601135ba8ac69880c01606c82140f2dde105e upstream.

[Description]
When choosing which dummy p-state latency to use, we
need to use the DRAM speed from validation. The DRAMSpeed
DML variable can change because we use different input
params to DML when populating watermarks set B.

Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Samson Tam <samson.tam@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1788,6 +1788,7 @@ void dcn32_calculate_wm_and_dlg_fpu(stru
 	int i, pipe_idx, vlevel_temp = 0;
 	double dcfclk = dcn3_2_soc.clock_limits[0].dcfclk_mhz;
 	double dcfclk_from_validation = context->bw_ctx.dml.vba.DCFCLKState[vlevel][context->bw_ctx.dml.vba.maxMpcComb];
+	double dram_speed_from_validation = context->bw_ctx.dml.vba.DRAMSpeed;
 	double dcfclk_from_fw_based_mclk_switching = dcfclk_from_validation;
 	bool pstate_en = context->bw_ctx.dml.vba.DRAMClockChangeSupport[vlevel][context->bw_ctx.dml.vba.maxMpcComb] !=
 			dm_dram_clock_change_unsupported;
@@ -1921,7 +1922,7 @@ void dcn32_calculate_wm_and_dlg_fpu(stru
 	}
 
 	if (dc->clk_mgr->bw_params->wm_table.nv_entries[WM_C].valid) {
-		min_dram_speed_mts = context->bw_ctx.dml.vba.DRAMSpeed;
+		min_dram_speed_mts = dram_speed_from_validation;
 		min_dram_speed_mts_margin = 160;
 
 		context->bw_ctx.dml.soc.dram_clock_change_latency_us =


