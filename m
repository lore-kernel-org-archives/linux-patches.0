Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3891DDF5;
	Thu, 15 Aug 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728554; cv=none; b=IPohDvYPQv5oC8DGkX2GKp/yLCa9R/2eCp6AWLlUaoVORPkSXMOQ/UNdz8pvh2e9+iV4Xe+9ZanS5fJBTBl3AwoAepb2s20unyW3cfPIrggVVWGbg962SgYLe9EFCmD8zFDVoHqG7Wwlnb7bBut6oRFGXYMQJhdmJUVSHCbGQks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728554; c=relaxed/simple;
	bh=inB9XeynXbxFYaUyns01Bt+6GIaVmNWmIGJdakRzNAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLv9BJ7mdmmWHINfXNEg29aKRa6YcXtm61H9cKJgFcjuv8488wHuAYLq4NF+3ynQs/KYoQyKX/AzH2GrOOpITKRUt6yPBTvkualbZZszGS4BjjLb1bz1A9X68xrxOcQe19dse9nfR6p20VvtfWqru1I9g7oZ/5mTIBJ6dSeT5Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU7cB4UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU7cB4UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DE7C32786;
	Thu, 15 Aug 2024 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728554;
	bh=inB9XeynXbxFYaUyns01Bt+6GIaVmNWmIGJdakRzNAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU7cB4UHtLU8rUlYgJqucFKJIpTPfWnEw4y/ORfl7l9LXF952tmE25nS+3GTQ5D52
	 9t3iIhu7lNbRzy48NrPAywVHoICrNMOh65HqFas/RyMWrJ5NKPCkeDbyogpa8fNtKl
	 4tkZpSe58nNPGM3irc6zPvu+e90JeNjvm6fBOqBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/196] leds: trigger: Unregister sysfs attributes before calling deactivate()
Date: Thu, 15 Aug 2024 15:22:33 +0200
Message-ID: <20240815131853.469283147@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ec4c957c36b6c..8738fc01523fd 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -125,9 +125,9 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
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



