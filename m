Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29AFFC0B;
	Wed,  5 Feb 2025 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764388; cv=none; b=YiKSZ/k/tIZvSFMZg7FlJbYmBHnx4SWTeYuUV9tK2ulkqsJvDTCNmS1lgQwxCTp0Yg92Ng/ASnkdCyPo9ahX8ipnXqh2vDG3+S44qSmCFDNLCbeZ0vd14z3vjOzXZMQGSd4/E80JpkQ4zTNReO99ANf17aQZAlExC8spqbUZOnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764388; c=relaxed/simple;
	bh=yG/3XdV98V+x4i/A8gOJgI3HSNReSp3N6XHvIQmltp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccCTfem+YsnFGuKyofLXjTEZoGLAkFPfdeBWYXBl+LmsP7ZeGcG5mdLGvZVWgqdlXL7PaDNini9RG7IOLUmvXbI4A51couqFLpZgtI/a2r3lZni1hELM5b6Xvolv7ntX5C9H1Vm/e6aO4U9Llq8of03G6QdBr87RUe8sIH7M4B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z55010vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z55010vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474E7C4CED1;
	Wed,  5 Feb 2025 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764388;
	bh=yG/3XdV98V+x4i/A8gOJgI3HSNReSp3N6XHvIQmltp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z55010vKIhRHKnkrg2k7OG39TVDt2Wm8/80Tkwo+mMoVsZmOGwd+r9MOVEuxNbBbu
	 142xIFKI55i+284FACbsrqh3p10sTWkJsUlqoJSFCYpzz6u5SbSCEOwpRZSDQ39OnP
	 ufpFnIP+S6roq2TUSEn1GabB1CTMAyUx0OFuwitQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/590] clk: imx8mp: Fix clkout1/2 support
Date: Wed,  5 Feb 2025 14:37:54 +0100
Message-ID: <20250205134459.812707406@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit a9b7c84d22fb1687d63ca2a386773015cf59436b ]

The CLKOUTn may be fed from PLL1/2/3, but the PLL1/2/3 has to be enabled
first by setting PLL_CLKE bit 11 in CCM_ANALOG_SYS_PLLn_GEN_CTRL register.
The CCM_ANALOG_SYS_PLLn_GEN_CTRL bit 11 is modeled by plln_out clock. Fix
the clock tree and place the clkout1/2 under plln_sel instead of plain plln
to let the clock subsystem correctly control the bit 11 and enable the PLL
in case the CLKOUTn is supplied by PLL1/2/3.

Fixes: 43896f56b59e ("clk: imx8mp: add clkout1/2 support")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20241112013718.333771-1-marex@denx.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 516dbd170c8a3..fb18f507f1213 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -399,8 +399,9 @@ static const char * const imx8mp_dram_core_sels[] = {"dram_pll_out", "dram_alt_r
 
 static const char * const imx8mp_clkout_sels[] = {"audio_pll1_out", "audio_pll2_out", "video_pll1_out",
 						  "dummy", "dummy", "gpu_pll_out", "vpu_pll_out",
-						  "arm_pll_out", "sys_pll1", "sys_pll2", "sys_pll3",
-						  "dummy", "dummy", "osc_24m", "dummy", "osc_32k"};
+						  "arm_pll_out", "sys_pll1_out", "sys_pll2_out",
+						  "sys_pll3_out", "dummy", "dummy", "osc_24m",
+						  "dummy", "osc_32k"};
 
 static struct clk_hw **hws;
 static struct clk_hw_onecell_data *clk_hw_data;
-- 
2.39.5



