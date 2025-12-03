Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF932E13D;
	Wed,  3 Dec 2025 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777029; cv=none; b=W57nrPVrRlpRV8bDbZAierG3XkHBN8qa/D9tXbVBGMi3oYAJKNIkyzfzxZWOxYRWgJdIbEK5Rl0Xs8gEJjfWIvDMBnkBu6vW2l0xRjd3XShhgbIwJHS+uBpyfDKCB4YOAqAKrjiClc1ruKmetx94hcleh3dOnimF2oiPkDnuxnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777029; c=relaxed/simple;
	bh=1LmRASerVQCwvDDIUYmlIBQLecCHJAwhrC6a7NnDESA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4JQyJC/JOi6F9nW/R7t9qZoDU3i3aF+g1OJ0eUs6WzlYgdcXNSh0R15MPhbCCRDCv3g8drFykiiU9KQn2VgY+M1Wm714iN9IPym6QTJpMEnjA8ueKqDWisoYudLT+2ViM+KqSHF5l0yxdkdtMmjaZECtaNG9faLn5eKHMH5UTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZsmyeX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZsmyeX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BEAC4CEF5;
	Wed,  3 Dec 2025 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777029;
	bh=1LmRASerVQCwvDDIUYmlIBQLecCHJAwhrC6a7NnDESA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZsmyeX2ZLegS4RYZVfNcBA2hSB9Y3e8Rq4pfHfaSe/XA9Hp3T3ozuBzSPdGCMOMd
	 XoSxmH/lE/5PVwVzV+NzjNM1hhEm77sTJnRsAY6eJYrLMZAxyp3i4s4K96BOXTN9jY
	 WeglD1vth6WPp6ojrp8CJkShwGJ9YIpxwtfPFJ4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Achim Gratz <Achim.Gratz@Stromeko.DE>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 060/146] iio: pressure: bmp280: correct meas_time_us calculation
Date: Wed,  3 Dec 2025 16:27:18 +0100
Message-ID: <20251203152348.665560360@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Achim Gratz <Achim.Gratz@Stromeko.DE>

commit 0bf1bfde53b30da7fd7f4a6c3db5b8e77888958d upstream.

Correction of meas_time_us initialization based on an observation and
partial patch by David Lechner.

The constant part of the measurement time (as described in the
datasheet and implemented in the BM(P/E)2 Sensor API) was apparently
forgotten (it was already correctly applied for the BMP380) and is now
used.

There was also another thinko in bmp280_wait_conv:
data->oversampling_humid can actually have a value of 0 (for an
oversampling_ratio of 1), so it can not be used to detect the presence
of the humidity measurement capability.  Use
data->chip_info->oversampling_humid_avail instead, which is NULL for
chips that cannot measure humidity and therefore must skip that part
of the calculation.

Closes: https://lore.kernel.org/linux-iio/875xgfg0wz.fsf@Gerda.invalid/
Fixes: 26ccfaa9ddaa ("iio: pressure: bmp280: Use sleep and forced mode for oneshot captures")
Suggested-by: David Lechner <dlechner@baylibre.com>
Tested-by: Achim Gratz <Achim.Gratz@Stromeko.DE>
Signed-off-by: Achim Gratz <Achim.Gratz@Stromeko.DE>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1042,13 +1042,16 @@ static int bmp280_wait_conv(struct bmp28
 	unsigned int reg, meas_time_us;
 	int ret;
 
-	/* Check if we are using a BME280 device */
-	if (data->oversampling_humid)
-		meas_time_us = BMP280_PRESS_HUMID_MEAS_OFFSET +
-				BIT(data->oversampling_humid) * BMP280_MEAS_DUR;
+	/* Constant part of the measurement time */
+	meas_time_us = BMP280_MEAS_OFFSET;
 
-	else
-		meas_time_us = 0;
+	/*
+	 * Check if we are using a BME280 device,
+	 * Humidity measurement time
+	 */
+	if (data->chip_info->oversampling_humid_avail)
+		meas_time_us += BMP280_PRESS_HUMID_MEAS_OFFSET +
+				BIT(data->oversampling_humid) * BMP280_MEAS_DUR;
 
 	/* Pressure measurement time */
 	meas_time_us += BMP280_PRESS_HUMID_MEAS_OFFSET +


