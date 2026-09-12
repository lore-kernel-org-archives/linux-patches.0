Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9D037F313;
	Sat, 12 Sep 2026 11:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213709; cv=none; b=GW2lM7EySRof2/mbvnuuvVbfNNzcndIhvKfyAGMbfml84nwQH03A7AtrUtkjnorhD9oId6aICG66OuDjZiVfv34p5VTF/6BmxGbMcaqrH73GQMmwRBok6RTnPeNKxLDl13O6T8UpDH4rmO4cx7D7nRToiXjibYMjtGr79bZc+GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213709; c=relaxed/simple;
	bh=od/ekrQVn7n2Hrjk1SRaiEL7eKF2MfFqM4UoUilR2vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XabqAR9uoRcGuMb51XRWqpeaM1w5LHZIosZkxiPGsaezs3WJxNfrdyTW5TnnPlC77pPilqG6kicW4TFYRTcRzKyr7KQpbM8Bk+6gR5Y9i9H1FLZ+w5lCw89+5702L0rILudkHHScMr7yn56Sd4tViooc9X+gk5BdKMBp7q+x59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRoYL4r7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRoYL4r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953EA1F000FF;
	Sat, 12 Sep 2026 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213707;
	bh=zatxXBXJkYiyZtMSwysiJa+RnHJmDjTEOKGjwqzawtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRoYL4r7/lFxEDgb4jUhT+m+N/aQwR2/Llnbb7xEt2HahuiA0BLsgnJYQqJKVzzjo
	 B/FvSIkjcl2VsXjzIfGbJYNyYhvDJLcdf+HOyPcpdMGrn3TMUPROglUkc515txmyWp
	 jdpTpXv3IFf9k2iL+2mbvwxzMl2V7R4krCZ9Bym4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0140/1376] iio: chemical: atlas-sensor: use iio_trigger_poll_nested() to fix remove UAF
Date: Sat, 12 Sep 2026 08:42:46 +0200
Message-ID: <20260912065610.673488617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,7 +88,6 @@ struct atlas_data {
 	struct iio_trigger *trig;
 	const struct atlas_device *chip;
 	struct regmap *regmap;
-	struct irq_work work;
 	unsigned int interrupt_enabled;
 	/* 96-bit data + 32-bit pad + 64-bit timestamp */
 	__be32 buffer[6] __aligned(8);
@@ -443,13 +441,6 @@ static const struct iio_buffer_setup_ops
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
@@ -475,7 +466,7 @@ static irqreturn_t atlas_interrupt_handl
 	struct iio_dev *indio_dev = private;
 	struct atlas_data *data = iio_priv(indio_dev);
 
-	irq_work_queue(&data->work);
+	iio_trigger_poll_nested(data->trig);
 
 	return IRQ_HANDLED;
 }
@@ -673,8 +664,6 @@ static int atlas_probe(struct i2c_client
 		goto unregister_trigger;
 	}
 
-	init_irq_work(&data->work, atlas_work_handler);
-
 	if (client->irq > 0) {
 		/* interrupt pin toggles on new conversion */
 		ret = devm_request_threaded_irq(&client->dev, client->irq,


