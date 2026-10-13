Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068594F4D07;
	Tue, 13 Oct 2026 12:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892935; cv=none; b=edAzDKoZ0THW1CXkcqPY6IOeRNVEgu8yr4mUh1uiX4x113U+P/k+S7oU60Mju4qvljCaIcB7YTCQkkVXOqqQLnXFBX/nEbbLvJopIpmJsOlCIpgTTeZQdWn+4btj7ZuXFDks+RlK50B1BqUOIXJWTl/iVGTr/f5b/mAZLz5sKMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892935; c=relaxed/simple;
	bh=29THFbD5sFI3XbbrdKakL5zS2LIqn3Cx6yU8Q7T94Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpoHnUmTD3mv58kfpbpxsz4bSzpD/eNs+C4VIWuYHOQLgaIzy/dZJIk0iRrllqR44TV8nEb0fs486Q57ZGUsFrd6rNFGuAYeaq7se7dNNhxhPV90Mn2CgSVSkUQhwIMJlaDOjMZeTxTFmFQLhEDn+Nrel7539+vPjcTq18TTHeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+KxCh9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+KxCh9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1331F000FF;
	Tue, 13 Oct 2026 12:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892933;
	bh=Kp092xL8Y+HaUs5EjK7cUvxg0N/0K36H4176H6MWXH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+KxCh9KkvVxStvbWHrF6n6Bq3Y9W9eQZ6n0SqyDfxyoj9/CAAVoXyl5dc33kn14Q
	 jieEeVoywc5pLjUMWzSEW8YK0KrPwFSxiyYBuVb8sJDXEWs4AGqJOLmgMFIhBFeHUF
	 APOGN2WmiLlGHY/3SKT3R71QNgV0w5Wdm1prJpEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 055/621] gpio: mpsse: fix race when arming the IRQ poll worker
Date: Tue, 13 Oct 2026 13:30:50 +0200
Message-ID: <20261013112922.169913392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
@@ -515,10 +518,24 @@ static void gpio_mpsse_irq_enable(struct
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
 
@@ -705,6 +722,9 @@ static void gpio_mpsse_disconnect(struct
 {
 	struct mpsse_priv *priv = usb_get_intfdata(intf);
 
+	scoped_guard(raw_spinlock_irqsave, &priv->irq_spin)
+		atomic_set(&priv->dying, 1);
+
 	/*
 	 * Lock prevents double-free of worker from here and the teardown
 	 * step at the beginning of gpio_mpsse_poll


