Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD22330B1F;
	Tue, 11 Nov 2025 01:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823362; cv=none; b=PaK0Z0kmEv/66ZBfX4hKMV43/pcKiv/mdd+ylexiMjkF898sCdDrv5x+lMKamiUX5ZWT2k0a3e1FgIPgEeFpz5pCbOKsLXO3sgD4qpj7K3HFOuNBZL5JRHNqBrLl92bTuhDDha6G0H05M26/fhxRZyYib7/FLo71CnHJcRIJ50Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823362; c=relaxed/simple;
	bh=1iPYQACMc+UECu9iugUf2DOPCeQmbQWEVs8KVeX8BLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMCQD0GcB7suwpTCeGT1erz5eRp0iYabptmSXlqLNixKdmwpGebnNL5FCoXo2FMkXM+LtCilEOLI1sGBXLdtk2hhBQ3Xknkubf1vXwUow8eRf2QXNcFWRh8R3lEtrRmQOv74/jZe8CFChLC+T3sdY27mOGZc7yn0oYB9akOD+IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAtpJl6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAtpJl6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49B5C113D0;
	Tue, 11 Nov 2025 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823362;
	bh=1iPYQACMc+UECu9iugUf2DOPCeQmbQWEVs8KVeX8BLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAtpJl6xFymmB7HKui4aVBTZzhChU34FFC7OiginBTk2K1NafOepjBKdY3wBERgMt
	 DKY+CBeoj76fWt+4WJEjG2ME9oH28LLtdo7OpzkOgZ9HJmGCP2C/4zxy1i9ygC7Dp9
	 O6hXxfcU86WdfwfEdU/r9Ga3nWT7GSxkGEAGlnSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/565] iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register
Date: Tue, 11 Nov 2025 09:41:23 +0900
Message-ID: <20251111004532.025172121@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index b6dd096391c11..39c383631a595 100644
--- a/drivers/iio/adc/spear_adc.c
+++ b/drivers/iio/adc/spear_adc.c
@@ -14,6 +14,7 @@
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
@@ -157,8 +158,8 @@ static int spear_adc_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&st->lock);
 
-		status = SPEAR_ADC_STATUS_CHANNEL_NUM(chan->channel) |
-			SPEAR_ADC_STATUS_AVG_SAMPLE(st->avg_samples) |
+		status = FIELD_PREP(SPEAR_ADC_STATUS_CHANNEL_NUM_MASK, chan->channel) |
+			FIELD_PREP(SPEAR_ADC_STATUS_AVG_SAMPLE_MASK, st->avg_samples) |
 			SPEAR_ADC_STATUS_START_CONVERSION |
 			SPEAR_ADC_STATUS_ADC_ENABLE;
 		if (st->vref_external == 0)
-- 
2.51.0



