Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671B14582D3;
	Fri,  9 Oct 2026 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557659; cv=none; b=SjkKf06QeQsD7WAFfyC7bPQwZzaSP01MXysxk3o1Pkp0z71Ev3tEKsGzdhreMImJvR1Amo9RPgS9mTIX2/Zr0u4tX2B3qpgYwMKSnBdYJJOVOz1PGz3Hr/IrNyGE202xh4VlR8wxgGLMqrF+KdPgoy+q3KWPgUfDaK3+wdgdc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557659; c=relaxed/simple;
	bh=XIKGlCb78F+GPwh24rbHhf31pgwVYSf4kPS6tvU0JWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVpMMSrC5D/HLA/r8DfnrELZWlaugDb0IMsFVOiM8fG+zJuqLK0RzieeldO6P0cxTWCdHVbBXXcr5mISm40Xz0oXZ8RteHBSccsk+Mp65Jxr5JgSORhRyGk8vA8AIhQHkCK+Dpjzx80kWlFHOoXLcoHlk34p5R9BsHz5dzvwWaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+m2+zCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+m2+zCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54C61F000FF;
	Fri,  9 Oct 2026 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557658;
	bh=im8HcrTjn228itZ0/iER+Dlotv3grIeTWBQbGHDH2mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+m2+zCF25wD01qGxv6CwDtuUex3afeFUkEQZDOKyCF0hiZqTICAH++yepGzlhVdw
	 SYvNm9qxns8cOcVZSnEMHlj2tNgdzgUfGO4RFpL5qYXg7rwwogGHiVlokRoDUfF8CG
	 x72anQtR2bRVrtXaJzpKQhBzZ1eCk0mjroygEbmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 390/428] iio: adc: stm32-adc: fix possible division by zero in processed channel
Date: Fri,  9 Oct 2026 16:12:07 +0200
Message-ID: <20261009140954.768456841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1608,11 +1608,16 @@ static int stm32_adc_read_raw(struct iio
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


