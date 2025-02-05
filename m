Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E3142E86;
	Wed,  5 Feb 2025 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763701; cv=none; b=BcNnTVzBUhEocDpXqA0+Izjf3Qen3o3K5KyHF0R1S15cc9qkP+qGUW92D9NKj3pV3VJnqcSgvaLY5oW1RMeC7AwkASOGI6OlgqyYG7llC9PJu4nngFLaMuueZHUvOjyJNqY19PVC2aJhMFWUNxXVCzyXiLrKgAW7foHsJb7gEDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763701; c=relaxed/simple;
	bh=afapCJp70i2eVHVs88yY9eLj2sOVqS2lH5CdnOjQ58c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWbVZDES4EuA5DrZM5Bq5PcXf+KUaiZedLsinwUewZyMGOQaRkHyDnufpK8b/L0idxHV+vWbdhjNAEytPOkU0HmFVX1xYLQBMZEtJKWFGJjkfdkx8veOrFudskVkGcd06Eb3qZEz0rH3YnwG0T/6oBkvM8zahZJfIORyE3i5lwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaGgWYAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaGgWYAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC31CC4CED1;
	Wed,  5 Feb 2025 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763701;
	bh=afapCJp70i2eVHVs88yY9eLj2sOVqS2lH5CdnOjQ58c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaGgWYAgrpIf10EIeXEhOyjL4DSD78AYSTskoRfoTziZMxlnDpB7WaMwCzQB93ZJo
	 irhvuzrEyfRfdWsvlWGhmStVQRRXmw7Ap51P7ey+AXgJ9Jls6+GvJ+SV4WmZg29N2e
	 X5Bhd5dn06Ua3USCCeBBhPDmjI7rYjfUUh/n9hLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/393] clk: imx8mp: Fix clkout1/2 support
Date: Wed,  5 Feb 2025 14:40:07 +0100
Message-ID: <20250205134423.659792790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e561ff7b135fb..747f5397692e5 100644
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



