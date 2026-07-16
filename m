Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B087426429;
	Thu, 16 Jul 2026 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211853; cv=none; b=fkcjPEfQn/xDucn8khk1I/qSQPjDMK87jTappxqmhK2z3MJjHF5tTcFAotlbKev0Az8ZsWul91EosCCjaOA/zhO2+KwIZscU9vCuEDyEBLJ2EzNhOW0QLiLQQ8TC2YHknhxAMNC8FXNC/h6D6nHjyDibrQVjdapyx9IX5d6ZTKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211853; c=relaxed/simple;
	bh=pzodht5uEc9JtqJeYfYLOxr6jUezzgdoddUH8YYzNZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai8v2udJPPBxFWUHp1E8TMZb4h7Cwf4AhIvNq5mfb+3biQXJxB2HMfiXpkzTq4ARGkZdtRN2/a7hSZ2RWh3q/z/MuV2tfbM3sGBkJcm/uR9TDV0NePtOyq/i2m1AfBm82OT0/Fhvmxw5/DpVyjTFSJYm2u3ndDboOrtcshoQhbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw5V68T6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw5V68T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D701F000E9;
	Thu, 16 Jul 2026 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211847;
	bh=CrxcbQlzam7N8WWcmNh/yk3PVHkyUtSR9EFZp5XhMjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pw5V68T6s2zEpnnBAi9xGETFzoprurq4/O+v5kpdcPsiYpPI8LyWDnQ30NSO2Q4ih
	 NPuaRVflu5ghtUyi2fJ5JtKaTW3Gz/WeU+UDQQAxpKeEIHVnv4TFxzCjJ/5pIqaj3j
	 Xnz2blncDMb/BOa/CAQ+n/fQPaU7U9Duqu4rLlLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 049/349] iio: adc: ti-ads124s08: Return reset GPIO lookup errors
Date: Thu, 16 Jul 2026 15:29:43 +0200
Message-ID: <20260716133034.420081821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 7dc4de2aa6316f1d044cde21f5acfec5f3ec6b47 upstream.

devm_gpiod_get_optional() returns NULL when the optional GPIO is absent,
but returns an ERR_PTR when the GPIO provider lookup fails, including
probe deferral.

Probe currently logs the ERR_PTR case as if the reset GPIO were simply
absent and keeps the error pointer in reset_gpio. Later ads124s_reset()
treats any non-NULL reset_gpio as a valid descriptor and passes it to
gpiod_set_value_cansleep().

Return the lookup error instead of retaining the ERR_PTR.

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Cc: stable@vger.kernel.org
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads124s08.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -321,7 +321,8 @@ static int ads124s_probe(struct spi_devi
 	ads124s_priv->reset_gpio = devm_gpiod_get_optional(&spi->dev,
 						   "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(ads124s_priv->reset_gpio))
-		dev_info(&spi->dev, "Reset GPIO not defined\n");
+		return dev_err_probe(&spi->dev, PTR_ERR(ads124s_priv->reset_gpio),
+				     "Failed to get reset GPIO\n");
 
 	ads124s_priv->chip_info = &ads124s_chip_info_tbl[spi_id->driver_data];
 


