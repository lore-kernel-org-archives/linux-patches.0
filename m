Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D06248BA1;
	Wed, 15 Jan 2025 10:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937766; cv=none; b=igijZ0RQFhmzf0yDKZ1DoOb4pNmj6RWQ6OPdIeTBVgXXrMvMWEbbslufikvekwCO3yazTZBn/wLzAKh6mS/yUTmIb2LpnP0Y5srWD5U2HhIenT7xFNJt9GmUlMiqP4Q6Tjtw/oNvjsHZHaqMz/Yte4W58dmqOOWH6pc0An3I3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937766; c=relaxed/simple;
	bh=Ae3BtkwsCSSavh4ms1LNzxu0cQGIh1aKCLH1vA2pyhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYLu5mthgGRQ+XIDJO1X1MnCwjEGjgTZ0JkouC8/TqeayqMUM0GyIuER7ek9pQd37d/ySBS3wUEb6/S27nJ4lQYG5TNR/az2a0gDeYMNgPwLUBirZYfKteaxfRJTkzAVqiGRzVOgJovz6+xV9ithKtRIhaWgEtVbG78ZQlmzCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBxR2D8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBxR2D8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A17C4CEE1;
	Wed, 15 Jan 2025 10:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937766;
	bh=Ae3BtkwsCSSavh4ms1LNzxu0cQGIh1aKCLH1vA2pyhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBxR2D8kzleCipO5YzJjY9JN1pjedt2Pd+RTs5ULNaadQ+UNsVw8fA1m3JsyvE16M
	 KVZjIaGE/9ZiSCeEVWMHmgdFsiBlSLkpEvVPyHkSY88UUnBWJv1kIJz9AvureCLz+i
	 ZTRTpv9fcOrZ0XiibrEf+4JhKvFnsnpV6xUOaZPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fabio Estevam <festevam@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 75/92] iio: adc: ti-ads124s08: Use gpiod_set_value_cansleep()
Date: Wed, 15 Jan 2025 11:37:33 +0100
Message-ID: <20250115103550.551564739@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

commit 2a8e34096ec70d73ebb6d9920688ea312700cbd9 upstream.

Using gpiod_set_value() to control the reset GPIO causes some verbose
warnings during boot when the reset GPIO is controlled by an I2C IO
expander.

As the caller can sleep, use the gpiod_set_value_cansleep() variant to
fix the issue.

Tested on a custom i.MX93 board with a ADS124S08 ADC.

Cc: stable@kernel.org
Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20241122164308.390340-1-festevam@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads124s08.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -183,9 +183,9 @@ static int ads124s_reset(struct iio_dev
 	struct ads124s_private *priv = iio_priv(indio_dev);
 
 	if (priv->reset_gpio) {
-		gpiod_set_value(priv->reset_gpio, 0);
+		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 		udelay(200);
-		gpiod_set_value(priv->reset_gpio, 1);
+		gpiod_set_value_cansleep(priv->reset_gpio, 1);
 	} else {
 		return ads124s_write_cmd(indio_dev, ADS124S08_CMD_RESET);
 	}


