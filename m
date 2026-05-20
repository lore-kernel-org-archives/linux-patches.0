Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB5A331220;
	Wed, 20 May 2026 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300516; cv=none; b=S/BRIsgjsnRAEnd7qM5Wx3A6KJTlkGH38ohRzZHmHXeJwmX5WoJ1xyPmiKKfGyTs+A5jyxO7LFtOnu67L1+3Mua7omFFjb4cnI7pF8U7uTUH3fQB7E1DCMDruxIVi3H644ybCs7nc5hl9xjtyUbpeP9ChLkXp0qa9utfeKqM8rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300516; c=relaxed/simple;
	bh=gRAoZgg+9ehYbfX8tGwWa4fYcDBUcfMMTcKxkj9sHZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3mGtzr1r7/QhEN5nkBgs02SgOLMbItJvGsPfg/APTQn7O1cXep3c8gAsskPg/yRHqIH4Lu+x8VyG+kTb+RvanD+rAm31w9T3NUzQI/monoy5AAda0lTCmulA6azB+ZcjSd5fYdLhEn40KLaK1yA/0NCGw8ZTbNy8E5XdTK+2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jtpswizl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jtpswizl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0071F000E9;
	Wed, 20 May 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300514;
	bh=iUlYmPYLsSMXlIacNqi8/yDbENPDd2nBtxEESENmfBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jtpswizl85D+woESZlRZ9xVQFbMKBf699ciMrau2ykee3IrP1jXonxoo1eYF5E2ZN
	 HPgON+C9/tIN8e1IgpTPs91q3j30nbZFPjcXjSBVljGIkpIm+uJWdNaDSV8CXoSRbt
	 zS4a5CeTgnZXFlaJlqpV7D/Pk5RFCColGlpfprJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/666] drm/msm/dpu: fix mismatch between power and frequency
Date: Wed, 20 May 2026 18:16:18 +0200
Message-ID: <20260520162114.825959582@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>

[ Upstream commit bc1dccc518cc5ab5140fba06c27e7188e0ed342b ]

During DPU runtime suspend, calling dev_pm_opp_set_rate(dev, 0) drops
the MMCX rail to MIN_SVS while the core clock frequency remains at its
original (highest) rate. When runtime resume re-enables the clock, this
may result in a mismatch between the rail voltage and the clock rate.

For example, in the DPU bind path, the sequence could be:
  cpu0: dev_sync_state -> rpmhpd_sync_state
  cpu1:                                     dpu_kms_hw_init
timeline 0 ------------------------------------------------> t

After rpmhpd_sync_state, the voltage performance is no longer guaranteed
to stay at the highest level. During dpu_kms_hw_init, calling
dev_pm_opp_set_rate(dev, 0) drops the voltage, causing the MMCX rail to
fall to MIN_SVS while the core clock is still at its maximum frequency.
When the power is re-enabled, only the clock is enabled, leading to a
situation where the MMCX rail is at MIN_SVS but the core clock is at its
highest rate. In this state, the rail cannot sustain the clock rate,
which may cause instability or system crash.

Remove the call to dev_pm_opp_set_rate(dev, 0) from dpu_runtime_suspend
to ensure the correct vote is restored when DPU resumes.

Fixes: b0530eb11913 ("drm/msm/dpu: Use OPP API to set clk/perf state")
Signed-off-by: Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/710077/
Link: https://lore.kernel.org/r/20260309063720.13572-1-yuanjie.yang@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index 9bcae53c4f458..edc35638ce763 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -1401,8 +1401,6 @@ static int __maybe_unused dpu_runtime_suspend(struct device *dev)
 	struct msm_drm_private *priv = platform_get_drvdata(pdev);
 	struct dpu_kms *dpu_kms = to_dpu_kms(priv->kms);
 
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(dev, 0);
 	clk_bulk_disable_unprepare(dpu_kms->num_clocks, dpu_kms->clocks);
 
 	for (i = 0; i < dpu_kms->num_paths; i++)
-- 
2.53.0



