Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B414B391832;
	Wed, 23 Sep 2026 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174768; cv=none; b=msU6IqwX5RB61QbiyYBQgPy99b5kuvu3zVHmit1VeVLGuVW+RgXmxGDbnYd+qqoZF5qzGLwc0A7w5H9xWh0WsxtrgTYzAtVLXyZDHpa3SKccM5j53wb5BvEaD1+biKESU8T28YNKQo39zWYVxzeXX/GMYRe18d4nd8UntjSxMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174768; c=relaxed/simple;
	bh=jjWy3V5kyOIQlPP/h5p5A6GNK149wTadJG98Y847L4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLjVNI8uzXMZJn01ChQhZwu/SYH45gd+BZse53wuAIrwx3iov0qDblDYfFjk22byVVEEQQjPjLM/0DudnYrhjd3/ELUrliUO9lQlrRx8IDQrxKJSEpKG4HEmPsfWd9zk2lNABwqolQ0MXCcOypgwAzCKDqnGf+aQSHjVduSYvfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXgMV7sV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXgMV7sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149521F000FF;
	Wed, 23 Sep 2026 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174767;
	bh=JfOkFNynFtGJATtPXp4UifKdBAIWwlNP12daFlVBuDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXgMV7sVv8huOuhRDNO+vDByNjlA3Aqv5ihklam8VHiOxegXCvkrnflfUYxOVlsyk
	 XaBPm/PIi/JBk4RN0g1j7AtDKB9Qlqhg2jKIoFKvpZK7vyVVgKe3MHlPzCGxm1gP7G
	 DRl+xGD08EiXfDjctN+0nY0A99dVDKdHF4dHoXv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itai Handler <itai.handler@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 220/398] spi: spi-zynqmp-gqspi: stop the controller on shutdown
Date: Wed, 23 Sep 2026 16:04:54 +0200
Message-ID: <20260923140649.124678756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Itai Handler <itai.handler@gmail.com>

commit e922bad8b2d5028c51a096d083fea41cd0987154 upstream.

The driver has no ->shutdown, and platform_drv_shutdown() has no
fallback of its own.  Unlike pci_device_shutdown(), which clears bus
mastering when kexec_in_progress, nothing on the platform bus disarms a
device that can still write to memory.  The normal kexec path never
calls ->suspend either, so the quiesce in zynqmp_qspi_suspend() is not
reached.

A controller that is still executing a DMA read may therefore keep
writing to memory across a kexec.  QSPIDMA_DST_ADDR still points at
memory owned by the kernel that called kexec, DST_SIZE is non-zero and
the flash is still clocked, so data can keep landing in RAM while the
new kernel is being relocated, and after it has started executing.

That destination is a physical address which means nothing to the new
kernel, so the writes can corrupt whatever now occupies it: kernel text
or data, page tables, or the initrd.  Nothing reports an error and the
resulting behaviour is undefined.

This can be observed by reading GQSPI_EN (offset 0x114) and
QSPIDMA_DST_ADDR/SIZE/STS/CTRL (offsets 0x800 to 0x80c) early in the new
kernel, before the driver probes: without this patch GQSPI_EN reads 1
and QSPIDMA_DST_ADDR still points into the previous kernel's memory.

Add a ->shutdown that stops the controller the way zynqmp_qspi_suspend()
already does.  spi_controller_suspend() stops the queue, waits for a
message that is already executing and makes any later transfer fail with
-ESHUTDOWN, so nothing can be cut short by the register write that
follows.  It may sleep, which is fine here: device_shutdown() runs in
process context.  Unlike ->suspend this cannot abort on error, because a
controller left mastering the bus is worse than a truncated transfer, so
a failure to drain is only logged.

GQSPI_EN_OFST is then cleared, as zynqmp_qspi_remove() and
zynqmp_qspi_suspend() already do.  Skip that write only when
pm_runtime_get_if_in_use() returns 0, i.e. runtime suspended: the clocks
are gated, so the registers are unreachable and the controller cannot be
mastering the bus.  A negative return is not the same thing - it is what
the CONFIG_PM=n stub always returns, and there probe() has enabled pclk
and refclk for good, so the controller is running and must be stopped.

Fixes: dfe11a11d523 ("spi: Add support for Zynq Ultrascale+ MPSoC GQSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Itai Handler <itai.handler@gmail.com>
Link: https://patch.msgid.link/20260910174832.873352-1-itai.handler@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynqmp-gqspi.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1374,11 +1374,45 @@ static void zynqmp_qspi_remove(struct pl
 	clk_disable_unprepare(xqspi->pclk);
 }
 
+static void zynqmp_qspi_shutdown(struct platform_device *pdev)
+{
+	struct zynqmp_qspi *xqspi = platform_get_drvdata(pdev);
+	int ret;
+
+	/*
+	 * Stop the queue and reject any later transfer first, so the write
+	 * below cannot cut into a message that is still being executed.
+	 * Unlike ->suspend this cannot abort on error: a controller left
+	 * mastering the bus is worse than a truncated transfer.
+	 */
+	ret = spi_controller_suspend(xqspi->ctlr);
+	if (ret)
+		dev_warn(&pdev->dev, "could not stop the queue: %d\n", ret);
+
+	/*
+	 * Only a runtime suspended controller can be left alone: its clocks
+	 * are gated, so it cannot be mastering the bus, and its registers
+	 * must not be accessed either.  Any other answer means it may be
+	 * running and has to be stopped.  In particular, on a kernel built
+	 * without runtime PM this returns -EINVAL, and there the clocks
+	 * enabled in probe() are never gated at all.
+	 */
+	ret = pm_runtime_get_if_in_use(&pdev->dev);
+	if (!ret)
+		return;
+
+	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
+
+	if (ret > 0)
+		pm_runtime_put_noidle(&pdev->dev);
+}
+
 MODULE_DEVICE_TABLE(of, zynqmp_qspi_of_match);
 
 static struct platform_driver zynqmp_qspi_driver = {
 	.probe = zynqmp_qspi_probe,
 	.remove = zynqmp_qspi_remove,
+	.shutdown = zynqmp_qspi_shutdown,
 	.driver = {
 		.name = "zynqmp-qspi",
 		.of_match_table = zynqmp_qspi_of_match,


