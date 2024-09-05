Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE6019882B;
	Thu,  5 Sep 2024 09:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529496; cv=none; b=czYYaxAJ5y4P6Rs2j35WwjrmHVbu4qOt+BhExS4d6iClem5LIzZEe62X7uU5cH9kFbIoMMRfKNuCeW/+PgPgFrOI+nOg1vscRtjN7+8Q/DPvBa/Xb3x57r+aMJdJTjglxkaMxgwt73vdfqe8GH9lkuZwxeecAgzEy71rtvV4wV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529496; c=relaxed/simple;
	bh=oLdyvYI/a8dsINqO3RVlcre8L8dWpqSxpPuQ/jqpqbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FERxDwYwbAQ6f+Ub0OjBTuQIVOdmjZ6B8q4jLbpqmoQlEYRukD42R9atxOtkU/mPnv+XzrcPf9LtFhqvYmw1ghcfdhysER8eTcHfmC8GobduCxglSxQUIKkI0AFm2KwQRjMOYQofVQv0/Pa2SEC0TA/lQfvgmsIESmLjShYTTWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0xIZPC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0xIZPC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E99C4CEC4;
	Thu,  5 Sep 2024 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529496;
	bh=oLdyvYI/a8dsINqO3RVlcre8L8dWpqSxpPuQ/jqpqbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0xIZPC9MyqUaH46uX6xVVny4IoF4QJ5pp3YBYlaNtcPGC+96UsAlDG+TgZdpSNg5
	 PtyBerQwC0EFdSgtBHxRgHzFAwUYzB/IrdAGixJVIyw4kP6CLdQXYTGHVSNmfySS73
	 iEanOh8Hhy7tERrOYv/EydP+zhpU6L2vTU960Bw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 051/184] drm/amd/pm: fix uninitialized variable warning for smu_v13
Date: Thu,  5 Sep 2024 11:39:24 +0200
Message-ID: <20240905093734.236275080@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 6e46b89f40e39e2054f2e179e8e8c3132e7a9d57 ]

Clear warning that using uninitialized variable when the dpm is
not enabled and reuse the code for SMU13 to get the boot frequency.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h  |  4 ++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c    | 55 +++++++++++++------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c  | 28 +---------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c  | 28 +---------
 .../drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c  | 28 +---------
 5 files changed, 51 insertions(+), 92 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index d9700a3f28d2..e58220a7ee2f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -298,5 +298,9 @@ int smu_v13_0_enable_uclk_shadow(struct smu_context *smu, bool enable);
 
 int smu_v13_0_set_wbrf_exclusion_ranges(struct smu_context *smu,
 						 struct freq_band_range *exclusion_ranges);
