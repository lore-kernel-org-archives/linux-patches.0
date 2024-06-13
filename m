Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D2A1C32;
	Thu, 13 Jun 2024 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282922; cv=none; b=HfKCMJSDF7bHCDx4Sl7huZGWxb9Fd6eAqzTMgmx0Ha9psMIZNPFQFudMAz2bmqxF/hbhX6kRxl/b8S1PYiS6HZ3rrJ4DqdTWvFkK4eqI9TV4EfAugUqoGMn4pZdXG2f+pAUN+WcSbaCbbIzoyJU7ZfMbZng+ss7tJApwQ72G/ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282922; c=relaxed/simple;
	bh=ucFYpo5HWIT8gyA/m9LSCCa51EEWgWIfSl0rXVFCQOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q89qbo+B/vHAWP0iQwoKwNaKjIMLkZRwy8ffXz6IhvsU5nKKG8wXPZwPKREhZW5SUaYujiC9dxvVrN05AEYeoxKgSg3Ky/I2OGWhHr/GqqNOs+m9VUaautuoxvkZ36coxqlSLGIzQKJ4j0bmNDriivz+QqLkMPpri3bPyngn+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ux2sO5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ux2sO5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5417BC2BBFC;
	Thu, 13 Jun 2024 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282922;
	bh=ucFYpo5HWIT8gyA/m9LSCCa51EEWgWIfSl0rXVFCQOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ux2sO5KVb9pFa8o6mbHhlI5dr6QupH8ASyukmSkDj3j0a0uLYsiQZDflPaZ8QYhW
	 Z/Jk8NMUZL6djVF4LshMpq6ZGYchgwlsqNPdciDk8MuXgmhkt9uBdBKCw6iAGNflpe
	 e53WdEUyowwlG8bxwPDZ8YH/9mi5U8prvXOdu5+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 38/85] mmc: core: Add mmc_gpiod_set_cd_config() function
Date: Thu, 13 Jun 2024 13:35:36 +0200
Message-ID: <20240613113215.619288403@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 63a7cd660246aa36af263b85c33ecc6601bf04be upstream.

Some mmc host drivers may need to fixup a card-detection GPIO's config
to e.g. enable the GPIO controllers builtin pull-up resistor on devices
where the firmware description of the GPIO is broken (e.g. GpioInt with
PullNone instead of PullUp in ACPI DSDT).

Since this is the exception rather then the rule adding a config
parameter to mmc_gpiod_request_cd() seems undesirable, so instead
add a new mmc_gpiod_set_cd_config() function. This is simply a wrapper
to call gpiod_set_config() on the card-detect GPIO acquired through
mmc_gpiod_request_cd().

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410191639.526324-2-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/slot-gpio.c  |   20 ++++++++++++++++++++
 include/linux/mmc/slot-gpio.h |    1 +
 2 files changed, 21 insertions(+)

--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -206,6 +206,26 @@ int mmc_gpiod_request_cd(struct mmc_host
 }
 EXPORT_SYMBOL(mmc_gpiod_request_cd);
 
+/**
+ * mmc_gpiod_set_cd_config - set config for card-detection GPIO
+ * @host: mmc host
+ * @config: Generic pinconf config (from pinconf_to_config_packed())
+ *
+ * This can be used by mmc host drivers to fixup a card-detection GPIO's config
+ * (e.g. set PIN_CONFIG_BIAS_PULL_UP) after acquiring the GPIO descriptor
+ * through mmc_gpiod_request_cd().
+ *
+ * Returns:
+ * 0 on success, or a negative errno value on error.
+ */
+int mmc_gpiod_set_cd_config(struct mmc_host *host, unsigned long config)
+{
+	struct mmc_gpio *ctx = host->slot.handler_priv;
+
+	return gpiod_set_config(ctx->cd_gpio, config);
+}
+EXPORT_SYMBOL(mmc_gpiod_set_cd_config);
+
 bool mmc_can_gpio_cd(struct mmc_host *host)
 {
 	struct mmc_gpio *ctx = host->slot.handler_priv;
--- a/include/linux/mmc/slot-gpio.h
+++ b/include/linux/mmc/slot-gpio.h
@@ -20,6 +20,7 @@ int mmc_gpiod_request_cd(struct mmc_host
 			 unsigned int debounce);
 int mmc_gpiod_request_ro(struct mmc_host *host, const char *con_id,
 			 unsigned int idx, unsigned int debounce);
+int mmc_gpiod_set_cd_config(struct mmc_host *host, unsigned long config);
 void mmc_gpio_set_cd_isr(struct mmc_host *host,
 			 irqreturn_t (*isr)(int irq, void *dev_id));
 int mmc_gpio_set_cd_wake(struct mmc_host *host, bool on);


