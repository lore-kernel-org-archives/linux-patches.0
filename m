Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E317555;
	Sat, 30 May 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165102; cv=none; b=uvTH2dQ8yj+lfGJWXraS4F7cX7jsxWISbKwACuIj2jAfaJdn5Ooq3JNl2sqGEBFRbqlGUaEHVPqIZRizHBxqgW6WAzfxWs5p2TqPwNliwPFZnYNTBG9+GyA9SfuKc+3JjTQuBM2wsrsubDh2nWxllFT2HT2FLxklxzsJJHGZTPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165102; c=relaxed/simple;
	bh=Cr/DVBhH5yQklrO8C4u6NvRX57XgjnZAONEoKJcjDN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJjSPRXVK6h/0hN39LEC7sYsmp9ZGLjXXNg0dfg/x9E6DntU4IhtKn554G/RPkzyqBwiYEq+mMzyzZi/A1sEIs+6LwYG6daaG6Tho5AeOwoKjAWFejCPtQ6OLyFJ1qjjUwSGDVZfKAfk7/SrYo/EwPrCiFCekDJlkWAl712cvVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsOIVVsJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsOIVVsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660BC1F00893;
	Sat, 30 May 2026 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165101;
	bh=lJpf7kBANBIPYYhY7scZQkq4xY6gMNaQCMn8pFKTnnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsOIVVsJ/9WIkVI0/nkwuwJMJcem6mseLm8OKym9kLAOyvs9xRTIbhbgKBxSvhoTE
	 liRAe3j5LozWaIitDpdDjPN/COb17jFBjzuUkss9aBNkIwGGlxeKvqZP2jUQAbMs3S
	 yPYZPMX0B584JFXoPBMc6lQxf4bvzpiRtf1Z+9JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 720/776] hwmon: (pmbus/adm1266) cap PDIO scan in get_multiple at ADM1266_PDIO_NR
Date: Sat, 30 May 2026 18:07:14 +0200
Message-ID: <20260530160258.423450580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit d7834d92251baade796812876e95555e2066fa9f upstream.

adm1266_gpio_get_multiple() iterates the PDIO portion of the
caller-supplied mask using

	for_each_set_bit_from(gpio_nr, mask,
			      ADM1266_GPIO_NR + ADM1266_PDIO_STATUS) {
		...
	}

where ADM1266_PDIO_STATUS is the PMBus command code (0xE9, i.e. 233),
not the number of PDIO pins.  The intended upper bound is
ADM1266_GPIO_NR + ADM1266_PDIO_NR = 25.

gpiolib hands in a mask sized for gc.ngpio (= 25 bits on this chip),
so the iteration walks find_next_bit() up to 242, reading up to 217
extra bits (a handful of unsigned-long words: four on 64-bit, seven
on 32-bit) of whatever lives past the end of the mask in the
caller's stack.  Any incidental set bit in that range then drives a
set_bit(gpio_nr, bits) call that writes past the end of the
caller-supplied bits array too -- both out-of-bounds.

Substitute ADM1266_PDIO_NR for the constant so the scan stops at the
last real PDIO bit.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-1-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -212,7 +212,7 @@ static int adm1266_gpio_get_multiple(str
 	status = read_buf[0] + (read_buf[1] << 8);
 
 	*bits = 0;
-	for_each_set_bit_from(gpio_nr, mask, ADM1266_GPIO_NR + ADM1266_PDIO_STATUS) {
+	for_each_set_bit_from(gpio_nr, mask, ADM1266_GPIO_NR + ADM1266_PDIO_NR) {
 		if (test_bit(gpio_nr - ADM1266_GPIO_NR, &status))
 			set_bit(gpio_nr, bits);
 	}


