Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715B01DE8AE;
	Tue, 13 Oct 2026 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895613; cv=none; b=YAwLjSkcdJvGH3z7JXVHdgy3BNdyjul6o9f6US5+vkULQydIoBxJ9N4T+73xn/cNNcJSwf68u9cFA13svyIe23T2iVoG1jFV58Qp85wtkIVR7d6icBpzyfUTWBVFUWdKfzgNNG3Rrg1RKTLtuWZtkqImcSRouRuomg1erQgyzRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895613; c=relaxed/simple;
	bh=GCLcXN1rULBTlV6tolM324odRii00O9G7WaZ8J/+IMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvNspr/BJOcl/FQ9f/fz7J3RxFGTF/fl/Lhcf7BLPPEmHMEcIcpoHdgopf2BPbyl+zh/CeoOuhZzHS4WlILiJZhgAaHjip+NncZ+ZIMQPcytK25KqsIBGLQqQD4ksuD/BsbPbVDrckts6qUhPzmg7aAbHfBn6GdJBgkppp+4AEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmNQRNnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmNQRNnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648A1F000FF;
	Tue, 13 Oct 2026 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895611;
	bh=IrXF9HMvRx8vKu0G5dVTj8ITZIl0C91tHFBh4doeGHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmNQRNnF1ozogWDHl5a7n7ITzLMhVTP0c7q71P9Pmyh0KJyW34CmQ0u/1QEhsqbh1
	 /7y4UPoseVqCxa16VmrJXwjA2dWGI+wADNyuHcSQIK/iEFIiy+HsYZkEYJJ0fFTZJ1
	 /wWULf5tmZVPm3lLPxpCUiteig1Yg221CiKBvn5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/497] iio: adc: stm32-adc: fix possible division by zero in processed channel
Date: Tue, 13 Oct 2026 13:38:21 +0200
Message-ID: <20261013112915.833125752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit c5de6a6f855fdcf1e0ea549fb227a316db51c405 ]

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
[ sashal: Changed iio_device_release_direct() to iio_device_release_direct_mode(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index db8dd129b0614..2513146639171 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1478,11 +1478,16 @@ static int stm32_adc_read_raw(struct iio_dev *indio_dev,
 			ret = stm32_adc_single_conv(indio_dev, chan, val);
 		else
 			ret = -EINVAL;
+		iio_device_release_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
 
-		if (mask == IIO_CHAN_INFO_PROCESSED)
+		if (mask == IIO_CHAN_INFO_PROCESSED) {
+			if (*val == 0)
+				return -EINVAL;
 			*val = STM32_ADC_VREFINT_VOLTAGE * adc->vrefint.vrefint_cal / *val;
+		}
 
-		iio_device_release_direct_mode(indio_dev);
 		return ret;
 
 	case IIO_CHAN_INFO_SCALE:
-- 
2.53.0



