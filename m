Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93511259C80;
	Thu, 17 Sep 2026 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660429; cv=none; b=MI11qwiLtPu3edCtVJiSJSHDa1MQS6ZLAokr43dycWVGElLCuk4m7cv9KIOeY2jLQ7aqOhUmCwY9vSIMR+NtuL6bKmaVzHzoclu6eaZ3ejTqwx8fJPHUJ5oT/ZmIEi1tEYEqVsaZgqizs2OAwASwd8sq2h/HORZoW1N8QT36mHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660429; c=relaxed/simple;
	bh=VTNe4vf5JdFmZYxIXoHrM+tCFMicwJ7D4PGHoraFnXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAHQRd5BqNbIS/PpP4OxA+g/OERpJR4seeM1upaEQqTC8glASzwyn2HTeGE6UqIWjHqP9akPAIHEgKWhCx4H8/6PSUoY42wVrAzS3yReJzIwzmcSkPK9E3uYLJRWZ9A/ycgCOaZ44hFk0PMbaT5/80mLsz47wMHMopFgXPntClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAj6S3jR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAj6S3jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D071F000FF;
	Thu, 17 Sep 2026 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660428;
	bh=1ZK61eOfItIs+Iaw1nNLhGkDacc/UD4GZ7NTGszM/x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAj6S3jR1jK69Te1X6OU9KG4/ixtMkxX4Fc6IqSiB/4a6xQZD/Fe2dM4N/S4FpnAU
	 /NGBjI5nHISD+W6LIqK1p/ivaq6FR7ZSWTXtv/GxeNWGawnQgojwm7n2CLE02U08vi
	 pppLV3fgwyRD9BmzblxZ05pAMWDE1l8JRPHgUbbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 590/733] hwmon: (applesmc) fix key backlight workqueue leak on register failure
Date: Thu, 17 Sep 2026 16:14:58 +0100
Message-ID: <20260917151407.134733286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit 5a0aacaa2d593d7582ecfe289529b937b6dc5d3c upstream.

applesmc_create_key_backlight() allocates applesmc_led_wq before calling
led_classdev_register(). When register fails, the error is returned to
applesmc_init(), which jumps to out_light_sysfs and skips
applesmc_release_key_backlight(), leaking the workqueue.

Destroy the workqueue on the register failure path. The bug was introduced
when the inline init block was refactored into a helper that returns errors
directly, dropping the old out_light_wq unwind label.

Fixes: 0b0b5dff8967 ("hwmon: (applesmc) Simplify feature sysfs handling")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260828105413.2401385-1-congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/applesmc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1249,12 +1249,17 @@ static void applesmc_release_light_senso
 
 static int applesmc_create_key_backlight(void)
 {
+	int ret;
+
 	if (!smcreg.has_key_backlight)
 		return 0;
 	applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
 	if (!applesmc_led_wq)
 		return -ENOMEM;
-	return led_classdev_register(&pdev->dev, &applesmc_backlight);
+	ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
+	if (ret)
+		destroy_workqueue(applesmc_led_wq);
+	return ret;
 }
 
 static void applesmc_release_key_backlight(void)


