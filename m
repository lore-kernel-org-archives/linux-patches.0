Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E7520B3E;
	Tue, 23 Apr 2024 21:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908528; cv=none; b=tGiUSGYKJFAleUAQLuax3/O4Xs4dsx1nrog7EpWSFvWkqVSQo7o1SpBvT0Am++hUvR6xFN37ZZFTHYkUGXxVAynobYDJDe9g/VBmtQwIEiE5lgIhOFCPLojofY9AK9oN0xYFcr+d3EwnjEtuS1WXPhUZ5twnvJPhuUixnqs/qd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908528; c=relaxed/simple;
	bh=GCNOPttGHyjkNtSa4vuMW2YBAPGF/2jyBZkRJ52E57Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpZr+7gmwFJvy5NAZoOj5h4cSC8ZDJsiegIRQVjVrr3QNIfN9Yb8c6LZFvwx6e6R3cerJoeTDumBNYeYl2GH7RbdXnZkuegk8goDXF184JWxvbDVRIzAhX9EbFECy+U9tvErGz1XF1JSmI6ojCcG+VTGqBgz6DZzpX9HcSB4iWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHreVTcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHreVTcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E0EC3277B;
	Tue, 23 Apr 2024 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908528;
	bh=GCNOPttGHyjkNtSa4vuMW2YBAPGF/2jyBZkRJ52E57Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHreVTcCQX0pTFk7GtDsJdP7eRy5Y80p0fthz612QFQ1hNL9k2ZAIOioCHknAxuWv
	 VE+KIixVUaIti/xMJDCNu9FYmzHbcTjBH4zz33WTnhORUPjUO0QdCgK8ghnFV1m38n
	 yoh2jngi896w2x7PhQEQnLcxFLE7zxCCTxeDFw5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Wentong Wu <wentong.wu@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.8 121/158] mei: vsc: Unregister interrupt handler for system suspend
Date: Tue, 23 Apr 2024 14:39:03 -0700
Message-ID: <20240423213859.848874352@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit f6085a96c97387154be7eaebd1a5420eb3cd55dc upstream.

Unregister the MEI VSC interrupt handler before system suspend and
re-register it at system resume time. This mirrors implementation of other
MEI devices.

This patch fixes the bug that causes continuous stream of MEI VSC errors
after system resume.

Fixes: 386a766c4169 ("mei: Add MEI hardware support for IVSC device")
Cc: stable@vger.kernel.org # for 6.8
Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Wentong Wu <wentong.wu@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240403051341.3534650-2-wentong.wu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/platform-vsc.c |   17 +++++++-
 drivers/misc/mei/vsc-tp.c       |   84 ++++++++++++++++++++++++++++------------
 drivers/misc/mei/vsc-tp.h       |    3 +
 3 files changed, 78 insertions(+), 26 deletions(-)

