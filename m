Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E002C23C6;
	Tue, 23 Jan 2024 00:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969588; cv=none; b=uO/6NOgdwUyGquf+kv5esyNbLC35bJPF3ORXeWzaeRCgvuhllG8Nc5y/9vyjfwwBC9P/gUmt3eAQDLReXcNJqNQD8N3NCDd/QU+GRMzWzZjMQNI0M4wFiXfujSFxx/CX3UokTInszNswq00YJENaEkxzPOKatpl8AKqoBhIct7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969588; c=relaxed/simple;
	bh=rbXyK/0UIDTai+bd6ahCwnWpBeLar12wyJ80HsXHrJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Txcvpyj0/GYvpibJDcqzGi+z0kqsA8rZ5CuMHfhtk+ASxnqyHXhBFS6F2XDcXnF1Ztco3znYkhEvS7WvQvq7Cks+j8Oac5dnwdZtbwwdjsoQO/bEKwa8tYYihZVNjw5+cYaJyqGpCM5toAUTD9VfrRzpF9ip5IiQwz39+MMf6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPYdv/Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPYdv/Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC2EC43390;
	Tue, 23 Jan 2024 00:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969587;
	bh=rbXyK/0UIDTai+bd6ahCwnWpBeLar12wyJ80HsXHrJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPYdv/SekgV6031Hor67snsXS4bUbKpxhf0gih16uTeJMPLkpV1kD/fSWum0O0nB6
	 p4iZHBm5pwt6j0Qkz7asTtG/0jLsJmsQLXmDhaE58Kwf8uemWyFI2dRowiWX/U0CAN
	 0EKc/YQROmp9r/zoAXYnNHF7o29F0G7Kp9mS/clo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 339/641] watchdog: bcm2835_wdt: Fix WDIOC_SETTIMEOUT handling
Date: Mon, 22 Jan 2024 15:54:03 -0800
Message-ID: <20240122235828.521100566@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



