Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE18F19DF9A;
	Thu, 15 Aug 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729548; cv=none; b=QqV0HqKONMOYxbJAbc5CGVCVJ/xt9TdG97DiZjMFCDqaDd/84VunhG+OrGFmPTfB9g5dRsMxhsFbbc4IlPtS1/X3NDympmj13YRslfofTIkMhniejjBt5unpIgL5vi4ohI/nLptJbKi/0htC/pQFslmvkvs4W/JPPzIp0/TG1Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729548; c=relaxed/simple;
	bh=nsGqwxP6ggTzw/EBJ6Ex6F9977DZkZz67Z08Tkajm8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N3FM/8gn92fG6hct+d8PZ7eWCwQTvc0zjgH+PWCbB6SnR34X9Zrk4HRa0pFvKqBhhNYkTcZmRO/psParYxnSfCVpEwmCHbiiTLXbQka4P0go6wFPwyhyUeVLXnuaGjtuH80mts+QuN+OeoP5XausdTzh2BiARNrc9O8RNeGtMOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxFcPfz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxFcPfz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BFEC32786;
	Thu, 15 Aug 2024 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729547;
	bh=nsGqwxP6ggTzw/EBJ6Ex6F9977DZkZz67Z08Tkajm8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxFcPfz+K80BrblfAT2O/Ayb1PIwS0l2OZ83KjArZW7Sap7VAMcT2PIhGREkXxE3x
	 PSCtgrR8uYItep/F++ipTyFwI1vKv+yxWcPGHO3BlKrAKQEm1Ssdx3j/F6ClVL8UeR
	 uFPct7qSJF9uJvhjl0WKQu8RSlXQ/YAt3PH9/Fe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/484] leds: trigger: Unregister sysfs attributes before calling deactivate()
Date: Thu, 15 Aug 2024 15:19:19 +0200
Message-ID: <20240815131945.197970184@linuxfoundation.org>
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
index 4e7b78a84149b..cbe70f38cb572 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -177,9 +177,9 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 			flags);
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



