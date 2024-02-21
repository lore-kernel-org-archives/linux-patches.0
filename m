Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ACC7B3E5;
	Wed, 21 Feb 2024 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521900; cv=none; b=g9f8oCMyiF8Ph6WugQFZqSlm9naUO87BEkJi1U/oHRBy5Y7sbO9tVA5Uhu9/tcwQbpy2vshy5uochIvNNI6n8d08pssRf+eEeD3Hf8038SFvsSBkG4rlol5ERAeEFFgPMjGVrJLNGZMytwMZUjPLzJfJ/avWE43xbKQJAh2v+gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521900; c=relaxed/simple;
	bh=A1T2ORXmZkhjRrvcaw7P+Z2MXxqICi4jUqUoLPNMGu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y14m/5HkCUBT5syKKDm/0PUAxgQObxUpkztK7R75fAfB7i0hVZP19Fh2mi03MLzdhHKa42uBXu5MQcJIr9SC4QA6nARCKIWSwdm3V08WPYVarHx+FhBK0sUtFIUwLGU9ITLXtrTrndZqlaaOrUgkJ4Div0uY65RQiIne556CpoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvXCdDTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvXCdDTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B59C433C7;
	Wed, 21 Feb 2024 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521900;
	bh=A1T2ORXmZkhjRrvcaw7P+Z2MXxqICi4jUqUoLPNMGu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvXCdDTcGSAbqtu4Zo7bKxcRr7mU8CoI3b10xGnRii+rCFQjpCmk4LdItDCtqRETH
	 HRS9uhMbgiTBNaqd+JLGGhhi7/hlsj5xJeCt4mAm9hVEz+6US66P/fCpiBGOfp6iPd
	 /BUJmG8yLpesNjbXg1Be2Q71/4xw8wHd55jvHHkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/476] iio: adc: ad7091r: Enable internal vref if external vref is not supplied
Date: Wed, 21 Feb 2024 14:00:59 +0100
Message-ID: <20240221130008.171787462@linuxfoundation.org>
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

[ Upstream commit e71c5c89bcb165a02df35325aa13d1ee40112401 ]

The ADC needs a voltage reference to work correctly.
Users can provide an external voltage reference or use the chip internal
reference to operate the ADC.
The availability of an in chip reference for the ADC saves the user from
having to supply an external voltage reference, which makes the external
reference an optional property as described in the device tree
documentation.
Though, to use the internal reference, it must be enabled by writing to
the configuration register.
Enable AD7091R internal voltage reference if no external vref is supplied.

Fixes: 260442cc5be4 ("iio: adc: ad7091r5: Add scale and external VREF support")
Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Link: https://lore.kernel.org/r/b865033fa6a4fc4bf2b4a98ec51a6144e0f64f77.1703013352.git.marcelo.schmitt1@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7091r-base.c | 7 +++++++
 drivers/iio/adc/ad7091r-base.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/iio/adc/ad7091r-base.c b/drivers/iio/adc/ad7091r-base.c
index 9ddda08918db..f345542e69a0 100644
--- a/drivers/iio/adc/ad7091r-base.c
+++ b/drivers/iio/adc/ad7091r-base.c
@@ -405,7 +405,14 @@ int ad7091r_probe(struct device *dev, const char *name,
 	if (IS_ERR(st->vref)) {
 		if (PTR_ERR(st->vref) == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
+
 		st->vref = NULL;
+		/* Enable internal vref */
+		ret = regmap_set_bits(st->map, AD7091R_REG_CONF,
+				      AD7091R_REG_CONF_INT_VREF);
+		if (ret)
+			return dev_err_probe(st->dev, ret,
+					     "Error on enable internal reference\n");
 	} else {
 		ret = regulator_enable(st->vref);
 		if (ret)
diff --git a/drivers/iio/adc/ad7091r-base.h b/drivers/iio/adc/ad7091r-base.h
index 7a78976a2f80..b9e1c8bf3440 100644
--- a/drivers/iio/adc/ad7091r-base.h
+++ b/drivers/iio/adc/ad7091r-base.h
@@ -8,6 +8,8 @@
 #ifndef __DRIVERS_IIO_ADC_AD7091R_BASE_H__
 #define __DRIVERS_IIO_ADC_AD7091R_BASE_H__
 
+#define AD7091R_REG_CONF_INT_VREF	BIT(0)
+
 /* AD7091R_REG_CH_LIMIT */
 #define AD7091R_HIGH_LIMIT		0xFFF
 #define AD7091R_LOW_LIMIT		0x0
-- 
2.43.0



