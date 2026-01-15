Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A98D3D6677;
	Thu, 15 Jan 2026 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499769; cv=none; b=Y+WVZs6v+oCn70AogB5/dkT6tZXh+bwBrPRjMMsC9SdX/rl4aZuwPG2oK1QzSItN7c89Loo69YLpDwk9yLuwSrynQ/3gRsmpyaABnsOO+0nwKhinBzqt/lFb1Rnq8LTmybPg84738ywMbdL8wRBh56Q2pxeL6UY/TMS1OsoJQzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499769; c=relaxed/simple;
	bh=NXUCBa53QfZix2i3oiyPsUILxrRsFTfF5f3++Um5Wa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5S+FVFR66zVYJ2XdcEDxhi3x13qXnHWKa1JyMpLtHUTZ4I08c/cpoz76cN7sKQLB9lqYF8xiaKiIC3nlPv0881WFDjxAXj7FB4fSoJyamtnI9OGpIInriNfe/JFlsGoe8XM95HrfNXgJBr5ukyvtJJoZvddv8EtKbCp5cuBCsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlQwi04K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlQwi04K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEF9C116D0;
	Thu, 15 Jan 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499769;
	bh=NXUCBa53QfZix2i3oiyPsUILxrRsFTfF5f3++Um5Wa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlQwi04K6MHNEtxX7fkHF5Nqq4g0gorcV6iw2XIO6FhjobmosFAQam3qg+lB1Zln6
	 T07NqYkc8JAq2/ZHATX4XY1quTBmsYOWPjc0oHokR0amuE/aNNsF+iCKCGZFKCcabF
	 tCLSJo1V0hxewvS50vheslgXzsbVPh888q/4X5HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 310/451] leds: leds-lp50xx: Allow LED 0 to be added to module bank
Date: Thu, 15 Jan 2026 17:48:31 +0100
Message-ID: <20260115164242.114743933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Christian Hitz <christian.hitz@bbv.ch>

commit 26fe74d598c32e7bc6f150edfc4aa43e1bee55db upstream.

led_banks contains LED module number(s) that should be grouped into the
module bank. led_banks is 0-initialized.
By checking the led_banks entries for 0, un-set entries are detected.
But a 0-entry also indicates that LED module 0 should be grouped into the
module bank.

By only iterating over the available entries no check for unused entries
is required and LED module 0 can be added to bank.

Cc: stable@vger.kernel.org
Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Signed-off-by: Christian Hitz <christian.hitz@bbv.ch>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Link: https://patch.msgid.link/20251008123222.1117331-1-christian@klarinett.li
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -348,17 +348,15 @@ out:
 	return ret;
 }
 
-static int lp50xx_set_banks(struct lp50xx *priv, u32 led_banks[])
+static int lp50xx_set_banks(struct lp50xx *priv, u32 led_banks[], int num_leds)
 {
 	u8 led_config_lo, led_config_hi;
 	u32 bank_enable_mask = 0;
 	int ret;
 	int i;
 
-	for (i = 0; i < priv->chip_info->max_modules; i++) {
-		if (led_banks[i])
-			bank_enable_mask |= (1 << led_banks[i]);
-	}
+	for (i = 0; i < num_leds; i++)
+		bank_enable_mask |= (1 << led_banks[i]);
 
 	led_config_lo = (u8)(bank_enable_mask & 0xff);
 	led_config_hi = (u8)(bank_enable_mask >> 8) & 0xff;
@@ -416,7 +414,7 @@ static int lp50xx_probe_leds(struct fwno
 			return ret;
 		}
 
-		ret = lp50xx_set_banks(priv, led_banks);
+		ret = lp50xx_set_banks(priv, led_banks, num_leds);
 		if (ret) {
 			dev_err(&priv->client->dev, "Cannot setup banked LEDs\n");
 			return ret;


