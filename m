Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F035B43B4AA;
	Mon, 17 Aug 2026 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974942; cv=none; b=EDv3feQlXQlkRigBsOFbw26l5uWNGRSjwa8rPiALeX+Nb7IZY7MNd2JQEzq3BhYV7/bvVLv5jXADfBQbUtzQtGUdWBxdiTO4vM/ii1TFixKW+I5uPdesg6MIpKDi3hQx/cxTAKZvvyhR9A0hki18ckaoS984TfhYJcRxKFq1erU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974942; c=relaxed/simple;
	bh=3nwVGhq0T8QL837e8BsGdY+zM/zta2rkK9vlGY1nHlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOoET0iIrEFlFbvMdrgvSKMRVKt8RWkGC4CSa6ELdZdcm/MdpNrA6TtAlHLgHNpmiNj/wqW3Jbi0y4rE0/gGEkCx7WaOgsi8LbFnlykwVbYDln1FBftqVq96C4Qzw7DXTUusizgUnerTEx7BLSN8Trb4BQxlx8qzA3rqlouwDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQNjx8iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQNjx8iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C1D1F000E9;
	Mon, 17 Aug 2026 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974935;
	bh=dQBIdEUZn/1QsIt3X/+Vd7igMdEtstEO97Bc6od1wIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQNjx8iWGYpePu9Ub5id2Z/+gV1ysWbAEgYUMrm+cmdyAsAdNWTyddJSvujulEDqC
	 6NoNPBfFcdOU475E3ghXNXltt3DS2zAY26LpuhPufBpmnGJxqHKmuRa7/TZmgwLocX
	 fXwxgmEAPyvsTdVKGgEXkHEpsVkU3/9Stjt6Vq1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/250] watchdog: at91sam9_wdt: prevent timer rearm during teardown
Date: Mon, 17 Aug 2026 15:31:05 +0200
Message-ID: <20260817132540.785228831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



