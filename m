Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C02857C1;
	Wed,  8 Apr 2026 19:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674825; cv=none; b=jfczCc+9B80KEZfSnksHMACzkeKT7jzCMjFpOI+Z/B7+c1b76rss2VciJwZJSE0FYUjz1NfGRTDc/F72INhav0DefT5lEXgTXBG5P2VdPF/FE6TuAhWRqsuZGIHjnTLHGKvxU8wleTK2naZ4qWH4I6eupH1fZo2Xom2BV1GvGWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674825; c=relaxed/simple;
	bh=K+d3sM3ZXbghcGPJnmUC6euMFq8hDUib7ue45uh1/dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYuEjPdfRNC5GOjnudooamFjQ2IoNm7EDYv/TV260ngF39RQTYi2BaUy9/284NkR/6S3xgDHqUnWAkNKhxn6+EL4ieQoj6Ey/mMlVpYuJkhrMUwtGFSgPdTCDip8rdku44WeBbIair+zSEZojHvhZ40cEVYwcMsV3xbk0jK+YT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIo7ZRqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIo7ZRqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7FBC2BC87;
	Wed,  8 Apr 2026 19:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674825;
	bh=K+d3sM3ZXbghcGPJnmUC6euMFq8hDUib7ue45uh1/dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIo7ZRqJ/Fm4jmXRS7GR/TNIlX5SyH2ItkWVXxUzj5k77uSrWbTWgQ0TBTxi8WI/l
	 x58vvwY6BuI9p18gjl7MaNANHz//oyfBmGlO1Rhw0VnVhEMEGh8qP8L9Imy9MibCgE
	 afwVKDg3P7sZKEDtlW9+yjOGkeGXsJI2pT4f7RdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 215/311] iio: adc: ti-ads7950: normalize return value of gpio_get
Date: Wed,  8 Apr 2026 20:03:35 +0200
Message-ID: <20260408175947.432205119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit e2fa075d5ce1963e7cb7b0ac708ba567e5af66db upstream.

The GPIO get callback is expected to return 0 or 1 (or a negative error
code). Ensure that the value returned by ti_ads7950_get() for output
pins is normalized to the [0, 1] range.

Fixes: 86ef402d805d ("gpiolib: sanitize the return value of gpio_chip::get()")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -433,7 +433,7 @@ static int ti_ads7950_get(struct gpio_ch
 
 	/* If set as output, return the output */
 	if (st->gpio_cmd_settings_bitmask & BIT(offset)) {
-		ret = st->cmd_settings_bitmask & BIT(offset);
+		ret = (st->cmd_settings_bitmask & BIT(offset)) ? 1 : 0;
 		goto out;
 	}
 


