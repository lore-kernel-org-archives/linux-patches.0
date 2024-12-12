Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68EE209F27;
	Thu, 12 Dec 2024 15:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015697; cv=none; b=VuMNraF+MsCs2YqbXDC7i9dquZHOwKau+N+0xbvS/gZn+znU9lCegHTDz6wMZtDTM8E21N1jvRK4oBZeiXwXqiAYQ/kbmLcSRBjSUT8py8LOV32UfK2xbNIpr4t0671UZ9nM0CMDsAM02GXcP9mzvhtaLJN/ooCl82O2WCPOoU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015697; c=relaxed/simple;
	bh=Jwy3EhtsHxqbc8RKO5Bxu7TSEAozmTDI5vDUwSNEqcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STitf9FD14uykPCyZlYjEeM4jGoQpIQ8JlQOwIuYzu9SW7/SHy87nqRBig5sC2Ba4dJ2btSyAt2SKE7pOnH+nkSCELWD0rH8L//v5TJ38huB9A1ES6DF+9OrdDtA0i7mg0hjNqrYWdWbceolFHh9BW8KUh12ZmpoTJf88bhP2JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTb9Hkbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTb9Hkbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D342AC4CECE;
	Thu, 12 Dec 2024 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015697;
	bh=Jwy3EhtsHxqbc8RKO5Bxu7TSEAozmTDI5vDUwSNEqcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTb9HkbwsWRSaK9IMShsBunhQf40TlR9p0tudxHxIdYo4cnWvraifMSS8PwSdaioR
	 Yvw6wz0sz8UuJoCEH4XKL+BcJGtZVH5BTje6o1c8GBcK3Ryl6bB6OgKvzcOLKdPXNZ
	 u/m/BY5Q9EWYkFrPEQSTFkMMMt5x6+7OTiXgFifc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Chan <towinchenmi@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/466] watchdog: apple: Actually flush writes after requesting watchdog restart
Date: Thu, 12 Dec 2024 15:52:52 +0100
Message-ID: <20241212144306.798911087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit 51dfe714c03c066aabc815a2bb2adcc998dfcb30 ]

Although there is an existing code comment about flushing the writes,
writes were not actually being flushed.

Actually flush the writes by changing readl_relaxed() to readl().

Fixes: 4ed224aeaf661 ("watchdog: Add Apple SoC watchdog driver")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Reviewed-by: Guenter Roeck  <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241001170018.20139-2-towinchenmi@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/apple_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/apple_wdt.c b/drivers/watchdog/apple_wdt.c
index d4f739932f0be..62dabf223d909 100644
--- a/drivers/watchdog/apple_wdt.c
+++ b/drivers/watchdog/apple_wdt.c
@@ -130,7 +130,7 @@ static int apple_wdt_restart(struct watchdog_device *wdd, unsigned long mode,
 	 * can take up to ~20-25ms until the SoC is actually reset. Just wait
 	 * 50ms here to be safe.
 	 */
-	(void)readl_relaxed(wdt->regs + APPLE_WDT_WD1_CUR_TIME);
+	(void)readl(wdt->regs + APPLE_WDT_WD1_CUR_TIME);
 	mdelay(50);
 
 	return 0;
-- 
2.43.0



