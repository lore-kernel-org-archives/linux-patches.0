Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEECB359A8B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302444; cv=none; b=sBIZPjZG5Khw4/cgo930KfhCGIEY4y/lkPd2Tpv8+2+uFVzuUhJdub6jHe+Wkml5C7IWO8lA7gPc5SAY86veT/D8s0wMQ7t2Q/sszJpDQu+5yJ1E1QUD5iz9uDDdS9LPdgvaNiVxIV1U5AEB4AIvMPVfIgwEnYUqc1VFG2vveo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302444; c=relaxed/simple;
	bh=yMtT+UVtI84JNts9tfr5hsvZwGbsNbST1MTWs9vpAJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfSvX1BKidjhWxmBzKIJCe3A3rW3Rt1aVLYeiIbMEmacC344mPmgrc1wQGK6lpkW8rx1hSTbqPe6LFg6QQbg/prS7+JV3LmjPomOshuqh0uh1qh0dmU6Db9pv6eVBNIxO5KZS6vtVur21SXjCmHBwbYy2JlmmClGoYilQW604pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGmTg65x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGmTg65x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED72C116D0;
	Sat, 28 Feb 2026 18:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302444;
	bh=yMtT+UVtI84JNts9tfr5hsvZwGbsNbST1MTWs9vpAJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGmTg65xAdEpKQOXaG8jFESxZOH8nrPSDcVssns0FRigqQVWNa74qU3CHovArx5Ei
	 VaVITI4uOTkDYCrCsw7b9k77rN+uS3KHzDczK+k7gg0Q3pepy/kSZA87j0RdvZZnDi
	 HKi6HPQWAcRdVKQIa1uJUSaW2Lf4lIG1LF7yc79QvzX4bnWDBBDYzzvXCtzVWon97t
	 n8Tvd5HZXJpZgth6XktoKlShm2br7fWKjO1t1Q6vYcxXkn+Dfgs6+lnYGIPUQf2A0B
	 QiUzue+21jv2gE8csDEihePuqXQ8hVEgC0gr0QG3LLwBtUvxUus2xqEJPEBQ52jUkm
	 im9tl7piHlCgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/232] clk: qcom: gfx3d: add parent to parent request map
Date: Sat, 28 Feb 2026 13:10:36 -0500
Message-ID: <20260228181127.1592657-183-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 0e26f4f0bdbae..3dc9356b711d5 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -916,6 +916,7 @@ static int clk_gfx3d_determine_rate(struct clk_hw *hw,
 	if (req->max_rate < parent_req.max_rate)
 		parent_req.max_rate = req->max_rate;
 
+	parent_req.best_parent_hw = req->best_parent_hw;
 	ret = __clk_determine_rate(req->best_parent_hw, &parent_req);
 	if (ret)
 		return ret;
-- 
2.51.0

