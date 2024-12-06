Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676BF53A7;
	Fri,  6 Dec 2024 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497432; cv=none; b=uoVNSQjTuVBEjMMIQaOo44f75gilbTkW26yoJpe0pFpnOrC292cyZlAnP0A1dZGvqihcqRy/EWkWZI5MxTO0IyJ5UdKiQRj4pZePHikJ7AWwGEQM1kj38VTXdACfoRJj3lew/9BL1FIXTmFjTPFo3Cq5B5e1zr7GfB1JMm5JsUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497432; c=relaxed/simple;
	bh=sHnkY6sDrzuRY1kLWsQISfftNcsCJPMW8oknBZwXXN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spj2DWX1rMeOT2AHZnZ9BUir2D67dM4HZc0tU3Xbdp9ygOu1Jr7TG/W9Y6+WG4lFrWN3nmVZ/6f2Q/KDO81VShi6KRfFTaumcXLpcsLOyPGRkdYUgPQgmnXRFZnc0hAgAAz0M0DEF9Pvd3VxFw6QlfKeVP28sOMw+lanQx9kvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=La7dtgBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="La7dtgBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D1C4CED1;
	Fri,  6 Dec 2024 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497432;
	bh=sHnkY6sDrzuRY1kLWsQISfftNcsCJPMW8oknBZwXXN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=La7dtgBFlLOpj1jqvgnxL4sONqK23Z1+xU1B7yNwDWliXiYbQPIGxfWlbv8VFoI5V
	 YC68VtNDNNjsGAabe5u/Q7CcviKRhedX9bP9LN13Y75TdZaQ6Y/s1ycW4CNqIqdSqY
	 njEjnKmaRUMg9aQDoVZGZLQfK+QOJJE6d9oZjDQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/676] clk: imx: fracn-gppll: correct PLL initialization flow
Date: Fri,  6 Dec 2024 15:31:50 +0100
Message-ID: <20241206143704.708754114@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 557be501c38e1864b948fc6ccdf4b035d610a2ea ]

Per i.MX93 Reference Mannual 22.4 Initialization information
1. Program appropriate value of DIV[ODIV], DIV[RDIV] and DIV[MFI]
   as per Integer mode.
2. Wait for 5 μs.
3. Program the following field in CTRL register.
   Set CTRL[POWERUP] to 1'b1 to enable PLL block.
4. Poll PLL_STATUS[PLL_LOCK] register, and wait till PLL_STATUS[PLL_LOCK]
   is 1'b1 and pll_lock output signal is 1'b1.
5. Set CTRL[CLKMUX_EN] to 1'b1 to enable PLL output clock.

So move the CLKMUX_EN operation after PLL locked.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Co-developed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241027-imx-clk-v1-v3-2-89152574d1d7@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index 1becba2b62d0b..f85dd8798f15c 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -301,13 +301,13 @@ static int clk_fracn_gppll_prepare(struct clk_hw *hw)
 	val |= POWERUP_MASK;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-	val |= CLKMUX_EN;
-	writel_relaxed(val, pll->base + PLL_CTRL);
-
 	ret = clk_fracn_gppll_wait_lock(pll);
 	if (ret)
 		return ret;
 
+	val |= CLKMUX_EN;
+	writel_relaxed(val, pll->base + PLL_CTRL);
+
 	val &= ~CLKMUX_BYPASS;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-- 
2.43.0



