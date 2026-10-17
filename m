Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B33911A9;
	Sat, 17 Oct 2026 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254627; cv=none; b=Gj6+hZwBCLIKPRJEaG8y6Fh554wuggkpzTphvc6KrK1b7XxN366tyjH5VHys79vD090/mGCWsvwpG7bWJq3aokQvX05Ixqtb7sxbebn2FXy/wMm4Gk+bL9M6Gyfz3LwDcrfQUmH25EO5wqLMJdgQXKlxSp5ligz5HZGp8wjLiWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254627; c=relaxed/simple;
	bh=J+xmxEQ1TaYtGswBPVB1QJEPv1AkU5X6jJwTz2UojY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF6Q7eFkArkm4aeOTlaJnm9e+pXHS4Et4FAUW/dTeqp8J+Rj3mqKIQKfmdq2wzigDE39lPY1VF2U+HSMKdv/oZ2UNBJExfuaszevogpvze/BGLYJhgdQYnCA3fef6cTeReTiN6LrQjBpHXAltFf+zlOcC/5t2Faodzq4g+YW+4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFEDauCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFEDauCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E471F000C4;
	Sat, 17 Oct 2026 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254625;
	bh=BH4QnEYuVGCv+SDsSK1ntt8fyFRA3jXQHAeVTNnimic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFEDauCfIYgfO00V/gjJaDpXTvh4Iqh1BaGi6SiBejJ09GTPm+3IRphdhxHh/rML+
	 Te0xXGKBvc3WtZJzqjHTPXvcVc9XDGXeKyo00OQYU4+VGm4ougOh0BgjJzFiJuEdKY
	 jh2brk1kW+Flihp2T8TrUgQ+BqbK3ZvTQEg9zMpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 507/869] watchdog: at91sam9_wdt: prevent timer rearm during teardown
Date: Sat, 17 Oct 2026 17:55:48 +0200
Message-ID: <20261017160050.102450309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c6474cb858b7..fe14f00662c56 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -242,7 +242,7 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 	return 0;
 
 out_stop_timer:
-	del_timer(&wdt->timer);
+	timer_shutdown_sync(&wdt->timer);
 	return err;
 }
 
@@ -378,7 +378,7 @@ static void at91wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&wdt->wdd);
 
 	pr_warn("I quit now, hardware will probably reboot!\n");
-	del_timer(&wdt->timer);
+	timer_shutdown_sync(&wdt->timer);
 }
 
 #if defined(CONFIG_OF)
-- 
2.53.0



