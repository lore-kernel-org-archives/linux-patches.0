Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981EF459AD2;
	Fri,  9 Oct 2026 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556985; cv=none; b=DTa3UTS8fTOYWedGOe1qHfncmbQWAcW/KXg8j+17yBjHoUDo0K7UOendQHd42LTDxMqDGwOa9s0PtUU8b0X8mBkI6qKiU7bxigCqVmuecxb8aBukHLiA6x8yskPDWoSKdRz6iBpjSWGIn4ynQg2nM1bZAUlFf/qTsNzzfm6/vFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556985; c=relaxed/simple;
	bh=K9EX3rnweD/dNRINPfN93tLQhhiqUAqINsZhDWpye5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx58Tm2Z5vkH4gQYN2bcls0GDxTkHrmKVEycFrYm7Uzw8ETLy2b5aB4tXJzxjRcKcYBVXYDGjx1Jz9yMkKkGlW77rNRh81DlFAjrA7YM5RV7xouMmweV/AZrp8UJJInF6H5QwxkpOsUu1Vy9Ih8XrDgqvmSNQHJhewo0zI8D0aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCzNAECz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCzNAECz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3991F000FF;
	Fri,  9 Oct 2026 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556983;
	bh=vH2jnLL7ZWLGuA5jgAY4Ano8R51Bt7MeG3sGCHG3ECA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCzNAECzqMKgBVAwSe0u2XaK6VEfYpd2Zg4sZYiwP6HAZ1pGq9A8IXm9Q1HxBCDqz
	 Fq06ikXV/VbFwzy+sgF6SG+LrSx0A6aXcpmSdldd0hWZM4pDlzaiEJ1WQk4Vu+QOLt
	 revf4TUD+PhEwbhSmNZHz64Tgcv8b9wgeZKZTBpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 328/403] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Fri,  9 Oct 2026 16:11:29 +0200
Message-ID: <20261009140959.903879448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

commit 63213927b141085b6c8719b8037dab3074b7e0fe upstream.

The threaded IRQ handler queues data->work through irq_work_queue() so
the trigger is polled from a per-CPU context.  free_irq() does not flush
an irq_work the handler already queued, so after gp2ap020a00f_remove()
returns that work may still run and call iio_trigger_poll() on data->trig,
which the devm cleanup has already freed, causing a use-after-free.

Add irq_work_sync(&data->work) after free_irq() in remove() and in the
probe error path, mirroring commit 78601726d4a5 ("iio: trigger: sysfs:
fix use-after-free on remove").

Found by an in-house static analysis tool, confirmed by manual review.

Fixes: bf29fbeaa13d ("iio: gp2ap020a00f: Add a driver for the device")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap020a00f.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/light/gp2ap020a00f.c
+++ b/drivers/iio/light/gp2ap020a00f.c
@@ -1560,6 +1560,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1582,6 +1583,7 @@ static void gp2ap020a00f_remove(struct i
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 }


