Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2189A24EF7A;
	Thu,  3 Apr 2025 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693968; cv=none; b=k33W7rAAE1q7Rkhi0G5Qm+0UjrPAOnC0f0iqaDG19LAPX/PrAuuyhGEPuIkwwM3yIZWzGFo4WLkf5BRBq0jMc6eGramRrqoNBKyNQOUfhCM1A1j8avyysvuz2b5ZfV4EwtLtG5LAI8F33Pw2rUX9/d54T7wWpMWoVunYJUhmuiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693968; c=relaxed/simple;
	bh=beNZAMnQiseOT2SOxwvpT6u2J0r/XFHSQV3xDJzAMpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s14EnwD0NShFB84TzybtS49gA4WXxqPsKxK+haIDNE+9wZijtk2nYb91F+FuEYr7XOsfOq1l6ZpmYjj36QptEMIGLuT2LL87O4IL34CEo6hZ2E63LwMKcSzwEnD8xFSc74rNjdTb+/1cD/J9gt+Id975B58ZjOIibGzR0p0kIjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FO2zWPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FO2zWPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE5EC4CEE3;
	Thu,  3 Apr 2025 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693968;
	bh=beNZAMnQiseOT2SOxwvpT6u2J0r/XFHSQV3xDJzAMpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FO2zWPLdPIe6UT8MprZSbAadv1Sj45R1IYWMZGGH0bnmcChEoWHIDgfz/zT1hJKt
	 uZeiAzCMNf/0SL2osV6H1XLqswGRCaKfHZn4evvR+WTEncMnVcQwlua6V8KUrjfc8r
	 K9svRsVWpj2s/Gi8yUlNqEE609LLLqUWMB4irEvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.13 09/23] counter: stm32-lptimer-cnt: fix error handling when enabling
Date: Thu,  3 Apr 2025 16:20:26 +0100
Message-ID: <20250403151622.543558538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 8744dcd4fc7800de2eb9369410470bb2930d4c14 upstream.

In case the stm32_lptim_set_enable_state() fails to update CMP and ARR,
a timeout error is raised, by regmap_read_poll_timeout. It may happen,
when the lptimer runs on a slow clock, and the clock is gated only
few times during the polling.

Badly, when this happen, STM32_LPTIM_ENABLE in CR register has been set.
So the 'enable' state in sysfs wrongly lies on the counter being
correctly enabled, due to CR is read as one in stm32_lptim_is_enabled().

To fix both issues:
- enable the clock before writing CMP, ARR and polling ISR bits. It will
avoid the possible timeout error.
- clear the ENABLE bit in CR and disable the clock in the error path.

Fixes: d8958824cf07 ("iio: counter: Add support for STM32 LPTimer")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20250224170657.3368236-1-fabrice.gasnier@foss.st.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/stm32-lptimer-cnt.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -58,37 +58,43 @@ static int stm32_lptim_set_enable_state(
 		return 0;
 	}
 
+	ret = clk_enable(priv->clk);
+	if (ret)
+		goto disable_cnt;
+
 	/* LP timer must be enabled before writing CMP & ARR */
 	ret = regmap_write(priv->regmap, STM32_LPTIM_ARR, priv->ceiling);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = regmap_write(priv->regmap, STM32_LPTIM_CMP, 0);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	/* ensure CMP & ARR registers are properly written */
 	ret = regmap_read_poll_timeout(priv->regmap, STM32_LPTIM_ISR, val,
 				       (val & STM32_LPTIM_CMPOK_ARROK) == STM32_LPTIM_CMPOK_ARROK,
 				       100, 1000);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = regmap_write(priv->regmap, STM32_LPTIM_ICR,
 			   STM32_LPTIM_CMPOKCF_ARROKCF);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
-	ret = clk_enable(priv->clk);
-	if (ret) {
-		regmap_write(priv->regmap, STM32_LPTIM_CR, 0);
-		return ret;
-	}
 	priv->enabled = true;
 
 	/* Start LP timer in continuous mode */
 	return regmap_update_bits(priv->regmap, STM32_LPTIM_CR,
 				  STM32_LPTIM_CNTSTRT, STM32_LPTIM_CNTSTRT);
+
+disable_clk:
+	clk_disable(priv->clk);
+disable_cnt:
+	regmap_write(priv->regmap, STM32_LPTIM_CR, 0);
+
+	return ret;
 }
 
 static int stm32_lptim_setup(struct stm32_lptim_cnt *priv, int enable)


