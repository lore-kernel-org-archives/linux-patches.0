Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981C04F405E;
	Tue, 13 Oct 2026 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892083; cv=none; b=tOn3GiOh+DEhsnrLB89NsR2C3DXP4JgUpo41V8VN32wLcSn0nSWsyieNRqLkhRIn4kYvy82ahHUDBl4l04AfkWLmtcpTxB4Iaj9HnwbpQlCLPzgOjVPhoNKJ1FC5FMoOjwUJyncxT7MvFt17Wceq7LDgY31mxhiAcCcS6LNGTrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892083; c=relaxed/simple;
	bh=03LyDcL5FgJsYulT3IAnR7rfUbVNfdwbJaDkLqzMDZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTZZObUGnRPlUkMLvJda7TcPUEg+DhEnnAnZ6vl6Wdt09X46EeeRg0Z3Ctsd3QfeVh1FmGjVzj/Mw/G/WxoGS0hGmKD3OAUmmQXdl1rqrmSJ/f1dguYfxsxFze6qPubkVcb4TJOsKJJfUmQR+vQ9iljt92Wz7YSrW6YIVgqwQ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKZ8dfhb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKZ8dfhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54F01F000FF;
	Tue, 13 Oct 2026 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892081;
	bh=TAFcGfOlrx6K//0Q/NQ3B2NjwIxl9Kz2pTHIt56dUd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKZ8dfhbTGbMBS9U7OHMtiz8ab3ZDp7xmZgSG4tP9SPJHyDVNAlnNuT/GLY55hK/I
	 jqkXpbp1xqTd2sAjMnGlN5kCBAlDTBxMdgOStK6OZc2F1HFiw1+6wDXCgTpkWxIHi7
	 K5QxL9JEq2kFWxbRx3xd2JLvYJptACzaU1lWLCMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 054/281] gpio: mpsse: fix race when arming the IRQ poll worker
Date: Tue, 13 Oct 2026 13:36:10 +0200
Message-ID: <20261013112856.363103000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

commit 7efa1a1953cd6b20b23a3524d5b4b81789c6ef25 upstream.

gpio_mpsse_irq_enable() arms the poll worker before publishing it:
schedule_work() runs before the worker is added to priv->workers. If
gpio_mpsse_disconnect() walks the list in that window it misses the
worker, and once disconnect returns, the USB core frees mpsse_priv
while the orphaned gpio_mpsse_poll() work keeps accessing it, causing
a use-after-free.

Fix this by publishing and arming the worker in one irq_spin
critical section. Teardown walks the same list under irq_spin, so a
worker found on the list is guaranteed to be armed, and
cancel_work_sync() handles it whether it is queued or running.

A worker armed after the disconnect walk would still be missed, so
also set a new priv->dying flag under irq_spin before the teardown
walk, and check it in the same critical section, freeing it via
kfree_rcu() instead when the device is going away, since kfree()
would be called with the IRQ core's raw spinlock held and may sleep
on PREEMPT_RT. schedule_work() is safe to call with irq_spin held,
and the next probe gets a fresh mpsse_priv, so the flag never needs
to be cleared.

This issue was found by an in-house static analysis tool.

Fixes: 179ef1127d7a ("gpio: mpsse: ensure worker is torn down")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260929093646.18419-1-fanwu01@zju.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpsse.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-mpsse.c
+++ b/drivers/gpio/gpio-mpsse.c
@@ -10,6 +10,7 @@
 #include <linux/cleanup.h>
 #include <linux/gpio/driver.h>
 #include <linux/mutex.h>
+#include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/usb.h>
 
@@ -24,6 +25,7 @@ struct mpsse_priv {
 	raw_spinlock_t irq_spin;     /* protects worker list */
 	atomic_t irq_type[16];	     /* pin -> edge detection type */
 	atomic_t irq_enabled;
+	atomic_t dying;		     /* no new workers after disconnect */
 	int id;
 
 	u8 gpio_outputs[2];	     /* Output states for GPIOs [L, H] */
@@ -46,6 +48,7 @@ struct mpsse_worker {
 	atomic_t       cancelled;
 	struct list_head    list;   /* linked list */
 	struct list_head destroy;   /* teardown linked list */
+	struct rcu_head      rcu;   /* deferred free for dying path */
 };
 
 struct bulk_desc {
@@ -525,10 +528,24 @@ static void gpio_mpsse_irq_enable(struct
 		worker->priv = priv;
 		INIT_LIST_HEAD(&worker->list);
 		INIT_WORK(&worker->work, gpio_mpsse_poll);
-		schedule_work(&worker->work);
 
-		scoped_guard(raw_spinlock_irqsave, &priv->irq_spin)
+		scoped_guard(raw_spinlock_irqsave, &priv->irq_spin) {
+			if (atomic_read(&priv->dying)) {
+				/*
+				 * Cannot kfree() here: this callback
+				 * runs with the IRQ descriptor's raw
+				 * spinlock held and kfree() may sleep
+				 * on PREEMPT_RT. The worker is not
+				 * yet published, so the deferred free
+				 * is unobservable.
+				 */
+				kfree_rcu(worker, rcu);
+				return;
+			}
+
 			list_add(&worker->list, &priv->workers);
+			schedule_work(&worker->work);
+		}
 	}
 }
 
@@ -704,6 +721,9 @@ static void gpio_mpsse_disconnect(struct
 {
 	struct mpsse_priv *priv = usb_get_intfdata(intf);
 
+	scoped_guard(raw_spinlock_irqsave, &priv->irq_spin)
+		atomic_set(&priv->dying, 1);
+
 	/*
 	 * Lock prevents double-free of worker from here and the teardown
 	 * step at the beginning of gpio_mpsse_poll


