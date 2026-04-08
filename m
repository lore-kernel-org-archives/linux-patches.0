Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6683328C87C;
	Wed,  8 Apr 2026 18:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673300; cv=none; b=rbFHts61NnLY6yofQxIX5baAevNUgSrSTqCAgYAFMM31HxamctHs6vhZ7dnAx6yMYjqOcR9InKCRPeCla/d/Xm6ZKNewX55kIpJ/TNSJWLngpHCCftDR4rOTCXeBsp0VQFX5jRjoFT6t5wV+M4EwWhsbabNV+sLIpChXTWAbv0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673300; c=relaxed/simple;
	bh=i/N0Cfs9VMJQlDSXS314qlbfF6jEkbRv+UEP+qKg4do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIGC394nfxMJjnFQQ6xjXuiQ8i93manguUhCjIMT7sDm4dR5O/sAIf9kRPlkUQR9uAflg/iV/MDA6Ba7MyQgIxGtSwC13y0F3shzhJoIkouok7qQAAupux6X9i+veWF+2Rx0YW7mwg7x0s5pGBX5vyG3c7cPiQZzhwCtTT6NWvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpFrJSYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpFrJSYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B458EC19421;
	Wed,  8 Apr 2026 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673300;
	bh=i/N0Cfs9VMJQlDSXS314qlbfF6jEkbRv+UEP+qKg4do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpFrJSYRkU++GEa+Rb3D7znvoiDW1IYc5UVcvzELItcblAKGZJR3Jtx3iyvAH5E08
	 oxRnlpD42En0cBOUlLpnSd4hoWOCqr/5zb3lHSfuNRKo1sVSG45ISny8O+PffE7Ggd
	 q3gTwKVthMosEPRFNr2PCXDfHudsC04fQmjOGOAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 177/277] iio: adc: ti-ads7950: do not clobber gpio state in ti_ads7950_get()
Date: Wed,  8 Apr 2026 20:02:42 +0200
Message-ID: <20260408175940.474859838@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit d20bbae6e5d408a8a7c2a4344d76dd1ac557a149 upstream.

GPIO state was inadvertently overwritten by the result of spi_sync(),
resulting in ti_ads7950_get() only returning 0 as GPIO state (or error).

Fix this by introducing a separate variable to hold the state.

Fixes: c97dce792dc8 ("iio: adc: ti-ads7950: add GPIO support")
Reported-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -427,13 +427,15 @@ static int ti_ads7950_set(struct gpio_ch
 static int ti_ads7950_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct ti_ads7950_state *st = gpiochip_get_data(chip);
+	bool state;
 	int ret;
 
 	mutex_lock(&st->slock);
 
 	/* If set as output, return the output */
 	if (st->gpio_cmd_settings_bitmask & BIT(offset)) {
-		ret = (st->cmd_settings_bitmask & BIT(offset)) ? 1 : 0;
+		state = st->cmd_settings_bitmask & BIT(offset);
+		ret = 0;
 		goto out;
 	}
 
@@ -444,7 +446,7 @@ static int ti_ads7950_get(struct gpio_ch
 	if (ret)
 		goto out;
 
-	ret = ((st->single_rx >> 12) & BIT(offset)) ? 1 : 0;
+	state = (st->single_rx >> 12) & BIT(offset);
 
 	/* Revert back to original settings */
 	st->cmd_settings_bitmask &= ~TI_ADS7950_CR_GPIO_DATA;
@@ -456,7 +458,7 @@ static int ti_ads7950_get(struct gpio_ch
 out:
 	mutex_unlock(&st->slock);
 
-	return ret;
+	return ret ?: state;
 }
 
 static int ti_ads7950_get_direction(struct gpio_chip *chip,


