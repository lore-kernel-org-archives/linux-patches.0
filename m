Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9B530CD9F;
	Fri, 17 Oct 2025 15:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715490; cv=none; b=QiRcYgM2CkPT2OsGYA1W3gVyR5fKWuDJY6CvitaJm9jF89c5P1YZnvXsQOuAzVsqgUd/eBM70eZWBtlGUgEp+Otbhew9xrAGjjzbktbM1kfTsWkVZvg09QTN2Me7D13I8pC6W+a11Ncc6TFuCPqtYhJ+rRQiQkd1VkzInuuFTQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715490; c=relaxed/simple;
	bh=gK6/eY2g0/qHufduk+zhtBjVVe1Y2uBeVmvmcguIlo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmvdLsHhOjCL+vUkfZ1gjyR2A2W90/Qv1xeq9E3OQPaLQ71co2ifSRPBHSD/kt8s4eJkV6rxN4X8gUIibfVstIhciYYi6kvQAChoIGmWb0THvRsQKIBGqqt4y3mYag0DPmr5Ujr7oX4j9lhuXEobsW8/O5ZYDePBDkQYOJi67ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4VUp7jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4VUp7jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61BBC4CEE7;
	Fri, 17 Oct 2025 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715490;
	bh=gK6/eY2g0/qHufduk+zhtBjVVe1Y2uBeVmvmcguIlo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4VUp7joJYws6QhtEcAB3j4WelG4SHbSU4+u3LrPLwclSOmiYKZvyeOb/2hQm9zUU
	 C5ciZs08Hec1dC2oG6FAktZ/5qYbFt5K2fDcsVMBSLz6FeBfsWjlytbgJwuAU3gSjV
	 tV7TEKcZuB4AQiQguPjJ8/yu2PhwVoFhDtBJdvnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denzeel Oliva <wachiturroxd150@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.17 201/371] clk: samsung: exynos990: Use PLL_CON0 for PLL parent muxes
Date: Fri, 17 Oct 2025 16:52:56 +0200
Message-ID: <20251017145209.198631942@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denzeel Oliva <wachiturroxd150@gmail.com>

commit 19b50ab02eddbbd87ec2f0ad4a5bc93ac1c9b82d upstream.

Parent select bits for shared PLLs are in PLL_CON0, not PLL_CON3.
Using the wrong register leads to incorrect parent selection and rates.

Fixes: bdd03ebf721f ("clk: samsung: Introduce Exynos990 clock controller driver")
Signed-off-by: Denzeel Oliva <wachiturroxd150@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20250830-fix-cmu-top-v5-1-7c62f608309e@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos990.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos990.c b/drivers/clk/samsung/clk-exynos990.c
index 8d3f193d2b4d..12e98bf5005a 100644
--- a/drivers/clk/samsung/clk-exynos990.c
+++ b/drivers/clk/samsung/clk-exynos990.c
@@ -239,12 +239,19 @@ static const unsigned long top_clk_regs[] __initconst = {
 	PLL_LOCKTIME_PLL_SHARED2,
 	PLL_LOCKTIME_PLL_SHARED3,
 	PLL_LOCKTIME_PLL_SHARED4,
+	PLL_CON0_PLL_G3D,
 	PLL_CON3_PLL_G3D,
+	PLL_CON0_PLL_MMC,
 	PLL_CON3_PLL_MMC,
+	PLL_CON0_PLL_SHARED0,
 	PLL_CON3_PLL_SHARED0,
+	PLL_CON0_PLL_SHARED1,
 	PLL_CON3_PLL_SHARED1,
+	PLL_CON0_PLL_SHARED2,
 	PLL_CON3_PLL_SHARED2,
+	PLL_CON0_PLL_SHARED3,
 	PLL_CON3_PLL_SHARED3,
+	PLL_CON0_PLL_SHARED4,
 	PLL_CON3_PLL_SHARED4,
 	CLK_CON_MUX_MUX_CLKCMU_APM_BUS,
 	CLK_CON_MUX_MUX_CLKCMU_AUD_CPU,
@@ -689,13 +696,13 @@ PNAME(mout_cmu_vra_bus_p)		= { "dout_cmu_shared0_div3",
 
 static const struct samsung_mux_clock top_mux_clks[] __initconst = {
 	MUX(CLK_MOUT_PLL_SHARED0, "mout_pll_shared0", mout_pll_shared0_p,
-	    PLL_CON3_PLL_SHARED0, 4, 1),
+	    PLL_CON0_PLL_SHARED0, 4, 1),
 	MUX(CLK_MOUT_PLL_SHARED1, "mout_pll_shared1", mout_pll_shared1_p,
-	    PLL_CON3_PLL_SHARED1, 4, 1),
+	    PLL_CON0_PLL_SHARED1, 4, 1),
 	MUX(CLK_MOUT_PLL_SHARED2, "mout_pll_shared2", mout_pll_shared2_p,
-	    PLL_CON3_PLL_SHARED2, 4, 1),
+	    PLL_CON0_PLL_SHARED2, 4, 1),
 	MUX(CLK_MOUT_PLL_SHARED3, "mout_pll_shared3", mout_pll_shared3_p,
-	    PLL_CON3_PLL_SHARED3, 4, 1),
+	    PLL_CON0_PLL_SHARED3, 4, 1),
 	MUX(CLK_MOUT_PLL_SHARED4, "mout_pll_shared4", mout_pll_shared4_p,
 	    PLL_CON0_PLL_SHARED4, 4, 1),
 	MUX(CLK_MOUT_PLL_MMC, "mout_pll_mmc", mout_pll_mmc_p,
-- 
2.51.0



