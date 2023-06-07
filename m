Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC7634CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AD7C433EF;
	Wed,  7 Jun 2023 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170656;
	bh=IL+PEPVVOt2jVGgMNqpVMeHduNdVQhJHTJaw5rYWAto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXYByzIONPrTX63QPCs8TG38kzdFoxHbpfbR7pmNUs589OJQR5lLSqDbmrjdxF9Zh
	 F1MBd2ZVwS6uk3A67GdY0HJxk5Dbw2CdJDcIs6Jz37tsm6hCPU9KON/klpJk1z8Pkg
	 x5jUDQxjfSGBc5FVL1xHlWbDO3fn3+dkMzDw81uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 168/225] drm/amd/pm: reverse mclk clocks levels for SMU v13.0.5
Date: Wed,  7 Jun 2023 22:16:01 +0200
Message-ID: <20230607200919.891822111@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <Tim.Huang@amd.com>

commit c1d35412b3e826ae8119e3fb5f51dd0fa5b6b567 upstream.

This patch reverses the DPM clocks levels output of pp_dpm_mclk.

On dGPUs and older APUs we expose the levels from lowest clocks
to highest clocks. But for some APUs, the clocks levels that from
the DFPstateTable are given the reversed orders by PMFW. Like the
memory DPM clocks that are exposed by pp_dpm_mclk.

It's not intuitive that they are reversed on these APUs. All tools
and software that talks to the driver then has to know different ways
to interpret the data depending on the asic.

So we need to reverse them to expose the clocks levels from the
driver consistently.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
@@ -866,7 +866,7 @@ out:
 static int smu_v13_0_5_print_clk_levels(struct smu_context *smu,
 				enum smu_clk_type clk_type, char *buf)
 {
-	int i, size = 0, ret = 0;
+	int i, idx, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	uint32_t min = 0, max = 0;
 
@@ -898,7 +898,8 @@ static int smu_v13_0_5_print_clk_levels(
 			goto print_clk_out;
 
 		for (i = 0; i < count; i++) {
-			ret = smu_v13_0_5_get_dpm_freq_by_index(smu, clk_type, i, &value);
+			idx = (clk_type == SMU_MCLK) ? (count - i - 1) : i;
+			ret = smu_v13_0_5_get_dpm_freq_by_index(smu, clk_type, idx, &value);
 			if (ret)
 				goto print_clk_out;
 


