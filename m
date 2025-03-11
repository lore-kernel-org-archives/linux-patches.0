Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F292E25D8E8;
	Tue, 11 Mar 2025 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705913; cv=none; b=GOm9avnY764KhOD/PdjZXnk2JCfzVdsT5pvqrVxxXRqxWbX0cROPPFfjfKyYLOZbcMsb0G4q8XM54h5Wbd3AD1CEockbqvDTVVMyBOCL/JYFISB0ClbS2ObYkD/+vviZsZ6lQ7e4ViJYAy64JpI0XEkXXP3RHSX7Yy2VUyoaYlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705913; c=relaxed/simple;
	bh=FzcLifCH+0ee7ooylg1DrdJp9ESu7nfD9XpEPWmtDiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlyBX8dkOWhxUPBWmmo0UFUuLFJvm3wGx3L7qGf5zAQeWSUAzlH4hWcWR2V+SSVLje45kwsxUUrJM5vDo6zwBgz7dXwrTcqFRToNVO0TjHZLviibTDmIl1qzTvTdKWNbJn7DuH9rnzJ8i+OQNL2B++owhDc50g23N9m1bDqGTao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHCX/xs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHCX/xs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1148AC4CEE9;
	Tue, 11 Mar 2025 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705912;
	bh=FzcLifCH+0ee7ooylg1DrdJp9ESu7nfD9XpEPWmtDiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHCX/xs7OLTyw543y4GwIxt5GE/IAWZNx4D1mY7CY+JX3SgtlTLZ+SbyaSzD9HygF
	 fDDKGxwLVQRTbuUGlItBW5U20hahYP0l9RHANZai+NKu88yg5Qz7zzEP01wktqoyNC
	 q6cdnetuL24fjDYBFZjmp+7IpB7hEZVdm17/hVLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.4 198/328] gpio: stmpe: Check return value of stmpe_reg_read in stmpe_gpio_irq_sync_unlock
Date: Tue, 11 Mar 2025 15:59:28 +0100
Message-ID: <20250311145722.773152011@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,7 +188,7 @@ static void stmpe_gpio_irq_sync_unlock(s
 		[REG_IE][CSB] = STMPE_IDX_IEGPIOR_CSB,
 		[REG_IE][MSB] = STMPE_IDX_IEGPIOR_MSB,
 	};
-	int i, j;
+	int ret, i, j;
 
 	/*
 	 * STMPE1600: to be able to get IRQ from pins,
@@ -196,8 +196,16 @@ static void stmpe_gpio_irq_sync_unlock(s
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
@@ -219,6 +227,7 @@ static void stmpe_gpio_irq_sync_unlock(s
 		}
 	}
 
+err:
 	mutex_unlock(&stmpe_gpio->irq_lock);
 }
 


