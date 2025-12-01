Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895382E62A2;
	Mon,  1 Dec 2025 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588468; cv=none; b=FfNxC2f86I05mYqskH1t6PtMzgUKq8oeHJCiSmiVojKzdibHh5su1oyaLgOGqg5b3wEjxfPkt88xVZjramn66QLbC5zeGOIdIHwz05/NS433Xqwh0ExHIjGesUvhJM6vArS2ez8A0JikQZElAHqqgDuhR08SAMFsPsN0TVcg/Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588468; c=relaxed/simple;
	bh=2ZHeaRSDEnVuEhiXGtZ3kJmr2M72XXfmFFUpCeGYizw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OY1wXvrYzM494vd2paKpShQD6I2ylFC79pLO3eS9cAqaXw1AXz+dbztniKfYsSMr3UgBMo6SwlSkIHxGeT+0lZAaKj/4cNRbDjohYWscX4dE9su2EbCopWbUQ0EltbMpC+2+u+vlXZ2aKQEWHeSjeCT6kDDgMMsNnJaGorC7x4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H79tq5qR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H79tq5qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66C0C4CEF1;
	Mon,  1 Dec 2025 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588467;
	bh=2ZHeaRSDEnVuEhiXGtZ3kJmr2M72XXfmFFUpCeGYizw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H79tq5qRXQksacVjKL1CootblgTTU6i+dOHye8F/D1cojyQbUnvr1ECFt9b+IWDgm
	 GacGiVOHkeRxUj2mqlUYKHouZFkq4WrXvXAl2Fr09PxEwFzI+AegrABxA8663wobDY
	 FSEUVl+Pc1Hcha/gI2LrOLOi7jQ7qAJnbzFUQ/wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/187] iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register
Date: Mon,  1 Dec 2025 12:22:47 +0100
Message-ID: <20251201112243.374510854@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit d75c7021c08e8ae3f311ef2464dca0eaf75fab9f ]

avg sample info is a bit field coded inside the following
bits: 5,6,7 and 8 of a device status register.

Channel num info the same, but over bits: 1, 2 and 3.

Mask both values in order to avoid touching other register bits,
since the first info (avg sample), came from DT.

Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250717221559.158872-1-rodrigo.gobbi.7@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/spear_adc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/spear_adc.c b/drivers/iio/adc/spear_adc.c
index 592b97c464dac..f2c4d590de0a0 100644
--- a/drivers/iio/adc/spear_adc.c
+++ b/drivers/iio/adc/spear_adc.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/completion.h>
@@ -29,9 +30,9 @@
 
 /* Bit definitions for SPEAR_ADC_STATUS */
 #define SPEAR_ADC_STATUS_START_CONVERSION	BIT(0)
-#define SPEAR_ADC_STATUS_CHANNEL_NUM(x)		((x) << 1)
+#define SPEAR_ADC_STATUS_CHANNEL_NUM_MASK	GENMASK(3, 1)
 #define SPEAR_ADC_STATUS_ADC_ENABLE		BIT(4)
-#define SPEAR_ADC_STATUS_AVG_SAMPLE(x)		((x) << 5)
+#define SPEAR_ADC_STATUS_AVG_SAMPLE_MASK	GENMASK(8, 5)
 #define SPEAR_ADC_STATUS_VREF_INTERNAL		BIT(9)
 
 #define SPEAR_ADC_DATA_MASK		0x03ff
@@ -148,8 +149,8 @@ static int spear_adc_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&indio_dev->mlock);
 
-		status = SPEAR_ADC_STATUS_CHANNEL_NUM(chan->channel) |
-			SPEAR_ADC_STATUS_AVG_SAMPLE(st->avg_samples) |
+		status = FIELD_PREP(SPEAR_ADC_STATUS_CHANNEL_NUM_MASK, chan->channel) |
+			FIELD_PREP(SPEAR_ADC_STATUS_AVG_SAMPLE_MASK, st->avg_samples) |
 			SPEAR_ADC_STATUS_START_CONVERSION |
 			SPEAR_ADC_STATUS_ADC_ENABLE;
 		if (st->vref_external == 0)
-- 
2.51.0



