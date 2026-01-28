Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2898F313272;
	Wed, 28 Jan 2026 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615040; cv=none; b=nLU4xFaAT510UY2OikogsLi5yUel7p/CA7DWx7BCg68b2WvpMsdV281HAgPGpgszSblefGGqc40TOfCtI9hnrHyek1cqBqHt9Y4SA1ArC1CyMbgw/OQFpVWzVY1WW2FsJUwlocmbRszu37XDnlgdm+dbDmljB4p3IgrjdrjHXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615040; c=relaxed/simple;
	bh=RmaeVAdfQDJZDQCtwTRQ+mGHB9ir0AaIu5tpIXZF3Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJlkocryeY4hSfJOL4mvob0JNv1iPjxyjFkeE50LdBsgbuC0WDk/yoD48nVML/SbUMr0GaqyvnYU9BWjzN5tIlirYNv/h3TD3cK19pMa69gW3ea6Va7a0oU4OyyH3UkSkVZ66OUcjKcRh0bsHrM5FJxUKTjvob2t/Z1i3lnsGmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANjLXOmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANjLXOmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC39FC4CEF1;
	Wed, 28 Jan 2026 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615040;
	bh=RmaeVAdfQDJZDQCtwTRQ+mGHB9ir0AaIu5tpIXZF3Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANjLXOmcy4HaspmCjdQ7pposV0dipH22UVIrLDA8EQWWFP2vRhUXJzZCslaupMoCA
	 n42bQsgWmxWNL53MJroFpqhMdas4vOXqXAkq8xlxvAm19ybu3Cu+0WkNvpYpPqarpC
	 xlVsf8pAwvBbQIcNxSWSm/myNRND1LBoa6I2AQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/169] iio: adc: ad7280a: handle spi_setup() errors in probe()
Date: Wed, 28 Jan 2026 16:22:24 +0100
Message-ID: <20260128145336.208137769@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit 6b39824ac4c15783787e6434449772bfb2e31214 ]

The probe() function ignored the return value of spi_setup(), leaving SPI
configuration failures undetected. If spi_setup() fails, the driver should
stop initialization and propagate the error to the caller.

Add proper error handling: check the return value of spi_setup() and return
it on failure.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2051f25d2a26 ("iio: adc: New driver for AD7280A Lithium Ion Battery Monitoring System")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7280a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7280a.c b/drivers/iio/adc/ad7280a.c
index 37522dca2c7c8..01d5719aa3eac 100644
--- a/drivers/iio/adc/ad7280a.c
+++ b/drivers/iio/adc/ad7280a.c
@@ -1026,7 +1026,9 @@ static int ad7280_probe(struct spi_device *spi)
 
 	st->spi->max_speed_hz = AD7280A_MAX_SPI_CLK_HZ;
 	st->spi->mode = SPI_MODE_1;
-	spi_setup(st->spi);
+	ret = spi_setup(st->spi);
+	if (ret < 0)
+		return ret;
 
 	st->ctrl_lb = FIELD_PREP(AD7280A_CTRL_LB_ACQ_TIME_MSK, st->acquisition_time) |
 		FIELD_PREP(AD7280A_CTRL_LB_THERMISTOR_MSK, st->thermistor_term_en);
-- 
2.51.0



