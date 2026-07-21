Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB094471423;
	Tue, 21 Jul 2026 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664897; cv=none; b=jjucU56kYlFgm1jNoavLz1/Z/iZAHnnAnF68MlNp/RejNDrnsLpY7pKp0YR/y999WdS+uRZahuoMT12XwBC3kbEZAZs+lOu24prSHHzwGDIDfA2GifXEotjqBdThBJlfFZmRW6m3jMTQmWGYT3ZFC5UyKgugy+l4CgETOjdEvU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664897; c=relaxed/simple;
	bh=DG9u93YGTvIMlMnpTuSEctwno79mmLr8M7GGb6bq0Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szMeevo0wGDa5hu9fUkRVS4G7df2cB++il/a5bG72Z63LpbhjtVmw8Gf472qElvYPI8VhXT11Lyt4aYko9ysizmNkSn+PngwmN9lUMrtI52o1l9xzYAKSvjJKUcjaTXBxDO+BlAZZipO1IgvaHZsR3os3IW923PGieluImk5VLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQeYeVrb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQeYeVrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7331F000E9;
	Tue, 21 Jul 2026 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664896;
	bh=Bk2QBbDA8cZMqWzItYZwf3IlJ4MC0n8hoL8Bw6bSf3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQeYeVrbpSR+yByEMfPZkEWDChDVtra5AibTIBqJ6JyTIWb1NkyAhjMtiTP3ZjqWS
	 A3J67ywXHIPPlHwk6sf23uzKc8Qhdn+9qDIvLjV3h6uBBjW3w7DnupNta+PmTB8VPC
	 Vk6dfZfCZ09LAlVL7oJHZOfh2qfxmnQJQjPHE138=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0101/1266] iio: temperature: ltc2983: Fix reinit_completion() called after conversion start
Date: Tue, 21 Jul 2026 17:08:58 +0200
Message-ID: <20260721152444.062705535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1231,12 +1231,11 @@ static int ltc2983_chan_read(struct ltc2
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


