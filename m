Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DB53CB54E;
	Wed, 30 Sep 2026 19:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795681; cv=none; b=ScvO+p38nXwKmUnN389qW88LvsA/WTT93kdpLX/kYXFciW55akVZ2D5uLtaH1tKSlMyxr7f3KNcMZ7cWC4Y/JgahPtxQTv8FUr1abX8MWND21HvdDZTi2C/E7ThZaNDXnVd/fg564+qk9G0j08prY8MdDXfmls2Oj6CNAoXgOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795681; c=relaxed/simple;
	bh=l/1S5zQ3BfmABuczQ7hbcn+BiAFKOsTFm87W6GGz7F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuiDDF/leCmKfZ8pT4aXHRCN6aHG8qNimEYoWWEPIOiMOYQeZxEbytFZrJ3jpaHOZ/cubwMDaxMftWEA+3qfOO1sQEAwgcTn0ssMbOMQ0zjTpKNTxvT4PDI8mDfyr2Zc7k40uH3tmpsjjo1/yzOg6WHNQNpI5k4C5xX3SlS043U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLPvP4IV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLPvP4IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EBE1F000FF;
	Wed, 30 Sep 2026 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795680;
	bh=qnVi5NdCxqStlujOEjQcUZ+PMmDiNHEAqtBI3zZQClo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLPvP4IVxcewtXuq2U41V7HSrCeRqVX7Wz4nnJMW82u1AU5Yq6p0HOwe4t2Mr+hik
	 UNsO/6wE+yq6U7lmDOj0RuC7GDiAGqTgn7D2Ryw8SrpOcIDIyjRQeMpqa1po/8Byrx
	 8ubN/Z5gzj8yVXCuSRwzFie5arW0gHDTv2MELmaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0645/1193] hwmon: (applesmc) fix key backlight workqueue leak on register failure
Date: Wed, 30 Sep 2026 17:22:09 +0200
Message-ID: <20260930152448.574883307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


