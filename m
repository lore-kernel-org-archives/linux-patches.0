Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7391C3BFC;
	Wed, 20 May 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298826; cv=none; b=okkrS9o+97v8dqgIPgIB3Mb1lZrnwu7O3ZivzJSAuVNWAohHYRDBSiG5082BcAX1c1+cqg09GMf9LFQ4PlAiXcVOCXzJ+72JajZyfTCp6jj2ZiYdu8DRkH36AyCnCpjbgb+Aqe6qXkIWzkT0T/OU0QQqhMXhe/RNAbp9eBgjeTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298826; c=relaxed/simple;
	bh=kwjvtZGlXiTesXB3vA4xedCMg20vlcIK2XFZLXOtKDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fre7UEnLKnl97yW/0rzJO8AruWxszCUlz0Dx3Mycjp4fnDVOvfYz77Rh8NPUlUbvqkpAd/x6cCGzVFBjwh25ldshhKGYfaNVeoBdtblhgQmYGP9ZGoujhnbiYUPhISur/CTT8nbTVvuu+lArQLcT101G3/9aJFy02kB1tupSS6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnT46x//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnT46x//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EBF1F000E9;
	Wed, 20 May 2026 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298824;
	bh=mpvkJZMgTFU5+SsvSaQ5cOXuZY9EonfF+Zch+PVhxg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnT46x//Xn428lZD+UOQb6mEN2H1ZwFwsLaJ5aK+OlTZZ1AVB7q3UPcnLlE39mSIR
	 hM4Cif94cansv8celJtwOxcy0AClAoorN3nojd1RTGfP8cJ5vXxwuMG0sA7q/p+sI6
	 vPJng4LUNHuzOSFeh1XbUhOxUgbMc282j/l0jXn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/957] clk: qcom: dispcc-sm4450: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:17:20 +0200
Message-ID: <20260520162146.611550552@linuxfoundation.org>
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



