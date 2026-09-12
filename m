Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1D026ED46;
	Sat, 12 Sep 2026 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242460; cv=none; b=lsIGCwXZHJBltoelEUJhU9k7IF6pnpleAsmxlQJk5Y/umYgL/3e9YM6P+ruZ6G0b1Ykf7eB7mbORb1WJzOiGdkja8c90BSy8QPWGODM05WvITHB+UCaTcN5FZfphlC8L7nzN2FdDVhmHGg2OAfgqNsjT7VvhQnJo/FgU40YdcvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242460; c=relaxed/simple;
	bh=1XtkVye4z4PcKrY/cCwWu3ju/ya39ETuUyYMfIbkPA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl5V1AaxhnHH1BEVbpnFOpPO9RxNBxihhuQZ7wT8C/yz4FaZpC3lvMtS2bXbR5ZStliprWQFY53xAUqz/T6P6GKcaxv6lMPzCHz0PNBPgi06JM6KE2ymmwH7o3zJNn3trUAP9kwbAZvogWhjvvgmnHKttN6YyM+l5Vp3HnlF+2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iusy+PKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iusy+PKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B221F000FF;
	Sat, 12 Sep 2026 19:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242458;
	bh=nS64hq5aoSwSRFGpRIVY0Go9+SdE6NIah0/1QdcNajg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iusy+PKd5zG/Y0XAyvDNo0JrSZYWJHNNeSjXoAqi6eig5l4sgbeKFGXjzDZMWNgLv
	 364azX/ybDIdxe3J8i95x5W0ubOlU5rIndrkl5pUudamYl0N8c7eHkTR/cu74uJiqN
	 hAnZTFv8xhRHsR+zXgBNJJpcErZ66TVfKUG+xNys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 410/798] leds: pca9532: Fix inverted GPIO output polarity
Date: Sat, 12 Sep 2026 09:00:38 +0200
Message-ID: <20260912065526.545159595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 27d0271654725..ae5e5dfaab3cd 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -285,9 +285,9 @@ static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned offset, int va
 	struct pca9532_led *led = &data->leds[offset];
 
 	if (val)
-		led->state = PCA9532_ON;
-	else
 		led->state = PCA9532_OFF;
+	else
+		led->state = PCA9532_ON;
 
 	pca9532_setled(led);
 }
@@ -305,7 +305,7 @@ static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned offset)
 static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	/* To use as input ensure pin is not driven */
-	pca9532_gpio_set_value(gc, offset, 0);
+	pca9532_gpio_set_value(gc, offset, 1);
 
 	return 0;
 }
-- 
2.53.0



