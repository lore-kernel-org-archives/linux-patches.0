Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6283191BB;
	Mon, 13 Oct 2025 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369287; cv=none; b=onDfaCwL5ln3x15sFt9K2GQ9mhUBDpY1IBoC4qWP0WX0geJJCCjIHmNzE4Fk/sbldGhbFnh3kQ9qsKpzM+uoH4SIm4h1CzO3zV8SBOaQbi7HjVUNs87L71XtV9DTKbcDUAIFCPnFM/KsQcW0+h+Rv+PDBZT4ekOP7z4/LLPgLLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369287; c=relaxed/simple;
	bh=oUw7ObERaqPl+JpU/PL3p8PihyvR4Dv/FtCf/YTmnNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQimHWXubeXdmL/6BPrardJ1z8xHrZquQn0a8VEiJqIDMuurA44OFht9Jh5gTVLP0jmsEoSBSMSVH/WJjyXXKtXvcnHqtvtbegdZbq0fTWNJX7nrLKzfiZzzVN++hBIBKOiKySShw8MjHCjw2RzT47dFQh0MILpgIx06T1z2KMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZveJ1fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZveJ1fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DBCC116B1;
	Mon, 13 Oct 2025 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369287;
	bh=oUw7ObERaqPl+JpU/PL3p8PihyvR4Dv/FtCf/YTmnNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZveJ1fe/bizfrzmBE2oN1CA2YBqGP30A4ZXw/KRkiJ8yPzE2mqBch94O0Nix353y
	 cTu6B40xDc+pqcc8OBxvAWf3/fdKbl61hsqIx1xzf0+YoB63ZQOBeDHHrWox4gDu0t
	 EU5Z5AWhSTG3uOgHkQWq+1WZXzeRE0vm+lcNpVgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 192/563] clocksource/drivers/tegra186: Avoid 64-bit division
Date: Mon, 13 Oct 2025 16:40:53 +0200
Message-ID: <20251013144418.238131642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 409f8fe03e08f92bf5be96cedbcd7a3e8fb2eeaf ]

The newly added function causes a build failure on 32-bit targets with
older compiler version such as gcc-10:

arm-linux-gnueabi-ld: drivers/clocksource/timer-tegra186.o: in function `tegra186_wdt_get_timeleft':
timer-tegra186.c:(.text+0x3c2): undefined reference to `__aeabi_uldivmod'

The calculation can trivially be changed to avoid the division entirely,
as USEC_PER_SEC is a multiple of 5. Change both such calculation for
consistency, even though gcc apparently managed to optimize the other one
properly already.

[dlezcano : Fixed conflict with 20250614175556.922159-2-linux@roeck-us.net ]

Fixes: 28c842c8b0f5 ("clocksource/drivers/timer-tegra186: Add WDIOC_GETTIMELEFT support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20250620111939.3395525-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-tegra186.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-tegra186.c b/drivers/clocksource/timer-tegra186.c
index 7b506de654386..47bdb1e320af9 100644
--- a/drivers/clocksource/timer-tegra186.c
+++ b/drivers/clocksource/timer-tegra186.c
@@ -159,7 +159,7 @@ static void tegra186_wdt_enable(struct tegra186_wdt *wdt)
 	tmr_writel(wdt->tmr, TMRCSSR_SRC_USEC, TMRCSSR);
 
 	/* configure timer (system reset happens on the fifth expiration) */
-	value = TMRCR_PTV(wdt->base.timeout * USEC_PER_SEC / 5) |
+	value = TMRCR_PTV(wdt->base.timeout * (USEC_PER_SEC / 5)) |
 		TMRCR_PERIODIC | TMRCR_ENABLE;
 	tmr_writel(wdt->tmr, value, TMRCR);
 
-- 
2.51.0



