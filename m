Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD53C8C65;
	Mon, 17 Aug 2026 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973975; cv=none; b=AOTRT6xSRmQG+p//6XVUO8WmCEWhkl0HAkPGTRzDyo9tZwmMgThojveMIORMntHm0RzkoTlbp7Z19adoMxTrskbn9toQUZ/Mk150rPrsu5axdjauQho1I0hOK5wwYXkrgFcQQ4wB/pvk+UfMSOv9uhcmtBUbE19mdyCGq9zFmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973975; c=relaxed/simple;
	bh=y5kt5TYTweyADIfKs3RO4oNMAO+JxgOZSxzdHOscEBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoWrHmsy5aAKbJVluDzcneK15cNNq6/5kESkjdLOHIjrYR9pN0p5vY3HWun4XMxio3ZyCChozXBMrk4IhEKyCy0NMzYnWDDsx6KTb6tzDZfClL9HRdYZCyjG0zLsGu3t5CaFIztrOuqG3AHAu3a2y8tjOSYcxNqNoQiNH3wR0iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpabgBzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpabgBzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94781F00A3A;
	Mon, 17 Aug 2026 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973974;
	bh=q5xY8ga6qypILzXgatQzQSvqXMjX3yXjuQaLs0hlGco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpabgBzAax6VhLhIvcomjBu3sGCgp3a0b1eEAnh74PCK7QAMhYIwR8g/YTNx1jDiO
	 QoYg34yfHZdNyNz9iaRNMSOVkJCNB8HRPckexGDKcFPo71/rCb4Lz6tcasamDMdnaa
	 /yZBKOAilujGcdwke/LYgj9RWc0fdVEdYRbeptrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 046/271] watchdog: bd96801_wdt: Fix timeout for enabled WDG
Date: Mon, 17 Aug 2026 15:29:31 +0200
Message-ID: <20260817132538.626943952@linuxfoundation.org>
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



