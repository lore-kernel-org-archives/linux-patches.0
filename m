Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6FF6A320;
	Tue, 23 Jan 2024 02:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975347; cv=none; b=WR3fzKjjwgbRQmaBAGswsRIEEUGeqsGa1lB5ER9okrZZlonMXJfgUBPSxycnNFlrrzLcK0SUPqi1qBb027YfOgfHpHRMw2F+BTflkRADb1rvjppM8mzQjv0T01DqmGHkxedJLtgjGK/JkXhaPs6z20LdX7VvisFQcC9BwhPxhI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975347; c=relaxed/simple;
	bh=JEZdAveXQvZIrfbl1eW4eI4EqtVM3lZLvkmqCdRdVNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWxstLh5RDyYhLq1lko169MC3VNOwg/wTzLq/ElCTKwrC5nVg5FSjfM7AFnrcgQhA+pcBwATTS7gYCIL2QYVf0o/KdVe905/kbdj/Lqfef155ovrjd4AHBFFnu+z1ehXGHMvGruT1gkJZEE4YlfFG1iPsGvJOusjed3rM7gFxaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0j9m1ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0j9m1ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A36DC433C7;
	Tue, 23 Jan 2024 02:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975347;
	bh=JEZdAveXQvZIrfbl1eW4eI4EqtVM3lZLvkmqCdRdVNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0j9m1eeKP5n03uoPec2BQM8fxCuIkm+BJY3/dxXffgEaMRJGtT9T0tMZRQLe7PE1
	 q9fjgsvy50Ck4+BZIB8Sxisx1pMYOx4ahtR8cbKJ8m9wQvBCr2YsOfXnuISElkUp4D
	 xFqr8b+w2+2EGyDh7DNgALgfIyQkN9h/OFAWmqfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/583] watchdog: bcm2835_wdt: Fix WDIOC_SETTIMEOUT handling
Date: Mon, 22 Jan 2024 15:55:53 -0800
Message-ID: <20240122235821.261132452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f33f5b1fd1be5f5106d16f831309648cb0f1c31d ]

Users report about the unexpected behavior for setting timeouts above
15 sec on Raspberry Pi. According to watchdog-api.rst the ioctl
WDIOC_SETTIMEOUT shouldn't fail because of hardware limitations.
But looking at the code shows that max_timeout based on the
register value PM_WDOG_TIME_SET, which is the maximum.

Since 664a39236e71 ("watchdog: Introduce hardware maximum heartbeat
in watchdog core") the watchdog core is able to handle this problem.

This fix has been tested with watchdog-test from selftests.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217374
Fixes: 664a39236e71 ("watchdog: Introduce hardware maximum heartbeat in watchdog core")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20231112173251.4827-1-wahrenst@gmx.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/bcm2835_wdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
index 7a855289ff5e..bb001c5d7f17 100644
--- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -42,6 +42,7 @@
 
 #define SECS_TO_WDOG_TICKS(x) ((x) << 16)
 #define WDOG_TICKS_TO_SECS(x) ((x) >> 16)
+#define WDOG_TICKS_TO_MSECS(x) ((x) * 1000 >> 16)
 
 struct bcm2835_wdt {
 	void __iomem		*base;
@@ -140,7 +141,7 @@ static struct watchdog_device bcm2835_wdt_wdd = {
 	.info =		&bcm2835_wdt_info,
 	.ops =		&bcm2835_wdt_ops,
 	.min_timeout =	1,
-	.max_timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
+	.max_hw_heartbeat_ms =	WDOG_TICKS_TO_MSECS(PM_WDOG_TIME_SET),
 	.timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
 };
 
-- 
2.43.0



