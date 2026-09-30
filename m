Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D2D3B2D1A;
	Wed, 30 Sep 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791714; cv=none; b=lpN1CqRq7WFF6Bp2ZNqzZZzxhVtuiGLeY07tW60gL50blq8JvN5C+lPJ88/R9oMHwiXtHlsLoFhYUH7UUk6WpNLFXm6UEEIEF3ZTLS+LF13wK8tdojC8FYN7Hny69uZ2kX1lHPbOif8jtOdfGNYusYCg0NpMi4DfMaSJ9kcxGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791714; c=relaxed/simple;
	bh=3pcdBd5lQVAwBL3sQHi6VArLzR0zRdzFNQXJO824DhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmOCO/UgVsNeOXhmycqDzCE0xiXtoT0PqBwR1Ak7+liJrxZ4/grGvvNtkFxF13DBHJuAKCrRbN30vrLQsNh8DwVZwVeh4IEzbe3SswwZ44GpbkuNV1VK11jqLzd0Lm0wkBh+4ILZ4cJfZicA+NdLKNaR4wi7mUCqusnQH17UkzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mb5C9Z3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mb5C9Z3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22901F000FF;
	Wed, 30 Sep 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791712;
	bh=5rYAOLapk4Nisif5Pf5fDZsi0Cblv6Gv/f6HMHO+Znc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mb5C9Z3sfwfQuUDPZMetaib3exXloWUx2g10NywaK6+M8MQb06YNy8C79CEXkuPYt
	 E6jHGE1iHNt3IP6zK+/0hJ9vC5Ch6i26zfq8s/BZyWX60pQnJV0gxecAOl4WMMa3y6
	 3Hv6GF0Jz8hdP+ywOOoB4uiwGTArpR6r7MYgxeWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 398/752] hwmon: (applesmc) fix key backlight workqueue leak on register failure
Date: Wed, 30 Sep 2026 17:24:28 +0200
Message-ID: <20260930152406.894086346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


