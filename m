Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B9F436342;
	Tue, 21 Jul 2026 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665005; cv=none; b=Dbyp90o/W3c19s7TUDfOV65sL0CBNt5MKFa4rdeqPKeMzS6kUptlKwdnd0tEnwC5hmX6jEUsRYYqgDFm9Yr2c4utN7kU6mBdp3Sfe9Lga7oK0Maxngx4/5jzOO6cJs6ZoeLbij8XwriqHLSYJQN+6Ol3+L5/ld2q9jUEh14phNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665005; c=relaxed/simple;
	bh=ndh+iXlgHyP0T5P7dxK04IbGdxuhpGhmdncWdmQiaLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia5UXnu5pmpwlnF3PQpKIRVekA/Oa6losRgdYAFcnpigz980Pz+lPkjOn1qYWoC6M1Ih//F5ub7KLQo+t/gollOEdZxAJAfzYQNMVzMfB2s189v0OO+HOgMdpRr6pk8HbLTHdOTKK4qenB2IfWeHIk2J1GBp88emYAgo9+cMUrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4iJZwpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4iJZwpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAF21F000E9;
	Tue, 21 Jul 2026 20:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665002;
	bh=Nyqsuw/KTVg/2pDi/90dZZlR7Ci5qzmNWTrrfMLv18A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4iJZwpM7WglXwLIj5Qmr5qKQe/93n4MxLLmYPydu2Z0/VJX18zmIBc658Ce5+HJx
	 X95ZzdKqlBX5dgAuwXlKQATSCM6rwCuXonqsWUgmKGnB8jtIZR/Sjc6S59Rom5cNWS
	 b6oFsWkwaWg0utR/yCTjxs916J0BtTUUp1Fk94Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0087/1266] iio: adc: ti-ads124s08: Return reset GPIO lookup errors
Date: Tue, 21 Jul 2026 17:08:44 +0200
Message-ID: <20260721152443.748981446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -322,7 +322,8 @@ static int ads124s_probe(struct spi_devi
 	ads124s_priv->reset_gpio = devm_gpiod_get_optional(&spi->dev,
 						   "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(ads124s_priv->reset_gpio))
-		dev_info(&spi->dev, "Reset GPIO not defined\n");
+		return dev_err_probe(&spi->dev, PTR_ERR(ads124s_priv->reset_gpio),
+				     "Failed to get reset GPIO\n");
 
 	ads124s_priv->chip_info = &ads124s_chip_info_tbl[spi_id->driver_data];
 


