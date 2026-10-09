Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B583BB112;
	Fri,  9 Oct 2026 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556822; cv=none; b=gWWn6NuK/rr079QMLtJ+fRN7bk/c/NraTBZxLwmsRfe8xhoEi5ZisCjbS8p073v2/Bsxo6KwoYe5C9CDBNVYz0IbXN9Ku6Z6xQQJcQ+1gulW+gEuh5LDYwNCD6s+0Ac+NJda2jd+aFVXZO+2riJmfhw8J16M0rr1KjjH1ex8iWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556822; c=relaxed/simple;
	bh=PAnN0b6rvfG3/OSIOLtKMcLNdNlhY1i9uo2GSktTr0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnve3wInskzICqmxkIRbHhhpaSY8zwDemK4XUL61NM7xQwAq4SJBpZA9ObBFLOT22nl0LBYSu/KP0LwKvv6NGOhUjNFhoubUZhRIs5fnBfbChTInypOr9Ro+yn/H4Jh9/hoYmV35IxrkCaMV+tE6TRSTy9PLV7fqrf06Vf6wM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnqSd9e0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnqSd9e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D211F000FF;
	Fri,  9 Oct 2026 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556820;
	bh=9dKeK0uZLDrD2R0frExn9Y1thmgk+5NSEeTzCSx1j9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnqSd9e0XJMwZeXteHFZZQflqPYA9tSpGly0INL/5VsW7nF6Az7WyDiOe2RaZAsr3
	 VzMi7KNZg4No47pedsrLVlshDWbyf8g7C+Hry6my4HW6VemF+mjhi1+cgUG0E0nimy
	 NEXE691Ew8a8TrxGFkMGPW37FUK1kLAJmHoqYSlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	stable@kernel.org
Subject: [PATCH 7.2 247/428] tty: serial: max3100: shut down timer before freeing port
Date: Fri,  9 Oct 2026 16:09:44 +0200
Message-ID: <20261009140951.532975003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit db0949bbd06db0a75b4b1076f1e25194be7d956a upstream.

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
---
 drivers/tty/serial/max3100.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -535,11 +535,11 @@ static void max3100_shutdown(struct uart
 	timer_delete_sync(&s->timer);
 
 	if (s->workqueue) {
+		free_irq(port->irq, s);
+		cancel_work_sync(&s->work);
 		destroy_workqueue(s->workqueue);
 		s->workqueue = NULL;
 	}
-	if (port->irq)
-		free_irq(port->irq, s);
 
 	/* set shutdown mode to save power */
 	max3100_sr(s, MAX3100_WC | MAX3100_SHDN, &rx);
@@ -752,6 +752,15 @@ static void max3100_remove(struct spi_de
 		if (max3100s[i] == s) {
 			dev_dbg(&spi->dev, "%s: removing port %d\n", __func__, i);
 			uart_remove_one_port(&max3100_uart_driver, &max3100s[i]->port);
+
+			s->force_end_work = 1;
+			timer_shutdown_sync(&s->timer);
+			if (s->workqueue) {
+				free_irq(s->port.irq, s);
+				cancel_work_sync(&s->work);
+				destroy_workqueue(s->workqueue);
+				s->workqueue = NULL;
+			}
 			kfree(max3100s[i]);
 			max3100s[i] = NULL;
 			break;


