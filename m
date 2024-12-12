Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B83237FFB;
	Thu, 12 Dec 2024 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020593; cv=none; b=ckzkAApAyvhRkA7xnPKAEN31QzA293H8Id144f9NfHjVqPuQM1N1CcVTiGxzplp+e8e0NG1qGnhbMEykV3d9BFYypSf07Wuieka280KkTAtpt+Q6w0VDc28qaoidU/tFFOY5Di4Z9mqBRKYdsip2U4yb9H2vX3WvqkJ3S79X5f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020593; c=relaxed/simple;
	bh=n1J24Gj93Yulhw5q2ecONnaUkk5F44ra3jASWhIr98c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzKgM+4BIPAha7y4k93fJT8SVhneVhWfyk5X7NHetJg8aIjul4jQ6wP6pV1zJUoJ6gsUQB1AQkhMPsJhIeAIcmWlbeu06BRjOg2WQADG9fAgzQlgoxsr9g0BHuU9MPeasyQ58YEfCi4IXmuLMtqMhKNiyaSSIRwOcwTv4KNOxqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4j4xH+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4j4xH+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF54C4CEDE;
	Thu, 12 Dec 2024 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020593;
	bh=n1J24Gj93Yulhw5q2ecONnaUkk5F44ra3jASWhIr98c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4j4xH+IX17hbIBw1uUrkmx+GqFflxD3SdkoOnRvvrTSP/0EIqn2lRoB/elpc/Ftr
	 BoGZtTt/VUCMcvUhtk++ka8e9/uqYQv18xVprFtBAwG+LDAXP6nih9a0L6Nw2p9mNw
	 DVF+fRmq0uOVDGDrRC+a1kVfQK6UyMqeCu9vAhA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Chan <towinchenmi@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 508/772] watchdog: apple: Actually flush writes after requesting watchdog restart
Date: Thu, 12 Dec 2024 15:57:33 +0100
Message-ID: <20241212144410.943290964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16aca21f13d6a..a5af532c40867 100644
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



