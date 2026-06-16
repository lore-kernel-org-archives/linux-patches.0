Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1AF35DA78;
	Tue, 16 Jun 2026 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636992; cv=none; b=KBTUlYGHvsaZYT+1CDfZ30AdtGPs1qK923guyf9wYYK5loK7X795seIz4PQPMIjmKFiw75EYXBRtlzfcgeCwfl+Qh/GLif5zY2ZhihudxtpAuInukw+8bzYbRKQ2mm0sL291/CSsXXZy3lGYIRENx8ct/U84grA8DuSFO74EIb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636992; c=relaxed/simple;
	bh=nuIqDvt4GrsurTCDuKCfdCSSt5V41NGOt6ve8CkHJR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lm5+2hq/IEoYcEvYQlqnxizaY1AjNtUgkMerHxa35DK2NEYk7NGNnw89GBMURDw3SMJROl/RP2lc2vh0t+5YWTpSs7e7fRU+D8N9ay4WMFn88CZuAxlYDI0D1K0XZo3YATsQ+XkLyS6+yUiqipPOc3J4V0Bw8frKiioVU7zLEN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgWtW+FC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgWtW+FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE881F000E9;
	Tue, 16 Jun 2026 19:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636991;
	bh=qwcKFCAIqQFdbWh+LSHANM6yAZsD/h4dOZnHkafwinQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgWtW+FClFr/6ncqF0oZ1Cu9DKAgLPTvErAZimEvoymtBKClOJRipFWp+JlPp59hf
	 bsoQKzShgQVY9n81F/uD/a0w9NFgMZhsgFlCm95NP8mZU5ig0YP9Y+/f67r0QpFRt+
	 +VwBg9fzlK8uwTi9IWDmO7uCGjv17tLoZIbWuQ2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/342] iio: gyro: adis16260: fix division by zero in write_raw
Date: Tue, 16 Jun 2026 20:30:19 +0530
Message-ID: <20260616145103.614501760@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -293,6 +293,9 @@ static int adis16260_write_raw(struct ii
 		addr = adis16260_addresses[chan->scan_index][1];
 		return adis_write_reg_16(adis, addr, val);
 	case IIO_CHAN_INFO_SAMP_FREQ:
+		if (val <= 0)
+			return -EINVAL;
+
 		mutex_lock(&adis->state_lock);
 		if (spi_get_device_id(adis->spi)->driver_data)
 			t = 256 / val;


