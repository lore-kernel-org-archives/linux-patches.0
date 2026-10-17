Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367C8391E51;
	Sat, 17 Oct 2026 17:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256749; cv=none; b=V8LTUw5yVfczhD4tQ6t3WtLBbeGViUggIKadw55Z4Q3fabbNJZRWv0AT8yImPg4N+5FT8V3rNXgiCqTol0XPCj6Uz7xNE/SovcZAXgJs/2b4xyVbmFe51LytR6FDBQFOcnGjzyAAaxJMD9Zv4+Zsrhi+onlbaNMSItWwtCCb/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256749; c=relaxed/simple;
	bh=+J2C28gHhY68GJTB2Y0thPVwPSue2hLSfuI2veAj8aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlQLua4dgA4ylmpSIAMWm3QlK0m6g1LkU3mcG1MYtJdNMcES+9OwoGuw5+laF+dNj9kVjacTeROwu1IOadAEX2LzhgqVlggDKVIS8Wn127f8AwJKiAPpBc7mvf/lXsqE5HwJxfmA3Co/xFCpt5bQPJ7rPfyj0vmFXWfLDJ7vPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT0S+cMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT0S+cMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF201F000C4;
	Sat, 17 Oct 2026 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256748;
	bh=Z0itSfJ7SU1VYuaSLV1yo8sedw69eeuMECr3I7xFPik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uT0S+cMNaQx4aJaH9l7NnpQ21DTiJtN6Svq8QHVM38x34VhkdM09mBl33D8nj8vSz
	 dsNaykpP6JVtauk5znyGEMyyEdqZztn2ESYBLKzmkEA0gmbleoBjL96okIH550tnEp
	 N0dz2qyWiKaJt6Vfd3fijSDF0JsLhZs9YQn/X5bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0337/1674] iio: adc: stm32-adc: fix check on internal channel availability
Date: Sat, 17 Oct 2026 17:43:29 +0200
Message-ID: <20261017160439.776889175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


