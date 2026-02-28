Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59B836C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302217; cv=none; b=C25J51mhsKIpX0HAKSpm0WrkP/LyAElObWWt9OcTmYiJhNp7DSXOmmu1nebcNj7QchXwYCmIgzl0Nv+IwkyuzEmlkkkRMkJD4X+HcdYfI4zPMz38XI5IY2DOoepF4mTk80wX++5xCcTjg+PDHGZARgDSW0dFF3zGjMprV7U43ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302217; c=relaxed/simple;
	bh=aof0vTbEQt+bCzTsQk3Wt8vvT849Ya1Et3HvZOoCc0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2R6IRI67pBBsp8OQvBIjzYv3oCNlA5DTvhd3x3xDBB74IkdjCpqeJSTkjTco9gZpS28gwmeRdBNxrwXYNT/xSRKgPDzKSkE4BC+qxLrsEveO2IoZk+80IB6PNdBSCnbH9IXiYPO6PVRicegkB91T+9ryqSaugfWS4FIBEenL7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=htAFBk7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="htAFBk7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB5C2BC9E;
	Sat, 28 Feb 2026 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302217;
	bh=aof0vTbEQt+bCzTsQk3Wt8vvT849Ya1Et3HvZOoCc0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htAFBk7Y88ITtTjHxDkrYwVuhtviHRsKcGE3w+XhxBUbF4ejkks9fHUBCzD3eRvMW
	 xXRuYIsJOVQp+uvLNS36uHojVVAAnynCqsGvEgEDyayDbTWWJ1fNNv0uat484BzK0X
	 h1rY5skbm6Ouxea8qoTGBwq0pRrhrz5wNCYVjdFnK92538QSiL05vK8QTN7+3QleJ1
	 hxc2KfLPqPH74pTND7wHtxGZFhNwcz5572peoWeZKD+xtblC8IWTmubeMeTo6ighP0
	 SCOXhO8IcP1pQ4/lWo5BGyseeGweS/P9fE9ZOnkfz2ZgccGPG6bpKD8wLyXrUtDwoH
	 FurZjtUmwDjug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/283] clk: qcom: gfx3d: add parent to parent request map
Date: Sat, 28 Feb 2026 13:06:06 -0500
Message-ID: <20260228180709.1583486-224-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 2583cb925ca1ce450aa5d74a05a67448db970193 ]

After commit d228ece36345 ("clk: divider: remove round_rate() in favor
of determine_rate()") determining GFX3D clock rate crashes, because the
passed parent map doesn't provide the expected best_parent_hw clock
(with the roundd_rate path before the offending commit the
best_parent_hw was ignored).

Set the field in parent_req in addition to setting it in the req,
fixing the crash.

 clk_hw_round_rate (drivers/clk/clk.c:1764) (P)
 clk_divider_bestdiv (drivers/clk/clk-divider.c:336)
 divider_determine_rate (drivers/clk/clk-divider.c:358)
 clk_alpha_pll_postdiv_determine_rate (drivers/clk/qcom/clk-alpha-pll.c:1275)
 clk_core_determine_round_nolock (drivers/clk/clk.c:1606)
 clk_core_round_rate_nolock (drivers/clk/clk.c:1701)
 __clk_determine_rate (drivers/clk/clk.c:1741)
 clk_gfx3d_determine_rate (drivers/clk/qcom/clk-rcg2.c:1268)
 clk_core_determine_round_nolock (drivers/clk/clk.c:1606)
 clk_core_round_rate_nolock (drivers/clk/clk.c:1701)
 clk_core_round_rate_nolock (drivers/clk/clk.c:1710)
 clk_round_rate (drivers/clk/clk.c:1804)
 dev_pm_opp_set_rate (drivers/opp/core.c:1440 (discriminator 1))
 msm_devfreq_target (drivers/gpu/drm/msm/msm_gpu_devfreq.c:51)
 devfreq_set_target (drivers/devfreq/devfreq.c:360)
 devfreq_update_target (drivers/devfreq/devfreq.c:426)
 devfreq_monitor (drivers/devfreq/devfreq.c:458)
 process_one_work (arch/arm64/include/asm/jump_label.h:36 include/trace/events/workqueue.h:110 kernel/workqueue.c:3284)
 worker_thread (kernel/workqueue.c:3356 (discriminator 2) kernel/workqueue.c:3443 (discriminator 2))
 kthread (kernel/kthread.c:467)
 ret_from_fork (arch/arm64/kernel/entry.S:861)

Fixes: 55213e1acec9 ("clk: qcom: Add gfx3d ping-pong PLL frequency switching")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20260117-db820-fix-gfx3d-v1-1-0f8894d71d63@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 658d2ee7aacff..20bb72565f0ed 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -918,6 +918,7 @@ static int clk_gfx3d_determine_rate(struct clk_hw *hw,
 	if (req->max_rate < parent_req.max_rate)
 		parent_req.max_rate = req->max_rate;
 
+	parent_req.best_parent_hw = req->best_parent_hw;
 	ret = __clk_determine_rate(req->best_parent_hw, &parent_req);
 	if (ret)
 		return ret;
-- 
2.51.0

