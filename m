Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80F111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E14C433C8;
	Mon, 28 Aug 2023 10:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218280;
	bh=tIsMWziSLfe1hScD/wAL5JLXIECT9Idw0rhCkiK2l7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3FGnyHb+obXsV/qmanG27Vsuio7anK/1NC/KtHA060mRqgqDT9Oz4dwmscy4Q74U
	 pQoH7MKJX8aaM6mWeiZktSxAXF6mE/c8LjP9X6DgUswopXQHdg3kULBhFdufkk9iqP
	 aZLnDXkpzAAEjKHynqJ07RR5f8iYTrnWL8S78T10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/129] iio: addac: stx104: Fix race condition for stx104_write_raw()
Date: Mon, 28 Aug 2023 12:11:57 +0200
Message-ID: <20230828101153.911704411@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 9740827468cea80c42db29e7171a50e99acf7328 ]

The priv->chan_out_states array and actual DAC value can become
mismatched if stx104_write_raw() is called concurrently. Prevent such a
race condition by utilizing a mutex.

Fixes: 97a445dad37a ("iio: Add IIO support for the DAC on the Apex Embedded Systems STX104")
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/c95c9a77fcef36b2a052282146950f23bbc1ebdc.1680790580.git.william.gray@linaro.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 4f9b80aefb9e ("iio: addac: stx104: Fix race condition when converting analog-to-digital")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stx104.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/stx104.c b/drivers/iio/adc/stx104.c
index c25523ecebab2..78e87d1aaaefb 100644
--- a/drivers/iio/adc/stx104.c
+++ b/drivers/iio/adc/stx104.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
@@ -77,10 +78,12 @@ struct stx104_reg {
 
 /**
  * struct stx104_iio - IIO device private data structure
+ * @lock: synchronization lock to prevent I/O race conditions
  * @chan_out_states:	channels' output states
  * @reg:		I/O address offset for the device registers
  */
 struct stx104_iio {
+	struct mutex lock;
 	unsigned int chan_out_states[STX104_NUM_OUT_CHAN];
 	struct stx104_reg __iomem *reg;
 };
@@ -186,9 +189,12 @@ static int stx104_write_raw(struct iio_dev *indio_dev,
 			if ((unsigned int)val > 65535)
 				return -EINVAL;
 
+			mutex_lock(&priv->lock);
+
 			priv->chan_out_states[chan->channel] = val;
 			iowrite16(val, &priv->reg->dac[chan->channel]);
 
+			mutex_unlock(&priv->lock);
 			return 0;
 		}
 		return -EINVAL;
@@ -360,6 +366,8 @@ static int stx104_probe(struct device *dev, unsigned int id)
 	indio_dev->name = dev_name(dev);
 	indio_dev->dev.parent = dev;
 
+	mutex_init(&priv->lock);
+
 	/* configure device for software trigger operation */
 	iowrite8(0, &priv->reg->acr);
 
-- 
2.40.1



