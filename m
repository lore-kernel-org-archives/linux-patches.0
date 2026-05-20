Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E437333B969;
	Wed, 20 May 2026 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296188; cv=none; b=R6dRcNuNjDjMK5elGZFPPh3mEl14C/oehtyJfs7b/PDanCMV0B3tZic0Sssd4wEMjr2k1AujnwwdyKn7yRmmmKtnWooGFZXZpaYqPMCxYkYg+cTmkHl/C0ohjCF/5/xTbq8o5B8U2i75QSGW0NNSRziEZ9m+6JV1L6TfWsFmIMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296188; c=relaxed/simple;
	bh=A6fL56Uh0ej5mnPSsPutWk9mot17KgHfLoAD5KE2Q9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WwkHuZdP/CG6sqOK3V+vI8nMUilTcV2v4/GimVLQgq8bCHvMSYwSsZZuQS8AfoXspjUsMuXe3ygW0ZMNGblb1DYGdpDj2UjC7wwtf+ssFd8MM9vo9oKNtiKgu2xfVd4i28zabEgcRLmfgvPYrFKfypwDWemFXe+AWo9TeUfhG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTqMrhXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTqMrhXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FAA1F000E9;
	Wed, 20 May 2026 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296186;
	bh=V3uXDt3a9/SNDcfk2D8zc9fyMHsBuKh80hOUCulQZ6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTqMrhXwbVrxJOGTiYreXGyv1wyeq2FeHGxjcLlC2pQQPS/yZOekcCaMw480ayssy
	 LNyUQEhLP+A4Ka4dZgI3sb91OprqT1ncbAsa5H+HUrw0/6ALpcMC6fqcrylGXBBT4f
	 8uPIGWDC2EkuaIUgNNQSFOq9eTWXjrEUrNFreqZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0705/1146] clk: qcom: dispcc-glymur: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:15:55 +0200
Message-ID: <20260520162204.144002712@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 98ea9eda030587601db56425efcd32263d853591 ]

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

Fixes: b4d15211c408 ("clk: qcom: dispcc-glymur: Add support for Display Clock Controller")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260304-topic-dsi_byte_fixup-v1-1-b79b29f83176@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-glymur.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-glymur.c b/drivers/clk/qcom/dispcc-glymur.c
index f352165bf56fc..bef74f58405ba 100644
--- a/drivers/clk/qcom/dispcc-glymur.c
+++ b/drivers/clk/qcom/dispcc-glymur.c
@@ -747,7 +747,6 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 			&disp_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -762,7 +761,6 @@ static struct clk_regmap_div disp_cc_mdss_byte1_div_clk_src = {
 			&disp_cc_mdss_byte1_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
-- 
2.53.0



