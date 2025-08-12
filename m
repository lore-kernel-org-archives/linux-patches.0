Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1512FE565;
	Tue, 12 Aug 2025 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023406; cv=none; b=i40hnb22u9aQj97IDDEAqRmo2H9y+GJ/3dDBAP8O/WgA5CMc2Y4UnkOOEiEEZ/sEL6KO+iL98IzWLpwLmRaaqlS9LD1EY2Q1n7KIs9pnr/H5Jk0RAEoxrLMw4swxhSo0XAfp/8vYeclRBJBgClYuoy00gRv+IYjMpQVOAEXaWJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023406; c=relaxed/simple;
	bh=RsEQn4O4En6YBdxWlaEYC3Td9QrckSWrcFmVfB1oHSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdZstb7XywK8Ze+C4x8lnKrmlTIFO+3FWWAuEV9uP0oPwaEzMxrfc8ZlEekdi8SDLE0jd2Vs1Ao2+LmwhmFpEgvC5GIQERAV7RUx4BbwTrB7phQIVT5pAj2/kArXgIuQ+2lucXB9UU76YZLfEkn2AAhuZr5dvUZdAs0aoPrBCU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHfXIPdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHfXIPdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF483C4CEF0;
	Tue, 12 Aug 2025 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023406;
	bh=RsEQn4O4En6YBdxWlaEYC3Td9QrckSWrcFmVfB1oHSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHfXIPdA8KvOqQ6sCfQszVlpQ9A7nXcbVpgMTTg4R3104spHcijguU5yODf21pa8q
	 xuAcZj6gXZHUFvGIo80CR0LmBfh9SGWpWzDRvYlBqZfKV4R0slAMmwuAYFJjzwJwrC
	 lx0oZU4mNpgkierhkfBj4QW48r/J2gLAU95CItTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 071/627] mei: vsc: Run event callback from a workqueue
Date: Tue, 12 Aug 2025 19:26:06 +0200
Message-ID: <20250812173422.014924922@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit de88b02c94db7f3c115eb5bfdc1ec444934f277a ]

The event_notify callback in some cases calls vsc_tp_xfer(), which checks
tp->assert_cnt and waits for it through the tp->xfer_wait wait-queue.

And tp->assert_cnt is increased and the tp->xfer_wait queue is woken o
from the interrupt handler.

So the interrupt handler which is running the event callback is waiting for
itself to signal that it can continue.

This happens to work because the event callback runs from the threaded
ISR handler and while that is running the hard ISR handler will still
get called a second / third time for further interrupts and it is the hard
ISR handler which does the atomic_inc() and wake_up() calls.

But having the threaded ISR handler wait for its own interrupt to trigger
again is not how a threaded ISR handler is supposed to be used.

Move the running of the event callback from a threaded interrupt handler
to a workqueue since a threaded ISR should not wait for events from its
own interrupt.

This is a preparation patch for moving the atomic_inc() and wake_up() calls
to the threaded ISR handler, which is necessary to fix a locking issue.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-9-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index d0450c80316c..b654ea59f305 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 
 #include "vsc-tp.h"
 
@@ -76,6 +77,7 @@ struct vsc_tp {
 
 	atomic_t assert_cnt;
 	wait_queue_head_t xfer_wait;
+	struct work_struct event_work;
 
 	vsc_tp_event_cb_t event_notify;
 	void *event_notify_context;
@@ -105,19 +107,19 @@ static irqreturn_t vsc_tp_isr(int irq, void *data)
 
 	wake_up(&tp->xfer_wait);
 
-	return IRQ_WAKE_THREAD;
+	schedule_work(&tp->event_work);
+
+	return IRQ_HANDLED;
 }
 
-static irqreturn_t vsc_tp_thread_isr(int irq, void *data)
+static void vsc_tp_event_work(struct work_struct *work)
 {
-	struct vsc_tp *tp = data;
+	struct vsc_tp *tp = container_of(work, struct vsc_tp, event_work);
 
 	guard(mutex)(&tp->event_notify_mutex);
 
 	if (tp->event_notify)
 		tp->event_notify(tp->event_notify_context);
-
-	return IRQ_HANDLED;
 }
 
 /* wakeup firmware and wait for response */
@@ -495,7 +497,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 	tp->spi = spi;
 
 	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
-	ret = request_threaded_irq(spi->irq, vsc_tp_isr, vsc_tp_thread_isr,
+	ret = request_threaded_irq(spi->irq, vsc_tp_isr, NULL,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   dev_name(dev), tp);
 	if (ret)
@@ -503,6 +505,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 
 	mutex_init(&tp->mutex);
 	mutex_init(&tp->event_notify_mutex);
+	INIT_WORK(&tp->event_work, vsc_tp_event_work);
 
 	/* only one child acpi device */
 	ret = acpi_dev_for_each_child(ACPI_COMPANION(dev),
@@ -527,6 +530,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 err_destroy_lock:
 	free_irq(spi->irq, tp);
 
+	cancel_work_sync(&tp->event_work);
 	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 
@@ -541,6 +545,7 @@ static void vsc_tp_remove(struct spi_device *spi)
 
 	free_irq(spi->irq, tp);
 
+	cancel_work_sync(&tp->event_work);
 	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 }
-- 
2.39.5



