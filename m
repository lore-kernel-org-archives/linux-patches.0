Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211263;
	b=myyDRJUGN3X1kfhW23FVKAT1UEoAP+w6MMMyptNGdNc4UAaMVzZLUVV2PCXKWXe+f6oU
	 bk5OTW177WyOICxwPg25JR/upEYqiQdz+nF6+LiCzJyeRNnb0DMSp4uCbZoEGLPVLw3bh
	 6caQc7gH8NGihlBVrVPbkKos40wTdB4Hl9YitCsO0iuf6f3X88fJLni2to+jKEd56kTq2
	 WtdcfUTCPv3htR8yGsDmH7wvpwoKxWcxrjHfGzdkX6ETDIDBTBoFQIc0usn96pIVn8aqo
	 RgBUBEEBZ7r4LQ9+p0s7v7ruYUHQnCZzo4v3pCO+p9bYGWMrj3YqyrL4pVbFIh4JqBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7kvSfuWu77mqRiwoR3UbXd+KsllEAOQdis6LY08147s=;
	b=yQE/axLfuVuCRO9D9/qBJP7ZJrCr06GUuBiB1XuJWLPkII8DuS2SIfT38qL5mildNV6k
	 LAaCXnU6p9R2QuwhweG3YF3vu56o/2OHHg26E95Rs0EvMIh71IB0lF3oyfHkpg1hV20G5
	 SkwdewOHFiv7G8jOZRh6DEYmHUE6xFweVcjdwMAxlHeJDsxrsHdufZXX3Hkljq2cXQm7C
	 qApjDVPDKN7krDGBW5J4vHkGWFsoRgWfgQNQCmDX12zGYvKhzvwEjc8l4soai8vUUTmVN
	 7bYsXjY3z/HE8PFpD53sQbEuMDzmD4y65z0XIBadOTijAr03lynMdl5RpmrevOj7lUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1L50US+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B9606BF5F;
	Wed, 28 Oct 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1L50US+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784B91F031E0;
	Wed, 28 Oct 2026 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211263;
	bh=7kvSfuWu77mqRiwoR3UbXd+KsllEAOQdis6LY08147s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1L50US+bRiwNgkc2cdqd4o4jEcdBi2sfJM2t0y5up6YLbQgnbIRCnuZzFfeB8Oc1
	 p4SyhsTI4NLYWNOAoVGvAN49c7V5ZdA0HEBE7da4gFrrUusu/e5fzJY/WMrbg5KvPz
	 EteHErzd/fIkPoyk8MlM2GB9jNNfSNDzAj/oz4pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 314/571] tty: serial: max3100: shut down timer before freeing port
Date: Wed, 28 Oct 2026 17:57:41 +0100
Message-ID: <20261028170015.450631874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted IRQ teardown to use s->irq instead of the port’s irq field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 8290ab72c05a3..c31cce1c0182a 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -568,12 +568,11 @@ static void max3100_shutdown(struct uart_port *port)
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
@@ -832,6 +831,15 @@ static int max3100_remove(struct spi_device *spi)
 		if (max3100s[i] == s) {
 			dev_dbg(&spi->dev, "%s: removing port %d\n", __func__, i);
 			uart_remove_one_port(&max3100_uart_driver, &max3100s[i]->port);
+
+			s->force_end_work = 1;
+			timer_shutdown_sync(&s->timer);
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



