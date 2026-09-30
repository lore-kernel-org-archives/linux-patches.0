Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED812511180;
	Wed, 30 Sep 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786142; cv=none; b=opZc0NT8ygZsrBoC1/Gs531YqW6xSJ1iZrWzsKyAbfxdNV3m03ANK90lY9teF/4tf3sOlbVEuz3rE9LzHaa0HVlDwSpn78q6l75RTuCJE59+1WmKHwrj5gVPqcfZnDfH+IsRApJo4fu3X+bODigfORv0/1ywmRkb0sQ/2VFmdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786142; c=relaxed/simple;
	bh=KR7GTir4fzyNZ0F9lZ9zxKr2oAmR47xtvzCQYpe7EoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fv8y8qQ2PmLZboACgzV4VF3gsgIdQXwk4/vEMSLHaBrwU0m6gP5bu8gGp09TTdo7NfId2KsHApwBl6FpljoO5Nj4IIF6kiDvSVgKH62ecZ42FYy1mLxir5r2i5nubhbR4y1PkEuit6Py3YbTP1AmWDrlntBtV6C3zx8ldAw6nC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahb5ixY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahb5ixY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555391F000FF;
	Wed, 30 Sep 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786140;
	bh=EO5keBegqm7qiA7MuqhBZWokWhh4pP+O6J7H6mmtMnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ahb5ixY9RuGCtU9T+0yz60tjzB/AimOEcY3TEU/B7meWRlssb+MA6YIdVlDizo4Xn
	 i6nQLl/jiXOv7t5Wm+OQWlBlxyrWoiXpmhAfUY5R446AiG2pT3PQ3yVXEUn/Qb0udy
	 56IDf2TbRm8jNYMHMwwbY5tuFO0wzWIF+3xnp2pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 757/982] watchdog: msc313e: Propagate error code in resume()
Date: Wed, 30 Sep 2026 17:24:53 +0200
Message-ID: <20260930152433.014480643@linuxfoundation.org>
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


