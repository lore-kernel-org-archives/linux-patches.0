Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2355C30C361;
	Thu, 16 Jul 2026 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211762; cv=none; b=iPl+OeDmIXVfax98StTOj/vBhqqecdN/PJGRgpDHZndpEW1jWM5lA5OKjZtS3bRx7ZIZDLYN3NE4mTFf5xD/hMXGorDCoTdhByKgEfazpEXLWnmqasjr3M7KP0RTIkqSUYOI1DA3K7aTbEDpKzXZt9TMtZxGoBRa2N061d8tlc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211762; c=relaxed/simple;
	bh=j+/iMsermM/HuMjZRZoEZgbkHSr+/yaKfWDcW0WnwyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGhhHKWGGmH45q2vPil4v/G+l5edmVipXziTDoZjMBsQWRmziunK8qPHUfM/TsRtahFsdPq6o7T0aPzrWdZz4tewIwqixrv8sLe3R/WsNHazH/JkY7HlKSyVT+uOWIVc1arbXo2j2CLnPyCsW4oJRiSjYEuKO9ddeM9p8zKICQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMJ+r6JW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMJ+r6JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884A21F000E9;
	Thu, 16 Jul 2026 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211761;
	bh=+lZzrCvhJbYu6L6JuMGIL9RLt1q6sBIbnLJKZGLjuEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMJ+r6JW3YlfGU5bir+rKblVgYWX1vszp+uoX1k/Q4GkJ0HREZcgNFHzlOboLajoi
	 fvssoLvggo+IQske5Dlr32SyYKanRPP0AsUGnimq8iZLSC6SnjtH3kekoq7pIS3T+w
	 BHCBzVWfSLRPDkShWFslbQdpKG5+rNrbGFT6q0+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 070/349] iio: temperature: ltc2983: Fix reinit_completion() called after conversion start
Date: Thu, 16 Jul 2026 15:30:04 +0200
Message-ID: <20260716133034.888984092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Liviu Stan <liviu.stan@analog.com>

commit 5cb9fdb446bfc3ae0524496f53fb68e67051701b upstream.

reinit_completion() was called after regmap_write() initiated the hardware
conversion, creating a race window where the interrupt could fire and call
complete() before reinit_completion() reset the completion.

Move reinit_completion() before the regmap_write() to close the race.
ltc2983_eeprom_cmd() already does it in the correct order.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1177,12 +1177,11 @@ static int ltc2983_chan_read(struct ltc2
 	start_conversion |= LTC2983_STATUS_CHAN_SEL(sensor->chan);
 	dev_dbg(&st->spi->dev, "Start conversion on chan:%d, status:%02X\n",
 		sensor->chan, start_conversion);
+	reinit_completion(&st->completion);
 	/* start conversion */
 	ret = regmap_write(st->regmap, LTC2983_STATUS_REG, start_conversion);
 	if (ret)
 		return ret;
-
-	reinit_completion(&st->completion);
 	/*
 	 * wait for conversion to complete.
 	 * 300 ms should be more than enough to complete the conversion.


