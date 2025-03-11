Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709241DF749;
	Tue, 11 Mar 2025 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706392; cv=none; b=bDiRUysED6IYDmWh0THiD1WIvvZ0TG7RY8gd8Cun3y9S9fHFc16xDsJ6nKEowi4m+ZZXL/rldXVd3XmPeKk7q2zkPHK8qxfJ41m26xfOO3yr6oLSVcXaqs1cd9NOim6CrmKyh00aUoXOqqanAJx2NK2XgFP9wF8XoONEShb0FK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706392; c=relaxed/simple;
	bh=3uIJgizv4DkGpatUUuSVqg2KSDjTiGtHuesefZDrHhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXldjC6tbIOzhPn/+EedTsmBpPWOfc95w54B7Msldm7yMOG27kQi7ILdS3O8bhiM1K3HUulaSnIhICXjkdujP/3mh15HdPdeAG8rCysoVorrumBz9AhUa3vDreoiottaxKT95KYZLbYNrmBmQ3Jegd48bsTHdUHAZ5kDmAPeByU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRf/LuBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRf/LuBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9C7C4CEE9;
	Tue, 11 Mar 2025 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706392;
	bh=3uIJgizv4DkGpatUUuSVqg2KSDjTiGtHuesefZDrHhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRf/LuBMFlm/sC6k9N5esUBO236k6LVY6kuxe2P8DrnI8eYvr3LcLg1ZSc7Qn9iP0
	 G9nGOoHt0uwT/S7Xa7vO4/ZhUarKXJyrqD9Z3SjRIFlvMI490GTFpjaEW4+T23Qi73
	 bsk+tawZTJdBRE8bgn0N9wf4zpxuHCNA9JxUHLvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/462] clk: imx8mp: Fix clkout1/2 support
Date: Tue, 11 Mar 2025 15:54:58 +0100
Message-ID: <20250311145759.625633488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 56d45caa603f8..385653fe39660 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -410,8 +410,9 @@ static const char * const imx8mp_dram_core_sels[] = {"dram_pll_out", "dram_alt_r
 
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



