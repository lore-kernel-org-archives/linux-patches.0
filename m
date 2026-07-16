Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF84429810;
	Thu, 16 Jul 2026 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210491; cv=none; b=dfUz3X3QqulgIuvj3IDZ2rzagusND56U9BcKVk/hLLPzdDB5fK9vR/Gp9kis+NHL3xi1RllmrvtWxWG2jq8xXzN8Wg6mD/6fA21zZnyGkRf1ihefWM7RxB6bNWgkH3vWaxp0dEPMTym1naIyOWMIdP2a5D0U0wJ9jJVF8b5ZQUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210491; c=relaxed/simple;
	bh=gTFkNqotiEG05TLnYSuEYxqxFGVxP74YWcUvCCXayxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTTCXrybnV1LoZ0bEuhDy8foAoD3On0oVFIB71dK4ow2YNvFyDbrgyfbtwrIzDkbP7B0C/YLiqG+PDaS7SmwxCbtd4EZIGJ5oWfxy9GxIMVP1A4ssAtuc0JP1BMr9J6kQ8tPTzoRP59b/AfD1gox4KXieJx9rgmb5F/V1vuZJmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWc+ZfOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWc+ZfOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615261F000E9;
	Thu, 16 Jul 2026 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210489;
	bh=G+rKzHz9UdqSt2lTmZhCp+7d+0ignWk3I2uzyLO3kas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWc+ZfOWTT3FunGltPO5dZJzlwjCjIlZUUpbml/ugTvaZWVCNHPSaxeHI+4W7F49/
	 ZRvMl/rB/hI7mr44Cco/kPKNNaAeVNMwh+uq4ryMhIn2TB856m9sKOKgKcju4DUsUz
	 NQY8cJlqz00B4pf8lTtuedOd+hmOQKYUQKLZ/mnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 067/480] iio: imu: adis: add IRQF_NO_THREAD to non-FIFO trigger IRQ
Date: Thu, 16 Jul 2026 15:26:54 +0200
Message-ID: <20260716133046.158922683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 6e1b9bff1202da55c464e36bd34a2b6863d7fe30 upstream.

devm_adis_probe_trigger() registers iio_trigger_generic_data_rdy_poll()
through devm_request_irq() on the non-FIFO path, but it does not add
IRQF_NO_THREAD to the IRQ flags.

When the kernel is booted with forced IRQ threading, the parent IRQ can
otherwise be threaded by the IRQ core and the subsequent IIO trigger
child IRQ is then dispatched from irq/... thread context instead of
hardirq context. Because iio_trigger_generic_data_rdy_poll()
immediately drives iio_trigger_poll(), this violates the hardirq-only
IIO trigger helper contract and can push downstream trigger consumers
through the wrong execution context.

Add IRQF_NO_THREAD on top of the existing adis->irq_flag value for the
non-FIFO request_irq() path, while preserving the current trigger
polarity and IRQF_NO_AUTOEN behavior.

Fixes: fec86c6b8369 ("iio: imu: adis: Add Managed device functions")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis_trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -94,7 +94,7 @@ int devm_adis_probe_trigger(struct adis
 	else
 		ret = devm_request_irq(&adis->spi->dev, adis->spi->irq,
 				       &iio_trigger_generic_data_rdy_poll,
-				       adis->irq_flag,
+				       adis->irq_flag | IRQF_NO_THREAD,
 				       indio_dev->name,
 				       adis->trig);
 	if (ret)