+
+int smu_v13_0_get_boot_freq_by_index(struct smu_context *smu,
+				     enum smu_clk_type clk_type,
+				     uint32_t *value);
 #endif
 #endif
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index b63ad9cb24bf..933fe93c8d1e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1559,22 +1559,9 @@ int smu_v13_0_get_dpm_ultimate_freq(struct smu_context *smu, enum smu_clk_type c
 	uint32_t clock_limit;
 
 	if (!smu_cmn_clk_dpm_is_enabled(smu, clk_type)) {
-		switch (clk_type) {
-		case SMU_MCLK:
-		case SMU_UCLK:
-			clock_limit = smu->smu_table.boot_values.uclk;
-			break;
-		case SMU_GFXCLK:
-		case SMU_SCLK:
-			clock_limit = smu->smu_table.boot_values.gfxclk;
-			break;
-		case SMU_SOCCLK:
-			clock_limit = smu->smu_table.boot_values.socclk;
-			break;
-		default:
-			clock_limit = 0;
-			break;
-		}
+		ret = smu_v13_0_get_boot_freq_by_index(smu, clk_type, &clock_limit);
+		if (ret)
+			return ret;
 
 		/* clock in Mhz unit */
 		if (min)
@@ -1894,6 +1881,40 @@ int smu_v13_0_set_power_source(struct smu_context *smu,
 					       NULL);
 }
 
+int smu_v13_0_get_boot_freq_by_index(struct smu_context *smu,
+				     enum smu_clk_type clk_type,
+				     uint32_t *value)
+{
+	int ret = 0;
+
+	switch (clk_type) {
+	case SMU_MCLK:
+	case SMU_UCLK:
+		*value = smu->smu_table.boot_values.uclk;
+		break;
+	case SMU_FCLK:
+		*value = smu->smu_table.boot_values.fclk;
+		break;
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		*value = smu->smu_table.boot_values.gfxclk;
+		break;
+	case SMU_SOCCLK:
+		*value = smu->smu_table.boot_values.socclk;
+		break;
+	case SMU_VCLK:
+		*value = smu->smu_table.boot_values.vclk;
+		break;
+	case SMU_DCLK:
+		*value = smu->smu_table.boot_values.dclk;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 int smu_v13_0_get_dpm_freq_by_index(struct smu_context *smu,
 				    enum smu_clk_type clk_type, uint16_t level,
 				    uint32_t *value)
@@ -1905,7 +1926,7 @@ int smu_v13_0_get_dpm_freq_by_index(struct smu_context *smu,
 		return -EINVAL;
 
 	if (!smu_cmn_clk_dpm_is_enabled(smu, clk_type))
-		return 0;
+		return smu_v13_0_get_boot_freq_by_index(smu, clk_type, value);
 
 	clk_id = smu_cmn_to_asic_specific_index(smu,
 						CMN2ASIC_MAPPING_CLK,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
index b6257f34a7c6..b081ae3e8f43 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -758,31 +758,9 @@ static int smu_v13_0_4_get_dpm_ultimate_freq(struct smu_context *smu,
 	int ret = 0;
 
 	if (!smu_v13_0_4_clk_dpm_is_enabled(smu, clk_type)) {
-		switch (clk_type) {
-		case SMU_MCLK:
-		case SMU_UCLK:
-			clock_limit = smu->smu_table.boot_values.uclk;
-			break;
-		case SMU_FCLK:
-			clock_limit = smu->smu_table.boot_values.fclk;
-			break;
-		case SMU_GFXCLK:
-		case SMU_SCLK:
-			clock_limit = smu->smu_table.boot_values.gfxclk;
-			break;
-		case SMU_SOCCLK:
-			clock_limit = smu->smu_table.boot_values.socclk;
-			break;
-		case SMU_VCLK:
-			clock_limit = smu->smu_table.boot_values.vclk;
-			break;
-		case SMU_DCLK:
-			clock_limit = smu->smu_table.boot_values.dclk;
-			break;
-		default:
-			clock_limit = 0;
-			break;
-		}
+		ret = smu_v13_0_get_boot_freq_by_index(smu, clk_type, &clock_limit);
+		if (ret)
+			return ret;
 
 		/* clock in Mhz unit */
 		if (min)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
index 218f209c3775..59854465d711 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
@@ -733,31 +733,9 @@ static int smu_v13_0_5_get_dpm_ultimate_freq(struct smu_context *smu,
 	int ret = 0;
 
 	if (!smu_v13_0_5_clk_dpm_is_enabled(smu, clk_type)) {
-		switch (clk_type) {
-		case SMU_MCLK:
-		case SMU_UCLK:
-			clock_limit = smu->smu_table.boot_values.uclk;
-			break;
-		case SMU_FCLK:
-			clock_limit = smu->smu_table.boot_values.fclk;
-			break;
-		case SMU_GFXCLK:
-		case SMU_SCLK:
-			clock_limit = smu->smu_table.boot_values.gfxclk;
-			break;
-		case SMU_SOCCLK:
-			clock_limit = smu->smu_table.boot_values.socclk;
-			break;
-		case SMU_VCLK:
-			clock_limit = smu->smu_table.boot_values.vclk;
-			break;
-		case SMU_DCLK:
-			clock_limit = smu->smu_table.boot_values.dclk;
-			break;
-		default:
-			clock_limit = 0;
-			break;
-		}
+		ret = smu_v13_0_get_boot_freq_by_index(smu, clk_type, &clock_limit);
+		if (ret)
+			return ret;
 
 		/* clock in Mhz unit */
 		if (min)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index d8bcf765a803..5917c88cc87d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -867,31 +867,9 @@ static int yellow_carp_get_dpm_ultimate_freq(struct smu_context *smu,
 	int ret = 0;
 
 	if (!yellow_carp_clk_dpm_is_enabled(smu, clk_type)) {
-		switch (clk_type) {
-		case SMU_MCLK:
-		case SMU_UCLK:
-			clock_limit = smu->smu_table.boot_values.uclk;
-			break;
-		case SMU_FCLK:
-			clock_limit = smu->smu_table.boot_values.fclk;
-			break;
-		case SMU_GFXCLK:
-		case SMU_SCLK:
-			clock_limit = smu->smu_table.boot_values.gfxclk;
-			break;
-		case SMU_SOCCLK:
-			clock_limit = smu->smu_table.boot_values.socclk;
-			break;
-		case SMU_VCLK:
-			clock_limit = smu->smu_table.boot_values.vclk;
-			break;
-		case SMU_DCLK:
-			clock_limit = smu->smu_table.boot_values.dclk;
-			break;
-		default:
-			clock_limit = 0;
-			break;
-		}
+		ret = smu_v13_0_get_boot_freq_by_index(smu, clk_type, &clock_limit);
+		if (ret)
+			return ret;
 
 		/* clock in Mhz unit */
 		if (min)
-- 
2.43.0



