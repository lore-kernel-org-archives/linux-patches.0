Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4315326DD;
	Wed, 23 Sep 2026 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173890; cv=none; b=SCLU+ImZRu5tjDRToLTvBTtsAFH2TW4p639g4syHsoRGmFOssxkzF0kh7IbmRTBvjXkaSTVumpXzsydNEZaKXSCaPDSe4rE9HcC8S63h/jQBSLnaCpsEEWeixsq9LxQgOeslnyu6MXj1qQbvlcddiI+kgR3G40I6lcsUh65OuY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173890; c=relaxed/simple;
	bh=kDVFO5sV7q84eu9J1wIWW2u1oClClYT9r6CSB9x63n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChshMRTRXQjzyVm8gitKd7bH/0bDvoWK5u+jRRRkoqMqRgOPcv5WDq1lfKxAuoJfZPpqKZR0TiMV82ih03R9FenVe+sOvnnCC7rumrxrvrcMDlgV4ia0yaoPz9Myh4tc5vdXDCXk2ZSGNZo9NmeDhEqf4GVb/kU73noCtnbIE6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6SYe1lD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6SYe1lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA311F000FF;
	Wed, 23 Sep 2026 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173889;
	bh=UGIE42Kph5fw/HZByOckyQVkrzydcYj3x9F4ohLm/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6SYe1lD9fvrwg109HDVsdAHJG+wvRBSglZ7BPA2MDILlMY3YfR6VhXwadPCr8hQT
	 ia7/vw7kujikzoVxeVL69aJ2ZEE1cB0AMA/FK51AIA1NmgZmTRMGDSfeDJ3VBdnwjG
	 VDDVnM+tuhUNq8JruvcebiiHvZyQXEExV/zUFTKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 377/438] watchdog: msc313e: Propagate error code in resume()
Date: Wed, 23 Sep 2026 16:06:38 +0200
Message-ID: <20260923140654.636629159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
@@ -197,11 +197,15 @@ static int __maybe_unused msc313e_wdt_su
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


