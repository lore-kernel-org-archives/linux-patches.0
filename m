Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C204E1D8;
	Tue, 23 Jan 2024 00:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969990; cv=none; b=YDy9y5+C2KJTF/JdaSW919RpshXyhyX3OsNbp0/Uu47N75x8f5CRk8KlqHtf1gETgHwz0vmKFyCxNq+iO7srqCaGtr0sTFCa6b4HTIhRngA+U+5Qgnlc7Zrhls4ROIIcAie7+NX7vY2+gEPWSzYKDUR2lm7bI9Y1nlmXPw1Ijnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969990; c=relaxed/simple;
	bh=vnWmFgeZyfawnANBigyyuGC5oJv5oH9E30xvA7jC6j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyfqpzQgy/j4Az0U9/nkFkvFVVXtVz52w6y0xyiPnQMZjnZHx9DmDrYEsHqj7d6H+ro8wgePP6V6FpN2G8VKZPlUBuhyPg7xz9BqTJzWv+wldvJbOVAf+YRaxLx6NvQPwL/4CEiqDl+Th/dYWbC/YdPYtspSM8muExqOQY+TtKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+ttXWsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+ttXWsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F03C433F1;
	Tue, 23 Jan 2024 00:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969990;
	bh=vnWmFgeZyfawnANBigyyuGC5oJv5oH9E30xvA7jC6j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+ttXWsmoG0UR2FxDfudkiXGvenBMHEHntajNJydeqr9ZVOlZBuFEUAcDbXwGogpa
	 373m/qYUeVF2imqImOAH/GZ9HDeyWHIXSbGCMt/dMo5KUIGrPl52fpTx2tu7ZdKTTi
	 4M2+l0d3W7htf/Mk8sRNV+dvNFriCl2dUPyIRyDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 530/641] iio: adc: ad9467: add mutex to struct ad9467_state
Date: Mon, 22 Jan 2024 15:57:14 -0800
Message-ID: <20240122235834.693114886@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 737720197be445bb9eec2986101e4a386e019337 ]

When calling ad9467_set_scale(), multiple calls to ad9467_spi_write()
are done which means we need to properly protect the whole operation so
we are sure we will be in a sane state if two concurrent calls occur.

Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20231207-iio-backend-prep-v2-3-a4a33bc4d70e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index d3c98c4eccd3..104c6d394a3e 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -4,8 +4,9 @@
  *
  * Copyright 2012-2020 Analog Devices Inc.
  */
-
+#include <linux/cleanup.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -121,6 +122,8 @@ struct ad9467_state {
 	unsigned int			output_mode;
 
 	struct gpio_desc		*pwrdown_gpio;
+	/* ensure consistent state obtained on multiple related accesses */
+	struct mutex			lock;
 };
 
 static int ad9467_spi_read(struct spi_device *spi, unsigned int reg)
@@ -161,6 +164,7 @@ static int ad9467_reg_access(struct adi_axi_adc_conv *conv, unsigned int reg,
 	int ret;
 
 	if (readval == NULL) {
+		guard(mutex)(&st->lock);
 		ret = ad9467_spi_write(spi, reg, writeval);
 		if (ret)
 			return ret;
@@ -310,6 +314,7 @@ static int ad9467_set_scale(struct adi_axi_adc_conv *conv, int val, int val2)
 		if (scale_val[0] != val || scale_val[1] != val2)
 			continue;
 
+		guard(mutex)(&st->lock);
 		ret = ad9467_spi_write(st->spi, AN877_ADC_REG_VREF,
 				       info->scale_table[i][1]);
 		if (ret < 0)
-- 
2.43.0



