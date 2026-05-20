Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8EE33B969;
	Wed, 20 May 2026 16:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296196; cv=none; b=E518BsWIuLzXb+C/QEbfcsVBeL4RpnwTnkJmThPO2/IjY9nsjTakJPix35rBzxBIcDUhUSDoanP5NzV6Q4Dko8TzAKz0iPLkk2/dwTdWPBH9OAY96DdAAuv/RxlGi2gw1M+x9z4Jl0gfXICi1R8DmVuCwnCBvvsWIWxbUHnGqhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296196; c=relaxed/simple;
	bh=xSZbCkonMeK+sL1kDaAGYhhk182ZQDPgu1U/Omixs6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRdhc2rDvwozzd63W1gRmhRKdO9mkTN/q4VGJAiTmw6CDkPs+hzyfdfSLQSG1GqUBND4xxmBLLuNmDjOmdzXKf1FYkCOjOIe4lPezl69bMLgET+ZvL6srlAmJ9L78YyL1+DJDRCLwctcw77GzHWGvUZJLC3xfL3G+mAIARqbME4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBV/9WSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBV/9WSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D61B1F000E9;
	Wed, 20 May 2026 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296194;
	bh=0bQ9FBrmI91wsmtZ8C4A09y7wO/yDDSe0kLxEGIArT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBV/9WSsHddCWf+RxxPwHKSh6cB9mmkbOPXJy+MyFohm8G56fOX2nn7d8NmBUbskl
	 iPSwakViiqpLr9gNV1X+VDUvzlDAey9ZxX7i3KhoYl5XmkTxBUCNsmPXx+B/UJNpLk
	 MKTJUkKwA9M+fKhwozTsqJYhqCj7XM2ze25cBF1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0708/1146] clk: qcom: dispcc-sm4450: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:15:58 +0200
Message-ID: <20260520162204.211660283@linuxfoundation.org>
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

[ Upstream commit 7bc48fcdf9e77bf68ef04af015d50df2a9acac00 ]

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

Fixes: 76f05f1ec766 ("clk: qcom: Add DISPCC driver support for SM4450")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260304-topic-dsi_byte_fixup-v1-4-b79b29f83176@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm4450.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm4450.c b/drivers/clk/qcom/dispcc-sm4450.c
index e8752d01c8e62..2fdacc26df698 100644
--- a/drivers/clk/qcom/dispcc-sm4450.c
+++ b/drivers/clk/qcom/dispcc-sm4450.c
@@ -335,7 +335,6 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 			&disp_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
-- 
2.53.0



