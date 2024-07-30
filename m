Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FE0155CB3;
	Tue, 30 Jul 2024 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358224; cv=none; b=F9rI1GUfijINVyEqzkRqE+TJejiOSmdBK3oePaFMstD1/DDRy0VgAD0dBf5YiUNsWfiLeMmfjZXgHDnzE09oCldD2SYf7Dexo3/wmCoX2DbZ1w4LzqmJnns93mxQuc6snRAkyNg2eJonqiItZvnI49gmbIZVIKMENnHizB2cAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358224; c=relaxed/simple;
	bh=Qb7LhAj6/u0/VYPrn689WskuckX4HYjqPze7suqTWRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0y7I7JsdY8i8EDLMjWMeTUeCv0Lfb9IK+dre67+otjh6+6CPZ7wZXFhzp/QIGYbyF+K+nTECS5M4p6u5DaOabTyvU66Dq3zN/yYhBGU/ckwUJSsBUjXirEiIP13IkkiyJwx4oVEVf7BfsG8E5ZZi4bOWbi2aZssD5fHtbIIET0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTTHFx5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTTHFx5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A89C4AF0C;
	Tue, 30 Jul 2024 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358223;
	bh=Qb7LhAj6/u0/VYPrn689WskuckX4HYjqPze7suqTWRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTTHFx5S784oNZamLvaBYuvcqDTRh0J2CasL+tcq9dwF2/sx9cKuvtQl/NlszXHll
	 QzqDZgqTBkcIxz2UjpftNHW2FOG5N49O4xmFGao1pOCo+VK4hRcBNVksNbWe4Gt+O3
	 SttM+2JV48WphrhrEHx3Ffsb6WwMD3nrJtVCnznE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 336/809] leds: trigger: Unregister sysfs attributes before calling deactivate()
Date: Tue, 30 Jul 2024 17:43:32 +0200
Message-ID: <20240730151737.891247560@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c0dc9adf9474ecb7106e60e5472577375aedaed3 ]

Triggers which have trigger specific sysfs attributes typically store
related data in trigger-data allocated by the activate() callback and
freed by the deactivate() callback.

Calling device_remove_groups() after calling deactivate() leaves a window
where the sysfs attributes show/store functions could be called after
deactivation and then operate on the just freed trigger-data.

Move the device_remove_groups() call to before deactivate() to close
this race window.

This also makes the deactivation path properly do things in reverse order
of the activation path which calls the activate() callback before calling
device_add_groups().

Fixes: a7e7a3156300 ("leds: triggers: add device attribute support")
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20240504162533.76780-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index b1b323b19301d..19e4866b00298 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -179,9 +179,9 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
+		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
-		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
 		led_cdev->trigger = NULL;
 		led_cdev->trigger_data = NULL;
 		led_cdev->activated = false;
-- 
2.43.0



