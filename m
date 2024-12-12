Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27298239BAF;
	Thu, 12 Dec 2024 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019922; cv=none; b=sMWbYkIvPVI+EGjpw8X9iQHhykpQ4IXuzYh33+Onf8y+O0ZJZez2DbgDz/G8uDOAKw4+z6J2yMVNO8rB8vnXyCTRYziinMEfAy8lAdBECpWO1CQbYIbpwYrHakxmwMHhXVP7VHjjUfDqumLX9YPAFtcmJ9lwzFkA/SnZ0jOzu/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019922; c=relaxed/simple;
	bh=lnavotHII/t9r0PzFQShZTCgsDa61o+CIck04NK1bn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJx5/rZZ1b4OgdBKwWW3lC3Emt0scqDVm+N/tg1+mDi1TLa8T/8UTkfbIt1MYfmgirRRESJ61CODTuHSzszZwG4+KV+hANDcNndc6V6gFhdbn1unkUuiUV650YKw0Lhh+VUJODVS0Ro/KnIP6kh8hlCao/o7p/f4EwyczzbW1I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLwDyfYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLwDyfYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F797C4CECE;
	Thu, 12 Dec 2024 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019922;
	bh=lnavotHII/t9r0PzFQShZTCgsDa61o+CIck04NK1bn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLwDyfYaC31G6mfGUMUK3ILyNWNGT6tXiWwxGJ/Shl4nRE1ALqJasWOXcH08uUsQl
	 JjPtkABBgZprcEEQRBFpvXgz4fiO54bACe9F0J82puPp8sjo3BM0QXmbtmntAlGV8U
	 u1TMalZOzS0RagkRsukxeUL5JFExelM30WPnqIx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/772] counter: stm32-timer-cnt: Add check for clk_enable()
Date: Thu, 12 Dec 2024 15:54:37 +0100
Message-ID: <20241212144403.620681393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9bf20a5d6bda8..e752fc8cb190a 100644
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
@@ -380,7 +386,11 @@ static int __maybe_unused stm32_timer_cnt_resume(struct device *dev)
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



