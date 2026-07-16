Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7C73BED2D;
	Thu, 16 Jul 2026 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209267; cv=none; b=ha0V63kuDoqQo77liXJP8mVDsQjw/YvNAk2Ca0FpHq3jePUP1d8obmDtQF9SXZSq9lgxjjGIqrwwp907JbA35VUsOkJ+F5eJGr3CluBU2iyEUMlTnz5yl3OYUxMaIqS14VZIsRRGFaMa3jCdYBttUBrufLJDmKZdFnv9IgGTYoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209267; c=relaxed/simple;
	bh=ksuNTiporSbLo/dzN0qdz6328Mi5thzVwHIwhUogI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtKdvHoXBHZRxeSZbHaJ+N5evv7Urrm6s2C+K3DXPkvSn7kcs/H9rMHyJUUP2hM7KJarPtbt8HHlag+e58Xa6xRHh6roL3v1Qaclutp/mXZbdO/8hWb9RtVxtZgRKa+C6Y8f88ybnV3jFsUNPFpjU1SR7yr92jnvEUS5npJ+unA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlmK3ZeO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlmK3ZeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50BC1F000E9;
	Thu, 16 Jul 2026 13:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209266;
	bh=56APLqO7AneSZTgL4cwOGuyHuH0BKLYUWDwz+vMQqlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlmK3ZeO1pZgLL9evyk7r6hJEqpmcwLu+nCAmcYYgqdIGQR7CR8BDTeAv84c3FjqM
	 YTni8DpiVU8AJL9nOnKownhsLpw95ILEShyUAXUfxI8GhCt+k71Q2hVTdo7QmXTUHu
	 yy4XdTgFs3K6mjDxY1x3iUyYurd7pB0QGzlUnSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 077/518] iio: temperature: ltc2983: Fix reinit_completion() called after conversion start
Date: Thu, 16 Jul 2026 15:25:45 +0200
Message-ID: <20260716133049.470851592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


