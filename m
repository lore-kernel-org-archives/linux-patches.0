Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D328269D18;
	Tue,  8 Apr 2025 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111604; cv=none; b=GVyhalw4wrx1to0SV5q8yReR0AE1qnrLZDmXaOHGCGQ7HEYaDTOUvKWIIBjls6gXzL3Xmx/GM7Kmg+SVr+8PceNDdoNPNGfzRIOr4cEwkjUmxqmb/904DABM7rjgfGCzPGTa2mSBlfU9nCHR+FooP5ixe2oJ1NuELk6j/lPrQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111604; c=relaxed/simple;
	bh=/D9D2MQqdTeTRdPXDe5x3k0OsmHaGshHWxVoL6jLs/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTAv/W3FkXGgOsFuJw/5JGgmErdpeEGEOwo41jWJ3F2LfPnZJK4dPJ5a306xEmK1P2TP+JlfLj3FRqRd0mPJm4ModHrbDkI/QtTIPAqJTUlJ7/M1iAxu8Ej780EdyY4Hq3+MvETgO5lDZsJfCjQweqg4QvbWsoXbwwpLgtnA9pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rw6Q+5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rw6Q+5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C744AC4CEF3;
	Tue,  8 Apr 2025 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111604;
	bh=/D9D2MQqdTeTRdPXDe5x3k0OsmHaGshHWxVoL6jLs/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rw6Q+5bdsPpM0b5t+97cDaAtmFxv9vhYOdSiWvjbDCxqukyo3BvRebwVMknmNWcf
	 FcZhWV4+qjYiIhug1b7JroMKK8zkuXQTK+LmPk/Py7JnvabbbtZDjKhwVsZIzd4i2e
	 KWCI1AiYVR3OtO0x2/vk4udL5DEfbaQYc7wkI1C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 491/731] iio: adc: ad_sigma_delta: Disable channel after calibration
Date: Tue,  8 Apr 2025 12:46:28 +0200
Message-ID: <20250408104925.696754760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit fb3a0811a7bc12d51cba4b75d6b123ab62e2fe4d ]

The function ad_sd_calibrate() enables the channel to calibrate at
function entry but doesn't disable it on exit. This is problematic
because if two (or more) channels are calibrated in a row, the second
calibration isn't executed as intended as the first (still enabled)
channel is recalibrated and after the first irq (i.e. when the
calibration of the first channel completed) the calibration is aborted.

This currently affects ad7173 only, as the other drivers using
ad_sd_calibrate() never have more than one channel enabled at a time.

To fix this, disable the calibrated channel after calibration.

Fixes: 031bdc8aee01 ("iio: adc: ad7173: add calibration support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250303114659.1672695-11-u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index d5d81581ab340..77b4e8bc47485 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -339,6 +339,7 @@ int ad_sd_calibrate(struct ad_sigma_delta *sigma_delta,
 out:
 	sigma_delta->keep_cs_asserted = false;
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
+	ad_sigma_delta_disable_one(sigma_delta, channel);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->controller);
 
-- 
2.39.5



