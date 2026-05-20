Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E813DA7D9;
	Wed, 20 May 2026 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296193; cv=none; b=UhP3lGhZ3T6+HkP80AebDpvpXGwhfnRlNnl27xfP+XMZGP2SEcGRckaeQf2So3KGIWRLCuqjUb9Vw/TgqnsbG1f0xFA7NLVINQzmUKMW3y7P+oNv41+5J66rn+28G2P3LEzHCtFW2QqWkXhhAgljXCNaK0E+Gs1QIasQrH1X+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296193; c=relaxed/simple;
	bh=MTDLNld6utW9ZH7Wy/AUs/1gQHIy+YRp6A5LNQ3k0SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxfVXlEBnc66xNP8Y3y4pJs6a5+dguk8PAPAW1snJYgtVbteF7N6FvJhcU43OPEED/ADQo6TdFhaC94PL2QthzU+Zyn/835XNHMc6KmgC6HUBrG1B9RBzz3ZIYFJ1EIrK5aX9OBtZqAIduiK9FhKd8f64jRFmdBLl4ud2UDcG2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHnb9HiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHnb9HiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981181F00893;
	Wed, 20 May 2026 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296192;
	bh=MpMQtpNSX8d1d5+LPrM+2DtXU9Rc9sCD6XQJXm4lOO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHnb9HiDeGvul3xhY8chM7UiBF1vEBK8U72NXeC5AN5RhEkpMkAG5WujESd8Vcuy0
	 7WFLdnngnK70vZUir8Lr645d8N0q84V9pHAbPMHEM3MpY44p02X+eA88TaqPa+yIz7
	 Yy1ufBlqrHuPBsH+aKM1aD+cYii5yDljc2N73DjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0707/1146] clk: qcom: dispcc-milos: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:15:57 +0200
Message-ID: <20260520162204.189398249@linuxfoundation.org>
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

[ Upstream commit dd5b76257b4048151006620c9895e2f5f0d997eb ]

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

Fixes: f40b5217dce1 ("clk: qcom: Add Display Clock controller (DISPCC) driver for Milos")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260304-topic-dsi_byte_fixup-v1-3-b79b29f83176@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-milos.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-milos.c b/drivers/clk/qcom/dispcc-milos.c
index 95b6dd89d9ae3..339cb1c63ba77 100644
--- a/drivers/clk/qcom/dispcc-milos.c
+++ b/drivers/clk/qcom/dispcc-milos.c
@@ -394,7 +394,6 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 			&disp_cc_mdss_byte0_clk_src.clkr.hw,
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_regmap_div_ops,
 	},
 };
-- 
2.53.0



