Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA7A18D65E;
	Thu,  5 Sep 2024 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529493; cv=none; b=NUuJ5ITzVsLPHJm0pQZXmn79szQca+g9St/LZsDdAzgeGH+1XgpE/O0SZHVIBpxDbrtPlRhDA8yh+G77MlEr3W5wKZPzXKD//qAKbWco+wtcEuk+vbUJyFuAFneoYz9l7ifxrHSuFRuJPP4ro/J9c614aqgorztZaPxHsj4USMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529493; c=relaxed/simple;
	bh=Ioi0dmqHvausUFQgxfpg/5k1Nr/ZMp0hOE5/A4ehtRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcVKMtTE/Wlwf3UZIRvhdtul7FEJIdTNaf16+HY/fihrrIPKjyYMWCOGh6IqHqKd1ihvuMpicdkE5JnsJlRSwVlyJYj+BzrrukvfZdp8DhdGYMfM79UgFrN0fRKsrVhZjEeyuevrXpctUNyzyXY0UisAYjgGyGWdELIJjrWSfTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGbdLQgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGbdLQgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C59C4CEC3;
	Thu,  5 Sep 2024 09:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529493;
	bh=Ioi0dmqHvausUFQgxfpg/5k1Nr/ZMp0hOE5/A4ehtRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGbdLQgvDjgT0ldOmDvLOh+XVClo8rB8Lb2TeYm5OWMZ7c65PpJVzz7tQXQ069UL+
	 V7LR7hN8KfaUr3upBT3tliS4HpNAxi2tGa5qhGp6lJWb+9e9viEGdBLgw0nfoOBsli
	 tWrw/byHjKjW/sQE3NzJYFomqD63BAXT4ZmZQmxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 050/184] drm/amd/pm: Fix negative array index read
Date: Thu,  5 Sep 2024 11:39:23 +0200
Message-ID: <20240905093734.197828731@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit c8c19ebf7c0b202a6a2d37a52ca112432723db5f ]

Avoid using the negative values
for clk_idex as an index into an array pptable->DpmDescriptor.

V2: fix clk_index return check (Tim Huang)

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   | 27 ++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 5a68d365967f..c06e0d6e3017 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -1219,19 +1219,22 @@ static int navi10_get_current_clk_freq_by_table(struct smu_context *smu,
 					   value);
 }
 
-static bool navi10_is_support_fine_grained_dpm(struct smu_context *smu, enum smu_clk_type clk_type)
+static int navi10_is_support_fine_grained_dpm(struct smu_context *smu, enum smu_clk_type clk_type)
 {
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 	DpmDescriptor_t *dpm_desc = NULL;
-	uint32_t clk_index = 0;
+	int clk_index = 0;
 
 	clk_index = smu_cmn_to_asic_specific_index(smu,
 						   CMN2ASIC_MAPPING_CLK,
 						   clk_type);
+	if (clk_index < 0)
+		return clk_index;
+
 	dpm_desc = &pptable->DpmDescriptor[clk_index];
 
 	/* 0 - Fine grained DPM, 1 - Discrete DPM */
-	return dpm_desc->SnapToDiscrete == 0;
+	return dpm_desc->SnapToDiscrete == 0 ? 1 : 0;
 }
 
 static inline bool navi10_od_feature_is_supported(struct smu_11_0_overdrive_table *od_table, enum SMU_11_0_ODFEATURE_CAP cap)
@@ -1287,7 +1290,11 @@ static int navi10_emit_clk_levels(struct smu_context *smu,
 		if (ret)
 			return ret;
 
-		if (!navi10_is_support_fine_grained_dpm(smu, clk_type)) {
+		ret = navi10_is_support_fine_grained_dpm(smu, clk_type);
+		if (ret < 0)
+			return ret;
+
+		if (!ret) {
 			for (i = 0; i < count; i++) {
 				ret = smu_v11_0_get_dpm_freq_by_index(smu,
 								      clk_type, i, &value);
@@ -1496,7 +1503,11 @@ static int navi10_print_clk_levels(struct smu_context *smu,
 		if (ret)
 			return size;
 
-		if (!navi10_is_support_fine_grained_dpm(smu, clk_type)) {
+		ret = navi10_is_support_fine_grained_dpm(smu, clk_type);
+		if (ret < 0)
+			return ret;
+
+		if (!ret) {
 			for (i = 0; i < count; i++) {
 				ret = smu_v11_0_get_dpm_freq_by_index(smu, clk_type, i, &value);
 				if (ret)
@@ -1665,7 +1676,11 @@ static int navi10_force_clk_levels(struct smu_context *smu,
 	case SMU_UCLK:
 	case SMU_FCLK:
 		/* There is only 2 levels for fine grained DPM */
-		if (navi10_is_support_fine_grained_dpm(smu, clk_type)) {
+		ret = navi10_is_support_fine_grained_dpm(smu, clk_type);
+		if (ret < 0)
+			return ret;
+
+		if (ret) {
 			soft_max_level = (soft_max_level >= 1 ? 1 : 0);
 			soft_min_level = (soft_min_level >= 1 ? 1 : 0);
 		}
-- 
2.43.0



