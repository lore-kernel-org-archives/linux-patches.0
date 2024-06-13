Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E655B14386B;
	Thu, 13 Jun 2024 11:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279346; cv=none; b=juOiy3+QgB4K6z4vPHEawsJ4kKGU5pm/PpFt4yfzVCi51JTiMsQzO8EfJrXDlMMZFrLv5UB/p7xGc59N72Cvot5mlsMlPjLzY/j4Bba3iRqr1j1SpgOATLXveDqRan+13kCo/DsHI6I5siic9ZtWXybnJyWRZP2xmxrNVWTLbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279346; c=relaxed/simple;
	bh=6/L9qMaaEvyi3JvLAxJqu3Z2qauXRrtz4D7ltyPhRi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dnvk4zHUNe0NtB1QVh47l6BLY6Fb9Glq9X5r816ByFIW2vznXej5uxB4b661YapdDJe0ljUdwA/HwW/qFBbR/vdInUhMslpbR2qNv+ozeK7P4A/mE9AaGO93DuTa6DKGHJokrZ6QRk0yUwl986nlmw6j9DbeZWBTvY8CYl9/QFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0fIChAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0fIChAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6470CC2BBFC;
	Thu, 13 Jun 2024 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279345;
	bh=6/L9qMaaEvyi3JvLAxJqu3Z2qauXRrtz4D7ltyPhRi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0fIChAWQ4iTwR/DTTrjITFJWpOlWcv2HOSFQ+ZGzQO4JfgfSmOqB5OSb6T5XGlhG
	 pQvCxliRrBfrZ0TyuBi41iBwf5fiyjfuMP1TIJ/SHQ20nDievWtUcwY4dnKw26hSMy
	 8SuqHpnJEhahhST9yK5V+J6Y1beQcdi0rModHyFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 044/157] mmc: core: Add mmc_gpiod_set_cd_config() function
Date: Thu, 13 Jun 2024 13:32:49 +0200
Message-ID: <20240613113229.131871446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -221,6 +221,26 @@ int mmc_gpiod_request_cd(struct mmc_host
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
@@ -21,6 +21,7 @@ int mmc_gpiod_request_cd(struct mmc_host
 			 unsigned int debounce);
 int mmc_gpiod_request_ro(struct mmc_host *host, const char *con_id,
 			 unsigned int idx, unsigned int debounce);
+int mmc_gpiod_set_cd_config(struct mmc_host *host, unsigned long config);
 void mmc_gpio_set_cd_isr(struct mmc_host *host,
 			 irqreturn_t (*isr)(int irq, void *dev_id));
 int mmc_gpio_set_cd_wake(struct mmc_host *host, bool on);


