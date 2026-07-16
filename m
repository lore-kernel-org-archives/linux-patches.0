Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D1730D3F6;
	Thu, 16 Jul 2026 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210690; cv=none; b=AAHhM8PyePWIR2C01wAasVS+uiKTSSYd+VefrasUQV8AZTas7p7weOBMtQa0bu/tVr9aj8v1/kNypqFWtuoMlnPHXmVuf/AEB1CDcitPUXKJsmdRdMf6KiON8jJkgDHV7GmWXX4m+8IDLQiHtjDvbfjOaa/w7LVEniqAAkBaDa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210690; c=relaxed/simple;
	bh=tTA4nL0Iw653TVbDlWmywEly4ImzZ2k6/PBgzHWKucY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUKFPcmgFL7ae+T7tF1XSt49VXPueMluFDhAAc3nIJyy4s86zHitIeP+uIyaNjr6sobvmBhEgsXagYy32scehyjVH1UoukIQROL8hoEzaFlmpFdMv2L238DS7mf9rcWPRLoFa68AZA3hnxSDM2MmcLRcSezBg81qx+f2BccB4JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOVi16g8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOVi16g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A54B1F000E9;
	Thu, 16 Jul 2026 14:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210689;
	bh=rFSpVSCmQkwkvzel3ZAK619Iz9T2UGmX044RdbTnEYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOVi16g8ettuTCo18vkfHY6ARISUyXvHSwDw1tgcWSyShNXk2xACVGv7RtHur1Kdo
	 0mj7GDtrZoNxXSe0cg2qbV7PHX59u5XVDPSI9NXIjL3N6ewMl/P82jdIFVKZdF+OZl
	 wCHG6nVjUdZGS5bbSOMogJbcYp5HMpQZAphyy7+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 089/480] iio: temperature: ltc2983: Fix reinit_completion() called after conversion start
Date: Thu, 16 Jul 2026 15:27:16 +0200
Message-ID: <20260716133046.636557753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


