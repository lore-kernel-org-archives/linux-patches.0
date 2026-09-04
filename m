Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D113AFB1C;
	Fri,  4 Sep 2026 05:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500564; cv=none; b=emmamP2n3q3KoPvlLvD7MLLObyc66NLJQ5ZEmmg529sbl1HQdwmFAf76SqaSSv59vuvPL7IAMMxXkRgSwKaPrrHDavvmCHnnlC5EXL0MBwntNDURRG+Xz37xDVX6IS/4JcQ62SpxGtq7X5xiJaQUiG7xKmLC36g5m6rLrmCbpt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500564; c=relaxed/simple;
	bh=3Xrcyhi53jZLFe4gzKERyXqq2IAQNmPbKYv63Kx4t/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLBxDypZ0M2IUjCsM6+2cHhlqPgRo9HtcMnjAUZPFUZXMGBOq5KqdzYMPQYk/LaAeKwU5SAaQ5J54bWloO27VkBLyn5n8mveYnLROYDo75fqDhViS/S/IPJ3JyoXLa+t/Ni0cWpqXq+qU3M+1nmhLpIfne6UXLtkXsrr3cMZci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hixT/Jjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hixT/Jjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1601F00A3D;
	Fri,  4 Sep 2026 05:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500561;
	bh=sqLS8+S+eQRLpf+ZuCgyHVAj6m83PXrVsGHWaDBzAI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hixT/JjxDNXdkl1pCqGV8zJwhr+HbuFpi2RrCVyOqSsB0yzmvISLIABjcDiwnowec
	 /7w0aMBxFN+uEAZtowzqLD5ujTKojqqKK26IwDcx0Xoym2gmLBVWfUxhklyTrLEZMB
	 aubVppmfZiLEwgBOwO/esn6Rt12aUJFbvg2XROvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.18 073/552] usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed
Date: Fri,  4 Sep 2026 06:53:50 +0200
Message-ID: <20260904045749.503380662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit c27d13ce4bab80fbdf6523928071b6c24b37606c upstream.

In polled-VBUS mode (board.vbus_pin && board.vbus_polled), probe arms a
self-restarting cycle: at91_vbus_timer() schedules vbus_timer_work, and
at91_vbus_timer_work() calls at91_vbus_update() and re-arms the timer via
mod_timer(). Both recover the same udc through container_of and dereference
it on every iteration.

Neither teardown path cancels this cycle. udc is devm-allocated, so it is
freed after at91udc_remove() returns, and is likewise freed when probe
fails and devres runs. A timer callback or work item that is pending or
running at either point dereferences the freed udc.

Add at91_udc_shutdown_vbus_timer() and call it from at91udc_remove() and
from the usb_add_gadget_udc() failure path in probe; the remaining probe
error paths fail before the timer is armed. timer_shutdown_sync() waits
for a running callback and clears timer->function, which makes the work
handler's mod_timer() a permanent no-op; cancel_work_sync() then drains
any pending or running work whose re-arm attempt now does nothing. The
timer must be shut down first, since cancelling the work alone would let
the timer re-queue it. The guard mirrors probe: in IRQ mode the timer and
work_struct are never initialized.

This does not require a fault; a normal driver unbind can interleave with
an already queued work item.

This issue was found by an in-house static analysis tool.

Fixes: 4037242c4f5f ("ARM: 6209/3: at91_udc: Add vbus polarity and polling mode")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260719042839.3167094-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/at91_udc.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1794,6 +1794,19 @@ static void at91udc_of_init(struct at91_
 		udc->caps = match->data;
 }
 
+/*
+ * The work handler re-arms this timer, so shut the timer down before
+ * draining the work; otherwise it restarts the polling cycle.
+ */
+static void at91_udc_shutdown_vbus_timer(struct at91_udc *udc)
+{
+	if (!(udc->board.vbus_pin && udc->board.vbus_polled))
+		return;
+
+	timer_shutdown_sync(&udc->vbus_timer);
+	cancel_work_sync(&udc->vbus_timer_work);
+}
+
 static int at91udc_probe(struct platform_device *pdev)
 {
 	struct device	*dev = &pdev->dev;
@@ -1907,7 +1920,7 @@ static int at91udc_probe(struct platform
 	}
 	retval = usb_add_gadget_udc(dev, &udc->gadget);
 	if (retval)
-		goto err_unprepare_iclk;
+		goto err_shutdown_vbus;
 	dev_set_drvdata(dev, udc);
 	device_init_wakeup(dev, 1);
 	create_debug_file(udc);
@@ -1915,6 +1928,8 @@ static int at91udc_probe(struct platform
 	INFO("%s version %s\n", driver_name, DRIVER_VERSION);
 	return 0;
 
+err_shutdown_vbus:
+	at91_udc_shutdown_vbus_timer(udc);
 err_unprepare_iclk:
 	clk_unprepare(udc->iclk);
 err_unprepare_fclk:
@@ -1933,6 +1948,9 @@ static void at91udc_remove(struct platfo
 	DBG("remove\n");
 
 	usb_del_gadget_udc(&udc->gadget);
+
+	at91_udc_shutdown_vbus_timer(udc);
+
 	if (udc->driver) {
 		dev_err(&pdev->dev,
 			"Driver still in use but removing anyhow\n");


