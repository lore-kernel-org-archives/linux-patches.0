Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2DD4657D0;
	Tue, 16 Jun 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630235; cv=none; b=mDOkOK3PO0J+qLfVW4d+SumodzuirBgFT1bE7ZUmVC08PNf1Q3oLs1yHfK2BUhW24a01xM8Gl1d+b1kgqQ3Apm2/llp+tDQ2VNlGiM/YP9W58NExoe9pRYID/vBeuex+f7gYnVuUMmiTJaw6HxvzMBugrVA462VZmBmZdJUxhT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630235; c=relaxed/simple;
	bh=ZMoEIbEz6b0yLTMjvPoIwO6tI8YB9HOjQKVPBaQIexY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C498GJpeMDIuohay2WQQs71q9pQThseT5LNxWwL41rhprcO+h6kPwGumEbPiwmVxqNUdi2cyLEoqzlMfd0zjX52LcRq4Q5tqS0dLIefYPvkGdgbgWSIXfzfri37U/o9Gc3OuSqxrbcMbt7KzYWIvMkZPlVyBCaDpa+ccnBNStkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqZZ5Whq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqZZ5Whq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11771F000E9;
	Tue, 16 Jun 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630233;
	bh=17CNR+EMwBIi+H6pZji750kjlBbE/qsRBT67yM11mdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqZZ5Whqduw+Gn7DgyE6HmLj4YWrnFCQscc/KAsBXBxrFShQnOtabmD2d5NrlyC7/
	 CNNK8b5Ecq+1DvnRKbuUMRhebjGAUO8pYzOPid++qthYQ8tWMboZ8StfMCdcGH9RNp
	 aKRFIbSFY1qXXVAutOhguTVvN8HuWeLGbVPtC5ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 409/452] iio: gyro: adis16260: fix division by zero in write_raw
Date: Tue, 16 Jun 2026 20:30:36 +0530
Message-ID: <20260616145138.280855860@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 761e8b489e6cf166c574034b70637f8a7eadd0ee ]

Add a validation check for the sampling frequency value before using it
as a divisor. A user writing zero to the sampling_frequency sysfs
attribute triggers a division by zero in the kernel.

Fixes: 089a41985c6c ("staging: iio: adis16260 digital gyro driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16260.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/gyro/adis16260.c
+++ b/drivers/iio/gyro/adis16260.c
@@ -288,6 +288,9 @@ static int adis16260_write_raw(struct ii
 		addr = adis16260_addresses[chan->scan_index][1];
 		return adis_write_reg_16(adis, addr, val);
 	case IIO_CHAN_INFO_SAMP_FREQ:
+		if (val <= 0)
+			return -EINVAL;
+
 		adis_dev_lock(adis);
 		if (spi_get_device_id(adis->spi)->driver_data)
 			t = 256 / val;


