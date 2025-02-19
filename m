Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25431E1A17;
	Wed, 19 Feb 2025 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955704; cv=none; b=hKxm9Nbe5r0EGJJHnj0V1iEESLZpiHhzuxdvvUpAc7pS0jK/HUKrrxzzWu+zEE1GTwiSffoGRmPltDo7+5EhvijQOX2i4U913PjvWellOMdixxUQj29G6rC6TIcD8EoSMwiSgZEvDxiJS1vHOYu4Ii7sJTKNA1K8Od1GwIx7sCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955704; c=relaxed/simple;
	bh=3zZKjPOCn43cTe1fCxi3saeG20pa4jBxYpux7cfrA/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYQHI3Ts8CmBo18MXMWHDVM2Mhztn7JFewBsQ7n4unsrMTk5m2h9aNXsq5fxW+tE+MszqRx9a0DNdEfJSly2AecH4bmeIT8L1XA2W/rl++cFwLAoWHTYUnViLtYnkCOB+CQ0WtEfrJ5t2ZEEaLGPRuWSN42hpQ5d+ORekXBl+6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSn7oZU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSn7oZU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AC3C4CED1;
	Wed, 19 Feb 2025 09:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955704;
	bh=3zZKjPOCn43cTe1fCxi3saeG20pa4jBxYpux7cfrA/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSn7oZU3oZ6JpTVbjTNHzn11h2Hc7RVdVc+DxQu911FGosh1h4R7reFP6Ce7HLd/P
	 SaXor6I5zUW4MiKUyYeWxKBqa7pDqkFZvpgxA8HptTQ9Cjw6s9QMEFyIZSuaF55fuI
	 sc+VHtms1Ad8aEVas1xuuuSKe7+CSQTer6DguU+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 088/152] gpio: stmpe: Check return value of stmpe_reg_read in stmpe_gpio_irq_sync_unlock
Date: Wed, 19 Feb 2025 09:28:21 +0100
Message-ID: <20250219082553.535785884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit b9644fbfbcab13da7f8b37bef7c51e5b8407d031 upstream.

The stmpe_reg_read function can fail, but its return value is not checked
in stmpe_gpio_irq_sync_unlock. This can lead to silent failures and
incorrect behavior if the hardware access fails.

This patch adds checks for the return value of stmpe_reg_read. If the
function fails, an error message is logged and the function returns
early to avoid further issues.

Fixes: b888fb6f2a27 ("gpio: stmpe: i2c transfer are forbiden in atomic context")
Cc: stable@vger.kernel.org # 4.16+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20250212021849.275-1-vulab@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-stmpe.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -191,7 +191,7 @@ static void stmpe_gpio_irq_sync_unlock(s
 		[REG_IE][CSB] = STMPE_IDX_IEGPIOR_CSB,
 		[REG_IE][MSB] = STMPE_IDX_IEGPIOR_MSB,
 	};
-	int i, j;
+	int ret, i, j;
 
 	/*
 	 * STMPE1600: to be able to get IRQ from pins,
@@ -199,8 +199,16 @@ static void stmpe_gpio_irq_sync_unlock(s
 	 * GPSR or GPCR registers
 	 */
 	if (stmpe->partnum == STMPE1600) {
-		stmpe_reg_read(stmpe, stmpe->regs[STMPE_IDX_GPMR_LSB]);
-		stmpe_reg_read(stmpe, stmpe->regs[STMPE_IDX_GPMR_CSB]);
+		ret = stmpe_reg_read(stmpe, stmpe->regs[STMPE_IDX_GPMR_LSB]);
+		if (ret < 0) {
+			dev_err(stmpe->dev, "Failed to read GPMR_LSB: %d\n", ret);
+			goto err;
+		}
+		ret = stmpe_reg_read(stmpe, stmpe->regs[STMPE_IDX_GPMR_CSB]);
+		if (ret < 0) {
+			dev_err(stmpe->dev, "Failed to read GPMR_CSB: %d\n", ret);
+			goto err;
+		}
 	}
 
 	for (i = 0; i < CACHE_NR_REGS; i++) {
@@ -222,6 +230,7 @@ static void stmpe_gpio_irq_sync_unlock(s
 		}
 	}
 
+err:
 	mutex_unlock(&stmpe_gpio->irq_lock);
 }
 


