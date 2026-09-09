Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D022353D0B8;
	Wed,  9 Sep 2026 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963827; cv=none; b=hh/vnNWtE1apWLETuQ08ihUGpHudzE8GkEHBPQ7OaUsCHxp6se9S+duYpsaky3/sYaieliEmEQ0X+OgXIOH2dHdh3/WROZHND/NoX1aJt7uGbu9NGFoF3Ix43UzLQssFCZCqwX9y7+uacBCs0M8aUH+ZzKQ0JgJA/1U6cKVuXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963827; c=relaxed/simple;
	bh=b9hUUa3ICF5Afxbp7MV/lNIwi9M3SAlxzqE9I+H6TaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKM3RA8zvU5CCeGGH91FgdQkAqYqP/p/euJe0t5dj+kIbsJRAScTasgdmbJBwynL2t9aOFu/KZ2lrKu+cevx4UsgMysf8eIxMgcSDX1+Tgh1+XackqAx2FrRVm+Osi7I4VsPLDEafZNCLClMI+ZGkjvc2sLq7T1M2mtQ4E8KRn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXMfEaBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXMfEaBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B051F00A3A;
	Wed,  9 Sep 2026 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963825;
	bh=XzJxQ9QNli5t1NzrlCx4G5IXHIPKvtQFIMQ4oxJCoKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXMfEaBuDMhlYYbB7QwBaNQVm2bo+pe6tquwhIpiTQ/1wE0vKI4EFkOn5BJmS4oT9
	 Tory7il3XLlE4xj4erxyKOjVDWOjt7ykDKdIUyBrRUhmkqNqHoVmElF8m7acYUdKKk
	 5yEIeiFk7Wy2RBImwGLgjW4NQ8cFu8dI5XFDBiXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 210/583] iio: chemical: atlas-sensor: use iio_trigger_poll_nested() to fix remove UAF
Date: Wed,  9 Sep 2026 15:38:15 +0200
Message-ID: <20260909134245.417298080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

commit be61c8c6252671ecf1fee0ad90f87669e0be1e20 upstream.

The atlas driver requests its hardware data-ready IRQ with
devm_request_threaded_irq(); its threaded handler queues an irq_work,
atlas_work_handler(), that calls iio_trigger_poll(data->trig).

The IRQ is devm-managed, so free_irq() runs from the devres unwind after
atlas_remove() returns without flushing that irq_work.  Once a buffer is
enabled, conversion-complete IRQs keep firing and queueing it; a pending
irq_work can therefore run after the unwind has freed atlas_data/indio_dev
and the trigger, when atlas_work_handler() derives the atlas_data pointer
via container_of() and dereferences data->trig, a use-after-free.

Call iio_trigger_poll_nested() directly from the threaded handler instead
of bouncing through irq_work.  free_irq() then drains the threaded handler,
closing the window; other iio drivers with a threaded data-ready IRQ do the
same (e.g. bmi270).

This issue was found by an in-house static analysis tool.

Fixes: 7103b99b031c ("iio: chemical: atlas-ph-sensor: reorg driver to allow multiple chips")
Cc: stable@vger.kernel.org # v6.4+
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-sensor.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/iio/chemical/atlas-sensor.c
+++ b/drivers/iio/chemical/atlas-sensor.c
@@ -13,7 +13,6 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/irq.h>
-#include <linux/irq_work.h>
 #include <linux/i2c.h>
 #include <linux/mod_devicetable.h>
 #include <linux/regmap.h>
@@ -88,7 +87,6 @@ struct atlas_data {
 	struct iio_trigger *trig;
 	const struct atlas_device *chip;
 	struct regmap *regmap;
-	struct irq_work work;
 	unsigned int interrupt_enabled;
 	/* 96-bit data + 32-bit pad + 64-bit timestamp */
 	__be32 buffer[6] __aligned(8);
@@ -441,13 +439,6 @@ static const struct iio_buffer_setup_ops
 	.predisable = atlas_buffer_predisable,
 };
 
-static void atlas_work_handler(struct irq_work *work)
-{
-	struct atlas_data *data = container_of(work, struct atlas_data, work);
-
-	iio_trigger_poll(data->trig);
-}
-
 static irqreturn_t atlas_trigger_handler(int irq, void *private)
 {
 	struct iio_poll_func *pf = private;
@@ -474,7 +465,7 @@ static irqreturn_t atlas_interrupt_handl
 	struct iio_dev *indio_dev = private;
 	struct atlas_data *data = iio_priv(indio_dev);
 
-	irq_work_queue(&data->work);
+	iio_trigger_poll_nested(data->trig);
 
 	return IRQ_HANDLED;
 }
@@ -670,8 +661,6 @@ static int atlas_probe(struct i2c_client
 		goto unregister_trigger;
 	}
 
-	init_irq_work(&data->work, atlas_work_handler);
-
 	if (client->irq > 0) {
 		/* interrupt pin toggles on new conversion */
 		ret = devm_request_threaded_irq(&client->dev, client->irq,


