Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C6B155730;
	Thu,  5 Sep 2024 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529593; cv=none; b=ANRd/cVddwRESulvoujfErkk0i45xMr1NPVmnZKbfZqFUSYZjLr4n/gYdF4dq7VuShqhyoEpqV1x/gb11r+UAty1kQnwpLC6NuCpl3qBITO1fiy1NEriV1SNm8tkwGq9mnPlPfaQ/cmIlaYqnsTSrP4V9x+YuVahAZg/8UQu65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529593; c=relaxed/simple;
	bh=8ybKEC97ns+3qvuldX909w2P8rl5WJgzqVb6HTOH208=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icQmosEAmbtObCW6Ac72PFidsq3LcDyd0XdQWN8KWYdHfEFX2CiFN9St6V5OUsJqLXKpscXV6huQLXI+LawZBI5k1UO85x6E3xtfinQ7ehhmfnb/92GxHm6C+/VwuIcUa0JSfwHQL58JXy2DGZuH3FDmYZjX2zBFgOzSSe8CBMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBnERAnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBnERAnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAADC4CEC3;
	Thu,  5 Sep 2024 09:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529593;
	bh=8ybKEC97ns+3qvuldX909w2P8rl5WJgzqVb6HTOH208=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBnERAnYCH2qKgAfy6NkNsFmWqkSZSY48M10FHM2fJQs98m3Xi7S1QtJDwVDw8N8r
	 7YGIT9ricq4fLLEvSEj68dnRSrbnUPcegSr3SPn0YCR89hxWBzn2mW4X0fi0TmCO2U
	 kvDn1VR51jALFNlhyLR8skqp6pTZOSlK0LCcIR3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/184] drm/amd/pm: fix uninitialized variable warnings for vangogh_ppt
Date: Thu,  5 Sep 2024 11:39:55 +0200
Message-ID: <20240905093735.444550889@linuxfoundation.org>
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

[ Upstream commit b2871de6961d24d421839fbfa4aa3008ec9170d5 ]

1. Fix a issue that using uninitialized mask to get the ultimate frequency.
2. Check return of smu_cmn_send_smc_msg_with_param to avoid using
uninitialized variable residency.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
index 379e44eb0019..22737b11b1bf 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -976,6 +976,18 @@ static int vangogh_get_dpm_ultimate_freq(struct smu_context *smu,
 		}
 	}
 	if (min) {
+		ret = vangogh_get_profiling_clk_mask(smu,
+						     AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK,
+						     NULL,
+						     NULL,
+						     &mclk_mask,
+						     &fclk_mask,
+						     &soc_mask);
+		if (ret)
+			goto failed;
+
+		vclk_mask = dclk_mask = 0;
+
 		switch (clk_type) {
 		case SMU_UCLK:
 		case SMU_MCLK:
@@ -2450,6 +2462,8 @@ static u32 vangogh_set_gfxoff_residency(struct smu_context *smu, bool start)
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_LogGfxOffResidency,
 					      start, &residency);
+	if (ret)
+		return ret;
 
 	if (!start)
 		adev->gfx.gfx_off_residency = residency;
-- 
2.43.0



