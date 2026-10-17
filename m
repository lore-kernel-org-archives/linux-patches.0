Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3036338F950;
	Sat, 17 Oct 2026 17:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259388; cv=none; b=Pxo93aDY2Wh1pDeiJWBGo1A+34JERTVzmFnZEsHrLmJx6VvRygn2ajjJHUALLPIwpFqR+Y4wHGEX2Jdkr5ajWZget4FVQLd3uBspIMadg71xKV+QdqIv3e3KBUZobnY00Vsn5CNX0OUbXXBUosRTzJm4HiSVSIyMLFEEtCNHEoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259388; c=relaxed/simple;
	bh=OqChxOrIXZVFnOICcOLtUVVUMWJFGzRCOIpBGwK3XuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEbeVTYPaAD6kd6Xv0BMMKKhiCMQmci5HZ2iOBpfmwgoEUi9lQ8ege20KbFdYt7VvNRG1F4dJqzuFmA2EE6DPM8vOdMIoG/WalcfnqQzB/6tHigrdaXSJtmr+cKH4QWPzrAk1RGc30cv7DyYAlhZ4ASgRHLNEKp/y4Jp7OOZgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19/yIlot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19/yIlot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD2F1F000C4;
	Sat, 17 Oct 2026 17:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259387;
	bh=CmXkiFXhJswXKMxT9t+pHqQhwu6YJPqY5XZ9JMVzeB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19/yIlotn7f+Niam0ZpVi/xX0mj2PV9BSV8/DL0Y7INRHxZEorc8dcHb1kWztcpEG
	 slKh3wmSeG1M/nkk0je/mNeAdhGzrChaMyzx9em94BYgxL7x61ADoq/4bK1390DTYX
	 2gwmaMsB1HMXltHxrk9mwvCW7qjJ/XSwfKRzc1Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1198/1674] watchdog: at91sam9_wdt: prevent timer rearm during teardown
Date: Sat, 17 Oct 2026 17:57:50 +0200
Message-ID: <20261017160501.888571470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index fed7be2464420..4e5171f4d0061 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -242,7 +242,7 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 	return 0;
 
 out_stop_timer:
-	del_timer(&wdt->timer);
+	timer_shutdown_sync(&wdt->timer);
 	return err;
 }
 
@@ -387,7 +387,7 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&wdt->wdd);
 
 	pr_warn("I quit now, hardware will probably reboot!\n");
-	del_timer(&wdt->timer);
+	timer_shutdown_sync(&wdt->timer);
 	clk_disable_unprepare(wdt->sclk);
 
 	return 0;
-- 
2.53.0



