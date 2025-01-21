Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0483C1F55E5;
	Tue, 21 Jan 2025 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482933; cv=none; b=VH48bF/Daqc/W7XXT8EzXli3SS3ytsAws0n3ePxQdYSZPPVotTSNdULRP2BrblhqaChJ2tNRDed/u3+ppUAG/PvQCKJh1d/KgEx0zje2qD+ZWh/JQjxksF4RcwX1QODAnfgpdyxONR/Vc9Yvn9lwtG5T33pHUapxBkmS7AmWgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482933; c=relaxed/simple;
	bh=xtwVaDidhGFKx3VUWOo9bT0ehfyd6gp09U+pIIGbdUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyMCgaXliOTNMqgLIJIlaeUqWVsvDq4ppF3WxYY3WAPc0CPEEWpfmCuwK5ykgwCZDNbaSm18vJcjyw+iunuxRnYamOJFsCFJ0+qE+gtZJPLoVy+SUooOXyQC3hBxP8A0Jb4vVUozQQQE29/kPydEgah37I0D4u2w3gUju8r3fz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htSwWQDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htSwWQDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B3AC4CEDF;
	Tue, 21 Jan 2025 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482932;
	bh=xtwVaDidhGFKx3VUWOo9bT0ehfyd6gp09U+pIIGbdUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htSwWQDRkp8nT2N9JYVQzoKmEEKvVhTSBPXlnZ81VHVo5Sutosv0YKQzMGFmtMRWi
	 fcq7DjaQDNI6F23iMEpAUWVCHPGHL25SVrJ6bnaWOSJdGEIrLzKZnFUlTbIwFQ/yS1
	 IkYQf45S8PZ8aCgrvJpeDMz6PGJAeeuqTK/sjTHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 058/127] iio: gyro: fxas21002c: Fix missing data update in trigger handler
Date: Tue, 21 Jan 2025 18:52:10 +0100
Message-ID: <20250121174531.901226411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


