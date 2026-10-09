Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F26342173;
	Fri,  9 Oct 2026 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557527; cv=none; b=lCJtyVkKTmcXHoxmk02t4FO+iKsnKZ96ZV8EQJzlrbSddj4Ew6ULp2UxI+vDTs4c17VOpCiI4XnhkTJ66D8oPOxqbpZc8QyFW2zE4MoPDXo0VlF1TtaJKF/uaWTSoL/yfa1YAFvzzDN82zA2WC8PjECXFouukOB+XUK7k0RWDe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557527; c=relaxed/simple;
	bh=aCC7tvpqBcbXUPJm7uWjLO425tIXVwGKD/PpnolPiV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnUWJbK/Kp38wN4IxBXzIwJtwtXErkFeRcI0l/ougc7blTucsu4d0dg63X/ZWCG2NnFeJ0RjUUwSAg+YVScVogclmz+GUQZHi/E2mVwu+LHxX9rXk39AsYavrbkw42aY1VzhOiZAPfRPVZZ3Wq/7RUTZm6RM/uvWB0URleUby6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEbxgdI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEbxgdI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A41F000FF;
	Fri,  9 Oct 2026 14:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557526;
	bh=tpy3wkY7B5YAs7h1dtT4UH9VVntVg6/NH0Hn0JkcbPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEbxgdI3byYmt6BtcdpPG37X5T2UWSG+9xCdWPFbC5jYrDa+N4iAk4hnNJE/729qM
	 QherDur8KfCAK+/7uF8pgoWLVTyJKLLtZFv9huzxLowNbKXL1ld3l8ABjy27QUIdJf
	 ihASXBMpuK9CaffL8w3mSG2Hezf4NN/ZbLVmhSYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 389/428] iio: adc: stm32-adc: fix check on internal channel availability
Date: Fri,  9 Oct 2026 16:12:06 +0200
Message-ID: <20261009140954.745615327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2263,33 +2263,37 @@ static int stm32_adc_populate_int_ch(str
 
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


