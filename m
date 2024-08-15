Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316861DFFB;
	Thu, 15 Aug 2024 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732214; cv=none; b=UQ0Yc8ycomfQjILcL2KQoFwfACBRbGV4dR1gpaqIEIKXD5sZdL79i7r8ApX+s1tUG1h3ppmgiIC8KXV2kokYS9/kh820DaEqpvm9COfpDSJKUw/GS4bJwuhx8bjVipahXL9ALLhJoFEobVVnk1nASc0/FVWAJuZNhJfYm7FH/2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732214; c=relaxed/simple;
	bh=GBFp05TVBF2vyA+9InlnNW5sp78SBIjhY/F4QJ4twdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZrBiw1//yjSJDh8NJQ6IbfqkQb3wMaw76Cym/o75XPgBnp5lhAQ9Ix1jaBQUwFxqW1s05knEnscDIOYihsmRT99+13NEo5HJY/5SxSkb3AvS3nODZu4Of/SKizginWnryiGbmyuuZh90vFzCIdkMqOCSx/hyBPkUr6eJxTBkto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDHDgEX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDHDgEX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68980C32786;
	Thu, 15 Aug 2024 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732213;
	bh=GBFp05TVBF2vyA+9InlnNW5sp78SBIjhY/F4QJ4twdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDHDgEX/CllGrimFGNfpYaM2ey7zXN3EfisdekV/zEQysgxsbOTQD5R2wCyxj7FP/
	 jqJS35DWbNbWlCIS+95uN6N7SEUl4W2EB63Yhu/3hTU6DcSXWq2Na984SDZavdQeS4
	 ZV2FC1plxwHNbS4cMh4CNBBj5Cp0TsxDf158xglQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/352] leds: trigger: Unregister sysfs attributes before calling deactivate()
Date: Thu, 15 Aug 2024 15:22:28 +0200
Message-ID: <20240815131922.416699485@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



