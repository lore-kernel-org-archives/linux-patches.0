Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209040;
	b=zR5jxRNEcE/mxEKCRaa8QsPTiS6U+H3yCoOa7hjQT/9VwbVKKAiyXIFcq8WtMKIRUejy
	 mgKQL7JOdibKKiQColqH6mYCNKEjR80VGzhhKLJyW9uluRE8wBw9fv53If1HIkJFtj9HZ
	 TqHxwEomV+u1bPGAiYa66tjFNfnENkvprLjCacQAZy+GJqpyXyAxuROpQ3D3Peu8Hvhko
	 iPC1Xll5bOYs1oZL21WLtY/taeturFa3TX49+J+8V/7DYdzM+MFd9ktiVlog5tV7f7phn
	 9jbjwCjtScQYuFE7788iyML58YuElzuMhpxFTH7PIwgJ2iGPD8ql3UNWaST4pwbbujQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7EqEFHSmRZT0g1C9RdyalhMfHQQbyeHy2IsfJlWhSS4=;
	b=La5/RV+XJELTk1Mx+evv7TkfqwHeCKkxW17qpF2cL95raONDrJlGEZpRPKeZto0mMLpb
	 6fbyhckf6+Hq64ECGKGRm0SxB6MaLPCIONdKe6b6Ke/8oMhTeMJIcJ1GccSEA9Qs43Yn/
	 fCkW9SKMl7o+Av1kAZHuWlzegjSYSyLOR3jiaZ3/+uYtp6L9HCdrbQlfPvOk7cjHwbdOD
	 4A/8wJCnKK7BbNOdowLUkbjYSsbdxlUGRJsZSF2M5Hu/tiY9Jh+3iG5do0siBhWeuv0Cu
	 wHYPUHg/z3nj/Dh3Rlr33ii52HVPZ3lNRiNYZ7qpsn5R/8CrmDPfqwk3iLKxhtmKWlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhPwK6tK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B272F606A321;
	Wed, 28 Oct 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhPwK6tK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103F81F01829;
	Wed, 28 Oct 2026 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209039;
	bh=7EqEFHSmRZT0g1C9RdyalhMfHQQbyeHy2IsfJlWhSS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhPwK6tKrdFo2b3Img3lzEeBNbSjFhFxOW18hKnc9rjV8DPSNRyN4rj1p2njQTGXd
	 ekzsIao4IgnYEdR4Zue1EGui/x2i2qtX2Y2HUFw7GmtQx2+YvMwfIoIOEyqsx/W4S+
	 SpOV0Gc8CLVHxfqsLN6mrdlp3BsxAKxIqRbegz8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.10 288/516] tty: serial: max3100: shut down timer before freeing port
Date: Wed, 28 Oct 2026 17:57:20 +0100
Message-ID: <20261028170010.314918519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit db0949bbd06db0a75b4b1076f1e25194be7d956a ]

max3100_shutdown() stops the polling timer but returns early during
system suspend. If the SPI device is unbound before resume, the serial
core does not call max3100_shutdown() again, so max3100_remove() frees
the port while the timer remains armed. max3100_timeout() may then
access the freed port and re-arm the timer.

Add final timer teardown to max3100_remove() and use
timer_shutdown_sync() to prevent a racing callback from re-arming it.
Also free the IRQ and destroy the workqueue there before freeing the
port. Keep timer_delete_sync() in max3100_shutdown() so that a
subsequent open() can re-arm the timer.

The workqueue is created before request_irq() and destroyed on both
request_irq() failure and normal shutdown. Its presence at remove thus
identifies the IRQ left registered when suspend bypasses shutdown.

Free the IRQ before destroying the workqueue, in both
max3100_shutdown() and max3100_remove(), and cancel the pending work
in between. free_irq() waits for a running interrupt handler to
finish and no new handler can start afterwards, so a racing handler
cannot queue work on a workqueue that is being destroyed; the
force_end_work check in max3100_dowork() only narrows that window, as
a handler delayed between the check and queue_work() could still run
after the teardown has cleared the workqueue pointer. Cancelling the
work also keeps destroy_workqueue() from waiting on a queued work item
in case remove() ever runs while the freezable workqueue is still
frozen, e.g. device removal during the resume window, before
workqueues are thawed.

This issue was found by an in-house static analysis tool.

Fixes: 7831d56b0a35 ("tty: MAX3100")
Cc: stable@kernel.org # 6.2+
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260927055957.561030-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Replaced unavailable timer_shutdown_sync() with timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 17b6f4a872d6a..a1b24c7d5d865 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -571,12 +571,11 @@ static void max3100_shutdown(struct uart_port *port)
 		del_timer_sync(&s->timer);
 
 	if (s->workqueue) {
-		flush_workqueue(s->workqueue);
+		free_irq(s->irq, s);
+		cancel_work_sync(&s->work);
 		destroy_workqueue(s->workqueue);
 		s->workqueue = NULL;
 	}
-	if (s->irq)
-		free_irq(s->irq, s);
 
 	/* set shutdown mode to save power */
 	if (s->max3100_hw_suspend)
@@ -835,6 +834,16 @@ static int max3100_remove(struct spi_device *spi)
 		if (max3100s[i] == s) {
 			dev_dbg(&spi->dev, "%s: removing port %d\n", __func__, i);
 			uart_remove_one_port(&max3100_uart_driver, &max3100s[i]->port);
+
+			s->force_end_work = 1;
+			/* Only the timer callback can rearm it after port removal. */
+			timer_delete_sync(&s->timer);
+			if (s->workqueue) {
+				free_irq(s->irq, s);
+				cancel_work_sync(&s->work);
+				destroy_workqueue(s->workqueue);
+				s->workqueue = NULL;
+			}
 			kfree(max3100s[i]);
 			max3100s[i] = NULL;
 			break;
-- 
2.53.0



