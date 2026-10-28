Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215672;
	b=2+Ff/XLsOy2CsNtMsxqPWSkTeMmUO4VqojSQtcga+qrfvyTfReU0dI8i/w0grtn1vU5E
	 YgKcScqV4uuc4ExoJvuygGE5vOQm54aNpCutQvN1Ibw282FlRW71cmwybF0TD7J0uLqya
	 45GlHy7Z3s6lxrMrLyd+Xg8xokYet+ijjhgAOuiurO4ZPDEqLI7RhRFUiww2aARUgq5Rj
	 osw1IbaCMWaOwi8H0Dg3wD6AAJRxXFeSBE3qWCAIWXyQJQWQEphCTpEy0DN97Q6RaDRw6
	 Mlt5aUyhjO5NIcKg4L86TvQtpFH6LbWCESaVvrQANiPi/dlRiMLiw77R67r4PMuUi5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t+ZeMocGtHtKN5Zef14n9eJC/fQbSHrDeccE24PNF3k=;
	b=5ttGsWp6ZG0qoUbjufYBew475moHKYgtiJ2rV4s/OevNftt78Nn158OSbMRDwRLNK711
	 LUvPmRXt10JieaG+SL/M4ehvFh3dw+B5flDp64PK3vyFxf3q8RM104H2DF/u+y15ZVEFn
	 LGVi3lh9UcWsNodlSaWMSXGAZ/rdvI6wCjj14AkzI3O5oeCL7KJLk45CRevzv37sBkbLh
	 Y/GHKB4PxArVjh383XPJ4Lp9u/DWudwtbN8+FjiottCijpRK0o8V5CnPcI4mb12Wy1QbX
	 KO473rGNoI7tPgHMtGZdz7/WMLKTBf3YLswMwVBTZ4boYwBWJHDpo37/9D5UvMbKtyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtobYx5j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96B9606A31A;
	Wed, 28 Oct 2026 19:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtobYx5j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2569D1F01828;
	Wed, 28 Oct 2026 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215671;
	bh=t+ZeMocGtHtKN5Zef14n9eJC/fQbSHrDeccE24PNF3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtobYx5jyT16bDeIcKqMAlt+6c0DIcv3YUPFAmbUvt6Eu9hDcUxuBqO4zN2aawa+o
	 Qpye5/YtxhMVWaNPcEEWeJVh7lOZwfFYfIMlWuByl7+Er3wmXxG24ZB0IeAispNox3
	 sjVoprZMZp1r+z7/js5zzsZUd94bc5Eu4PeafGC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1292/1887] watchdog: at91sam9_wdt: prevent timer rearm during teardown
Date: Wed, 28 Oct 2026 17:56:28 +0100
Message-ID: <20261028170528.828245912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



