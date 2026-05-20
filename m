Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3103A3E9C;
	Wed, 20 May 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298820; cv=none; b=n5ANIssTfBowhW14cOCxCsr3xCZ4nLrFlEPO0OF6AEW0t+TkG27xerdOEEOd21W6xFnTok3RrLTKKePNY3nGcZKV0BiB1Laa20LolncPCbI3HsRIce08AUnP9JAK9UX0lQhdaRgGctuvWLfPKzdJuSDx0okfzzLrvxwYyk5OhWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298820; c=relaxed/simple;
	bh=oLDP/WWQehSxb+ch3tajseDM8FlDkHTlu5vqpCOCy2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ymcn95AheQjJaglcRFXb3APXTpPgcmP+s8ePypMPQxCo12VdUS+6L22MXt+csjrDHB0U8NhLkcKm4VFmBgAEnxaLyIYEg6QovhMOLu7/ctcj/R42g/e91jl/INE0sgg95GOpunPc95L0MhsnTHqRUroXu48fJwKeHmhKxXarimU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xd/Yd+gR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xd/Yd+gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311FF1F000E9;
	Wed, 20 May 2026 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298819;
	bh=GT81CopjW1m6GdgBSORHGc/l/3EyEVS9QQ7Y9JVRgBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xd/Yd+gRVaaruxftlxB1+hq/54sToVrgrX97U7PQeqpRvKqSA0apMSOsCLGeoqlPb
	 C1EM91qOVOO5LcqSuipg3cGreTnFtePlHEg1fIaXxq/l7BBM1RHxLXPPrnH784hYZN
	 M9lGxkkp5BI0c6CE/a17wdd0NV2jBf4sa+Y7Jcq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/957] clk: qcom: dispcc-milos: Fix DSI byte clock rate setting
Date: Wed, 20 May 2026 18:17:19 +0200
Message-ID: <20260520162146.590044293@linuxfoundation.org>
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



