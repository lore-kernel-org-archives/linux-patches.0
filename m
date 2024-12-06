Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD3C20B80A;
	Fri,  6 Dec 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497917; cv=none; b=lHMe3+mthFe5Us2J/EuqVY5ykS2bdFPqjsMu9px7h0YPQllyyChX1qW7y5kOll+0DeDWQtHR9f2pyveME/NLCdxvAZeTJiuYQRF9Tb5GVHjOLc0AmZhSgHJdamu3PVb7Y8WdM8mQ1SbfxKaDsmnuIR6AzBtQz6S54pds46Ke6yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497917; c=relaxed/simple;
	bh=js78gtHUxeuS6EHio3O2IHPoGm2ROCrYEaegFhYZx4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO3Yjw4COZCGtSSa6fwoMjmK9JG7OGQiOqXWD/OAhoi7Oc+BbO4d3dN9W+DgP0tiDX501QGyQ/r+lMfAkfIlryDgIKTaxvTEWq0ONImMloPaY3NwZmrYiCJhIKF0CACBPcHO7ENDbfYBGjyYlfNsJjZs6pfdFplM5qPMzyGM4z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZTnhup6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZTnhup6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F43C4CED1;
	Fri,  6 Dec 2024 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497917;
	bh=js78gtHUxeuS6EHio3O2IHPoGm2ROCrYEaegFhYZx4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZTnhup6LM0osCxbZjY1D15nLwvSUYYY35A+xhvVE9j8mC37hfTsXiA4/eIr4zNxS
	 zYx//iA8QhPod7w7Gff+kM2U5F5SZquQT8npvxNBVhKbL48B2HqbJSqipV3P/f9Wvu
	 4tDmaqg6Y6XbcfKIENzvzu4RCf+Sl4z04CGiTQaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 432/676] counter: stm32-timer-cnt: Add check for clk_enable()
Date: Fri,  6 Dec 2024 15:34:11 +0100
Message-ID: <20241206143710.217559025@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 842c3755a6bfbfcafa4a1438078d2485a9eb1d87 ]

Add check for the return value of clk_enable() in order to catch the
potential exception.

Fixes: c5b8425514da ("counter: stm32-timer-cnt: add power management support")
Fixes: ad29937e206f ("counter: Add STM32 Timer quadrature encoder")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241104191825.40155-1-jiashengjiangcool@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-timer-cnt.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 6206d2dc3d470..36d7f0d05b5f2 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -195,11 +195,17 @@ static int stm32_count_enable_write(struct counter_device *counter,
 {
 	struct stm32_timer_cnt *const priv = counter_priv(counter);
 	u32 cr1;
+	int ret;
 
 	if (enable) {
 		regmap_read(priv->regmap, TIM_CR1, &cr1);
-		if (!(cr1 & TIM_CR1_CEN))
-			clk_enable(priv->clk);
+		if (!(cr1 & TIM_CR1_CEN)) {
+			ret = clk_enable(priv->clk);
+			if (ret) {
+				dev_err(counter->parent, "Cannot enable clock %d\n", ret);
+				return ret;
+			}
+		}
 
 		regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN,
 				   TIM_CR1_CEN);
@@ -383,7 +389,11 @@ static int __maybe_unused stm32_timer_cnt_resume(struct device *dev)
 		return ret;
 
 	if (priv->enabled) {
-		clk_enable(priv->clk);
+		ret = clk_enable(priv->clk);
+		if (ret) {
+			dev_err(dev, "Cannot enable clock %d\n", ret);
+			return ret;
+		}
 
 		/* Restore registers that may have been lost */
 		regmap_write(priv->regmap, TIM_SMCR, priv->bak.smcr);
-- 
2.43.0



