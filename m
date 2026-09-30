Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610B23CC300;
	Wed, 30 Sep 2026 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796435; cv=none; b=utC4uUGyviy2FPKbDVkxnK9ckTSWzFShF1ksItWDneShLyN60XCCJ42bI/5hPUBchE7B8HdTfxA72OAxFIkZTFgq0kqYlhcujR7yvF7h196F50oGM4tJ4cQaPnJhDvvJhxXmiajOFbxoKKOSNryuuq1OFYo/uJlJ1PS0IapkJPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796435; c=relaxed/simple;
	bh=oLrFkSWpqI+JHFRvPsB2PobU7/sqcKk9Hy7ox9i+eag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAMeq546vW2PybWVs7WaDRbUbOSFO8a9gza3o9OHQ3tLPwZ+bmV++5rjJVQG2t0spia38V6lDmFxNG45oAJ1zpbtcUgH9iSpNhE53W/86hkzxE4GfcSa7RDATyfbLEMIBD47byaTeOkAJO2eIA5WPhqBFLtX68PiMslpwmxB6I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMB7aYwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMB7aYwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14051F000FF;
	Wed, 30 Sep 2026 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796434;
	bh=6eIk4FZV/ZSEKBg4Autb7M441FCh3E58QKO96dSppzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMB7aYwhcqdz1f/fFtWpCY5VK0/wueAJPJHH3IYp2FJyw9zKerB892hYWjlVq8KOt
	 J+JGL2uUXQzC2q2UNaLi1CUqIIxvz48EMF0f2+uj1PQcv9WjlK1+KAK25ILl56mnvf
	 EfhB1aNkQt1Tw2JgqFFho9+FrqAwFyFZIj2JYFao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0913/1193] watchdog: msc313e: Propagate error code in resume()
Date: Wed, 30 Sep 2026 17:26:37 +0200
Message-ID: <20260930152454.525970611@linuxfoundation.org>
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


