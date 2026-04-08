Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57A33D522C;
	Wed,  8 Apr 2026 18:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673397; cv=none; b=jX3jv9nVMmk7HlAdn3jCcAj7TshIIVVLnpbrTH/wnm7KtviaQemkL9gRW1ZdCvmnQv2WD49pb2PSDmRMle61Q9xNIZHZg/Ld3Fc/s53FrtwhMbobtdNpAndF3CLnwkmatuyCeHKkhwcVIhw04EzeU1RUy0G3ppcwlZWFOOItzRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673397; c=relaxed/simple;
	bh=xeZ9awLKx4+1VRUz9GJR8N4Iv/pWCwl3WzRRdMZxwXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6i+IBJP8j1S29fVmVZOHgiKDLLOckltK2Pfwpe5FprkKX1tPYlWuL1RufKcekRpeKdUCUosiiF+MOmF79rh5dMdq3efaKZrBTKtep3J/5T25lrz4XK8Plp8FO+f2mPbmp9YdTJFnpTJ+K3JJ0GwOBTMoGDafJA//kWZ3iXdDIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jtx0TJyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jtx0TJyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5A9C19421;
	Wed,  8 Apr 2026 18:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673397;
	bh=xeZ9awLKx4+1VRUz9GJR8N4Iv/pWCwl3WzRRdMZxwXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jtx0TJySrYkg/rWQdn2mZMsH9DCFgWrEdhQme8MALbJsOndNmx+Ztt1xqWQiSEd3g
	 KUYq31SQqz7rtB3HR3f46hAFMK7XaxgodyyjoNmafWuyO6BrIK6WX1ut8yBDIsTtPm
	 PUWaD0ZQJab0PYOagdZwPp+1xdl2FgaBEUpOylhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 184/277] iio: accel: adxl313: add missing error check in predisable
Date: Wed,  8 Apr 2026 20:02:49 +0200
Message-ID: <20260408175940.733943304@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 9d3fa23d5d55a137fd4396d3d4799102587a7f2b upstream.

Check the return value of the FIFO bypass regmap_write() before
proceeding to disable interrupts.

Fixes: ff8093fa6ba4 ("iio: accel: adxl313: add buffered FIFO watermark with interrupt handling")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl313_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/adxl313_core.c b/drivers/iio/accel/adxl313_core.c
index 9f5d4d2cb325..83dcac17a042 100644
--- a/drivers/iio/accel/adxl313_core.c
+++ b/drivers/iio/accel/adxl313_core.c
@@ -998,6 +998,8 @@ static int adxl313_buffer_predisable(struct iio_dev *indio_dev)
 
 	ret = regmap_write(data->regmap, ADXL313_REG_FIFO_CTL,
 			   FIELD_PREP(ADXL313_REG_FIFO_CTL_MODE_MSK, ADXL313_FIFO_BYPASS));
+	if (ret)
+		return ret;
 
 	ret = regmap_write(data->regmap, ADXL313_REG_INT_ENABLE, 0);
 	if (ret)
-- 
2.53.0



