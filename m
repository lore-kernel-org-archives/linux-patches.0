Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6905B3B0ACE;
	Wed, 30 Sep 2026 19:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795437; cv=none; b=h68zUht76BsuGTx/fDpJKoUdC8c5OFeanqP5YqiMdeGsmRRc7AtLtUHOaAG9s9p+xdirxL1I6msagzitFuFDm8oG3cOtSfC+Iz6hAf1cTUiDSV22ViLFR03/Rzx9BmVcAYyX7rk8CcqGp547xEQBT1Z5eH1PiyLOC1cE0tq3sGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795437; c=relaxed/simple;
	bh=BCgB43cqfQXibY186wsDD31KEP2h83zeQf59C/VpxOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRAXDHT2Pya8UN1NvzipF5gkqUXzxd/CY0cFb6aJ4fFI/vkCvsPgyXbRjB1qY6Ic9UWJWp1tq+QmnOOH+4hAG1pmoSWIeaRp0jW6sbgkWcPPgpEuVArSVpcDUor4O9+bKOPxpmev9Xoi03xzvXccRyXQ73IHMxvCMawg07Ir13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYeiQYrg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYeiQYrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B0D1F000FF;
	Wed, 30 Sep 2026 19:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795436;
	bh=8H9+IjWd/rJq8QqZrPv7iWD6eN/u8P2qUnbfjxqKoIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYeiQYrgVomji7GGT1LUH0jb/3TK+28FJAEFM4cdqtVptijazfoO7una2XKBcJxYh
	 G2tTYFkZdX58PmeYJaowyyEubfNbTfDwVTFlAfD8hjJXrpeASNDLzLVTD9pCLckLTu
	 peDNl0KILb+tmRTBrpB0DCy9G9hlVEiQ9IpdelE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0559/1193] watchdog: msc313e: Fix clock leak and spurious timer in settimeout()
Date: Wed, 30 Sep 2026 17:20:43 +0200
Message-ID: <20260930152446.660110514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 3db30f315935c2fb0d95f46b7a593b5b4d3ec3d0 ]

msc313e_wdt_settimeout() unconditionally calls msc313e_wdt_start() which
introduces two severe bugs:

1. If the watchdog is already active, calling start() again will
   increase the reference count of the clock again.  However stop() is
   only called once, the reference count is unbalance.
2. If the watchdog is stopped, calling settimeout() will start
   the hardware timer accidentally.

Factor out the register-writing logic into a helper function.  Only call
it in settimeout() if the watchdog is running.  Otherwise, simply update
`wdev->timeout`.

Fixes: e9800b799464 ("watchdog: Add Mstar MSC313e WDT driver")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-4-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 072bfcea85c24..5dc5e3ab7001e 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -32,20 +32,26 @@ struct msc313e_wdt_priv {
 	struct clk *clk;
 };
 
+static void msc313e_wdt_set_hw_timeout(struct msc313e_wdt_priv *priv,
+				       unsigned int timeout)
+{
+	u32 t = timeout * clk_get_rate(priv->clk);
+
+	writew(t & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
+	writew((t >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
+	writew(1, priv->base + REG_WDT_CLR);
+}
+
 static int msc313e_wdt_start(struct watchdog_device *wdev)
 {
 	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
-	u32 timeout;
 	int err;
 
 	err = clk_prepare_enable(priv->clk);
 	if (err)
 		return err;
 
-	timeout = wdev->timeout * clk_get_rate(priv->clk);
-	writew(timeout & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
-	writew((timeout >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
-	writew(1, priv->base + REG_WDT_CLR);
+	msc313e_wdt_set_hw_timeout(priv, wdev->timeout);
 	return 0;
 }
 
@@ -70,9 +76,13 @@ static int msc313e_wdt_stop(struct watchdog_device *wdev)
 
 static int msc313e_wdt_settimeout(struct watchdog_device *wdev, unsigned int new_time)
 {
+	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
+
 	wdev->timeout = new_time;
 
-	return msc313e_wdt_start(wdev);
+	if (watchdog_hw_running(wdev) || watchdog_active(wdev))
+		msc313e_wdt_set_hw_timeout(priv, wdev->timeout);
+	return 0;
 }
 
 static const struct watchdog_info msc313e_wdt_ident = {
-- 
2.53.0



