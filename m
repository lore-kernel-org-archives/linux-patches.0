Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B6516148;
	Wed, 30 Sep 2026 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788964; cv=none; b=azFFvSfK1TL/7FMtaaEjLgFpZAVUEKIYQ7U80WGPQdTn8UnPexqdW0LWNqKWttBdN03/OuTc3bnkAKLPN050lOUk3b7jqonJk9EM01LA0e1n33yEVEYVFMcy7zTGKHCdztKQdsaYo8GIbw7QgAGJhb1zi7q44aDkkUgYE5DJs3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788964; c=relaxed/simple;
	bh=T7qGKpZM2egLD03ZN+QNrvPUcTkmQb++Kv7Vy1fYGJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR6N7zLVo18aNwom4myl6QSCoJ1jgVFTMUI3Nef4n9vtLBLF6Ws2Qh81CZc2dUMSEwfae4yIl7qohqRFqw0KyOdFma+k6rG0UDjMr5GBKR/fk8adE64f1uPOMGPyBh/Hbu7Wm8ehQPte8DV8j6T1hB6/6AB2vQOb6IuBCPgspsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rq8O9PCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq8O9PCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E70B1F000FF;
	Wed, 30 Sep 2026 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788962;
	bh=AiFckynmaEU9OokDXTrr/8e0wsNI9l4vqLidxCqLa5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rq8O9PCaX/rFcqykLD6Gw/qG0YHzxSCkP6wwYzUBCRT8dm8ksxaNAEvtTXzNkR9MX
	 EBhZWdyCP1Mat3TzUkLTNKEpOx6HSYeX/X1PeDJ8Lgn4PZKIpA8dfOU697f1D8Ng6C
	 YalAueS1aAzs8x/O4X/ABEmQM98imQh+eGdbwMvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 255/877] watchdog: msc313e: Propagate error code in resume()
Date: Wed, 30 Sep 2026 17:19:26 +0200
Message-ID: <20260930152420.224270667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

commit 1d9763f34a85680db1e8233d654fdb85e5f897cc upstream.

If msc313e_wdt_start() fails during system resume, the error is
currently ignored.  Consequently, the watchdog isn't running without the
user's knowledge.

Propagate the error code and print a message if msc313e_wdt_start()
fails.

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Fixes: e9800b7994642 ("watchdog: Add Mstar MSC313e WDT driver")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260912163334.28636-1-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/msc313e_wdt.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -198,11 +198,15 @@ static int __maybe_unused msc313e_wdt_su
 static int __maybe_unused msc313e_wdt_resume(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
+	int ret = 0;
 
-	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
-		msc313e_wdt_start(&priv->wdev);
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev)) {
+		ret = msc313e_wdt_start(&priv->wdev);
+		if (ret)
+			dev_err(dev, "Failed to restart watchdog (err=%d)\n", ret);
+	}
 
-	return 0;
+	return ret;
 }
 
 static SIMPLE_DEV_PM_OPS(msc313e_wdt_pm_ops, msc313e_wdt_suspend, msc313e_wdt_resume);


