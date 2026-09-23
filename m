Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F9253B5ED;
	Wed, 23 Sep 2026 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175181; cv=none; b=qZPNZS8FIzXDTWtDek75aqsqQmHC/IORdLZwS8/jq3xDggM60wq+BbgmWXlzfnbUhdJq3vJd4aTqP2SqO0TrszpOq7bb0ms9flFSOE+Wd/sBrkKNvh0P3EAU6cxPw4vGoJ7+jTY9xTqqR/1cbaq9x07OpqFrjJLXbnj3jmp1Ch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175181; c=relaxed/simple;
	bh=EDScgsurfjYl9Dh4vUgid8+uKtQCRLInxLlQXsqdPAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i28QltgazpSvgh9dq2L4the9ctlPa4zca6vKNh3LMao2riDMDNDLOufzulhDSOM1ygGK0+qYvsNCqTG2KXb0sGJWylZPOXoD31K54HbcQZRbWD/v6Gfg9hW+OSat2/Ve4oRl109zyezXENNhTXC0Xpc+CS0n3Or+QVWZdA7l8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wacrmwA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wacrmwA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0581F00893;
	Wed, 23 Sep 2026 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175179;
	bh=99y4oV6uLzzTf7ccU4hFIht6tXm28o3C6Y/75HLVvVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wacrmwA0GJQWIm/wgDnzp5wRtmYgzbqk20WXdt4SnBq5M1fq4RraOrrArXJ4bYJTg
	 zyiczc8HbnEEmlBr9Q5fqz5H1TFJnevmXYkqRdqxubykoVmmY06w4zeanGsWCQLyRc
	 L+udoygd1jv86m+tRI1Bqbw4nWsfo2ciRR3+uq6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 318/398] watchdog: msc313e: Propagate error code in resume()
Date: Wed, 23 Sep 2026 16:06:32 +0200
Message-ID: <20260923140651.664263238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


