Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114684028D8;
	Wed, 20 May 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302463; cv=none; b=j6cRiqhisEqbIW8GrjEpXRc4YdTQVuBlVF9G8pSp85E4N/7jU84ytrdUe234+yc4o1RxGaWvuUeXOErPzedPFO3twT6MqtiFHaFmsjWqW3Z1spLnKg0G7CU8I4dcWGlcNdNniUq2FbwhAuy2GSr5eDEhEihWcoGiJgp825gwqtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302463; c=relaxed/simple;
	bh=USIyc6dsX2yeShmOeT6vV13qTf5jPbvpUb9/7BfexCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1z0KXMws7IS29FfI8G0JKw7sXmGLruXMpBgkwapRgLni6TOmXWaCXShxf3G5bVPV5RnYFpGzUszpJfmXi6eoQq+wSNIeu3i9Nv9hi2CXHSoKod7o/OegRrgWPb/Xn4LlFESyOqjDmRdtF9XlidtQZc2p88VmfUzFLhL/grv6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9THyCRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9THyCRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CED11F000E9;
	Wed, 20 May 2026 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302461;
	bh=jkFrTRZfllG2TTMxT3J1ULZSk6xl07PCA6VOwHDOOX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9THyCRtqQXrTNEqUAB7UafSpz29ZPTTolzC6zGHFdPSpD4jLYsQMQ0fFhP71nkRa
	 ss302Um7FEmoUmWiSj0SkTNwcvwKdS7zSSf5hpLJxhTcF52E27WP0ARRAbSpIssW3s
	 1QM2gzpsIMJRpfBWmnUedhCvfNO5nsUEFJq7dbPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	White Lewis <liu224806@gmail.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/508] clk: qcom: dispcc-sc8280xp: remove CLK_SET_RATE_PARENT from byte_div_clk_src dividers
Date: Wed, 20 May 2026 18:21:39 +0200
Message-ID: <20260520162104.627208041@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: White Lewis <liu224806@gmail.com>

[ Upstream commit 0b151a6307205eb867250985a910a88787cbf12e ]

The four byte_div_clk_src dividers (disp{0,1}_cc_mdss_byte{0,1}_div_clk_src)
had CLK_SET_RATE_PARENT set. When the DSI driver calls clk_set_rate() on
byte_intf_clk, the rate-change propagates through the divider up to the
parent PLL (byte_clk_src), halving the byte clock rate.

A simiar issue had been also encountered on SM8750.
b8501febdc51 ("clk: qcom: dispcc-sm8750: Drop incorrect CLK_SET_RATE_PARENT on byte intf parent").

Likewise, remove CLK_SET_RATE_PARENT from all four byte divider clocks
so that clk_set_rate() on the divider adjusts only the divider ratio,
leaving the parent PLL untouched.

Fixes: 4a66e76fdb6d ("clk: qcom: Add SC8280XP display clock controller")
Signed-off-by: White Lewis <liu224806@gmail.com>
[pengyu: reword]
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260303115550.9279-1-mitltlatltl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sc8280xp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sc8280xp.c b/drivers/clk/qcom/dispcc-sc8280xp.c
index 30f636b9f0ec8..7f8819ece5eb0 100644
--- a/drivers/clk/qcom/dispcc-sc8280xp.c
+++ b/drivers/clk/qcom/dispcc-sc8280xp.c
@@ -1161,7 +1161,6 @@ static struct clk_regmap_div disp0_cc_mdss_byte0_div_clk_src = {
 			&disp0_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -1176,7 +1175,6 @@ static struct clk_regmap_div disp1_cc_mdss_byte0_div_clk_src = {
 			&disp1_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -1191,7 +1189,6 @@ static struct clk_regmap_div disp0_cc_mdss_byte1_div_clk_src = {
 			&disp0_cc_mdss_byte1_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -1206,7 +1203,6 @@ static struct clk_regmap_div disp1_cc_mdss_byte1_div_clk_src = {
 			&disp1_cc_mdss_byte1_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
-- 
2.53.0



