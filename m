Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCD01F707A;
	Tue,  3 Dec 2024 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239542; cv=none; b=PYil72Ynuhp2YaAklvvhCpD8krBdDJfyD4OoAYHQS2qm1QpUGbjx6555Zt/fATu4WgCPv2jjAc+mTlYPNnR4ZKFKZ1/RZgRckdQ2j8sKSLkuXyu7oxVON/dWC7UBsUncSa0nqKy7ao4+zYj7hfU2MhN6xFKyjvjH7pH8esy6Am4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239542; c=relaxed/simple;
	bh=dnQBWLH5WsqBRwrYt8M0wEiDOhRKvqr4cN1ob/LMVvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPYft0P6RlPiW+0wKT64XUZulMDx7gsb7CYWtrbZzNFnfcHAwslDkZNmifvAQsu/YPaqX9ja16AvsFG3+f6Q/wNUovZ6bM/U5F8t4Ts4RWXE+yZdJH50X94w6/bAn0OkWm0qlnUAFcNdmJWh+7O9JeS/DoFZlvdX+cyNAEsEacM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISY1BV6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISY1BV6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB918C4CECF;
	Tue,  3 Dec 2024 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239542;
	bh=dnQBWLH5WsqBRwrYt8M0wEiDOhRKvqr4cN1ob/LMVvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISY1BV6gQy/7JoZGUATwLvIdKzBQwhO4oj82VsZ9Qsgqe9/8hNkCbcajdwEQlNK5g
	 pTCtQEvRu0s8/0rf2Gf5+KNlS4DRgZ5x2R7dq5ZZCY1awnMy+E5gnqWDhChCIRPlWj
	 JMYErbgLbcyW5Ax9Y9SjPnV4TtcTEP5of/NRqtLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 608/817] counter: stm32-timer-cnt: Add check for clk_enable()
Date: Tue,  3 Dec 2024 15:43:00 +0100
Message-ID: <20241203144019.665824104@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 186e73d6ccb45..9c188d9edd89f 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -214,11 +214,17 @@ static int stm32_count_enable_write(struct counter_device *counter,
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
@@ -816,7 +822,11 @@ static int __maybe_unused stm32_timer_cnt_resume(struct device *dev)
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



