Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F52F34A77E;
	Wed,  3 Dec 2025 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777667; cv=none; b=M8qUde7cgdW8VeM0cqz/igB9AgQWfDNNGvCwrosUy+RtqHQmbHtac61lQk+F9+1D9xomd8nCzhssjA5MO1+zNt5mM/1RrOcRByxBu3uFjVnFOKFbtSgIDjTX56OUxTAdGvqLNtdUeg9ydZJjZ2BZzw5sz1XTbkCynUt5T2N/XQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777667; c=relaxed/simple;
	bh=WAJndhheaQWhDobcJqDngIqhlsW5EkT/lpfAbnnkTmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE1vRclxr2jr3336HJw6V1iky2fHNVyIFGc1gNLtlQp+a6bVTkxWWdV7nxumNlvPsoAAzQWZ9OItz6K90wzR3FchFNrmQYgblAOMw/W/Q+JkhObxpyl3/XTWXT5CMztuFce208FaMj58oQvVTG/Bhr1PCf2xkWrN2J54N7EpiFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFtjzu1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFtjzu1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DE3C4CEF5;
	Wed,  3 Dec 2025 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777667;
	bh=WAJndhheaQWhDobcJqDngIqhlsW5EkT/lpfAbnnkTmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFtjzu1uD1SKYEf8KIIAW2NdBbZKzDz/zoBiEPd9+vCk9f/bgMsz4K8E6cQh1YCWJ
	 RtdIWsrbIEy48GDYlM7c1QfBFLaYWKR1EAgdsVx3NdQLJlOk47YlIR7dilZK0JJING
	 Kcse3mCX7GbsGlJ7h9i698s9+o8a7DTHV1JqkVTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/392] iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register
Date: Wed,  3 Dec 2025 16:24:19 +0100
Message-ID: <20251203152418.109529204@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d93e580b3dc5b..8fda16dd012f7 100644
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



