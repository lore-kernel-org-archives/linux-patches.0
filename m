Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B85311964;
	Wed,  3 Dec 2025 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776113; cv=none; b=eTPP3T+jku21S2d292RL9udpBuigjTPQLFj5Qr1G8twtyQbqS/JRIcbUyptnafl/4jKR/j2Ew/owLz6b+YPUfTnOr/I1GT1jrFCLgufg6D6xaBs6S01V2NSpURsw8duqbok9NsLaI7FlStEvzkS77v3PqRUMiCZP53fTEAzkYDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776113; c=relaxed/simple;
	bh=nM0e8jd9fybngWNv8K7ebKtaZ5iSNIlbIU88XRqm2Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFDB+qeqOeqYmGy773bk71vKaIE/N7wA/+RHiMH34tYAjet8eNDcja7Vwj091mPoxJMO5MS0Jp/iMr5rcsIDidDfg/fWdxtGp1WNVur5VT+ZN1aaPOQZ/KrrIQX8jbR4iEkXlyN/imDgfY8FNHqkyZps4B14VeKGyMens9wH0Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JflN+E/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JflN+E/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B8FC4CEF5;
	Wed,  3 Dec 2025 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776113;
	bh=nM0e8jd9fybngWNv8K7ebKtaZ5iSNIlbIU88XRqm2Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JflN+E/hbBJ1kwBrUFOzARR3Asey3j3/hvl6j5zKtVCus/mc0gNJB1nyUFpX3EZDJ
	 MH+stuMhj46kvOJKiP9aAPSYZCnLZC/bs1+bFVv0RJDifUbinX0WHI47hEWAZjtR0+
	 6dlkOXJ9GXTWYdyifxdooydj5BIFXb0O9nZygGWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/300] iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register
Date: Wed,  3 Dec 2025 16:24:48 +0100
Message-ID: <20251203152403.736995739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1bc986a7009d2..4d4aff88aa6ce 100644
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



