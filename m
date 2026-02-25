Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB90304BB4;
	Wed, 25 Feb 2026 06:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002654; cv=none; b=R7aKcpKHqB9CFQXT5lt7clqoW8hI4gTKXEHVZuAEHlYW4WvQDNi1Ejo6nsHjAdvF/ZVfrOAoK/LDnwPObJzyLVfC5vlnWQIX3GvzqExHnWwEN/xoaqubqCRD7KfCn3d4SExTHFlVixS85/8JlEbmSUPWLvaZ6YPhEXdbn9mqpaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002654; c=relaxed/simple;
	bh=JspSa2UTOjaLIpbho9jEd5XVq/cuH5jdGS7bDE/yH/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyipOpYHGM5ZH25d7nv9ablzkzlYe4YyRhHNsGSooMGeDcAC6lUSKDbHBCLpTXs1DaENMhSGtXQBq8a4hgzSb49RVj0MqIw0o0QSQxCkh0bDEI3MrDQFsPu2p1OnvMugWkh27YYBK+hc+vAnnrbnhBfiJlPI3OMGgw724ZEPujI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEtQWZuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEtQWZuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFADC116D0;
	Wed, 25 Feb 2026 06:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002653;
	bh=JspSa2UTOjaLIpbho9jEd5XVq/cuH5jdGS7bDE/yH/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEtQWZuBrhECZckIsQ9jJFeTUUlyz7yMT1mXW4J08ElUoDCjEZDDqkmb7A/FseFfj
	 nYtbMmbpuSRiXeWREikV79BW+l9LkgYLj7IQaiOHtlhPa6+xyFM/puFOwgSC9LzSIW
	 XVf7eH1H44fi1JBBugR3VqyCFYK0AMRO+hGesFzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 429/641] clk: qcom: gfx3d: add parent to parent request map
Date: Tue, 24 Feb 2026 17:22:35 -0800
Message-ID: <20260225012358.941093517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2838d4cb2d58e..d0a5847f91114 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1264,6 +1264,7 @@ static int clk_gfx3d_determine_rate(struct clk_hw *hw,
 	if (req->max_rate < parent_req.max_rate)
 		parent_req.max_rate = req->max_rate;
 
+	parent_req.best_parent_hw = req->best_parent_hw;
 	ret = __clk_determine_rate(req->best_parent_hw, &parent_req);
 	if (ret)
 		return ret;
-- 
2.51.0



