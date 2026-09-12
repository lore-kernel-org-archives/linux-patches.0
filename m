Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38323345CCE;
	Sat, 12 Sep 2026 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222981; cv=none; b=k5oht6j345z9VOtx4LK5BT93YavaqHVkdfNXXwJDFQNdOXYCPkw18iai87FExzObZeOUn1X9hTsrEjpGXfh77RxSTYCSLEB3+fPMvbZYEFpCwD6C04gEQ+TJW0M/A10+uE/JwatFdJ6B4hsyCcGSB+aIB5eUI58Y8slduLJXGQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222981; c=relaxed/simple;
	bh=NLA6iqNcSVWwJJaWwWcYHgvTfMfUKp2F3nDBkOfiUIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZYHNHcrPWfKnBBm5jsjpBPZARWpDJF2MX1qQ0g1liz9YDS98t0+Bm5qv910lmmmhIODByuTRrHrXrHgxXzsp7Mj1O8Tmtc5pCuf6jMbnWkbif1ZOaPq59ZX7WbHMSbsmnAzCI9eNfU5vk81agca/KsRFrhu/QFpnQVEnrLnQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1Y7dv2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1Y7dv2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE701F000FF;
	Sat, 12 Sep 2026 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222978;
	bh=Zuphn6Q7VMDrKfDna1rMCz+VKXaLxJqvy8Z2808EAhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1Y7dv2mRkoMa6b8tBXhi4D4etgVUvZUHOyAaMgdGjlzsGK8XhsQ085h0Y/Zl73vq
	 FQcMuctsOwyzAxmEfS9PT/1IDzyMcbZ+Iq1h8OiJTn4dYg/mqk8jlWGHWc/fJdYbek
	 VnGpFr0neGlYioSQD7Ox1v98IsrXxyNVFCvBQ30c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0696/1424] leds: pca9532: Fix inverted GPIO output polarity
Date: Sat, 12 Sep 2026 08:52:08 +0200
Message-ID: <20260912065622.885592258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Cosmo Chou <chou.cosmo@gmail.com>

[ Upstream commit 65a38a28a0b04af19a5e1fbf3869051412eeac96 ]

The pca9532_gpio_set_value() function incorrectly mapped the requested
value to PCA9532_ON and PCA9532_OFF, inverting the GPIO output polarity.
A requested logical high (val=1) incorrectly enabled the LED output
driver, which on this open-drain device pulls the pin low, while a
requested logical low (val=0) released the pin.

Correct the mapping so that val=1 yields PCA9532_OFF (pin released /
high-impedance) and val=0 yields PCA9532_ON (pin driven low).

pca9532_gpio_direction_input() is also updated to pass val=1 to
pca9532_gpio_set_value() to align with the corrected polarity mapping,
ensuring the pin remains not driven when configured as an input.

Fixes: 3c1ab50d0a31 ("drivers/leds/leds-pca9532.c: add gpio capability")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260703014201.69829-1-chou.cosmo@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca9532.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index bf8bb8fc007c6..b15389d818eb7 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -283,9 +283,9 @@ static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned offset, int va
 	struct pca9532_led *led = &data->leds[offset];
 
 	if (val)
-		led->state = PCA9532_ON;
-	else
 		led->state = PCA9532_OFF;
+	else
+		led->state = PCA9532_ON;
 
 	pca9532_setled(led);
 }
@@ -303,7 +303,7 @@ static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned offset)
 static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	/* To use as input ensure pin is not driven */
-	pca9532_gpio_set_value(gc, offset, 0);
+	pca9532_gpio_set_value(gc, offset, 1);
 
 	return 0;
 }
-- 
2.53.0



