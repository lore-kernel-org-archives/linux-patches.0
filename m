Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED8D1420A6;
	Tue, 27 Feb 2024 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043221; cv=none; b=Pspvv2LixSHmfZNnFjd7s0bIaJHJEKlGJNfIca7ZUv+1jIHe6dvFF6jsAibm/8lGFmd9xuF9RybRNABRBcPS4I1y6iFvhXPrkfiKIPiPuoNSYjEB6dkTG/j64FSpOqMVmtvoTqiDmysH/e3bj/pLFomVD+xVOjA6ItISeF8g5kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043221; c=relaxed/simple;
	bh=yeoCL4dQXTohIDQCb/3NXWoxvOfjmB6ShBjkh3RAwB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvLwdiqtGJAoVq89ASRR8mYi+24aQrxmcvVcfZWfjsHfATSnZzEKdsC01JzhbsdiIuSOJl6JqysTKoa9AgQGyN8GdLkVpUpsJGPukgeH8rmP9XOuyWjpN7M5lh9azYzPux7hxjmV31LtvYyYCWfFqVWiKWRY9JiWlhpUONI6Mxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P94dVNWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P94dVNWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7015C433C7;
	Tue, 27 Feb 2024 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043221;
	bh=yeoCL4dQXTohIDQCb/3NXWoxvOfjmB6ShBjkh3RAwB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P94dVNWhgmwiprhzSpmLpI6ij93kBmMsQk6atGAsFkXiDMe5yA60tzJtfPO5hubyb
	 ftE6b8UNGUqwc9il5AWRC+6g0Kqs37SxL8AOt8omWHbIPGiz1OjteGXIrmVED3P3R1
	 fS3gsldvyN+ydvu11WlzMTcZVkjJ7iW748xeoXso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/195] Input: goodix - accept ACPI resources with gpio_count == 3 && gpio_int_idx == 0
Date: Tue, 27 Feb 2024 14:24:50 +0100
Message-ID: <20240227131611.355931151@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 180a8f12c21f41740fee09ca7f7aa98ff5bb99f8 ]

Some devices list 3 Gpio resources in the ACPI resource list for
the touchscreen:

1. GpioInt resource pointing to the GPIO used for the interrupt
2. GpioIo resource pointing to the reset GPIO
3. GpioIo resource pointing to the GPIO used for the interrupt

Note how the third extra GpioIo resource really is a duplicate
of the GpioInt provided info.

Ignore this extra GPIO, treating this setup the same as gpio_count == 2 &&
gpio_int_idx == 0 fixes the touchscreen not working on the Thunderbook
Colossus W803 rugged tablet and likely also on the CyberBook_T116K.

Reported-by: Maarten van der Schrieck
Closes: https://gitlab.com/AdyaAdya/goodix-touchscreen-linux-driver/-/issues/22
Suggested-by: Maarten van der Schrieck
Tested-by: Maarten van der Schrieck
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231223141650.10679-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 3f0732db7bf5b..6de64b3f900fb 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -884,7 +884,8 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 		}
 	}
 
-	if (ts->gpio_count == 2 && ts->gpio_int_idx == 0) {
+	/* Some devices with gpio_int_idx 0 list a third unused GPIO */
+	if ((ts->gpio_count == 2 || ts->gpio_count == 3) && ts->gpio_int_idx == 0) {
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_first_gpios;
 	} else if (ts->gpio_count == 2 && ts->gpio_int_idx == 1) {
-- 
2.43.0



