Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C84ED1A2;
	Tue, 13 Oct 2026 12:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895449; cv=none; b=KB3mUbcyhiUXxkTUXOB9CvLdqDFyAUzW0pwMvzgLgTuPfmYnKtoTMhsNz0ft27/op1lVOjX9MLQd1ScMB/IgChxXTnmZrpSGIKR0Q019/XDAI2cYaEg/wd9g5ruY1jfBXVPCo0Y7dIqqUrA2kc9pzLscQq6fln/9S/bHTWuBF38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895449; c=relaxed/simple;
	bh=LZ5UVL9GNojB6wMgbsdKDW12QoRaXZoKDLG5WJMQbGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2uRx8sXo7aaFmvs3NVFGrz+5EvA1/nl3hKveUE+ACJHBkTgC658+x77M6iex+BSdxaJhSyPMMA7siPkrXED6qTGK9n8mQ/VFQkz1q1AD+COiat1NT2+uNboHqhYtxriH+TFNDZ87Exy1B+7bSWgeJu5MGKp/kvWKbJ+H+TckCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx5zY2bV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx5zY2bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221261F000FF;
	Tue, 13 Oct 2026 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895447;
	bh=o8QumJyoEE2H2rPCBVVnzJjyM6svSYUsbqcSoYaKcBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bx5zY2bVgKDO1qKWpgWeCpqXQHOz6AicjIa20xTLN2LoB/ccfxcxJY6vs4V2lvFjy
	 cxXvKabi8tX7mssbUYpryi4tyJd2OIcUQqlqQLssJiKAHnvfwnokU7KL5Gam9FfY0n
	 WoDapbs8G/hV5pu6wDPIV+Dj+gB91A0/2jHbf9ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 234/497] iio: adc: stm32-adc: fix check on internal channel availability
Date: Tue, 13 Oct 2026 13:36:41 +0200
Message-ID: <20261013112913.451900661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 9db3deeb2de485a9d412f0825f9ab4c8e2bccf44 upstream.

If an unsupported internal channel like vddgpu is requested, the driver
prints a warning but falls through and assigns it a valid int_ch below.

This causes a problem later during setup:
stm32_adc_int_ch_enable() {
    ...
    case STM32_ADC_INT_CH_VDDGPU:
        stm32_adc_set_bits(adc, adc->cfg->regs->or_vddgpu.reg,
                           adc->cfg->regs->or_vddgpu.mask);
    ...
}

Because the register offset is uninitialized (0), this performs a
read-modify-write on offset 0, which corresponds to the ISR register.

Fix this by returning before a valid int_ch is assigned. Choice is
made to keep current driver behavior to warn about the channel name.

Fixes: cf0fb80ae167 ("iio: adc: stm32-adc: add stm32mp13 support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260911162602.D323F1F000FF@smtp.kernel.org/
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2127,33 +2127,37 @@ static int stm32_adc_populate_int_ch(str
 
 	for (i = 0; i < STM32_ADC_INT_CH_NB; i++) {
 		if (!strncmp(stm32_adc_ic[i].name, ch_name, STM32_ADC_CH_SZ)) {
+			bool na;
+
 			/* Check internal channel availability */
 			switch (i) {
 			case STM32_ADC_INT_CH_VDDCORE:
-				if (!adc->cfg->regs->or_vddcore.reg)
-					dev_warn(&indio_dev->dev,
-						 "%s channel not available\n", ch_name);
+				na = !adc->cfg->regs->or_vddcore.reg;
 				break;
 			case STM32_ADC_INT_CH_VDDCPU:
-				if (!adc->cfg->regs->or_vddcpu.reg)
-					dev_warn(&indio_dev->dev,
-						 "%s channel not available\n", ch_name);
+				na = !adc->cfg->regs->or_vddcpu.reg;
 				break;
 			case STM32_ADC_INT_CH_VDDQ_DDR:
-				if (!adc->cfg->regs->or_vddq_ddr.reg)
-					dev_warn(&indio_dev->dev,
-						 "%s channel not available\n", ch_name);
+				na = !adc->cfg->regs->or_vddq_ddr.reg;
 				break;
 			case STM32_ADC_INT_CH_VREFINT:
-				if (!adc->cfg->regs->ccr_vref.reg)
-					dev_warn(&indio_dev->dev,
-						 "%s channel not available\n", ch_name);
+				na = !adc->cfg->regs->ccr_vref.reg;
 				break;
 			case STM32_ADC_INT_CH_VBAT:
-				if (!adc->cfg->regs->ccr_vbat.reg)
-					dev_warn(&indio_dev->dev,
-						 "%s channel not available\n", ch_name);
+				na = !adc->cfg->regs->ccr_vbat.reg;
 				break;
+			default:
+				return -EINVAL;
+			}
+
+			if (na) {
+				/*
+				 * Channel label matches an internal STM32 ADC channel.
+				 * Warn about it, as there's normally no restriction on the
+				 * name but that's not among available internal channels.
+				 */
+				dev_warn(&indio_dev->dev, "no %s internal channel\n", ch_name);
+				return 0;
 			}
 
 			if (stm32_adc_ic[i].idx != STM32_ADC_INT_CH_VREFINT) {


