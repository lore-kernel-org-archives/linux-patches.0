Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B673A8F4;
	Tue, 23 Jan 2024 00:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969876; cv=none; b=EngAx1pKvErJOuMaTezgjoI/j8bYiZ/XzGzsR0PfnLRl5OsNVl/5ePi2b5aZZPgAUPa985pVww951nd4Cwlr3XxIsCR8wMA5MZ1bVeWjXtu5RbFZgvUIsRQnDJf27jUcW4i/9t2zilWA6YP4kCMu32GwXTJhCCNbYXd3HBSwuBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969876; c=relaxed/simple;
	bh=i8kw/Zb+MRNC2XYLx3l/ux6JssCbUUAjW1vxmJoqRTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqgltP/TbI34b3rKv1NM0ylDPVqop+jLD4V/UnC9vtLAQnrXhoY2dL9pCHHFYnbtz1xRSF9uBSmVJir3lNlaKvOA4HeqzBrVQ1gwl3Lb6uXKBsnz12NgyxIzYwUVlexGypTYoOrEV4FTE11++XUPJYehNzi9n3loTrK9ZQnYjaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIP6hfVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIP6hfVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22569C433F1;
	Tue, 23 Jan 2024 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969876;
	bh=i8kw/Zb+MRNC2XYLx3l/ux6JssCbUUAjW1vxmJoqRTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIP6hfVM4oI+AyUzFoaWKaU0U3FkrzZgYOSyE3BfIliD8xKIv5ZZPG0q8uFNzc2Pp
	 Ex4Jcy9fup3CgIlsex25ZHQDtXPDWzr6pTOk+fXqnMqCkf3WzepaPQGpmtJmZVJyro
	 W5FLI6Kxanwf/wJaxvKF5/MzoDZfIS/i6V8t9NUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 476/641] iio: adc: ad7091r: Pass iio_dev to event handler
Date: Mon, 22 Jan 2024 15:56:20 -0800
Message-ID: <20240122235832.953744975@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

commit a25a7df518fc71b1ba981d691e9322e645d2689c upstream.

Previous version of ad7091r event handler received the ADC state pointer
and retrieved the iio device from driver data field with dev_get_drvdata().
However, no driver data have ever been set, which led to null pointer
dereference when running the event handler.

Pass the iio device to the event handler and retrieve the ADC state struct
from it so we avoid the null pointer dereference and save the driver from
filling the driver data field.

Fixes: ca69300173b6 ("iio: adc: Add support for AD7091R5 ADC")
Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Link: https://lore.kernel.org/r/5024b764107463de9578d5b3b0a3d5678e307b1a.1702746240.git.marcelo.schmitt1@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7091r-base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ad7091r-base.c
+++ b/drivers/iio/adc/ad7091r-base.c
@@ -174,8 +174,8 @@ static const struct iio_info ad7091r_inf
 
 static irqreturn_t ad7091r_event_handler(int irq, void *private)
 {
-	struct ad7091r_state *st = (struct ad7091r_state *) private;
-	struct iio_dev *iio_dev = dev_get_drvdata(st->dev);
+	struct iio_dev *iio_dev = private;
+	struct ad7091r_state *st = iio_priv(iio_dev);
 	unsigned int i, read_val;
 	int ret;
 	s64 timestamp = iio_get_time_ns(iio_dev);
@@ -234,7 +234,7 @@ int ad7091r_probe(struct device *dev, co
 	if (irq) {
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				ad7091r_event_handler,
-				IRQF_TRIGGER_FALLING | IRQF_ONESHOT, name, st);
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT, name, iio_dev);
 		if (ret)
 			return ret;
 	}


