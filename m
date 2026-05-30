Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BD434389B;
	Sat, 30 May 2026 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161056; cv=none; b=Goq+sTrB8tb8iHUOe6jnC5OPAg+86wZPS7LKKKkDuQgC5WpUiAVKsc9SYM8Ru3PDDVWQPdNeScLikW8fWa8DDHwxobHblBwvpSpt+GQ/LL5plfeT9zeSFk+s2iITfKg5hlH/Y8cIn5qwZ7rrYlxysLv3KHCbiCCuTJZmwTKiwHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161056; c=relaxed/simple;
	bh=UygjFdnX1219cs9v+W120zEI7NSpL+1q2gKPFHE4rao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jstbpgLYe6hnScyRvkdf6Usl3WO+Zr61i0q2Jj9vAEmsKcCGRQX6SOkqbBtkVNGMS9q/iaO6WOwXbgl528ousDOIMd/mgA502ubEOO9KGaL0b486p2z7Klh0wqo4HD4ZtnW8stPCCISkkzvgDlvOTwVwqx54/pKoZKrwfjvD/go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evBLrBZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evBLrBZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0F01F00893;
	Sat, 30 May 2026 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161055;
	bh=fOtHMCR7/TDwZXZVQKEs2d5F5JnCUEDVAqHfDgaMPzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evBLrBZyBgHx7oD0M8GSRW2UMuf68H9SNU/l06cLz18tTS0638NGEhBAW/5ijkrI1
	 kugdNi8LKdNneIDkf7Z0ttEz5pIQ4TdrDtkPnocK9+i5yJzNve4m5b9QwD2aPK6hJP
	 dRmAWtRFCdvn+xu/RuIhgqb2h1kYbpW4DbFApLEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/969] drm/msm/dpu: fix mismatch between power and frequency
Date: Sat, 30 May 2026 18:00:37 +0200
Message-ID: <20260530160314.505514781@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b7901b666612a..46fa3a703a1a5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -1259,8 +1259,6 @@ static int __maybe_unused dpu_runtime_suspend(struct device *dev)
 	struct msm_drm_private *priv = platform_get_drvdata(pdev);
 	struct dpu_kms *dpu_kms = to_dpu_kms(priv->kms);
 
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(dev, 0);
 	clk_bulk_disable_unprepare(dpu_kms->num_clocks, dpu_kms->clocks);
 
 	for (i = 0; i < dpu_kms->num_paths; i++)
-- 
2.53.0



