Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF973348C55;
	Wed, 20 May 2026 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301037; cv=none; b=b1UZ+veuQaBm9b0exqEZ0KxMvCgVoTtZqWlWlJr69GDZPjtNloX+iQEqkiETGSv4QotNEgSuaG8n7OhkMQzU5Zllua5fayoLLMCpAs8yAmxUqdm37/dDR6LFK7F5ZtfwpCgfmL+LHwtkG84Zm/FfrWj4FV9Yqktap1L/QpvrFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301037; c=relaxed/simple;
	bh=NuLtJy/MC5Glv1EFesiISLiv3h/Z9OzJ2aKJl2WGNG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e90Blhyjz2pORN+bOLd8gBagIHOJr1/ZeZuAPFe4+KPdbQJQv6ud3KLkHnCIV7joLM98P+XfiUw40zeVWum0qp1BOzz6IHHCvrmlJfZFS4tRwHaZnMWJ/nANL+C2h2r9ztN0cHZvdwMNbNctKGbEHcvhd3CzCl+YeNbKrn2gGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp4sGF50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp4sGF50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577D91F000E9;
	Wed, 20 May 2026 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301035;
	bh=r08N7Fu92awSl74kOUxmGiq6T+gnlBstHPDCPL9cEaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp4sGF50I0AGxK6SvckYk1PFV3LevdT3+w+wKmUN2gzAQ9UCpmKkkGShnv5y/h1Vf
	 QhZAvRTHrz4AvA3n7Yk+QeqgpLLw4x4YBd2cn7RA0J5QntA+YXuPUl1H8DhgMQpI5v
	 BzsrBXY+pyBAeXik9GEK3Tfw5TOhzlifptvV1nOg=
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
Subject: [PATCH 6.12 403/666] clk: qcom: dispcc-sc8280xp: remove CLK_SET_RATE_PARENT from byte_div_clk_src dividers
Date: Wed, 20 May 2026 18:20:14 +0200
Message-ID: <20260520162119.994817874@linuxfoundation.org>
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
index f1ca9ae0b33f4..c23cbb983d29e 100644
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



