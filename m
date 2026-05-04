Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F236309C;
	Mon,  4 May 2026 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904843; cv=none; b=aHKRpiaO2bWllHQ2X7MAM/3mB+JPWAL39QYr+aRVEv0MhhcqJZdXgE5PN5vZ2kYL/GX8JTYA5uukOrycNrrVAvf9IIjxkINZxXyJC6m/+ycICNeJoGPVxvHZDvd9cCFA9IwJ64JQTdhXlr0S1JDSxCSK2XvrBzvQHmtkkfc+VQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904843; c=relaxed/simple;
	bh=QqaKcGcpUAvT5INq0UOOYFle0qaMuWrOg+VVtCGk0LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/BBZlWDtX/vbduZOJfKadlnppq4+3qjuBa6FEFpO7GLgSGOe0X1qDmykGPbEAbJtOdCO0waSL/76aimSB3cTq+wyutKLBrWvJmpK4ReacypH+Lt/UFX0YU+j+0JLIpb+tNNw2nloAzwQAThebTv74rzlAn0fr4jVtjdgBpGHJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOLBtjxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOLBtjxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C24C2BCB8;
	Mon,  4 May 2026 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904842;
	bh=QqaKcGcpUAvT5INq0UOOYFle0qaMuWrOg+VVtCGk0LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOLBtjxKeLrpIcQtm7B32/GlXWcUpycwRTE71IqGwu9tkUm4cn/TOeldWOC4IagZo
	 rgcmy+QrQPjDcwVoJjOAMb/WCR9MMFDrmwMQkVcJSjEy/PLkDDd7MNX8qnJbLU6myv
	 ggkmww8FoL7K1TU4LB8D390/5yU1fke+LhZTDG1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/215] iio: frequency: admv1013: add dev variable
Date: Mon,  4 May 2026 15:53:34 +0200
Message-ID: <20260504135137.609182155@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit e61b5bb0e91390adee41eaddc0a1a7d55d5652b2 ]

Introduce a local struct device pointer in functions that reference
&spi->dev for device-managed resource calls and device property reads,
improving code readability.

Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: aac0a51b1670 ("iio: frequency: admv1013: fix NULL pointer dereference on str")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -518,11 +518,11 @@ static int admv1013_properties_parse(str
 {
 	int ret;
 	const char *str;
-	struct spi_device *spi = st->spi;
+	struct device *dev = &st->spi->dev;
 
-	st->det_en = device_property_read_bool(&spi->dev, "adi,detector-enable");
+	st->det_en = device_property_read_bool(dev, "adi,detector-enable");
 
-	ret = device_property_read_string(&spi->dev, "adi,input-mode", &str);
+	ret = device_property_read_string(dev, "adi,input-mode", &str);
 	if (ret)
 		st->input_mode = ADMV1013_IQ_MODE;
 
@@ -533,7 +533,7 @@ static int admv1013_properties_parse(str
 	else
 		return -EINVAL;
 
-	ret = device_property_read_string(&spi->dev, "adi,quad-se-mode", &str);
+	ret = device_property_read_string(dev, "adi,quad-se-mode", &str);
 	if (ret)
 		st->quad_se_mode = ADMV1013_SE_MODE_DIFF;
 
@@ -546,11 +546,11 @@ static int admv1013_properties_parse(str
 	else
 		return -EINVAL;
 
-	ret = devm_regulator_bulk_get_enable(&st->spi->dev,
+	ret = devm_regulator_bulk_get_enable(dev,
 					     ARRAY_SIZE(admv1013_vcc_regs),
 					     admv1013_vcc_regs);
 	if (ret) {
-		dev_err_probe(&spi->dev, ret,
+		dev_err_probe(dev, ret,
 			      "Failed to request VCC regulators\n");
 		return ret;
 	}
@@ -562,9 +562,10 @@ static int admv1013_probe(struct spi_dev
 {
 	struct iio_dev *indio_dev;
 	struct admv1013_state *st;
+	struct device *dev = &spi->dev;
 	int ret, vcm_uv;
 
-	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
+	indio_dev = devm_iio_device_alloc(dev, sizeof(*st));
 	if (!indio_dev)
 		return -ENOMEM;
 
@@ -581,20 +582,20 @@ static int admv1013_probe(struct spi_dev
 	if (ret)
 		return ret;
 
-	ret = devm_regulator_get_enable_read_voltage(&spi->dev, "vcm");
+	ret = devm_regulator_get_enable_read_voltage(dev, "vcm");
 	if (ret < 0)
-		return dev_err_probe(&spi->dev, ret,
+		return dev_err_probe(dev, ret,
 				     "failed to get the common-mode voltage\n");
 
 	vcm_uv = ret;
 
-	st->clkin = devm_clk_get_enabled(&spi->dev, "lo_in");
+	st->clkin = devm_clk_get_enabled(dev, "lo_in");
 	if (IS_ERR(st->clkin))
-		return dev_err_probe(&spi->dev, PTR_ERR(st->clkin),
+		return dev_err_probe(dev, PTR_ERR(st->clkin),
 				     "failed to get the LO input clock\n");
 
 	st->nb.notifier_call = admv1013_freq_change;
-	ret = devm_clk_notifier_register(&spi->dev, st->clkin, &st->nb);
+	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
 	if (ret)
 		return ret;
 
@@ -606,11 +607,11 @@ static int admv1013_probe(struct spi_dev
 		return ret;
 	}
 
-	ret = devm_add_action_or_reset(&spi->dev, admv1013_powerdown, st);
+	ret = devm_add_action_or_reset(dev, admv1013_powerdown, st);
 	if (ret)
 		return ret;
 
-	return devm_iio_device_register(&spi->dev, indio_dev);
+	return devm_iio_device_register(dev, indio_dev);
 }
 
 static const struct spi_device_id admv1013_id[] = {


