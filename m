Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE1221F17;
	Wed,  4 Feb 2026 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216415; cv=none; b=ut9yObsE29/stoQ2vfmJNIj/O+ByMOgvU3/I9Je1+EJOcRqXOCrveDTXY1o6LwkR0FqH/eyZf7/BGDAcHKued3Z4p+9KvPc17VbKB9wdpLIGxBm+He9D0fosGMxdSaPhYywvPXjLT/19L81Sy589nz2UWSAhm8rnfXYbN0dIlHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216415; c=relaxed/simple;
	bh=wdkZlToF3aUxtfur6Hy4S8EOyyAHBLTc4ownTmYlQnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zeg/iMZgu0/TtKWdxLy6PRp2tVVtHBXm0Nu0TM82XMnWqYwLQaMBzDkLIstRxzyFwmNi/Bh0FPPMmv6Y8VsZxkL4n8+uUI9Na5dmt4EB6dnfPhWkKiH+T6VCUTcCdRPkYKwshU7LkMKKrFKRTAhGV3ytVR0SvypzA3cUockISHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c75xSKTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c75xSKTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B7C4CEF7;
	Wed,  4 Feb 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216415;
	bh=wdkZlToF3aUxtfur6Hy4S8EOyyAHBLTc4ownTmYlQnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c75xSKTY0T9UtqHcQSGUXbeQ2sw07s4d8um0dXtAr23DcwKBrELQ+IWssHho46rwT
	 j/isHJfmv5O88iHZqyfEWXmKU75skSvIFG7piwHrTV09nCImYW46sfrgXlPxOHMv/y
	 kTatz5TPZC05PbP/kjjaETnyl4huZ5GLj9rAv/mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/161] drm/amd/pm: Dont clear SI SMC table when setting power limit
Date: Wed,  4 Feb 2026 15:39:04 +0100
Message-ID: <20260204143854.664308026@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index 6f0653c81f8fb..0238b91d95e7e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -2242,8 +2242,6 @@ static int si_populate_smc_tdp_limits(struct amdgpu_device *adev,
 		if (scaling_factor == 0)
 			return -EINVAL;
 
-		memset(smc_table, 0, sizeof(SISLANDS_SMC_STATETABLE));
-
 		ret = si_calculate_adjusted_tdp_limits(adev,
 						       false, /* ??? */
 						       adev->pm.dpm.tdp_adjustment,
@@ -2297,16 +2295,8 @@ static int si_populate_smc_tdp_limits_2(struct amdgpu_device *adev,
 
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



