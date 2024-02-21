Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BB17BAE5;
	Wed, 21 Feb 2024 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521893; cv=none; b=aqi1NlLPIc9HBxjs0PjlYQ1wHBDik1xg1/3CqO9esWi/9/i3hn4yJA2lAd2lIeXfpe5B95nY63GmUvLGQjhVw+w4n/QcPRxfHke2Acfy3VwO2KRCRn9ZNcbg64Cm5PxF3tUOJU6m/Yjd601fY+eA+DQPPgydkqZmbNM1Kpk1SDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521893; c=relaxed/simple;
	bh=z9WT+U06kTrpuf/V1rGPIfJ9NKpNUhARbNHzgjX7NTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g65j02c0Ii0SOvzX7LhnijVCX56af7nckXKhAIvsi2k0u7eOkUwnnWGlis4Pvc1z4omdpG+acn7PEPHjvXJU4p82/KmmDjxPf/YErXWsx74COshB97PKwdq1oB72yapoLB5KVE4Q889iPHWP4tRidREn9EUcOkbVu93xyBok6bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhEUra2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhEUra2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476C7C433F1;
	Wed, 21 Feb 2024 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521893;
	bh=z9WT+U06kTrpuf/V1rGPIfJ9NKpNUhARbNHzgjX7NTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhEUra2n/HCbj00lZMnpDu/NLXcXjFWfmF/BodHC35kJ8/eS8S1U2YiCAK9M/mo2M
	 klH6+6bLxBuJ2hE6WZJUufZQud1wUlsV9q+UPdkz6ClSEjYnnKsh7CFUByrSrKFfE/
	 ogAl51fpgZzLqiYm8FIn6c4p4Tn/z3jF+DVrXvcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/476] iio: adc: ad7091r: Set alert bit in config register
Date: Wed, 21 Feb 2024 14:00:57 +0100
Message-ID: <20240221130008.093292976@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

[ Upstream commit 149694f5e79b0c7a36ceb76e7c0d590db8f151c1 ]

The ad7091r-base driver sets up an interrupt handler for firing events
when inputs are either above or below a certain threshold.
However, for the interrupt signal to come from the device it must be
configured to enable the ALERT/BUSY/GPO pin to be used as ALERT, which
was not being done until now.
Enable interrupt signals on the ALERT/BUSY/GPO pin by setting the proper
bit in the configuration register.

Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Link: https://lore.kernel.org/r/e8da2ee98d6df88318b14baf3dc9630e20218418.1702746240.git.marcelo.schmitt1@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 020e71c7ffc2 ("iio: adc: ad7091r: Allow users to configure device events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7091r-base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iio/adc/ad7091r-base.c b/drivers/iio/adc/ad7091r-base.c
index 811f04448d8d..ad089c0ff953 100644
--- a/drivers/iio/adc/ad7091r-base.c
+++ b/drivers/iio/adc/ad7091r-base.c
@@ -28,6 +28,7 @@
 #define AD7091R_REG_RESULT_CONV_RESULT(x)   ((x) & 0xfff)
 
 /* AD7091R_REG_CONF */
+#define AD7091R_REG_CONF_ALERT_EN   BIT(4)
 #define AD7091R_REG_CONF_AUTO   BIT(8)
 #define AD7091R_REG_CONF_CMD    BIT(10)
 
@@ -232,6 +233,11 @@ int ad7091r_probe(struct device *dev, const char *name,
 	iio_dev->channels = chip_info->channels;
 
 	if (irq) {
+		ret = regmap_update_bits(st->map, AD7091R_REG_CONF,
+					 AD7091R_REG_CONF_ALERT_EN, BIT(4));
+		if (ret)
+			return ret;
+
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				ad7091r_event_handler,
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT, name, iio_dev);
-- 
2.43.0



