Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948FB3DA7D9;
	Wed, 20 May 2026 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296190; cv=none; b=Pd5W4wjJzDIu7Q/GUMkRCtYyBLrpja2HP3vaZ9AzfKVUAnFBO6suThIDSB+RoFZPfTBe1z+6Li3LpU/x0CPHArVifgtIdXqaMr4XjC7/qRfjzqfqBMUUkCaI2hty7UIGz4krcDFEe//b4aL9QFKXdqfqBcgyfcLuzgEYsQqidJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296190; c=relaxed/simple;
	bh=AY5WUhy5RIk26ZaGxgo1fQ/nHJo/BNaa+kIyzwM72kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nfT8gudaxj5hhYBgd3tkLTdDKcgGNig/aBtmm1pFhAVQaQMIarBfHqSWFhD5SRchaynHMkjAHrPQMmiFiRE9mO2ig1Zj6sdY/Bdhhv3wBpIhvPBW6wOWQP1q/BO5fHp9u0hbYep23hfc50mfTWBEA4abfImSsVyOJHk7s5juxrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yuy+GcQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yuy+GcQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE05B1F000E9;
	Wed, 20 May 2026 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296189;
	bh=Ljcm49n3PQhCYQs+YBarhIIuYup/e11YzgqllQNRDwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yuy+GcQ6SJvReN0za7auKsEm3jIVvUHZFzdPtUEnwHjB+O4IQ6ZWhCYDqu5GjrQdI
	 ONXwO+kyRAwVh8ESlQiKGc7sB/SOiPFJPYWs4zqSrFDRbnDEW97WBOHCA63RSjnTsF
	 jF7RKypby2wkr0e8q7g7HAuvTkqLxo2MJAu2C/YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0706/1146] clk: qcom: dispcc-kaanapali: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:15:56 +0200
Message-ID: <20260520162204.167514442@linuxfoundation.org>
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

[ Upstream commit e892f4e3f3d558ce5d7595dca7cce2bd170a19fa ]

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

Fixes: 6c6750b7061c ("clk: qcom: dispcc: Add support for display clock controller Kaanapali")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260304-topic-dsi_byte_fixup-v1-2-b79b29f83176@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-kaanapali.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-kaanapali.c b/drivers/clk/qcom/dispcc-kaanapali.c
index baae2ec1f72aa..c1578cd07041b 100644
--- a/drivers/clk/qcom/dispcc-kaanapali.c
+++ b/drivers/clk/qcom/dispcc-kaanapali.c
@@ -800,7 +800,6 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 			&disp_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
@@ -815,7 +814,6 @@ static struct clk_regmap_div disp_cc_mdss_byte1_div_clk_src = {
 			&disp_cc_mdss_byte1_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
-- 
2.53.0



