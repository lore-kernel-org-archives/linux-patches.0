Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827861F12F7;
	Tue,  3 Dec 2024 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242095; cv=none; b=UNxeAi7g1vazO5hSQ8Dvc3h0RYOibsgHRLdjHy4v9vc3EbvWcjDqZQ8TQPffnETdyw96DEl4IzsooyiSgWGsCeCrtjHt7aQ8RO3yPupOrNrl0W7Cq6sSYv5uLcIUmXB+c2cglgIlhz1hMW3Ri5uQ7WnP6RSi6bnLdmM2oVS/HLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242095; c=relaxed/simple;
	bh=CtVHV8W9QN5zWTwzwNd/MMKnboFooHU2VHCPvffFFy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvpQpbNXbGdB/1dVUo9etQ1Yr7WIYYDeE+Fd20OyK22gKAsBub60JuG5zieYFA5nMd8M2icN+mc6BFQhAwSW4H1RfjRKRe/E3R2eJj27y6lHhLAjR/smg8x2mBpfO7vttlTlJzqJytNTSwSGe99h1kPuQlsj58ukQHZs2Pfxm1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBEeIZwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBEeIZwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47BEC4CEDE;
	Tue,  3 Dec 2024 16:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242095;
	bh=CtVHV8W9QN5zWTwzwNd/MMKnboFooHU2VHCPvffFFy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBEeIZwanV3oqYPoq6DJ/XacB3R0kIWcLVVUf6CPA14EtbAv+HD0NgZjPaEVRfn0J
	 ZDSEzOa1Zttfgv9TFrvPQ/gIE1WXcJ58EFYICMCS8pkiUakNXBi6aNFcbcME5SnwNW
	 8Rg4UeO8MDfdeDAoEPyaBb/eQzzA+1IaTGSnKSMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 606/826] counter: stm32-timer-cnt: Add check for clk_enable()
Date: Tue,  3 Dec 2024 15:45:33 +0100
Message-ID: <20241203144807.393267225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



