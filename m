Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2431770F;
	Mon, 13 Oct 2025 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369285; cv=none; b=N47Do5pm4UC9OKwNOGVl4CCHgpwZCdAQNjk3VplJwqGu7gP+AoqfPGV6ioLy9e4RXZdy+LvwlSvkFMdK9LUvslLLGQvZ14A6+DiUvY+Z+fy7RtGC6DhspIMOdBVYE3MSbuosZ4dnLeg+3pAFf/EvF1ZWLlZxhaL4o5HQ9GJzzcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369285; c=relaxed/simple;
	bh=kMp4yrTvnw+1egMgjaCd5VAdxQrbb03cJMj2EQ4uDpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loNU2xPxuiKtCH79BaX1Et3OPifLHyLoKsegOfpBNhQf+OHgrUzTu1fpDvILayyIam+hKAq5q1Ep8juWv4/vKAHGk9XoYQivqrJjcIcwkpI69q1Nmf7y4SsHu9C1fVUGPRE9dxPGD3Ty02XwChgpHprmeZupgV33B1B+AyH9+nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfAu8JDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfAu8JDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2A5C116B1;
	Mon, 13 Oct 2025 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369284;
	bh=kMp4yrTvnw+1egMgjaCd5VAdxQrbb03cJMj2EQ4uDpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfAu8JDNz3nxxYTc2GEeiIbP/uQ6Ucl8zfKnpy9wo7rLT0AcbpJU4lZ8xk+iJynLM
	 LpJ3iIdgi5xEWCjREZ5eSYIciBWAlTf72vs/s4ROXvXybsNE62paTDUKSnVQCIqjZo
	 o0UtlHgvXKJSNF9a/WYa+fiPmth4IRVCxHoV8kb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Pohsun Su <pohsuns@nvidia.com>,
	Robert Lin <robelin@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 191/563] clocksource/drivers/timer-tegra186: Avoid 64-bit divide operation
Date: Mon, 13 Oct 2025 16:40:52 +0200
Message-ID: <20251013144418.202575208@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 916aa36042db8ee230543ffe0d192f900e8b8c9f ]

Building the driver on xtensa fails with

tensa-linux-ld: drivers/clocksource/timer-tegra186.o:
	in function `tegra186_timer_remove':
timer-tegra186.c:(.text+0x350):
	undefined reference to `__udivdi3'

Avoid the problem by rearranging the offending code to avoid the 64-bit
divide operation.

Fixes: 28c842c8b0f5 ("clocksource/drivers/timer-tegra186: Add WDIOC_GETTIMELEFT support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Cc: Pohsun Su <pohsuns@nvidia.com>
Cc: Robert Lin <robelin@nvidia.com>
Link: https://lore.kernel.org/r/20250614175556.922159-1-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-tegra186.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-tegra186.c b/drivers/clocksource/timer-tegra186.c
index e5394f98a02e6..7b506de654386 100644
--- a/drivers/clocksource/timer-tegra186.c
+++ b/drivers/clocksource/timer-tegra186.c
@@ -267,7 +267,7 @@ static unsigned int tegra186_wdt_get_timeleft(struct watchdog_device *wdd)
 	 * counter value to the time of the counter expirations that
 	 * remain.
 	 */
-	timeleft += (((u64)wdt->base.timeout * USEC_PER_SEC) / 5) * (4 - expiration);
+	timeleft += ((u64)wdt->base.timeout * (USEC_PER_SEC / 5)) * (4 - expiration);
 
 	/*
 	 * Convert the current counter value to seconds,
-- 
2.51.0



