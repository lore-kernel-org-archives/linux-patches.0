Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65671A76AF;
	Tue, 30 Jul 2024 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360132; cv=none; b=EaCTy4+kWDw8iez1JIfJThWNOWaSYWJc/CD7GVnZkkA+wbGxAjUs9cSAgrcN67p9siQDdBSyI9JF1YJEt3oVAJrlYDKCYK0E4pwFhmZq2ZVOXZhXkduH7HVK7RIiA8Ke2OJcL0c87K0ZMrsDUTaSliB23wsNefGkIsEF4BgbnvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360132; c=relaxed/simple;
	bh=pCc+jRz0Fs/cF8m2sUZng7Xb/7btWKtFnLDTFFbou5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNdJ9FSGyyDOG+07+iAkLzdHR6UgdRswq0OjpZ5r3YFOVfGwGd4B722UDKzbj71aadFhjCmEpa9iAUf95eidjpFCIIcxdkcqsUzab+TzPMMnNYTmuEmzITVG2RLdEr7u9VZlF5RPwkPnLcbP81k8CiX8Lm6voY1vOjYpKuzP/mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1Ckj0UP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1Ckj0UP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D33C32782;
	Tue, 30 Jul 2024 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360132;
	bh=pCc+jRz0Fs/cF8m2sUZng7Xb/7btWKtFnLDTFFbou5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1Ckj0UPH+j62j2bsM7LthZxSdg4/+9YUXApyon6e6aq2LtmZ+TKFCZ7a/zE2FZiY
	 +uFg+JcOd2N0FiyRotjRmkZR0s0JZA/fGuvEy28dbVskvjFg7PISmlVvIo76yCfxLG
	 /n/UFVb6U/7lYRmNfdpsHBiHUgR+v0jgU2RgH8sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.10 607/809] leds: triggers: Flush pending brightness before activating trigger
Date: Tue, 30 Jul 2024 17:48:03 +0200
Message-ID: <20240730151748.810030938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit ab477b766edd3bfb6321a6e3df4c790612613fae upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/led-triggers.c          |    6 ++++++
 drivers/leds/trigger/ledtrig-timer.c |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -194,6 +194,12 @@ int led_trigger_set(struct led_classdev
 		spin_unlock(&trig->leddev_list_lock);
 		led_cdev->trigger = trig;
 
+		/*
+		 * If "set brightness to 0" is pending in workqueue,
+		 * we don't want that to be reordered after ->activate()
+		 */
+		flush_work(&led_cdev->set_brightness_work);
+
 		ret = 0;
 		if (trig->activate)
 			ret = trig->activate(led_cdev);
--- a/drivers/leds/trigger/ledtrig-timer.c
+++ b/drivers/leds/trigger/ledtrig-timer.c
@@ -110,11 +110,6 @@ static int timer_trig_activate(struct le
 		led_cdev->flags &= ~LED_INIT_DEFAULT_TRIGGER;
 	}
 
-	/*
-	 * If "set brightness to 0" is pending in workqueue, we don't
-	 * want that to be reordered after blink_set()
-	 */
-	flush_work(&led_cdev->set_brightness_work);
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
 


