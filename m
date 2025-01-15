Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB551E9905;
	Wed, 15 Jan 2025 11:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938925; cv=none; b=kneDrSlOH6cL5O6tBLBCf6XvSjNwcD6Cl+yw30um3gaxdeFFplQe38rfG5n8SpRatWGT69gRbahZn8GmhZjNwcTWCNQOt78dvaV0GhcnmDnssHZQuh/v4SN9xe5Op/JH0gzP6Vu8wLZ93xwIXI+KRD/St25dAF74Ep5MuVE8x5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938925; c=relaxed/simple;
	bh=BmSAU7RkoOq02UHSbnGxyPu5Fx1KGEAR+yUqGv9YcgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MypUv9xSUvRBGu/bCd6/4vSz13KgE1g85VmFxtb8jdwtL2p/7JCEd/SXM4I6uGKvdnr9b/OYFEwbQXcSV2XneKxzflQxjGOzGJA9PHJ+6KwWRGPEt96p9rJ4eOjapmxSPpQ9ryq5YqnbUa5VuC4JF1kUK5mytwkGMtS4JC0maxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSByk+d0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSByk+d0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97809C4CEDF;
	Wed, 15 Jan 2025 11:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938925;
	bh=BmSAU7RkoOq02UHSbnGxyPu5Fx1KGEAR+yUqGv9YcgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSByk+d0RziCL3X+PNlWVvWpih/32z5inbnkvkSbbGR6NYgoUcw7OiNcU4UaSpnc8
	 T9h46DptzQRASS0/fKfhImV7zdCzFpHiA5aAtdinALTkMF69M8faVBcdIJLJrrSsTo
	 UY+NmAsrLCoYag7QACeK8HbS4iGYIrPE798XVpfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 108/129] iio: gyro: fxas21002c: Fix missing data update in trigger handler
Date: Wed, 15 Jan 2025 11:38:03 +0100
Message-ID: <20250115103558.656842494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

commit fa13ac6cdf9b6c358e7d77c29fb60145c7a87965 upstream.

The fxas21002c_trigger_handler() may fail to acquire sample data because
the runtime PM enters the autosuspend state and sensor can not return
sample data in standby mode..

Resume the sensor before reading the sample data into the buffer within the
trigger handler. After the data is read, place the sensor back into the
autosuspend state.

Fixes: a0701b6263ae ("iio: gyro: add core driver for fxas21002c")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20241116152945.4006374-1-Frank.Li@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/fxas21002c_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/gyro/fxas21002c_core.c
+++ b/drivers/iio/gyro/fxas21002c_core.c
@@ -730,14 +730,21 @@ static irqreturn_t fxas21002c_trigger_ha
 	int ret;
 
 	mutex_lock(&data->lock);
+	ret = fxas21002c_pm_get(data);
+	if (ret < 0)
+		goto out_unlock;
+
 	ret = regmap_bulk_read(data->regmap, FXAS21002C_REG_OUT_X_MSB,
 			       data->buffer, CHANNEL_SCAN_MAX * sizeof(s16));
 	if (ret < 0)
-		goto out_unlock;
+		goto out_pm_put;
 
 	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
 					   data->timestamp);
 
+out_pm_put:
+	fxas21002c_pm_put(data);
+
 out_unlock:
 	mutex_unlock(&data->lock);
 


