Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E7C1A76B2;
	Tue, 30 Jul 2024 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360405; cv=none; b=EP7h+E0Wc5Cbt3gvdD1Zow1iRSFNIZNezuWkguMrunuE/R0aygXnEl8OQ9UMEpHbuszz++cgs1RWbku40BW46K2T63W761pBT01HwNABJFfPhZRa8LX0V5LyQXnNx/WuePGmlkUBfZSA8O6UJwsPBDJQA7I2Ffd+ENiTkigGsWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360405; c=relaxed/simple;
	bh=UdlXN4sHWc0lDRXLm0G+E6XgQJVO7BzD99bZ1M0ENxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyzru3zXch89tlvZptXyBU1oar0OLouwG2efcOE9LyglSPjkYl9Vn1P9dGgvYU0emgcbfD5UljcviIV7Fb1UWS6SndTPIZrSvdefu1jVm1MCw8A0j76LXHmb9+/qgnUMCCHvu7mWviUihEGHW8Nn/A//1LE6txfYwrPhFh9LFaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvzxsQPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvzxsQPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63806C32782;
	Tue, 30 Jul 2024 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360404;
	bh=UdlXN4sHWc0lDRXLm0G+E6XgQJVO7BzD99bZ1M0ENxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvzxsQPA/wMww3B0lV0CUkruBBleVzuEI6tAwdy/5foL1y934EFomUYX7eqeP1dZn
	 TyXUNdPAD3caUi2WFNGbvmKDlxtFzC9p3deAxEwuiJ/nbL/9o5eRjsSGLY/izeEuE+
	 hvt5jYDQ3JAFCPfsMlZgINMiM37Ezfxsyzsgey7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.10 661/809] clk: samsung: fix getting Exynos4 fin_pll rate from external clocks
Date: Tue, 30 Jul 2024 17:48:57 +0200
Message-ID: <20240730151750.998001443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit f99b3feb3b0e9fca2257c90fc8317be8ee44c19a upstream.

Commit 0dc83ad8bfc9 ("clk: samsung: Don't register clkdev lookup for the
fixed rate clocks") claimed registering clkdev lookup is not necessary
anymore, but that was not entirely true: Exynos4210/4212/4412 clock code
still relied on it to get the clock rate of xxti or xusbxti external
clocks.

Drop that requirement by accessing already registered clk_hw when
looking up the xxti/xusbxti rate.

Reported-by: Artur Weber <aweber.kernel@gmail.com>
Closes: https://lore.kernel.org/all/6227c1fb-d769-462a-b79b-abcc15d3db8e@gmail.com/
Fixes: 0dc83ad8bfc9 ("clk: samsung: Don't register clkdev lookup for the fixed rate clocks")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240722063309.60054-1-krzysztof.kozlowski@linaro.org
Tested-by: Artur Weber <aweber.kernel@gmail.com> # Exynos4212
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos4.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index a026ccca7315..28945b6b0ee1 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1040,19 +1040,20 @@ static unsigned long __init exynos4_get_xom(void)
 static void __init exynos4_clk_register_finpll(struct samsung_clk_provider *ctx)
 {
 	struct samsung_fixed_rate_clock fclk;
-	struct clk *clk;
-	unsigned long finpll_f = 24000000;
+	unsigned long finpll_f;
+	unsigned int parent;
 	char *parent_name;
 	unsigned int xom = exynos4_get_xom();
 
 	parent_name = xom & 1 ? "xusbxti" : "xxti";
-	clk = clk_get(NULL, parent_name);
-	if (IS_ERR(clk)) {
+	parent = xom & 1 ? CLK_XUSBXTI : CLK_XXTI;
+
+	finpll_f = clk_hw_get_rate(ctx->clk_data.hws[parent]);
+	if (!finpll_f) {
 		pr_err("%s: failed to lookup parent clock %s, assuming "
 			"fin_pll clock frequency is 24MHz\n", __func__,
 			parent_name);
-	} else {
-		finpll_f = clk_get_rate(clk);
+		finpll_f = 24000000;
 	}
 
 	fclk.id = CLK_FIN_PLL;
-- 
2.45.2



