Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B5D3438B2;
	Sat, 12 Sep 2026 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232802; cv=none; b=Nwd4iV+DX04yjwBjuTrvHv1KiTSEYOdFqJFLkperdJL+aPMHJdE8C9sU+62iJO/8Ar1eQRDvjVg65VXVpnROlljYS+9n6ywuBc5o/KlzEni2XQn81ku6niSEp1DTgkcluzbHgQ/mc0TYtw1PZyt/QTeFQ6YxC2ogs5QdXfv8zJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232802; c=relaxed/simple;
	bh=/McRCc9CBQZskUGO+UqegKpMYjH5ENvRfL5Lo95BWKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcXGix/WJWx7funRLpyWXpfkC1dH43nUfM3ChR8dAgvODVGpzSAatIkrI5/u5DztSqREzHqWngPBr7IdTncu8dZmTbzYT1MXrOlqL6Bh3g92qo2gFrDsiVMXDhN5UIJJ2iJZiAWzenNdOW2e9sP5N33e20BTpwx/BZttnqVmjiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWAAGwd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWAAGwd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4B81F000FF;
	Sat, 12 Sep 2026 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232801;
	bh=UuHY5+/13YgyTISU6oaMqpGqAvXT1AZGt80dWYdUTgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWAAGwd7dIx8NvUNqZfPFaCLv5UGOlpCtIC7YQkShEvP2o5XrvrFwiz9O/L7HexYW
	 yJXiPMKLh939iEcX9sjeYAvz29Zv7M0WPVACnRtyh9jSzBreZ8wM7mY2vOmLTGCjko
	 doRsIxL4HS3cz/jvV1bmcaxRFnFo2zNji9fTtELY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 085/935] auxdisplay: charlcd: cancel backlight work on registration failure
Date: Sat, 12 Sep 2026 08:51:55 +0200
Message-ID: <20260912065528.776637078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -594,6 +594,16 @@ static int charlcd_init(struct charlcd *
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
@@ -653,8 +663,10 @@ int charlcd_register(struct charlcd *lcd
 		return ret;
 
 	ret = misc_register(&charlcd_dev);
-	if (ret)
+	if (ret) {
+		charlcd_deinit(lcd);
 		return ret;
+	}
 
 	the_charlcd = lcd;
 	register_reboot_notifier(&panel_notifier);
@@ -664,16 +676,11 @@ EXPORT_SYMBOL_GPL(charlcd_register);
 
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


