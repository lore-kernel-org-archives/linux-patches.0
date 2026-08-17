Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DEB40EBAE;
	Mon, 17 Aug 2026 13:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974176; cv=none; b=SBF6IDtihhqwWDY5BLCkBDmzJ29/cDM04YXHMPC9073E5ucRj4ttvEn0orWUMBCRshUclTh1Km2/J0NaT3RVfyIcGyFmCy1CusNBiI5iZsaWkq6QCDmMVVG9kLF+qpw6vDZ06t+TMSupbEcMuMN2RkuIkO4Yr5B8rjXE8Rbc0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974176; c=relaxed/simple;
	bh=Q5q616Nl6GeP4ERKPlAXo3OeW0/RG2VUIaHa6ow2uxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK2j/NMcDpMV9RvIfBkxRYwRm8oTvNomjNyqi3GK4oPSGO7XIUHqF3xOZ4nstgqdFi73Y/2Gdj1Q8eYR+mMQ2GdC+D4DQyMZbiZQnu5alwwDkIb1BQ+UhZcnf4vR4G0LzNnVJs4G/vhyrdO6D5cRyD3yrf+He/fsWFWnhqgsRAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bj58Oc4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bj58Oc4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6251F000E9;
	Mon, 17 Aug 2026 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974175;
	bh=clO8WBn5a3C5tC9rsfMIEcyF/bcCqFy0X0K54HZJaH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bj58Oc4rSDoqXPwNAZYWo2riadDs4Ibv+scWXBz8cmj8B95hpZOujQSc8RUKhyP3Q
	 OxO7/TI2wuqfhjbLsu0DsEAHYaxuH1stT68iIHmqlf5YufInEWfFjwdlRXLha4x+JH
	 fd6ZM4+JY7/5Q9195Lq5znRsfOnaS33sw1nlQDyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 114/271] watchdog: at91sam9_wdt: prevent timer rearm during teardown
Date: Mon, 17 Aug 2026 15:30:39 +0200
Message-ID: <20260817132541.574855688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 8444d66aa6b6e7fe0a26fa1a00a11cb4d0523783 ]

at91_ping() rearms the watchdog timer from its callback. timer_delete()
neither waits for a running callback nor prevents it from rearming the
timer, so probe failure or driver removal can leave the timer accessing the
devm-allocated at91wdt after it has been freed.

Use timer_shutdown_sync() on both teardown paths. It waits for a running
callback and rejects any attempt by the callback to rearm the timer.

Fixes: 5161b31dc39a ("watchdog: at91sam9_wdt: better watchdog support")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/20260806060613.1830-1-getshell@seu.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/at91sam9_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index aba66b8e9d033..80ba04df54adf 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -242,7 +242,7 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 	return 0;
 
 out_stop_timer:
-	timer_delete(&wdt->timer);
+	timer_shutdown_sync(&wdt->timer);
 	return err;
 }
 
@@ -378,7 +378,7 @@ static void at91wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&wdt->wdd);
 
 	pr_warn("I quit now, hardware will probably reboot!\n");
-	timer_delete(&wdt->timer);
+	timer_shutdown_sync(&wdt->timer);
 }
 
 #if defined(CONFIG_OF)
-- 
2.53.0



