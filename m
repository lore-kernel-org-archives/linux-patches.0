Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B73D091A;
	Tue, 16 Jun 2026 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633393; cv=none; b=MA+Mv1L08Edu8gESQluK9W+2gjoEyVfH+S8JUWjEIp9yaOvBIyt4uV9D0I/LS+BV/3UJXWdZFXu0IsYqMqUt2myCkECvbmhNjeXCt+3UaWrA1SjeUCKzpwjirQIp3Cpuy/qYS586Pntu51XUJX8AzIR7DISRzcYXt+NjLeWVDWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633393; c=relaxed/simple;
	bh=Y1bmhfTzomNWzp/P2RHsaIbKo4yHM1EzANOF9zt5li0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLYe5oDQ5mfJoIIs1EjDrqOWSkrN30541AjZ6Ooi0u/a+D/C37R2F+fpcdj69Ab5MVZ6Bz2kQhHL49j20Hhcr0jUKGKTRWDRuT4w1qAwzSJ44xSAU/rT4/Yg1qobWdS90OhVARQKS+IUPUBd8P0PiGTd94DucyRMBVToqSbc+2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sv6rjfzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sv6rjfzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BC81F000E9;
	Tue, 16 Jun 2026 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633392;
	bh=EZh1eYgKCLK8ZE1W8gDNcQpoHug3i097T52twBMBSGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sv6rjfzp4wLgxXrbzkCa0qY/URd0AEpQTSztyqYC0depSrSKKCJBlekyC/0kAConc
	 MgdNWkFz+Y0+3059OXmJcvF1+23sUJkbeQR4/C8KB+Mxnn8M7MPGi1maAKYcQncM7Y
	 QA0PfE7P04w88paFXTiJQTD85DkQS0/QrsVorBlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 070/411] iio: dac: ad5686: fix input raw value check
Date: Tue, 16 Jun 2026 20:25:08 +0530
Message-ID: <20260616145104.003676711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

commit d01220ee5e43c65a206df827b39bf5cf5f7b9dce upstream.

Fix range check for input raw value, which is off by one, i.e., for a
10-bit DAC the max valid value is 1023, but 1 << 10 equals 1024, which
passes the previous check, allowing an out-of-range write. The issue
exists since the ad5686 driver was first introduced.

Fixes: c2f37c8dcadc ("iio: dac: New driver for AD5686R, AD5685R, AD5684R Digital to analog converters")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -154,7 +154,7 @@ static int ad5686_write_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val > (1 << chan->scan_type.realbits) || val < 0)
+		if (val >= (1 << chan->scan_type.realbits) || val < 0)
 			return -EINVAL;
 
 		mutex_lock(&st->lock);


