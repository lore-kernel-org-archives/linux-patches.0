Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE92379C40;
	Thu, 17 Sep 2026 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670732; cv=none; b=A5dfkohg8h606ZoX5DkL8LolgftecKxPM0Hxi2izihSsIFq2IXpTKSiAKd3czf6Oz8D7S9yFxDxBnBoWc1L8SRnViIeSbMBwAT/hrSBk/C1hxENmuLgc6Ke3dOkrdHNYV9V8P62h2SG9nYqx7jpkYGlMI75cX2lzqmtyEy4mzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670732; c=relaxed/simple;
	bh=dQvDgCBEYIAVR3Aat7N611okQ6JkALrmrb0Fhy7Xtpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh6iNnO2n4Yb+cqPl3kb8RZ6WNd1DzIg41pkCTUz1EDOBNzPhR8sb4bTzse3D7TiQFxMKuxFwZBcB8gATLigOlPeeAlHTLJDiSTMwf9CvcyR4oR1JGuCu8ynw8RnmYuTam3ags5jMMxWI+YpIkj+n6YySmw1YrMp7Lsxa4j5vZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vphS7nBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vphS7nBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F921F000FF;
	Thu, 17 Sep 2026 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670730;
	bh=CrYNOIKBS3t1JA/Vn9v3J+WjFe20Sr46I54MNMC1890=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vphS7nBrar0CNVbjzuwQgl8DBw23rE/k40rlCuZb5s5GYRJJsksRCA5qxsANiHUQm
	 6cJ+2u0RDEa1Sn2W0MBTl18snY9ojWKPuuSHKenpIpzISmxydvyUxWfrXBVu11VUXr
	 wrB5udECwkEpmz5bzf7wy42VQnbe4RXAtXIraOi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0751/1102] watchdog: msc313e: Fix spurious reset on suspend
Date: Thu, 17 Sep 2026 16:11:34 +0100
Message-ID: <20260917151559.275413833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 4f6817c9eff4aa1078e16652d82e4b7ef4ffae3e ]

If the hardware watchdog was started by the bootloader and the device is
suspended before userspace opens it, the ping worker (from watchdog
core) is frozen and the active hardware timer continues running.  This
leads to a spurious system reset.

Check both watchdog_active() and watchdog_hw_running() when deciding
whether to start or stop the watchdog during suspend and resume.

Additionally, call watchdog_stop_ping_on_suspend() to ensure the ping
worker be correctly paused and restarted during suspend and resume.

Fixes: ffd264bd152c ("watchdog: msc313e: Check if the WDT was running at boot")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-6-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 86e72aea96855..9cfe059fd31a7 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -157,6 +157,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
 	watchdog_stop_on_unregister(&priv->wdev);
+	watchdog_stop_ping_on_suspend(&priv->wdev);
 
 	ret = devm_watchdog_register_device(dev, &priv->wdev);
 
@@ -171,7 +172,7 @@ static int __maybe_unused msc313e_wdt_suspend(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
 
-	if (watchdog_active(&priv->wdev))
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
 		msc313e_wdt_stop(&priv->wdev);
 
 	return 0;
@@ -181,7 +182,7 @@ static int __maybe_unused msc313e_wdt_resume(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
 
-	if (watchdog_active(&priv->wdev))
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
 		msc313e_wdt_start(&priv->wdev);
 
 	return 0;
-- 
2.53.0



