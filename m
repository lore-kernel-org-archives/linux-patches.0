Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522A33B27E8;
	Sat, 12 Sep 2026 08:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201066; cv=none; b=TTqgtz+l75MBHC56wmCLXQnEK9v/MrQtCdyX0CAjFZIUUk0LAayw4TpzLkAKccn4s0h45Itt2RKd2PVQqhuraD92qzpzalq2qfxD+s19QDz5aKfnak5M+hW+ZHRlIYVHL+ORFrPf9IXZepJrqpAY8u7e5nEQvr87/7csVNRfQQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201066; c=relaxed/simple;
	bh=F0UkNM/a01BVC9ArNlQ3LKNO+2z8lK3kviJ1XMiOgBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRpCBMGM4ygeYUZzElN4Ozhn4ijFy67DRC376Qv0kyJFXD06LJSjNQZoOxE1B9D8Km1kYppeFV45CqB96hLobP2Lgxr/vnVsEwhNDliqF7UtLrJIOO3H0j6/Mh7XgyFCmh5DGIalUg1qTL2gV1uV0XuipqyMKy2EmwvEU/GCw1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0ANBr5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0ANBr5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AD11F00893;
	Sat, 12 Sep 2026 08:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201063;
	bh=ic4Dv7saLO6wHmtoCedL2R7TzqITJtnew47YvOKYlOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0ANBr5fkpipNmnuRqTmZLxz4Z9tMVHKUU0RSYIhLojTd1cjjU7TVJxC4OLGnGuWQ
	 1++LWuNvDqhzvPceBv0bpVmQO9VrfHZazLE0p2kzIuQum93KkX8Zfv2Fx7u9ZOlhrG
	 8pe6hD9vYqk5EYcE2pWIYdAzIL7Dk/BfSDYOZxtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0912/1815] drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:44:22 +0200
Message-ID: <20260912065710.332746016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 811c38907eab0f66c22c5e5708e6f8eab14d76fa ]

dev_pm_opp_set_rate(0) removes the vote specified in required-opps but
does not actually park the clock, making it run without the necessary
power backing. Prevent that from happening when
_dpu_core_perf_get_core_clk_rate() returns 0.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/742779/
Link: https://lore.kernel.org/r/20260728-topic-dpu_power-v1-1-e7783b859a70@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 13cc658065c56..6524531bd8bdc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -394,6 +394,10 @@ int dpu_core_perf_crtc_update(struct drm_crtc *crtc,
 
 		trace_dpu_core_perf_update_clk(kms->dev, !crtc->enabled, clk_rate);
 
+		/* If we're going offline, PM callbacks will disable the clocks instead */
+		if (!clk_rate)
+			return 0;
+
 		clk_rate = min(clk_rate, kms->perf.max_core_clk_rate);
 		ret = dev_pm_opp_set_rate(&kms->pdev->dev, clk_rate);
 		if (ret) {
-- 
2.53.0



