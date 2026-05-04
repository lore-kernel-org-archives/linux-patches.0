Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F73DE45C;
	Mon,  4 May 2026 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904790; cv=none; b=gqv2E4ikr/8HMubW2xrztwuLTVwvOvKCz8MyygenfZoXU2ku+nwY3UmNAG3y3Za74HzveYCpT/TddgkTIYUXmga7PmL1socH/xR7oW6Ee4+tvS5ag9n3IfZJEFU03TR3zEMS5GoS2O6faUSmP7/e9hgXwhq7LrEDkPBQsUVAfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904790; c=relaxed/simple;
	bh=hIKG7rqtl6B5oi4HYO2gww619wFvpWDQA0kUPxaalRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhJ55NyhsEkBZ58CtEuKoPftW+hdvCCsDLCyztbkowCzQG55SD1u1+OyVrNFu5IEfk7Y7bfYH5r1p8ZciWjqh5Xi96FKeEkvjmOIgC9SBAvddBvtIi4GexjfkU3mGvHilsIbYh90o1m18FcaJzJmwfa/2WAKC5qkfP8dp8wdZFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTJ/Lzpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTJ/Lzpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D574C2BCB8;
	Mon,  4 May 2026 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904790;
	bh=hIKG7rqtl6B5oi4HYO2gww619wFvpWDQA0kUPxaalRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTJ/Lzpvj8mRFvCi7nzKP/KEGCaoV7RdL9WZKPiM+Ian1Qi5V3zG2G9BRr0IRKzmk
	 pW8ehvKAj30Aa3m2UWl+fPMov730P8136MrfUjRR9Hf9JCQGAcyaTJsjG9hDPbfWFl
	 PW573ztvqUpLTXqMXJVbvwhuDBD8Ig4+dDZN5NI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Eikmeyer?= <andre.eikmeyer@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 143/215] HID: apple: ensure the keyboard backlight is off if suspending
Date: Mon,  4 May 2026 15:52:42 +0200
Message-ID: <20260504135135.380303779@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 1f95a6cd5ad78ed27a31a20cbd1facff6f10b33d upstream.

Some users reported that upon suspending their keyboard backlight
remained on. Fix this by adding the missing LED_CORE_SUSPENDRESUME flag.

Cc: stable@vger.kernel.org
Fixes: 394ba612f941 ("HID: apple: Add support for magic keyboard backlight on T2 Macs")
Fixes: 9018eacbe623 ("HID: apple: Add support for keyboard backlight on certain T2 Macs.")
Reported-by: André Eikmeyer <andre.eikmeyer@gmail.com>
Tested-by: André Eikmeyer <andre.eikmeyer@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -832,6 +832,7 @@ static int apple_backlight_init(struct h
 	asc->backlight->cdev.name = "apple::kbd_backlight";
 	asc->backlight->cdev.max_brightness = rep->backlight_on_max;
 	asc->backlight->cdev.brightness_set_blocking = apple_backlight_led_set;
+	asc->backlight->cdev.flags = LED_CORE_SUSPENDRESUME;
 
 	ret = apple_backlight_set(hdev, 0, 0);
 	if (ret < 0) {
@@ -900,6 +901,7 @@ static int apple_magic_backlight_init(st
 	backlight->cdev.name = ":white:" LED_FUNCTION_KBD_BACKLIGHT;
 	backlight->cdev.max_brightness = backlight->brightness->field[0]->logical_maximum;
 	backlight->cdev.brightness_set_blocking = apple_magic_backlight_led_set;
+	backlight->cdev.flags = LED_CORE_SUSPENDRESUME;
 
 	apple_magic_backlight_set(backlight, 0, 0);
 


