Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A831C3BFC;
	Wed, 20 May 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298829; cv=none; b=Uow0mZuQR6ZT5KfNSxA4nloutG99o5YbD8S3FVz0H+BMhfQG/vFvJaylH+YInzxnepugOCJ55QDzCvL6NRF11QCaE52GCx/CvM0IFaC/BSUOyQLbBtNyTUoxcX2f3gEPQQ6w7u8XMLIvnjeysGUz5SD4KA21fi/oNyXZdYK/D+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298829; c=relaxed/simple;
	bh=fUWAokZ6icpE2Ts59BewdhzTJGYI3ZLYqEUX9cULMNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=og/dNrrjAPL605EhLkIzoY6eeQQdUKPEs64EdcGY9HbXHDBDdHl90Dv4wcw2LpFVnoYHhYWQVdT7wQFvn06f39c0eMD2ZZWMOOoXMEdBvC6R1z+siivA3eJ8bmw7zyBKx3EnGBpJ37Eywxvk2lX0n5+kk3cVxMOOrW+pxRrbarU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj3hYDKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj3hYDKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C211F000E9;
	Wed, 20 May 2026 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298827;
	bh=ClIRSmpi8EhmqXlL8eHiY+74H/hj/3iWmbY12XSlp70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tj3hYDKG1HNG09FUBk5TNWuaDtR/fUtC9nxjubAXAHenXRZ+GaovE+0czk/uV6Tix
	 jWbuoxLTsZQJsjtMPP/m2VxJ9LZgdMd0ECDspnkPQM5a7IkD6MHwDz7dO5WV9KyQY3
	 7DarM0BnKMeKtUe4HPeQ2/3Nq34pzXkqMwAPVMFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 558/957] clk: qcom: dispcc[01]-sa8775p: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:17:21 +0200
Message-ID: <20260520162146.633475350@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 2851b6c6a42e22c243aa4cd606a49e2b9acfb6d6 ]

The clock tree for byte_clk_src is as follows:

   ┌──────byte0_clk_src─────┐
   │                        │
byte0_clk            byte0_div_clk_src
                            │
                     byte0_intf_clk

If both of its direct children have CLK_SET_RATE_PARENT with different
requests, byte0_clk_src (and its parent) will be reconfigured. In this
case, byte0_intf should strictly follow the rate of byte0_clk (with
some adjustments based on PHY mode).

Remove CLK_SET_RATE_PARENT from byte0_div_clk_src to avoid this issue.

Fixes: e700bfd2f976 ("clk: qcom: Add support for Display clock Controllers on SA8775P")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260304-topic-dsi_byte_fixup-v1-5-b79b29f83176@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc0-sa8775p.c | 2 --
 drivers/clk/qcom/dispcc1-sa8775p.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/clk/qcom/dispcc0-sa8775p.c b/drivers/clk/qcom/dispcc0-sa8775p.c
index aeda9cf4bfee8..b248fa9705873 100644
--- a/drivers/clk/qcom/dispcc0-sa8775p.c
+++ b/drivers/clk/qcom/dispcc0-sa8775p.c
@@ -591,7 +591,6 @@ static struct clk_regmap_div mdss_0_disp_cc_mdss_byte0_div_clk_src = {
 			&mdss_0_disp_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -606,7 +605,6 @@ static struct clk_regmap_div mdss_0_disp_cc_mdss_byte1_div_clk_src = {
 			&mdss_0_disp_cc_mdss_byte1_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
diff --git a/drivers/clk/qcom/dispcc1-sa8775p.c b/drivers/clk/qcom/dispcc1-sa8775p.c
index cd55d1c119024..9882edbb79f9e 100644
--- a/drivers/clk/qcom/dispcc1-sa8775p.c
+++ b/drivers/clk/qcom/dispcc1-sa8775p.c
@@ -591,7 +591,6 @@ static struct clk_regmap_div mdss_1_disp_cc_mdss_byte0_div_clk_src = {
 			&mdss_1_disp_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -606,7 +605,6 @@ static struct clk_regmap_div mdss_1_disp_cc_mdss_byte1_div_clk_src = {
 			&mdss_1_disp_cc_mdss_byte1_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
-- 
2.53.0



