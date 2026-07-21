Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3417843C079;
	Tue, 21 Jul 2026 21:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670925; cv=none; b=e1g0hPa6JJNfAclhU1UlO6CcQrlXx1MPDmhQOnsrD1rUvW6G1saqzpG+tEGGR/JOUrhYV461RI13wfkVBJpW7hckDZid45xSh9bEthwVIJ/4h3102psC2yGfkh9uVv0XWqyZvo5VOhiDhUP1dNUEopVRz+A83JLQoLKJtRuRae4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670925; c=relaxed/simple;
	bh=uB+lOnEaQArzpYOp07yzFW93hdNxbtkiX2nBU8LoEGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITbRAYbjxfg7rNoO19emASOpBN/rkqKDcztjKL87mjXRUngETRELQAdVsNQGjUD1O3W7zU1n8DF3n7peE6Vr2tAVz/Jv+flTh0floET+WrfZnDpe8CCUkj2GAGYDwZNOHzvmO3IqYOeSwRH0vGpjjr7abSl72IakCk90OuPYz+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTeYvVYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTeYvVYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A52B1F00A3A;
	Tue, 21 Jul 2026 21:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670924;
	bh=NzungL869bbgnH8rERM/z2LCgIwaJl2EeHu5hZBI6xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTeYvVYN8tb4A5XVYGSUhm3s3MhGPhzwMWxm8ENjgQ12Ei2ZAqKpprKQoow13ocrv
	 tytY2Lzy9D9pfdHncANPuESrqFrzX84DXFEBYoSfuqKgmBk5VAoxp2Ha9qLVr9Rp6Z
	 NnLgyIiTfV8AVwnu/VO0aeQPx/CPaEiUKyvOSbhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 052/843] iio: adc: ti-ads124s08: Return reset GPIO lookup errors
Date: Tue, 21 Jul 2026 17:14:47 +0200
Message-ID: <20260721152407.155230484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 7dc4de2aa6316f1d044cde21f5acfec5f3ec6b47 upstream.

devm_gpiod_get_optional() returns NULL when the optional GPIO is absent,
but returns an ERR_PTR when the GPIO provider lookup fails, including
probe deferral.

Probe currently logs the ERR_PTR case as if the reset GPIO were simply
absent and keeps the error pointer in reset_gpio. Later ads124s_reset()
treats any non-NULL reset_gpio as a valid descriptor and passes it to
gpiod_set_value_cansleep().

Return the lookup error instead of retaining the ERR_PTR.

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Cc: stable@vger.kernel.org
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads124s08.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -323,7 +323,8 @@ static int ads124s_probe(struct spi_devi
 	ads124s_priv->reset_gpio = devm_gpiod_get_optional(&spi->dev,
 						   "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(ads124s_priv->reset_gpio))
-		dev_info(&spi->dev, "Reset GPIO not defined\n");
+		return dev_err_probe(&spi->dev, PTR_ERR(ads124s_priv->reset_gpio),
+				     "Failed to get reset GPIO\n");
 
 	ads124s_priv->chip_info = &ads124s_chip_info_tbl[spi_id->driver_data];
 


