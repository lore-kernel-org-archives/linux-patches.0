Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B42D439903;
	Tue, 21 Jul 2026 21:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670571; cv=none; b=ewoft8rE11WC5Ng22PxPHyM5A8x9m1GhE9kOTYaU6eWf8sfPjsuTm1SduxbwD10DHROo0kJsRLFQ/84bmupD2AUwkHK5erKFkzp4rGUP7Uax9YQ6B5WoLXLXUpf/pdeqrTqqcXJ9BrgRwT+6KD34YtoyK5OIkhH+ytPk1sCQsTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670571; c=relaxed/simple;
	bh=2UZVrJlrkS6w8X4u+hWpzJDOfgKs+bSf7AF/eQuenUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZD7uBeEAzxlY0CJLlPsb3k/Owt4Tsw3RgCL4WjHsgftOK9DqqPetrvnXLODvZTmW81rlm1ji7y6ccIoaYCdFZdn7SLSs6pmBhyIGjidIHvMPvNSpmDPeG9Apl8vCLGy9Mt2n2jKc//ZE9b6LJfzoZDQLD8TwU7dTdP8Dhe0G0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NByH72Ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NByH72Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCE01F00A3A;
	Tue, 21 Jul 2026 21:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670568;
	bh=2gARESZbQ/YrlKXUYHDzHzuqUQKPuL4yyPylps3/0ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NByH72KyLWnnrunWquvSTwFs1IyYy6JZ8ql/fVXbS078/qREBdn2KI9Z6XML+pWl3
	 0fZ6GOWfqwWlrrAXzyqs4mj5/A//IElDtu47AlGQUxJSP7k0h9oUFAmzEh0bFbIYMp
	 tuWi++MmVNWZpG1lDxCijiAnbXLf+8guuMwlAC3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0940/1067] iio: imu: adis: add IRQF_NO_THREAD to non-FIFO trigger IRQ
Date: Tue, 21 Jul 2026 17:25:41 +0200
Message-ID: <20260721152445.560913428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 6e1b9bff1202da55c464e36bd34a2b6863d7fe30 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis_trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -79,7 +79,7 @@ int devm_adis_probe_trigger(struct adis
 
 	ret = devm_request_irq(&adis->spi->dev, adis->spi->irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       adis->irq_flag,
+			       adis->irq_flag | IRQF_NO_THREAD,
 			       indio_dev->name,
 			       adis->trig);
 	if (ret)


