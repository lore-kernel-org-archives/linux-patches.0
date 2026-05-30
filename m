Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E753267B05;
	Sat, 30 May 2026 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163014; cv=none; b=U1shFKLefJfRDxbYh2dTDvEtx4YJ7vpI9guOiZWi1e85udSULrnYBq/riJ3xq+B1IdK0b874426js47vMtVp1SPFGbg0YxJOOabRx/2+uVTGuzyNIFhFiQ+ZYhGIKp8VqHWhgBC/gEL4RksLpqbDce5fuPePEg1rVHmmeV/dZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163014; c=relaxed/simple;
	bh=1w0SpJEyuNcp25b5DJcsUCgcznsV2CdlX0+sQv+Ju4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP9+q/6MueNvBqxwPib/Zrp1lcQFWtr5EMYUXB+J9pNqeN4o9PiVgysOjSVe5q/aGbaLsSPXPHzOyKQC+ppr+dCuC7668/0pgljL7ZZMfGhWQq9JVL91FxxNOdh6Y75GOGdAyfwE6rH2CfqOR2bFE5iS8HafBGs8cL3+Cx83/P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx5WOG2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx5WOG2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464DE1F00893;
	Sat, 30 May 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163012;
	bh=hWBbE1KteLGjmpdNfC+y1XM0yPX6gE8+ra2nS3FmXOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zx5WOG2yo3RApMI9yPfw4GbN8gdTI4Ih7gdJ9VtR1N3iIme/a/mjPLih/yp/RY7Rs
	 ZCtsCt3QPdK8bBaM8WKU7WqnYOWhOYzPmKCJuodOQtyF69u2ENxB+SAPHNEr0Fso07
	 EgMwcqh4rGuBBrCR2Dah2bde6OAlRrbW3yvAkJQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Khairul Anuar Romli" <khairul.anuar.romli@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Niravkumar L Rabara <nirav.rabara@altera.com>,
	Mark Brown <broonie@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 130/776] spi: cadence-quadspi: Implement refcount to handle unbind during busy
Date: Sat, 30 May 2026 17:57:24 +0200
Message-ID: <20260530160243.744908964@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khairul Anuar Romli <khairul.anuar.romli@altera.com>

[ Upstream commit 7446284023e8ef694fb392348185349c773eefb3 ]

driver support indirect read and indirect write operation with
assumption no force device removal(unbind) operation. However
force device removal(removal) is still available to root superuser.

Unbinding driver during operation causes kernel crash. This changes
ensure driver able to handle such operation for indirect read and
indirect write by implementing refcount to track attached devices
to the controller and gracefully wait and until attached devices
remove operation completed before proceed with removal operation.

Signed-off-by: Khairul Anuar Romli <khairul.anuar.romli@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Reviewed-by: Niravkumar L Rabara <nirav.rabara@altera.com>
Link: https://patch.msgid.link/8704fd6bd2ff4d37bba4a0eacf5eba3ba001079e.1756168074.git.khairul.anuar.romli@altera.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[Add cqspi defination in cqspi_exec_mem_op and minor context change fixed.]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -85,6 +85,8 @@ struct cqspi_st {
 	bool			use_direct_mode;
 	struct cqspi_flash_pdata f_pdata[CQSPI_MAX_CHIPSELECT];
 	bool			wr_completion;
+	refcount_t		refcount;
+	refcount_t		inflight_ops;
 };
 
 struct cqspi_driver_platdata {
@@ -684,6 +686,9 @@ static int cqspi_indirect_read_execute(s
 	u8 *rxbuf_end = rxbuf + n_rx;
 	int ret = 0;
 
+	if (!refcount_read(&cqspi->refcount))
+		return -ENODEV;
+
 	writel(from_addr, reg_base + CQSPI_REG_INDIRECTRDSTARTADDR);
 	writel(remaining, reg_base + CQSPI_REG_INDIRECTRDBYTES);
 
@@ -826,6 +831,9 @@ static int cqspi_indirect_write_execute(
 	unsigned int write_bytes;
 	int ret;
 
+	if (!refcount_read(&cqspi->refcount))
+		return -ENODEV;
+
 	writel(to_addr, reg_base + CQSPI_REG_INDIRECTWRSTARTADDR);
 	writel(remaining, reg_base + CQSPI_REG_INDIRECTWRBYTES);
 
@@ -1210,11 +1218,29 @@ static int cqspi_mem_process(struct spi_
 static int cqspi_exec_mem_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
 	int ret;
+	struct cqspi_st *cqspi = spi_controller_get_devdata(mem->spi->controller);
+
+	if (refcount_read(&cqspi->inflight_ops) == 0)
+		return -ENODEV;
+
+	if (!refcount_read(&cqspi->refcount))
+		return -EBUSY;
+
+	refcount_inc(&cqspi->inflight_ops);
+
+	if (!refcount_read(&cqspi->refcount)) {
+		if (refcount_read(&cqspi->inflight_ops))
+			refcount_dec(&cqspi->inflight_ops);
+		return -EBUSY;
+	}
 
 	ret = cqspi_mem_process(mem, op);
 	if (ret)
 		dev_err(&mem->spi->dev, "operation failed with %d\n", ret);
 
+	if (refcount_read(&cqspi->inflight_ops) > 1)
+		refcount_dec(&cqspi->inflight_ops);
+
 	return ret;
 }
 
@@ -1564,6 +1590,9 @@ static int cqspi_probe(struct platform_d
 			cqspi->wr_completion = false;
 	}
 
+	refcount_set(&cqspi->refcount, 1);
+	refcount_set(&cqspi->inflight_ops, 1);
+
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
 			       pdev->name, cqspi);
 	if (ret) {
@@ -1613,6 +1642,11 @@ static int cqspi_remove(struct platform_
 {
 	struct cqspi_st *cqspi = platform_get_drvdata(pdev);
 
+	refcount_set(&cqspi->refcount, 0);
+
+	if (!refcount_dec_and_test(&cqspi->inflight_ops))
+		cqspi_wait_idle(cqspi);
+
 	cqspi_controller_enable(cqspi, 0);
 
 	if (cqspi->rx_chan)


