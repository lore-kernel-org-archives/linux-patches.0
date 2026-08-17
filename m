Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ECE3EC829;
	Mon, 17 Aug 2026 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974756; cv=none; b=lpZY29BYLAogFWsJC3vnbNpa53vGKaFV6vFFev3SObtbih0MpYHiWA4wJ74YPyQb4lXlYm/dGv0xGc7gl40no1EAv2mmsRBkSAintk4oiXGbCgeyxjcdtUCAQxf/8X8mql/skGecy3TT66fuX8okAJxz8zlAhhsP29vP0Vno2G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974756; c=relaxed/simple;
	bh=cQJdu+4QU2guWzOX5VayrEixewNinMMO6cRKvuniqTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEia9NRyT2z7WQK9/1EKFyMo7RAxg7LNx7uj9zE4ToOwhMmKTQbSrMLfDoal2tilW5fQNDdWHxjzohfAsvTkPKTNpNJp9t6vpmGyGkya4mW2UsSNBK+kmpWto8KtjYG0jR2EwoSw8GLMMmO5Z4WFIO3+nKMRHDQlYLUHgFmCPQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaIlbfQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaIlbfQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCB71F00A3D;
	Mon, 17 Aug 2026 13:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974747;
	bh=8LABmahqqdWiRWfTxTFTbKTbDZTTSXik/LaqEF6U4oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaIlbfQ9rNXSNjgymG6ek55QvVv9X+8ZCS2OIqOBldGOSDZATXq/RkduBlqG9Zy3D
	 HoFvqtfXdwI2AJ8L8i/2BfxE9ghI3Wei/j5D01KAQ8tQX6CIDlII/WCTookphjVmY0
	 AqWncK8Zaw9rv/vmGF8fcKFa50fKd+NCxDudEadU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/250] watchdog: bd96801_wdt: Fix timeout for enabled WDG
Date: Mon, 17 Aug 2026 15:30:02 +0200
Message-ID: <20260817132538.131432455@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 1246aa2b6ccc8944676bd24ff3e37cc56b93b51b ]

When watchdog is enabled at the probe time, the bd96801 driver retrieves
the timeout configuration from the registers to set-up the heart-beat
values.

As Sashiko pointed out at
https://lore.kernel.org/all/20260722085819.495211F000E9@smtp.kernel.org/
the timeout values are incorrectly computed in driver, resulting wrong
heartbeat. This leads to devere problems if watchdog was enabled at probe
time.

According to the data-sheet, the "too fast" ping limit is configured as
multiple of FASTNG_MIN. Furthermore, the "too slow" ping limit is
configured as multiples of "too fast" timeout. The FASTNG_MIN is set to
11, meaning 1.1 mS and "too fast" and "too slow" limits are computed from
this. Hence, converting the limits to mS should be done by dividing by 10,
not by dividing by USEC_PER_MSEC.

Fix this by dividing the timeout values with correct scaling factor.

While at it, fix whitespace problem (double empty line).

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 09dad69757b6 ("watchdog: ROHM BD96801 PMIC WDG driver")
Link: https://lore.kernel.org/r/amxskHmQbi9v-8_l@mva-rohm
[groeck: Added reference to whitespace change to description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/bd96801_wdt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/bd96801_wdt.c b/drivers/watchdog/bd96801_wdt.c
index 12b74fd2bc052..a25b7cf1488b2 100644
--- a/drivers/watchdog/bd96801_wdt.c
+++ b/drivers/watchdog/bd96801_wdt.c
@@ -169,7 +169,6 @@ static int bd96801_set_wdt_mode(struct wdtbd96801 *w, unsigned int hw_margin,
 	int fastng, slowng, type, ret, reg, mask;
 	struct device *dev = w->dev;
 
-
 	if (hw_margin_min * 1000 > FASTNG_MAX_US) {
 		dev_err(dev, "Unsupported fast timeout %u uS [max %u]\n",
 			hw_margin_min * 1000, FASTNG_MAX_US);
@@ -258,10 +257,10 @@ static int bd96801_set_heartbeat_from_hw(struct wdtbd96801 *w,
 	fast = FASTNG_MIN << sel;
 
 	sel = (val & BD96801_WD_RATIO_MASK) + 1;
-	w->wdt.max_hw_heartbeat_ms = (fast << sel) / USEC_PER_MSEC;
+	w->wdt.max_hw_heartbeat_ms = (fast << sel) / 10;
 
 	if ((conf_reg & BD96801_WD_TYPE_MASK) == BD96801_WD_TYPE_WIN)
-		w->wdt.min_hw_heartbeat_ms = fast / USEC_PER_MSEC;
+		w->wdt.min_hw_heartbeat_ms = fast / 10;
 
 	return 0;
 }
-- 
2.53.0



