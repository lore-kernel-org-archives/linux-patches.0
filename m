Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93B3AEF36;
	Sat, 17 Oct 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256839; cv=none; b=rvdLAGXfYWCa+/RXd2XFgRrPugLwgJlAjtWWy22sEuI5yBB+ouW79oKsF4ozDEeQutZnVHI1zZoinnRCzuoeN0FILHErDEMtOIRfuWGJmzP4GNMjRXHbTKjnKNDueBBs3+wZ9a/ZEb+VhTrFJ0J8E7Oux/vGJU6uCFSR8INcZyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256839; c=relaxed/simple;
	bh=63WwoI2VV73vHXEF/gWZ+s0GMoXmjnzottQlCARUbrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7bIQntBkgDXgCtwMUHRIUxdLHT7O6ZHdRoMH3ITIC+UzU50X0Am36UxbcG7fjmXhn+Q++PAHOA++10KCdQgDFHm8yS/iTqLrK0xxAI3z2+9Ue4O8coTvlKDOHZnWvFyTK/3d9+skoV/ODBERxdpcJFC53msQPSDIzWyUDrlwCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA0Q3gSx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA0Q3gSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57A01F000C4;
	Sat, 17 Oct 2026 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256838;
	bh=V6gDEa/42SIOps2f/uAbNnrOHoV8OGNawrKHRnsDZQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pA0Q3gSxpQP1SvaAqi3HdLwqsakHZK6mKu7Fxmt8NN+uDkaDRYVW3oMzy44gK9wKM
	 E6JN3V9igdSj0RPOfiBC6tSJkn2QFQM0uLUMykBRsBzpYTb7nGMEHEMD/2EYFKel8+
	 lv4Jd2E4jC89IiZqAiuCb5EKUY4RfheVEL7Q0nFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0368/1674] usb: gadget: at91_udc: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:44:00 +0200
Message-ID: <20261017160440.567686482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit cbd1b152519a581bfe14fb6b14ea6e57cca426c1 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

In the error path emit an error message replacing the (less useful)
message by the core. Apart from the improved error message there is no
change in behaviour.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231120215830.71071-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c27d13ce4bab ("usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/at91_udc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1924,7 +1924,7 @@ err_unprepare_fclk:
 	return retval;
 }
 
-static int at91udc_remove(struct platform_device *pdev)
+static void at91udc_remove(struct platform_device *pdev)
 {
 	struct at91_udc *udc = platform_get_drvdata(pdev);
 	unsigned long	flags;
@@ -1932,8 +1932,11 @@ static int at91udc_remove(struct platfor
 	DBG("remove\n");
 
 	usb_del_gadget_udc(&udc->gadget);
-	if (udc->driver)
-		return -EBUSY;
+	if (udc->driver) {
+		dev_err(&pdev->dev,
+			"Driver still in use but removing anyhow\n");
+		return;
+	}
 
 	spin_lock_irqsave(&udc->lock, flags);
 	pullup(udc, 0);
@@ -1943,8 +1946,6 @@ static int at91udc_remove(struct platfor
 	remove_debug_file(udc);
 	clk_unprepare(udc->fclk);
 	clk_unprepare(udc->iclk);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -2000,7 +2001,7 @@ static int at91udc_resume(struct platfor
 #endif
 
 static struct platform_driver at91_udc_driver = {
-	.remove		= at91udc_remove,
+	.remove_new	= at91udc_remove,
 	.shutdown	= at91udc_shutdown,
 	.suspend	= at91udc_suspend,
 	.resume		= at91udc_resume,


