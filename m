Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74254330B3C;
	Fri, 17 Oct 2025 15:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715441; cv=none; b=ievSIGBYdxlC+pAanHbeClF46TQ7dBubtuYT+71tZ0i0YUfcPbzDmZnQXIrEU1dRgg+u3pRJM3PDIp/Sysew0BCqJZPXbm1CvZhevH6UZJu5ymf3bfcySL/Eq2iC1IrzQUwjPDDsHQpaiC/BYtekzOmsCaqwrLmZZopwjVV+JXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715441; c=relaxed/simple;
	bh=SmX2aW+6fy+2nr/JaMRvviepMuEZF9iPwPGl9hDV670=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci3THBW8nWTD8PpL7+7tyhK/fSF0sfzqMxlCaNLfY+YH9Mz0ZHN66jcIwRtMzYBSEK0RJeeMMoLPLsg7UYQWM4B89LoePPgQQQdhEk+pRJEN4gSNTdqZ0Sfzr4gJtk1/SUYoLgfFVJHuzKx9GwuSrFDFUt9DFKB4pm/TfsdOOGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O63uBnQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O63uBnQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4996C4CEFE;
	Fri, 17 Oct 2025 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715441;
	bh=SmX2aW+6fy+2nr/JaMRvviepMuEZF9iPwPGl9hDV670=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O63uBnQp+b/a74W5RWaoONlPq/7aAax19ul6FCa67btYAHZPjYMNKy3GMia9foLeA
	 mf7ux72uXz0EXJVR2pyTY56q/gKAJe8G6HR6a0FN3hN3LmODW02ycqaNWQvtsGQeoi
	 5gIHp0qdxS4TCUVfdfbl9RG+G81lg48XweoLebps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.17 217/371] gpio: mpfs: fix setting gpio direction to output
Date: Fri, 17 Oct 2025 16:53:12 +0200
Message-ID: <20251017145209.938991831@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit bc061143637532c08d9fc657eec93fdc2588068e upstream.

mpfs_gpio_direction_output() actually sets the line to input mode.
Use the correct register settings for output mode so that this function
actually works as intended.

This was a copy-paste mistake made when converting to regmap during the
driver submission process. It went unnoticed because my test for output
mode is toggling LEDs on an Icicle kit which functions with the
incorrect code. The internal reporter has yet to test the patch, but on
their system the incorrect setting may be the reason for failures to
drive the GPIO lines on the BeagleV-fire board.

CC: stable@vger.kernel.org
Fixes: a987b78f3615e ("gpio: mpfs: add polarfire soc gpio support")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250925-boogieman-carrot-82989ff75d10@spud
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mpfs.c
+++ b/drivers/gpio/gpio-mpfs.c
@@ -69,7 +69,7 @@ static int mpfs_gpio_direction_output(st
 	struct mpfs_gpio_chip *mpfs_gpio = gpiochip_get_data(gc);
 
 	regmap_update_bits(mpfs_gpio->regs, MPFS_GPIO_CTRL(gpio_index),
-			   MPFS_GPIO_DIR_MASK, MPFS_GPIO_EN_IN);
+			   MPFS_GPIO_DIR_MASK, MPFS_GPIO_EN_OUT | MPFS_GPIO_EN_OUT_BUF);
 	regmap_update_bits(mpfs_gpio->regs, mpfs_gpio->offsets->outp, BIT(gpio_index),
 			   value << gpio_index);
 


