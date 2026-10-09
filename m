Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991FB2D77F5;
	Fri,  9 Oct 2026 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557593; cv=none; b=MiSQcNeX9wTRvmvzPPm0Ei8s8N1+B/l0fy4PEPOxjxBewC9GIVhMR0Kl9QQU1TnRArOC3hmZUJv1xzRz4wkj/6ux2J/J4bHovuboWYpl8b501JMixWOpAN7LLYhfI/vPDkfwPcD1vHtw7ptYYSxNC0AE9Tr6MCie9qPBTtWdkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557593; c=relaxed/simple;
	bh=sSh9Zo1IddIeUkh3YT1u3UWYGtq2dvTX0PBdaNM9cyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOc1p9bYFXS92JfPwndR0Sew9gO3U3TZn3u5+whb3rn8uSFYc77wL9L7YUH57f0OiboXR8RUGLDjHW5wJexT9yBl9xmvnomxzXgHqrFbP8S+F+ym8gE1F51jhQhZAkDr53WtODU5fqK/N92EnLXrEal0h/ZdZIaqZc8buKG6uyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjJJLcQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjJJLcQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A901F000FF;
	Fri,  9 Oct 2026 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557592;
	bh=fWVxo77hf6IOIbL/I7MQesnYPkAg7Ge97KZBnH0fzjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjJJLcQhxksNl5M/gI5u8//Rb/XCFRDmqBYfg2oeq47aXOTqd0piZKHzyMc3ta5hx
	 6LVyUsAdcb3MFvvDZaQRN5K6BivJY1T4HgFGKzynUthFnFbzFFq4wiOktJF6EO43TC
	 +tBaiXrSZLqywEEY6nYmZClgTnGoL2UgLz6Qt3i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 414/428] iio: trigger: cancel reenable_work before freeing trigger
Date: Fri,  9 Oct 2026 16:12:31 +0200
Message-ID: <20261009140955.324907379@linuxfoundation.org>
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

commit 2a57b9246cecd5dd797a42eb310d6c8816f26d9e upstream.

iio_trigger_notify_done_atomic() defers ->reenable() into
trig->reenable_work on the system workqueue, and the worker dereferences
the owning trigger through container_of().  Nothing cancels this work
before iio_trig_release() frees the trigger, so a worker armed by the
last in-flight IRQ can outlive the free and touch freed memory.

Cancel it at the top of iio_trig_release(), which every free path
reaches through the device core's final put_device().

Found by an in-house static analysis tool.

Fixes: 9020ef659885 ("iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -509,6 +509,8 @@ static void iio_trig_release(struct devi
 	struct iio_trigger *trig = to_iio_trigger(device);
 	int i;
 
+	cancel_work_sync(&trig->reenable_work);
+
 	if (trig->subirq_base) {
 		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
 			irq_modify_status(trig->subirq_base + i,


