Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A6B82495;
	Wed, 19 Jun 2024 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803211; cv=none; b=Du+blc2yK+bCKiyWmTkITJLZUD/LMvLpReUHTrHzP22B2cUYDUqWNe8HhRDZ5TjbhIHbrmvxWWUSQrbfyNI8fx0m478mu4SGNgVPCK0uJSZJBTsOgn8hRmjAoT27/gHuufE/4E+3MmyveF9N9GyGWhTaXLQntmDgDUsW4nFQMAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803211; c=relaxed/simple;
	bh=j57I3MZfQEUdgVVq4wCwJiiBGjiwIbtak0+kDWewnIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sLw4J8u16Wkvbw1r569sgAoMa3lj7Z+QaMNMYTWSz5zZCfIPYMiTZiOh6hZ2wWMNfp4mh+s1+MsPXWYbsdiIg3FgzGZKgyk8yKdv2u+JNqu0eQxSUnwIIhqBle6MDSaJjKVItLCQ7bs2kK9ERSVKQswGxnZkT9t9f+6Tq4ImCnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKywKeq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKywKeq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F9C2BBFC;
	Wed, 19 Jun 2024 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803210;
	bh=j57I3MZfQEUdgVVq4wCwJiiBGjiwIbtak0+kDWewnIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKywKeq0p+PiXzzYZqY3SQZcHRKIMDJ5Mgd583QwJAgIoBQ/170SKD5DeAFZXHQAW
	 +e3Sfvy8jf+uSeUOVA29MPaFcrKXMIaNtML6tOn6fwQBUf0+Uzp8T5i0YQz84VgUgR
	 zOYwgSBfkH9vgUNBcf8ewRv2iLKr9toAvEO2op4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genes Lists <lists@sapience.com>,
	=?UTF-8?q?Johannes=20W=C3=BCller?= <johanneswueller@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.9 191/281] leds: class: Revert: "If no default trigger is given, make hw_control trigger the default trigger"
Date: Wed, 19 Jun 2024 14:55:50 +0200
Message-ID: <20240619125617.298871497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit fcf2a9970ef587d8f358560c381ee6115a9108aa upstream.

Commit 66601a29bb23 ("leds: class: If no default trigger is given, make
hw_control trigger the default trigger") causes ledtrig-netdev to get
set as default trigger on various network LEDs.

This causes users to hit a pre-existing AB-BA deadlock issue in
ledtrig-netdev between the LED-trigger locks and the rtnl mutex,
resulting in hung tasks in kernels >= 6.9.

Solving the deadlock is non trivial, so for now revert the change to
set the hw_control trigger as default trigger, so that ledtrig-netdev
no longer gets activated automatically for various network LEDs.

The netdev trigger is not needed because the network LEDs are usually under
hw-control and the netdev trigger tries to leave things that way so setting
it as the active trigger for the LED class device is a no-op.

Fixes: 66601a29bb23 ("leds: class: If no default trigger is given, make hw_control trigger the default trigger")
Reported-by: Genes Lists <lists@sapience.com>
Closes: https://lore.kernel.org/all/9d189ec329cfe68ed68699f314e191a10d4b5eda.camel@sapience.com/
Reported-by: Johannes Wüller <johanneswueller@gmail.com>
Closes: https://lore.kernel.org/lkml/e441605c-eaf2-4c2d-872b-d8e541f4cf60@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Lee Jones <lee@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/led-class.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 24fcff682b24..ba1be15cfd8e 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -552,12 +552,6 @@ int led_classdev_register_ext(struct device *parent,
 	led_init_core(led_cdev);
 
 #ifdef CONFIG_LEDS_TRIGGERS
-	/*
-	 * If no default trigger was given and hw_control_trigger is set,
-	 * make it the default trigger.
-	 */
-	if (!led_cdev->default_trigger && led_cdev->hw_control_trigger)
-		led_cdev->default_trigger = led_cdev->hw_control_trigger;
 	led_trigger_set_default(led_cdev);
 #endif
 
-- 
2.45.2



