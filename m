Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD534E4C43;
	Fri,  9 Oct 2026 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556927; cv=none; b=fuoMjeHPRwUvKRBT39ClU3BFHOtnxxm2nZ/lOBwmFViHHofo3rbp0uM3aDjucDw8lobJGA2vG45S3EVNDdgMk79w+XsmTi64XPSa2L4zJE4Hw7vl0qgGr6wRZ2LRE+apuo76oewzfdxNh9Sacu+94mtP6At7PSr5jgCmuV29N8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556927; c=relaxed/simple;
	bh=Gz16RbM2Qp2SkNb1c0+VtTDwHQgz39xVzEPIDrrMhhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI7V18H2durPzD8IWe4TfdKqqKRnzQODaS1AggyjDIBfSk36oNBQjKfoxmyo/WzJB4OyKJuSXGLooFLPXxQR7tGx1Q71NUADyCtwgFVgNK9dnVtqOsDxHZhmiRTbNX06nBIHMwNskUdgV2NuT7IgDtO9jf3/hFd/sbAd9hSyVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAbTgDZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAbTgDZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E756A1F000FF;
	Fri,  9 Oct 2026 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556925;
	bh=eWDMd0/aqCvt4ZQk186/0np64+znd4pThq6m9PpReMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAbTgDZnxdjGpOUIqZdhzRUTerFKi0Cprax7S69zQvaovZfqpNvFJtKa9vQhJ8is8
	 x4IptvBzKw4YBBf+3cVR8hyveYy69PBiFgxQ0Fl1l2Fuy7AlmpymPhcZgjgDLFwtc7
	 4m9RrpNwhjIiicWL1Msvb6Cj6VujRmxOvbvf94lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 315/403] iio: adc: stm32-adc: fix possible division by zero in processed channel
Date: Fri,  9 Oct 2026 16:11:16 +0200
Message-ID: <20261009140959.589810405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit c5de6a6f855fdcf1e0ea549fb227a316db51c405 upstream.

In case the conversion has failed or returned zero, processing *val
can lead to a division by zero. Need to check for errors, or converted
value is zero, before processing the data. In case the converted value
is zero, e.g. the Vrefint channel, this should be considered as invalid
in all cases.

Fixes: 0e346b2cfa85 ("iio: adc: stm32-adc: add vrefint calibration support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260911161555.244F31F000FF@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1609,11 +1609,16 @@ static int stm32_adc_read_raw(struct iio
 			ret = stm32_adc_single_conv(indio_dev, chan, val);
 		else
 			ret = -EINVAL;
+		iio_device_release_direct(indio_dev);
+		if (ret < 0)
+			return ret;
 
-		if (mask == IIO_CHAN_INFO_PROCESSED)
+		if (mask == IIO_CHAN_INFO_PROCESSED) {
+			if (*val == 0)
+				return -EINVAL;
 			*val = STM32_ADC_VREFINT_VOLTAGE * adc->vrefint.vrefint_cal / *val;
+		}
 
-		iio_device_release_direct(indio_dev);
 		return ret;
 
 	case IIO_CHAN_INFO_SCALE:


