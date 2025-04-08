Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56352268FE9;
	Tue,  8 Apr 2025 11:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110218; cv=none; b=KWvBG538vsDt7lgNppnSf9E86XJcMXJ4YS6INkzkeE4PohNJqTmjUrd6RTRNL/jRbdhLqT8KgfVp1L2BRjxE3l8DBJomgAH9cwoSI0gprI0SkPr1EWn1iT6Yk6wZ4oWcihcQE86uHA0llD2bQ4pHaF1l8h+SWzQseyyp/+P07Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110218; c=relaxed/simple;
	bh=aaz9YXeODtWVgFGuKIgTD6nDX9HSWJ6rOqJPEAN1I6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz67O+Fz1nJKYiSdsKiLYIZaZbvok7LjBzt+OKAR9EIcsNKsoibqqpX4OMAiXvcSnH6dqESjkKw05vuDU9w9wqsyhxQGJvBCI0Hn8Pwcu3uupiMG89MG0ffiRyt7hL3tZAUtNHiqrpa0zEylc8ZvuFFOGT1Jsj9VIrxkGUcfRcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8IHISAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8IHISAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB96C4CEE5;
	Tue,  8 Apr 2025 11:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110217;
	bh=aaz9YXeODtWVgFGuKIgTD6nDX9HSWJ6rOqJPEAN1I6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8IHISAtSmG0WW3NaAEaxR0zqmpBjXk3pdu9+3BeULvsgX1ySlgU5owV8wyVq13pO
	 posebgHSGby6t3U/Cu4UYXGZb0iz8KFB9iWM8rEeeV9jppshgB5dUg3w8HsdRIrxvj
	 ZlHVVtZJZFkNh/D5ENTGtYumndXpX+Q6uXwZU+3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 209/227] drm/amd/pm: Fix negative array index read
Date: Tue,  8 Apr 2025 12:49:47 +0200
Message-ID: <20250408104826.583718298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

commit c8c19ebf7c0b202a6a2d37a52ca112432723db5f upstream.

Avoid using the negative values
for clk_idex as an index into an array pptable->DpmDescriptor.

V2: fix clk_index return check (Tim Huang)

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -900,19 +900,22 @@ static int navi10_get_current_clk_freq_b
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
-	return dpm_desc->SnapToDiscrete == 0 ? true : false;
+	return dpm_desc->SnapToDiscrete == 0 ? 1 : 0;
 }
 
 static inline bool navi10_od_feature_is_supported(struct smu_11_0_overdrive_table *od_table, enum SMU_11_0_ODFEATURE_CAP cap)
@@ -964,7 +967,11 @@ static int navi10_print_clk_levels(struc
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
@@ -1127,7 +1134,11 @@ static int navi10_force_clk_levels(struc
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


