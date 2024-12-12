Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2025176AA1;
	Thu, 12 Dec 2024 17:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023293; cv=none; b=BZtOE3hKR8YYWwUGkFRvel4auT17bgrlABOhamSRx1YcJOz4fctizCPbcB8WVwW+37GI46smvMiAv3SWgcFyzuMQ1zy9w64qziXfNnVIq5ftb5CC6ZqTemaJgloh2FkC20WIZ0IjcXmxdct+u8SaWvjJfyk/m1fAi4PnDkj4/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023293; c=relaxed/simple;
	bh=eX56A0pVVlOyMXxkxKTtY/jPKB3U+T0ZHFQuQzThZVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgPS6b9kwzmSetJY2Vul2w8Uv7iRbCQRb6l2e4lCTotfNGf6dBGb4GfW5kC/UXDkVYvQLcwV5zZLblKIc5hsgHDluV6S3IciUjpM5CiMv0PTCg1ekzwU6+kZwe9gFKDYGa/noWVmTsGdzGUerMMheO2RowOm7c8NNnc8tOjA0A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvbIApMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvbIApMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F12C4CECE;
	Thu, 12 Dec 2024 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023292;
	bh=eX56A0pVVlOyMXxkxKTtY/jPKB3U+T0ZHFQuQzThZVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvbIApMcrGGG/hnIhYBuciXTLVYFvdW4aScRbMk6fQO2IjNlyzgdRAjTEdFgqpahy
	 vfGTvkQZaflpIvWj1Foz7xtpm608zwm91lAwyvdbaqubWhi+Q+Z0+ADXlRSnlXPm9C
	 /3Z+jLqTiskxM9DqtDxZio+foxX7y+EOLex14lCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 447/565] can: dev: can_set_termination(): allow sleeping GPIOs
Date: Thu, 12 Dec 2024 16:00:42 +0100
Message-ID: <20241212144329.384579151@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit ee1dfbdd8b4b6de85e96ae2059dc9c1bdb6b49b5 upstream.

In commit 6e86a1543c37 ("can: dev: provide optional GPIO based
termination support") GPIO based termination support was added.

For no particular reason that patch uses gpiod_set_value() to set the
GPIO. This leads to the following warning, if the systems uses a
sleeping GPIO, i.e. behind an I2C port expander:

| WARNING: CPU: 0 PID: 379 at /drivers/gpio/gpiolib.c:3496 gpiod_set_value+0x50/0x6c
| CPU: 0 UID: 0 PID: 379 Comm: ip Not tainted 6.11.0-20241016-1 #1 823affae360cc91126e4d316d7a614a8bf86236c

Replace gpiod_set_value() by gpiod_set_value_cansleep() to allow the
use of sleeping GPIOs.

Cc: Nicolai Buchwitz <nb@tipi-net.de>
Cc: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Cc: stable@vger.kernel.org
Reported-by: Leonard Göhrs <l.goehrs@pengutronix.de>
Tested-by: Leonard Göhrs <l.goehrs@pengutronix.de>
Fixes: 6e86a1543c37 ("can: dev: provide optional GPIO based termination support")
Link: https://patch.msgid.link/20241121-dev-fix-can_set_termination-v1-1-41fa6e29216d@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -409,7 +409,7 @@ static int can_set_termination(struct ne
 	else
 		set = 0;
 
-	gpiod_set_value(priv->termination_gpio, set);
+	gpiod_set_value_cansleep(priv->termination_gpio, set);
 
 	return 0;
 }


