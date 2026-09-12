Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A9E2E7622;
	Sat, 12 Sep 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224394; cv=none; b=kXAgvWcn9fBJQ3q6K8sZr/rl/fGGt3pv69mgXoc30M45pUspEmh6n154ZRPREpJmh2t1MT0Lg9INqIYDSXOgozkUNU4SILLIOIUnJh8rpMPHmsPhH9dNlSaXNfEvpjhC6tJiXsF/IU/FHe3YE8o43zz8MJd/I8ohHsln6h6Bt0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224394; c=relaxed/simple;
	bh=9PbVA++z3wQupl0YKJ4A7c71texynzjuDHGsD4aU5CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGGbWVyDXkyH5+5Z7BiHxVMVt/rmssEmS4/I6izXlvnzVWC80d0YIgH9w3/VQJjbtQZNwgdMM9KsRqAxhZFWHrrgWTlxGpl5tXQYwtb/oLFGXEvAEFjPepDID90MvUMTtQESff+bhRPfs8bLeb3pFS+M/P4TWYj5SiXhSzAOTc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlZF39eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlZF39eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB921F000FF;
	Sat, 12 Sep 2026 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224392;
	bh=yrA7aNZetj8KiTcDvgG7KgYSd25jF3ZiNRHj4ye5jtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlZF39ehQlxLnxgAL6ggivOJXXHEb/YLoM/6GKK8AGcXXu9q2LwPJfBumiNnFW80+
	 BKp8PfaAMQ8jHQYoJ5IdmmmAU5d70l1F6hk0Fo+iuw1AQ+CkH0tlunaP8J3eSMCqj2
	 djuKC72prmaplz23aWnNWYEKiqrYEaSYqoPq8q8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0983/1424] drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:56:55 +0200
Message-ID: <20260912065629.328899210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 260accc151d4b..d29df73c02c5f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -383,6 +383,10 @@ int dpu_core_perf_crtc_update(struct drm_crtc *crtc,
 
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



