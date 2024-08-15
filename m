Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2ED1714A1;
	Thu, 15 Aug 2024 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730143; cv=none; b=XA7HTovc0MAzvM8IkjlhiY6jg0Hxyuuj8MndenIme95SE1NY8QEaR6kgtZzMqPuk9R+o4ZmZI9Q2Pm9SngSSlxx6lZubSA8vGH1i+KBU4J3VHh86IThRjKD2YFwnMYg6gIDj3GLUzU67zBBxTIAeARU98i/to5PUe1M4IXm+cvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730143; c=relaxed/simple;
	bh=ZB+OF2YiXECrWPSR3ygLqsNcmhxkh13AwlM55u4drPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XcDOBHAFPWDpOZ6NWuyl3qZ74ghBuZ/X5R7l9Q9rXvHlk/Ji/Xn+BzbBYM/lUMwrlrFifWjNaPJfquGAvjJX/CQRi10nv++a2/ekmiRfUFA+7d1fBXs1g9GsqXyDQdINvPaYYA2I2XsEPmaOay+ck62rJJPTr/ZiyHm75wsWn4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXIocWWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXIocWWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CCEC32786;
	Thu, 15 Aug 2024 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730143;
	bh=ZB+OF2YiXECrWPSR3ygLqsNcmhxkh13AwlM55u4drPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXIocWWcha24LcOEp1d5psLzqHE9EAztk9VpknJzER/BKU6D4FuIPt46nnssF+2eH
	 qWPqi5N9BNfbvhwuYwSpT1kDlmIeNnt1fe8y7hahe2d8lKr/EOO+VaUtTUbKgQP0YL
	 m0J3AFziW1GHPfsscitb2w0WT1+K/mgkXG4bbA2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/484] leds: triggers: Flush pending brightness before activating trigger
Date: Thu, 15 Aug 2024 15:22:54 +0200
Message-ID: <20240815131953.608476380@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit ab477b766edd3bfb6321a6e3df4c790612613fae ]

The race fixed in timer_trig_activate() between a blocking
set_brightness() call and trigger->activate() can affect any trigger.
So move the call to flush_work() into led_trigger_set() where it can
avoid the race for all triggers.

Fixes: 0db37915d912 ("leds: avoid races with workqueue")
Fixes: 8c0f693c6eff ("leds: avoid flush_work in atomic context")
Cc: stable@vger.kernel.org
Tested-by: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20240613-led-trigger-flush-v2-1-f4f970799d77@weissschuh.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c          | 6 ++++++
 drivers/leds/trigger/ledtrig-timer.c | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index fe7fb2e7149c5..3d3673c197e38 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -200,6 +200,12 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		 */
 		synchronize_rcu();
 
+		/*
+		 * If "set brightness to 0" is pending in workqueue,
+		 * we don't want that to be reordered after ->activate()
+		 */
+		flush_work(&led_cdev->set_brightness_work);
+
 		ret = 0;
 		if (trig->activate)
 			ret = trig->activate(led_cdev);
diff --git a/drivers/leds/trigger/ledtrig-timer.c b/drivers/leds/trigger/ledtrig-timer.c
index b4688d1d9d2b2..1d213c999d40a 100644
--- a/drivers/leds/trigger/ledtrig-timer.c
+++ b/drivers/leds/trigger/ledtrig-timer.c
@@ -110,11 +110,6 @@ static int timer_trig_activate(struct led_classdev *led_cdev)
 		led_cdev->flags &= ~LED_INIT_DEFAULT_TRIGGER;
 	}
 
-	/*
-	 * If "set brightness to 0" is pending in workqueue, we don't
-	 * want that to be reordered after blink_set()
-	 */
-	flush_work(&led_cdev->set_brightness_work);
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
 
-- 
2.43.0



