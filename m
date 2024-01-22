Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5D36FB3;
	Tue, 23 Jan 2024 00:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968435; cv=none; b=tGWiksINmaf/WbPB7vqEAN7HT/ypRng+cN40rUaeXFnnuBdEJhUndwQkEnUG2y7rV0UVdjvkVIs7lyMdrC9RXoChN+SvAcdRROGfiVfqcBGFfrgXjutzGtV9RgQv+68b/B8v1UW/dSEoQIXssMJSVWhYNKyX6oLJYMMd0G7A8LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968435; c=relaxed/simple;
	bh=VVEUFL5Z/gnsOYYGTE2stq6GJ8fWLWoJ+3XPc/2N0e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRLRhmzKxmGspxBDHIa73RLVtoyT2k/Viujn5tS85M5nIi2/vTFLa5OPHctba+ehUrAn5ZHvygSCHWmyxTA3cjQfbnFwiIOvwjdQCGukcvBYG2vQTrxraQEaPn4zYILU9CziYIqdODsbhjWJs8c7qwRzLeEUxh/FNY/QoerRHx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u37wg9HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u37wg9HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A914C433C7;
	Tue, 23 Jan 2024 00:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968435;
	bh=VVEUFL5Z/gnsOYYGTE2stq6GJ8fWLWoJ+3XPc/2N0e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u37wg9HQ9YpJ4AaYj62vtRtS7QRyVnOQ7HXdI89qgH1pPuDfkWo18lKzojzQwFxr4
	 olkl3Kv0dGm6LNE5F/KnUqHPjXvEJFQWIqT222Oqpu1UC/mFzswK6OtP1s/84rHTPS
	 eWgkb/qGp8rg45p4Aj5ZBtm2XDvwmi9DLFaErrhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/148] watchdog: bcm2835_wdt: Fix WDIOC_SETTIMEOUT handling
Date: Mon, 22 Jan 2024 15:57:44 -0800
Message-ID: <20240122235716.802063306@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e6c27b71b136..35389562177b 100644
--- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -41,6 +41,7 @@
 
 #define SECS_TO_WDOG_TICKS(x) ((x) << 16)
 #define WDOG_TICKS_TO_SECS(x) ((x) >> 16)
+#define WDOG_TICKS_TO_MSECS(x) ((x) * 1000 >> 16)
 
 struct bcm2835_wdt {
 	void __iomem		*base;
@@ -137,7 +138,7 @@ static struct watchdog_device bcm2835_wdt_wdd = {
 	.info =		&bcm2835_wdt_info,
 	.ops =		&bcm2835_wdt_ops,
 	.min_timeout =	1,
-	.max_timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
+	.max_hw_heartbeat_ms =	WDOG_TICKS_TO_MSECS(PM_WDOG_TIME_SET),
 	.timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
 };
 
-- 
2.43.0



