Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C623C4555;
	Thu, 16 Jul 2026 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211841; cv=none; b=QzWVDUMYH7LORZR44JKPT67BpKCX51rXJalEM96su3hOWv2iVGv0wLJK7xhuLS1zBkszfn6CX5R9uDbOpy4jyGdoCHH8LXgkroBDhBrL67UqME2HhH2tmR6th04hxIpVXTRSzLdMKcl62xD2dBGLyYiZgZ1TDdV2aW9TUtP7Kh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211841; c=relaxed/simple;
	bh=Nw22p+qZPddXkgbBe8zjqgWqNCgLE89BQ2bXYtFO6co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvC8JWamjbq85JvgnR3NJFlKVOpc70YFFJB3iphPh53FllNwkrRcSvEdQXDmGBs2dYnd1FJpi4vUQrKMa0zzv8QYqjZYrs7GwClcy2Q1iNZu6Bkt7yvzL7yob46g6Jv9ryUVJSuiueI4W0ROk0ilFc4ZZvRDLoAomv0Zdj4EnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DUgdRr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DUgdRr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781021F000E9;
	Thu, 16 Jul 2026 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211840;
	bh=ll+7E2iBkElePaTQOR6aeoMPD6OoMSoISszQwkxEBzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DUgdRr+dJvWKkK8MNAaxm+ujJtDzEBby13xzmpecVuC2M1zrYUgpXwd9RcM4+AP/
	 mxbrynrQ8+7Jo7GnwbFhxR8/viFPSiJPwWjWnX+7rw/VV/ig9/5RAzaaiJ3QazxlPI
	 CwRlhuIo0U7Bzc9o8OjhyknvCYkQ8jlRj8LwZYQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 056/349] iio: imu: adis: add IRQF_NO_THREAD to non-FIFO trigger IRQ
Date: Thu, 16 Jul 2026 15:29:50 +0200
Message-ID: <20260716133034.578890690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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


