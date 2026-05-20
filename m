Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0133A9CF;
	Wed, 20 May 2026 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295176; cv=none; b=h+Dej6/Q6LQZqJnFi0loUWt/I5ttnS4h9tOVHzLt6gueVbuwBotzt0tpUP+e672SzfFa2/tBtzj4NmGSTd4d1WJuQbx4gutuRVcdWm80usPOUigFEoCxkFg+8KJgvtB6TcLwjjfBOGyRksVTSyV0ki84vKwlHfelqzwx8PjKBuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295176; c=relaxed/simple;
	bh=YVKuC0ayb7PmvHg+1pFm+dFYNIGuoaLI/fgZeEMVDM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuHTeKjfQmjIC3nQytz/iM4D4QSe42JpZ4DaebZETGut8LLJQ/oWB87SIeoYweg2+aNFFKvJrLzAxaTxwAlI5UpcfW3lHtzD9iUFk90llepg+CeiKRfXfBomMBSCqYLAs3xmFmsdjCCTTcjLaM/lzKbtByilNHTfziDpwyGuM4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHl67x8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHl67x8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0A91F000E9;
	Wed, 20 May 2026 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295174;
	bh=LqBClvSut/349/PPgJyIUA155Esncj+nIMlAoyQMDAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHl67x8Gu8nv9c6Jan6UhnhwiL92D0DF9a8mRrc7AWFMbt0/pNm6Y2BHmMQ6dPHh4
	 2HupHjbRqzQfaMO+CwnWR32chUiPF4WbSM3PDZnE4p0rD4md9x6IoC5Yqcm1/3c+tE
	 FTRDy/VOBQ+kDeXKdFRgTLRfoOtgQuh/tSq5EP58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0319/1146] drm/msm/dpu: fix mismatch between power and frequency
Date: Wed, 20 May 2026 18:09:29 +0200
Message-ID: <20260520162155.417447494@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 61d7e65469b3a..014b2c504eda6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -1461,8 +1461,6 @@ static int __maybe_unused dpu_runtime_suspend(struct device *dev)
 	struct msm_drm_private *priv = platform_get_drvdata(pdev);
 	struct dpu_kms *dpu_kms = to_dpu_kms(priv->kms);
 
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(dev, 0);
 	clk_bulk_disable_unprepare(dpu_kms->num_clocks, dpu_kms->clocks);
 
 	for (i = 0; i < dpu_kms->num_paths; i++)
-- 
2.53.0



