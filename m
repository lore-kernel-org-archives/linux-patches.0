Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F94E2F13;
	Wed, 30 Sep 2026 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786363; cv=none; b=EzEEBvPWlW0fl1hDz8ZOD3G1y3UvCSwxisEqCxG0/dgIkpiCGbQkkYnHN+cJBlgQtsQtJS1yien2QAXK9JFN+4uKK1+5pibAOVlOgsgk3OZ7vmv2W8tmrehNWUEdBMFvkqGQXsNbgOUTYbteMz1LGPWkie7eXtt/QdHjGENSfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786363; c=relaxed/simple;
	bh=wuFDm5sbUYeZLPkqVCkhiO/74TVjn1DToTB9bWntjHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9P5DscNnE5m0b5Ynyef0qdJJCArXLq8REVXnnJnMtopA4GJeu17+ZFVl7pzmz0J434c/vHcbrduIZqH5lEUn6Utmt42wCfY8DeXJ/uf6SYHxVMu7fODaCq5XEO2EoaIayjb4ENYIwyAx3KNoIEeFMlGEA7pSIPHN9bmZ2xTcag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbjWAjDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbjWAjDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2449A1F000FF;
	Wed, 30 Sep 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786361;
	bh=O3DAhrhVgwVDaDGPx06aD2b+Do3FzwyR77uxyM9AKCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbjWAjDB/8O1IAg9YG1BeSEOYWro36coL+wjNF0ljYWRAEbfLnBbJ1tMhjAt9ecKR
	 m1I0GNXYBmxscT9E46wCp9p4W/xEBJ7asegIXuFmED+0NvTHocL7DiJulPxV8u3PfN
	 ujb+hQkACLTV7dG2LpsBAIHdEKTmqCXc0/pYhKHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itai Handler <itai.handler@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 790/982] spi: spi-zynqmp-gqspi: stop the controller on shutdown
Date: Wed, 30 Sep 2026 17:25:26 +0200
Message-ID: <20260930152433.723725737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
[ itai: context only - zynqmp_qspi_of_match[] still sits between
  zynqmp_qspi_remove() and MODULE_DEVICE_TABLE() in this tree, hoisted to
  the top of the file upstream by commit 29f4d95b97bc ("spi:
  spi-zynqmp-gqspi: Add tap delay support for GQSPI controller on Versal
  platform"), so zynqmp_qspi_shutdown() is placed above it ]
Signed-off-by: Itai Handler <itai.handler@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 204e5d03a6c53..ab62100f0b987 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1257,6 +1257,39 @@ static int zynqmp_qspi_remove(struct platform_device *pdev)
 	return 0;
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
 static const struct of_device_id zynqmp_qspi_of_match[] = {
 	{ .compatible = "xlnx,zynqmp-qspi-1.0", },
 	{ /* End of table */ }
@@ -1267,6 +1300,7 @@ MODULE_DEVICE_TABLE(of, zynqmp_qspi_of_match);
 static struct platform_driver zynqmp_qspi_driver = {
 	.probe = zynqmp_qspi_probe,
 	.remove = zynqmp_qspi_remove,
+	.shutdown = zynqmp_qspi_shutdown,
 	.driver = {
 		.name = "zynqmp-qspi",
 		.of_match_table = zynqmp_qspi_of_match,
-- 
2.53.0



