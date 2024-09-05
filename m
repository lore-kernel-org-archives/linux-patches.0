Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E3F1494DB;
	Thu,  5 Sep 2024 10:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530523; cv=none; b=e2SUOj24re3OaH0euqbsflhyNT0ckMwgSknkEVOxjJdmfcXB4oKavE/nsm04wb4Q0u5XB38ze/FADJ+PuFaYb+UW0jfsadkoWQsNphJ1pFJ0Qz2kxkj+u8CCkgUesj3oyJDKkfNaYilq+JSyKR4zJjBSNIjYRJF4TacbjfxyJ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530523; c=relaxed/simple;
	bh=tNQTO+pgkN8b6DaReBcv+tTNMoB3lZRZ+nNJKa+nqAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlr+xYqqxRRbVPGf2/z0+QoirRD48oUrNTJRNQ4C8VWzLbttCEpxMq8Dztvdk6Uzf5o5L0jb6FqntYPabQK5agMRhJjPLs3CLQu2UwPJP5VWz+ynwqlX4M6L0ESl9jO/gxzw8GRn6l5CgUlM1+plBWDFjPX6KHdDaxZ98A+Rqcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfgIaVtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfgIaVtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B51C4CEC3;
	Thu,  5 Sep 2024 10:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530522;
	bh=tNQTO+pgkN8b6DaReBcv+tTNMoB3lZRZ+nNJKa+nqAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfgIaVtgO08C4SbOcKg3IwSEWwyw1z0TEmsIIf1LBJhxSD/yoSZsjgGtvSfrzBO0a
	 5zp7i5L8r5C8dKuvulSJkuaj6EQZg26IZx2r1vEOS+zmm+0E3dOqO81bWbgH2T8YwS
	 c/0dg9niEOU2tv59nJCiEOKJHCEpnZNxRJ9AsGPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/101] drm/amd/pm: fix uninitialized variable warnings for vangogh_ppt
Date: Thu,  5 Sep 2024 11:41:22 +0200
Message-ID: <20240905093718.094271644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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
index 1b731a9c92d9..c9c0aa6376e3 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -1003,6 +1003,18 @@ static int vangogh_get_dpm_ultimate_freq(struct smu_context *smu,
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
@@ -2363,6 +2375,8 @@ static u32 vangogh_set_gfxoff_residency(struct smu_context *smu, bool start)
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_LogGfxOffResidency,
 					      start, &residency);
+	if (ret)
+		return ret;
 
 	if (!start)
 		adev->gfx.gfx_off_residency = residency;
-- 
2.43.0



