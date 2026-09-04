Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C941A4F8;
	Fri,  4 Sep 2026 06:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502302; cv=none; b=KqBy0XadTenxB2uIccd6XI3F1HfZhbBlAHT0tvG/9EXnG1ET3zFMxE3Fag7uU+rsqjdJCa53vAnEfpbIKg3Yw69Ya3iV58WzJSHAh4ib0MFKIoW0oay1/zdUwaH5kNCu/CtRCcGgaz2qUt+ma88zxescXdg4ZkPnvI3J6ubnzbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502302; c=relaxed/simple;
	bh=fpsfdcMzICmcJ8TVBojv+4qzgTFerQeiiBywlCzJZtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVUh8h5m6j1VqISGL65txz1kwtesc1jIPoF+lRvxeZgEt9XRa03aOL1Tp7hVVB/DRHpJgckt8mdLVJSY4VCy6C4M6Jyq7y5n9eV9AzmoKwEXvPQZ+KAA5bHKnYpu5msQcH/nUkTagBDICgpqFKux7gGwTZnD4vHKmJxXbZtQQgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd1TrwHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd1TrwHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196D01F00A3D;
	Fri,  4 Sep 2026 06:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502299;
	bh=dTzqEaPWy3u/naU7oA4Yqg0Uz/O6SN6nssmMvJ1xIzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zd1TrwHPJ1/s5olubqd22/KG0eXQUIBGANQs1X7aALCdRg51FU6qukpcFb7TF5LuS
	 qOJKiPwYLGIQjt43/kQw2KUh8dzha6UADVh/o6PxCIfWO5Odan1M52Di0aHpSdQDJB
	 wISMM06gCzoURciPc+jxxcK1Rh17o+n3uNVQF0nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 159/403] auxdisplay: charlcd: cancel backlight work on registration failure
Date: Fri,  4 Sep 2026 06:59:22 +0200
Message-ID: <20260904045738.468065946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

commit e3e3bf40916c1e810df03958cfa7ba6883cdce79 upstream.

With CONFIG_CHARLCD_BL_FLASH, charlcd_init() schedules bl_work before
charlcd_register() calls misc_register(). If registration fails, the
caller frees the charlcd object while delayed work still contains its
address.

Add charlcd_deinit() to cancel the delayed work and turn the backlight
off. Use it for both registration rollback and normal unregistration.

Fixes: 39f8ea46724e ("auxdisplay: charlcd: Extract character LCD core from misc/panel")
Cc: stable@vger.kernel.org
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/charlcd.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -595,6 +595,16 @@ static int charlcd_init(struct charlcd *
 	return 0;
 }
 
+static void charlcd_deinit(struct charlcd *lcd)
+{
+	struct charlcd_priv *priv = charlcd_to_priv(lcd);
+
+	if (lcd->ops->backlight) {
+		cancel_delayed_work_sync(&priv->bl_work);
+		lcd->ops->backlight(lcd, CHARLCD_OFF);
+	}
+}
+
 struct charlcd *charlcd_alloc(unsigned int drvdata_size)
 {
 	struct charlcd_priv *priv;
@@ -654,8 +664,10 @@ int charlcd_register(struct charlcd *lcd
 		return ret;
 
 	ret = misc_register(&charlcd_dev);
-	if (ret)
+	if (ret) {
+		charlcd_deinit(lcd);
 		return ret;
+	}
 
 	the_charlcd = lcd;
 	register_reboot_notifier(&panel_notifier);
@@ -665,16 +677,11 @@ EXPORT_SYMBOL_GPL(charlcd_register);
 
 int charlcd_unregister(struct charlcd *lcd)
 {
-	struct charlcd_priv *priv = charlcd_to_priv(lcd);
-
 	unregister_reboot_notifier(&panel_notifier);
 	charlcd_puts(lcd, "\x0cLCD driver unloaded.\x1b[Lc\x1b[Lb\x1b[L-");
 	misc_deregister(&charlcd_dev);
 	the_charlcd = NULL;
-	if (lcd->ops->backlight) {
-		cancel_delayed_work_sync(&priv->bl_work);
-		priv->lcd.ops->backlight(&priv->lcd, CHARLCD_OFF);
-	}
+	charlcd_deinit(lcd);
 
 	return 0;
 }


