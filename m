Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF942512DE;
	Thu,  3 Apr 2025 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693839; cv=none; b=Xl5oYrt0sxIZ/fYYhzH597iVtFjSSTBoKNQP+MI+rBMf6auqx3yWN30QUU8dTpn12MZWdd4oyxhhce6eYzPrwSctnaqSAutyEPbHUfD9mEVkqB4axDCQHNojtZ48c9uK64zGo2oRFgAwIwgJjVdTRM+bhdONvyJY7G4j0WffLHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693839; c=relaxed/simple;
	bh=fS4dbSudEvTWbyGUtjMYKQW3Cu2jKCcGXjzDhtRyeg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fim1Uwi8W3quJMu8TLOX9PFCvDJ/nWNWkKUzsz+2I5JXZ/kqwFRakNmI84aTwEC2IKMhGbiKMm8+1YngwevKLXlxdO4Ea8G44mZAkJt7Et8ZUAMNs+EsJJNmkUnRncXWkoNFA088pS6FiL8I2evGfMK2QQtdiBC4BVADnz3WvQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hwg14mVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hwg14mVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA305C4CEE5;
	Thu,  3 Apr 2025 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693839;
	bh=fS4dbSudEvTWbyGUtjMYKQW3Cu2jKCcGXjzDhtRyeg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hwg14mVl9W3RuyJl62rgtsnQYn6qv6AalDbsQGfhcRAvKOgrP/UoO45rxYFBmU4oJ
	 Fk4e18F91fWX+U1++P7tD5RND+p7g3DE9Fl2tg35m7jBcrmgvCj8oPt7ooCCju2C+F
	 ++CHDCRd8GdfkAW/ADUif67wkkYu7VfG/Gwgh9Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.14 08/21] counter: stm32-lptimer-cnt: fix error handling when enabling
Date: Thu,  3 Apr 2025 16:20:12 +0100
Message-ID: <20250403151621.376612940@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


