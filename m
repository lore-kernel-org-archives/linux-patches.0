Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE8A4F3900;
	Thu, 17 Sep 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659853; cv=none; b=mBfKHB4LTJJ5QRs2tApzjsrQqAjiKFhg7AaC+uy8U2yCc+QQs0emfhYXZvZiZcwwovAGlRxuJFqiZ12/g/RFtBnevTaV9JxV7n/l0tbXBLqdlwZqJNuCFcmC59zJj0OkOn9sGWS298W4HPQZLCNu316+Fzlz3hbodlxHLvWteV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659853; c=relaxed/simple;
	bh=kCLWuKbLI7mOTLVLA0O6ssJNfhKTzANreOB6tPj3Fgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDxLY2fbTu3rqZr6AbtNVXiT7l9vEtCP0m+aSiUoUVnm0sPjFp3rHkJPOQ94Sl2nR4wMbitQCKXfNLPtdiqIWIKoCrLUTxgxxlHQCQiGOO5RIhmI1FnB8utC/R05sHJtDfLYiBX3sgnUvihxrC9jVNyqoUbro64xEycM5gS5orI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYFLwHKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYFLwHKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480591F000FF;
	Thu, 17 Sep 2026 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659847;
	bh=QfJaCABc8BTT3aKnclks7eDszHByvYhP2OIUNf6IGp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYFLwHKh0IN1Fyuj4LNeOhKBxOKI7HIal/WEVhJbYxCDwEADp5xEyQVL255h5F98a
	 QrO+z3/IZUuMO0VthRUcWTTWtm3y/f+o7tA6LW653id1snQELuOKK3d9LKteYjf9AW
	 U+f/xgjx54CqO7hyWESuRf08NOi/sEENq9c1X8Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 394/733] watchdog: msc313e: Fix spurious reset on suspend
Date: Thu, 17 Sep 2026 16:11:42 +0100
Message-ID: <20260917151401.535354803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7c45935667818..c7d558fefc860 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -156,6 +156,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
 	watchdog_stop_on_unregister(&priv->wdev);
+	watchdog_stop_ping_on_suspend(&priv->wdev);
 
 	ret = devm_watchdog_register_device(dev, &priv->wdev);
 
@@ -170,7 +171,7 @@ static int __maybe_unused msc313e_wdt_suspend(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
 
-	if (watchdog_active(&priv->wdev))
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
 		msc313e_wdt_stop(&priv->wdev);
 
 	return 0;
@@ -180,7 +181,7 @@ static int __maybe_unused msc313e_wdt_resume(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
 
-	if (watchdog_active(&priv->wdev))
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
 		msc313e_wdt_start(&priv->wdev);
 
 	return 0;
-- 
2.53.0



