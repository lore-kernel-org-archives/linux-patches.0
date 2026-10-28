Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213036;
	b=1EqnKjilJ7YJFfZecyFZG39hICsiAGZCHTLFK0cFLDxfRYLJHioGG8m+wtS+HROF339k
	 gM+Mp9fc36LtaOcoMOA5nSCEkGudWJKi7YfW8AxVABk7bL+ZCnUpiqeNNojOrM/3HQXOv
	 3MjLk46e1CyCsAopqI4Jc0qxjuZ6DGO5GBkYN92oeIFZgzPZSrJOXben8l/lUUPBK0JlV
	 2rOn1jhzWq7sNP6Qe9DJHuEu+jUGUZoBoG4i42/0qlL7tXT7GMBQibnR1k+ynCJSe1Sms
	 AI8KbNjqpRytZbUS6Rr8aQIPM8TcZfWPx4vDRd02juaAZFS1TpedKoDYOlu8ZtzZ15A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FDLltPf0SrGLXPdndeMyQPWJ1KlapknIZc7s5Jm9xfs=;
	b=etfGxcvH/k9GSo6UtY7uzL5apcI+7y1L29K1JiHwsKUI66bSrHT1owRjFspgDE2Mk9/z
	 YmuOYjhENboggVIU8UwD6aOh+5ygECqc9pZs49DO3GQMIaO3cbkQvzzRsU/063xZMpgR2
	 enFp7rZmxTH+OiYOr7eEMhCS+uFtH5ZQkT7Vy8YGi25Yi+7fvkar8Dip15sflYRP8O3UF
	 9KElYsb3LEpB/TkYOnoU7vQ0cjnOsu0hJa3OSce3Kamq+QbCkYBcueTS2aewEyVXO7JFZ
	 SQS2usdSV6xoZVh2DyIFK/L1DbBmkk51Blv1Tp3JD86HX50K3qtFay+qVxPhg57uJ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnaBmFhp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9E7606A31C;
	Wed, 28 Oct 2026 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnaBmFhp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383FC1F01825;
	Wed, 28 Oct 2026 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213035;
	bh=FDLltPf0SrGLXPdndeMyQPWJ1KlapknIZc7s5Jm9xfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnaBmFhpqBqmPc9eYxbPZM+YAQd/rvfkFMQtQN1V5lrjUWBUszoTr62dOR7dGffgO
	 7feGFN3d8ps4AOYIjv5pfHVyRnDtgjB/zpZ4/4PUkncYTCdVDCY87Xj3Ga0ixSGFWO
	 RMp2Pha1mGYiqkLUNfdTlvRjZ1hQaPeF93X5W/9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0364/1887] usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed
Date: Wed, 28 Oct 2026 17:41:00 +0100
Message-ID: <20261028170507.516403558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit c27d13ce4bab80fbdf6523928071b6c24b37606c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/at91_udc.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1796,6 +1796,19 @@ static void at91udc_of_init(struct at91_
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
@@ -1909,7 +1922,7 @@ static int at91udc_probe(struct platform
 	}
 	retval = usb_add_gadget_udc(dev, &udc->gadget);
 	if (retval)
-		goto err_unprepare_iclk;
+		goto err_shutdown_vbus;
 	dev_set_drvdata(dev, udc);
 	device_init_wakeup(dev, 1);
 	create_debug_file(udc);
@@ -1917,6 +1930,8 @@ static int at91udc_probe(struct platform
 	INFO("%s version %s\n", driver_name, DRIVER_VERSION);
 	return 0;
 
+err_shutdown_vbus:
+	at91_udc_shutdown_vbus_timer(udc);
 err_unprepare_iclk:
 	clk_unprepare(udc->iclk);
 err_unprepare_fclk:
@@ -1935,6 +1950,9 @@ static void at91udc_remove(struct platfo
 	DBG("remove\n");
 
 	usb_del_gadget_udc(&udc->gadget);
+
+	at91_udc_shutdown_vbus_timer(udc);
+
 	if (udc->driver) {
 		dev_err(&pdev->dev,
 			"Driver still in use but removing anyhow\n");


