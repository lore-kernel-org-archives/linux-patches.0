Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8224C4FD78D;
	Wed, 30 Sep 2026 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785324; cv=none; b=lzMbGAPorxsKcSlfFECAPyWzweaZZamVjR73wp4q+ZDEK8l16vTBxWlBnhNKqKCYpEcaEbR1V+NCuAYPo6yBTMvIxYFoseN8iZJ4NP3VRxFILlxjrZTebMF9/3nGveiZkWfOnvDrk0UXlZev/qqZ9TpUh4fn5vrvMMKBwmGWcOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785324; c=relaxed/simple;
	bh=8bFpWjnVGGvYSTkOVVFTPF5aZF8/+lDecihIlnKANr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3zpZIr03KEi8c6UJKs9PbyQfDYbuO7NZaohW8ediTDUeoit9qRDo/zz5EHdvG4y7FXRQBI7toVEiGfcbbTfVsK0RyzvLwj6AtBCkvYugaoLAwWZf7ltOb/ItikuLe105GYTqVCf/wkwF0SVWNfF45TcU2xwOpMq5CIBV2irIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOc/2lbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOc/2lbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85D21F000FF;
	Wed, 30 Sep 2026 16:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785316;
	bh=yrsKEHTmBkjSjoR3g+xlm2SBkTMephfSpo/tlN1ESr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOc/2lbMksxYGVa51V72fKn2/Lutfn+laNlTdldC7EBf69uSt+ZPkV+Y4jpOcbLwI
	 zJ7Au1AbPwtKaNm2jRfFy+MKkMFk77HWQC14+ZKmjvAqcBvvcC92hG/tujWRKQkALl
	 Z9u9ghKdlR7H4F2CkwbPBKOVTRFapT7+2S0yqPO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 466/982] watchdog: msc313e: Fix undefined behavior
Date: Wed, 30 Sep 2026 17:20:02 +0200
Message-ID: <20260930152426.795441094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit ab390021b2a3bb4cc875f28a6f76d13de90d7457 ]

readw() returns a u16.  Left shifting a u16 by 16 bits yields undefined
behavior.

Cast to u32 explicitly before the shift.

Fixes: ffd264bd152c ("watchdog: msc313e: Check if the WDT was running at boot")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-7-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 9cfe059fd31a7..72620adec641a 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -32,6 +32,16 @@ struct msc313e_wdt_priv {
 	struct clk *clk;
 };
 
+static u32 msc313e_wdt_get_hw_timeout(struct msc313e_wdt_priv *priv)
+{
+	u16 low, high;
+
+	low = readw(priv->base + REG_WDT_MAX_PRD_L);
+	high = readw(priv->base + REG_WDT_MAX_PRD_H);
+
+	return ((u32)high << 16) | low;
+}
+
 static void msc313e_wdt_set_hw_timeout(struct msc313e_wdt_priv *priv,
 				       unsigned int timeout)
 {
@@ -140,7 +150,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		return ret;
 
 	/* If the period is non-zero the WDT is running */
-	if (readw(priv->base + REG_WDT_MAX_PRD_L) | (readw(priv->base + REG_WDT_MAX_PRD_H) << 16)) {
+	if (msc313e_wdt_get_hw_timeout(priv)) {
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 		/*
 		 * Keep the clock enabled. The watchdog core will skip the next
-- 
2.53.0



