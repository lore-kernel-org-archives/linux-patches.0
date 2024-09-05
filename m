Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB7C194A64;
	Thu,  5 Sep 2024 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530237; cv=none; b=pae/NeN3InsJHbr9gtlO2pXWiR3gHOxlDnt4AWZ/deIWWKHrpin8yrLQdSwr50gEHyluRf/NnWx22Da0mtd+9G4I22vuOH7X+h1Mif6fjzfLlsyBhJPL7+7eTToSgwvc4nIsRLmziD1cNteGmzcgBKpQi7f8XKpwp2uR3tzFAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530237; c=relaxed/simple;
	bh=n+EUU+hMx23uBHGZqJ0WKc9lZDuzqf1tM0fmw5ADNGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU3DqQh7V4DdEHO0lzHpKpZP7UpMQdBUP/FyIiLXEBPYd4QRyzPtMSVAF9v9ug3bJmLhzZad8E2eT1FNNPgkb7rIVfvAKZZmmJi4eF6RYtLc5wHDuTE7rK0TbW+SqVSUX1fEbM1AnrjeRQyA/GjF9PmO/WjU+rJ2pYBoU27BGug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E8b26gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E8b26gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FEDC4CEC3;
	Thu,  5 Sep 2024 09:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530237;
	bh=n+EUU+hMx23uBHGZqJ0WKc9lZDuzqf1tM0fmw5ADNGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1E8b26gRt9+/07KJvxiIRyuE34rsoPjNQydUgyG3Et6wbYZbT1lG5lJHPCfN/4/ID
	 WhszTpq8YBOMYvChmYUQMEdmNeSgJHSA+1RBF1vhFAJc3ttlMEFbt4Racg4Errtn+u
	 N7JTFldPWyam7M7U5zt7bIJujSuIoNAuR+wK4Qis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/132] drm/amd/pm: fix uninitialized variable warnings for vangogh_ppt
Date: Thu,  5 Sep 2024 11:40:52 +0200
Message-ID: <20240905093724.786291072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 201cec599842..f46cda889483 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -1009,6 +1009,18 @@ static int vangogh_get_dpm_ultimate_freq(struct smu_context *smu,
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
@@ -2481,6 +2493,8 @@ static u32 vangogh_set_gfxoff_residency(struct smu_context *smu, bool start)
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_LogGfxOffResidency,
 					      start, &residency);
+	if (ret)
+		return ret;
 
 	if (!start)
 		adev->gfx.gfx_off_residency = residency;
-- 
2.43.0