--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -402,25 +402,40 @@ static int mei_vsc_remove(struct platfor
 static int mei_vsc_suspend(struct device *dev)
 {
 	struct mei_device *mei_dev = dev_get_drvdata(dev);
+	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
 
 	mei_stop(mei_dev);
 
+	mei_disable_interrupts(mei_dev);
+
+	vsc_tp_free_irq(hw->tp);
+
 	return 0;
 }
 
 static int mei_vsc_resume(struct device *dev)
 {
 	struct mei_device *mei_dev = dev_get_drvdata(dev);
+	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
 	int ret;
 
-	ret = mei_restart(mei_dev);
+	ret = vsc_tp_request_irq(hw->tp);
 	if (ret)
 		return ret;
 
+	ret = mei_restart(mei_dev);
+	if (ret)
+		goto err_free;
+
 	/* start timer if stopped in suspend */
 	schedule_delayed_work(&mei_dev->timer_work, HZ);
 
 	return 0;
+
+err_free:
+	vsc_tp_free_irq(hw->tp);
+
+	return ret;
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(mei_vsc_pm_ops, mei_vsc_suspend, mei_vsc_resume);
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -94,6 +94,27 @@ static const struct acpi_gpio_mapping vs
 	{}
 };
 
+static irqreturn_t vsc_tp_isr(int irq, void *data)
+{
+	struct vsc_tp *tp = data;
+
+	atomic_inc(&tp->assert_cnt);
+
+	wake_up(&tp->xfer_wait);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t vsc_tp_thread_isr(int irq, void *data)
+{
+	struct vsc_tp *tp = data;
+
+	if (tp->event_notify)
+		tp->event_notify(tp->event_notify_context);
+
+	return IRQ_HANDLED;
+}
+
 /* wakeup firmware and wait for response */
 static int vsc_tp_wakeup_request(struct vsc_tp *tp)
 {
@@ -384,6 +405,37 @@ int vsc_tp_register_event_cb(struct vsc_
 EXPORT_SYMBOL_NS_GPL(vsc_tp_register_event_cb, VSC_TP);
 
 /**
+ * vsc_tp_request_irq - request irq for vsc_tp device
+ * @tp: vsc_tp device handle
+ */
+int vsc_tp_request_irq(struct vsc_tp *tp)
+{
+	struct spi_device *spi = tp->spi;
+	struct device *dev = &spi->dev;
+	int ret;
+
+	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
+	ret = request_threaded_irq(spi->irq, vsc_tp_isr, vsc_tp_thread_isr,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   dev_name(dev), tp);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(vsc_tp_request_irq, VSC_TP);
+
+/**
+ * vsc_tp_free_irq - free irq for vsc_tp device
+ * @tp: vsc_tp device handle
+ */
+void vsc_tp_free_irq(struct vsc_tp *tp)
+{
+	free_irq(tp->spi->irq, tp);
+}
+EXPORT_SYMBOL_NS_GPL(vsc_tp_free_irq, VSC_TP);
+
+/**
  * vsc_tp_intr_synchronize - synchronize vsc_tp interrupt
  * @tp: vsc_tp device handle
  */
@@ -413,27 +465,6 @@ void vsc_tp_intr_disable(struct vsc_tp *
 }
 EXPORT_SYMBOL_NS_GPL(vsc_tp_intr_disable, VSC_TP);
 
-static irqreturn_t vsc_tp_isr(int irq, void *data)
-{
-	struct vsc_tp *tp = data;
-
-	atomic_inc(&tp->assert_cnt);
-
-	wake_up(&tp->xfer_wait);
-
-	return IRQ_WAKE_THREAD;
-}
-
-static irqreturn_t vsc_tp_thread_isr(int irq, void *data)
-{
-	struct vsc_tp *tp = data;
-
-	if (tp->event_notify)
-		tp->event_notify(tp->event_notify_context);
-
-	return IRQ_HANDLED;
-}
-
 static int vsc_tp_match_any(struct acpi_device *adev, void *data)
 {
 	struct acpi_device **__adev = data;
@@ -485,10 +516,9 @@ static int vsc_tp_probe(struct spi_devic
 	tp->spi = spi;
 
 	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
-	ret = devm_request_threaded_irq(dev, spi->irq, vsc_tp_isr,
-					vsc_tp_thread_isr,
-					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					dev_name(dev), tp);
+	ret = request_threaded_irq(spi->irq, vsc_tp_isr, vsc_tp_thread_isr,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   dev_name(dev), tp);
 	if (ret)
 		return ret;
 
@@ -522,6 +552,8 @@ static int vsc_tp_probe(struct spi_devic
 err_destroy_lock:
 	mutex_destroy(&tp->mutex);
 
+	free_irq(spi->irq, tp);
+
 	return ret;
 }
 
@@ -532,6 +564,8 @@ static void vsc_tp_remove(struct spi_dev
 	platform_device_unregister(tp->pdev);
 
 	mutex_destroy(&tp->mutex);
+
+	free_irq(spi->irq, tp);
 }
 
 static const struct acpi_device_id vsc_tp_acpi_ids[] = {
--- a/drivers/misc/mei/vsc-tp.h
+++ b/drivers/misc/mei/vsc-tp.h
@@ -37,6 +37,9 @@ int vsc_tp_xfer(struct vsc_tp *tp, u8 cm
 int vsc_tp_register_event_cb(struct vsc_tp *tp, vsc_tp_event_cb_t event_cb,
 			     void *context);
 
+int vsc_tp_request_irq(struct vsc_tp *tp);
+void vsc_tp_free_irq(struct vsc_tp *tp);
+
 void vsc_tp_intr_enable(struct vsc_tp *tp);
 void vsc_tp_intr_disable(struct vsc_tp *tp);
 void vsc_tp_intr_synchronize(struct vsc_tp *tp);


