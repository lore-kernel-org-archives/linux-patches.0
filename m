Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8102832B13B;
	Sat, 12 Sep 2026 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227049; cv=none; b=iI5ixMmaylZhOmwM+WlOdcAP/7ogfOAKFShvYdhsqVMp4D0Ax82LCzIv5zEHdOfIwIJsA5EbDK56jRU5ixGya0D7ix1f4TBDtHyiJYYfWo9kvmJzsM+K7hf6WMo/oVJ4fjJNH17TNVuzVy6oD4hh9Pvd9qh1FDLkeFuAv4qqJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227049; c=relaxed/simple;
	bh=1vjMiL+GhdqLbuy13ToorNcYugs7ut0zOZvpXf4OGhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNM0NXKF1VcAuYgnOXB8LBsEQwF3UtQsx39EfoSiPCES6OBU6gFdAVujtCEpRRzV1kXuzOW6ujMYpQN+j4zjsC9+6+qOPDvQ00sHG3l1wnWz1n6sQ6T8xGBpMgPp0vJH3PNM1w6w9Zm3NI8+jofyzr1sdz/Wfi8KX+bWiwxYUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB5pqZq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB5pqZq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05D71F000FF;
	Sat, 12 Sep 2026 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227048;
	bh=kNY+54Tf8W9NsR+O0+QXuO3WXbrrdjq97azW3in4wcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB5pqZq0On3ezdHOdmy7IFjkcVtASl/+EFEMTODrQosigzgwvPR5TTwpPz0w+sssK
	 592mDHFOAy+AWTvJ5V8smAD/avpkVYmu41NQAwCrPA7KI2ZN2u1wBSea/J0gtX/WtH
	 l5YtnxGbzRXuw1qxiIl2adf0n2mc6sLlBreAdL4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 0099/1191] auxdisplay: charlcd: cancel backlight work on registration failure
Date: Sat, 12 Sep 2026 08:47:07 +0200
Message-ID: <20260912065550.404142993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


