Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A973AF66D;
	Sat, 17 Oct 2026 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257089; cv=none; b=U9DW9sMQZaI0PJfzJV3yghmxY4u/j7m6BIvQuztGFHN5djYwa+Erh/KpkfVQgQ+W+ydv/+AUbw/5oaP5BwuOfEuZwA8+pHd9tluurZZC/T7+KxpFlw3onBs5ph6h30hjZPv0G7EPtEzvaVQ8bsjI6Q9uUNj5dhnvWEsz0GHwTnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257089; c=relaxed/simple;
	bh=uVzA7wkJJWPsdGMlsL0Y+hLg3n8bzODpDvTK0a1fBZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2r0l/6iuOKBi1UBi/h6fXoO31QAOpsYUI+EnkuGabl4V5zX8/aGvi9pjrDyc+0sTLjSqm8KZHbKmcodGzzR0SXxlwDJ1geTc+85gbo9IYlKNBJHryZXuwDoMpszNvpQH7ptqWXvdnvjZlrcV0cOa10HQPexaZrbx2AvbiDtgbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/2k97F8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/2k97F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5F71F000C4;
	Sat, 17 Oct 2026 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257088;
	bh=rrdRtY3reuVljoDEbaBH+tHoP2685Xk/0zXV605cyG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/2k97F8UVqj3sVZFG4Fe1RQKk6WqZp/fUfgzV86MvqEyj2QKPOMSjidgSHcNxCLN
	 nEsRmqwD3UFpDzaSwmaFy2LFKr5g9LpUNWrSYspc1BSI3x8BSyJCcAkQLuE+/1i2B9
	 ESJfHV5J1mdsblxExxrGg6smXaQirCJdmqYbWqK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0449/1674] iio: adc: stm32-adc: fix possible division by zero in processed channel
Date: Sat, 17 Oct 2026 17:45:21 +0200
Message-ID: <20261017160442.641414648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2ce521871bdcf..3b78581c5e785 100644
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



