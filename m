Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8E62D0C62;
	Wed, 28 Jan 2026 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614556; cv=none; b=HK5ivfh5PlCoUb+tOZB11CJZjJ9hYElsdyrHpdVkDvgfnt8JIPuJCLMPk4tMLXItS9ujBkBEyS2uXAK7ldvpqBHOv4smjd7kYEbnYGrJ4CopqxyEQlJCwgtXyohZWpwqb7husH9ywhKT8nj2QQN9GEk7M+EzbTMrT6j8lVaXP8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614556; c=relaxed/simple;
	bh=jLK4cBd2G0swFuzUr0la9jXhgvlDjKRXvozuY23vdi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TN7jx/jjbZwSiMG77slUC18hzLBXUG+g5z1HI/8Dxp/EsZoHv1m8aiB3lTdSKzarzs5KfSbu08bRH3e5pIouigHT65x8nPvQxSCrYl821sb0zIV2cGDXcXIWF+mowXvg7GJENuZC0DHomgDMi6cocF6PR/9AFcqPdIdlR2DbkVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNbToHw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNbToHw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F75DC4CEF1;
	Wed, 28 Jan 2026 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614555;
	bh=jLK4cBd2G0swFuzUr0la9jXhgvlDjKRXvozuY23vdi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNbToHw7AFNMZzpzDHk+kvSoMhIPjO6IY2rRSFVFo6PDbTLQ6DhYSQPXw4Hofk6vD
	 Q7F2zYgSLblHBnkjpidjU6Yr+BMO9nFk94a8SRWzGZzwUk/0/RDgF1T3QgsK7hgszB
	 in/h7tpnOESBMWdo41yrbHTz2WtCNJggy69nxlxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/254] drm/amd/pm: Dont clear SI SMC table when setting power limit
Date: Wed, 28 Jan 2026 16:22:27 +0100
Message-ID: <20260128145350.959751384@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit d5077426e1a76d269e518e048bde2e9fc49b32ad ]

There is no reason to clear the SMC table.
We also don't need to recalculate the power limit then.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e214d626253f5b180db10dedab161b7caa41f5e9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index e5f68b2b8def3..e8ca74fc089b7 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -2257,8 +2257,6 @@ static int si_populate_smc_tdp_limits(struct amdgpu_device *adev,
 		if (scaling_factor == 0)
 			return -EINVAL;
 
-		memset(smc_table, 0, sizeof(SISLANDS_SMC_STATETABLE));
-
 		ret = si_calculate_adjusted_tdp_limits(adev,
 						       false, /* ??? */
 						       adev->pm.dpm.tdp_adjustment,
@@ -2312,16 +2310,8 @@ static int si_populate_smc_tdp_limits_2(struct amdgpu_device *adev,
 
 	if (ni_pi->enable_power_containment) {
 		SISLANDS_SMC_STATETABLE *smc_table = &si_pi->smc_statetable;
-		u32 scaling_factor = si_get_smc_power_scaling_factor(adev);
 		int ret;
 
-		memset(smc_table, 0, sizeof(SISLANDS_SMC_STATETABLE));
-
-		smc_table->dpm2Params.NearTDPLimit =
-			cpu_to_be32(si_scale_power_for_smc(adev->pm.dpm.near_tdp_limit_adjusted, scaling_factor) * 1000);
-		smc_table->dpm2Params.SafePowerLimit =
-			cpu_to_be32(si_scale_power_for_smc((adev->pm.dpm.near_tdp_limit_adjusted * SISLANDS_DPM2_TDP_SAFE_LIMIT_PERCENT) / 100, scaling_factor) * 1000);
-
 		ret = amdgpu_si_copy_bytes_to_smc(adev,
 						  (si_pi->state_table_start +
 						   offsetof(SISLANDS_SMC_STATETABLE, dpm2Params) +
-- 
2.51.0



