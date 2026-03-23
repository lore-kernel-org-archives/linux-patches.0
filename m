Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7E83B0AEF;
	Mon, 23 Mar 2026 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276844; cv=none; b=S3NDw7FrPc/f+OOzqoe8neXSs1gDWxEc0zjNeinb+LJPqS4TShspoQeilvkQCEPwPvANefnvnxacFmF80tRwAJsRvTcmvBqUZc8HkTJvemjKDcQPRCNaTBiRxzS7wQscRmkz2Ciplnah96D0Qp6mClwFBcsHR0TjjsoeC7MD484=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276844; c=relaxed/simple;
	bh=Cy6kTe8uQC/PW1gIy7TseYylxQkg2Rn5Ql3hReUMOxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shQxJMtky93pWAHYUKV5tGpcSkHv95za+QHNu32X45ng3oqnX385OK0gaxjCVzQ8+yHT3b+Wptyw7+EJHjIarJOh3SXyzhDBtibwgYRZMALJ8DDVRvYTWv/q040xuN10Msm7A8aq4qY69W7myyVrH5tyQk6R5EqcPN5rZUMptNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lf4GlYgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lf4GlYgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2B9C2BCB1;
	Mon, 23 Mar 2026 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276844;
	bh=Cy6kTe8uQC/PW1gIy7TseYylxQkg2Rn5Ql3hReUMOxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lf4GlYgph+ty2kPQOb43azYe5LmEW+2G2tTFRh3uJsQrXScaNlQWeMcpFH/UrvuYW
	 t/f1Zf02j9pPldeWtcNQcBFLD2dnFFnyjd3ZrsgV6Mycg2+/HRB++/YlTFoTgYZziR
	 XsjN/oF4qLfJSKDRLXz00a0r4olv1dzTmw6nEeq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Khairul Anuar Romli" <khairul.anuar.romli@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Niravkumar L Rabara <nirav.rabara@altera.com>,
	Mark Brown <broonie@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.12 224/460] spi: cadence-quadspi: Implement refcount to handle unbind during busy
Date: Mon, 23 Mar 2026 14:43:40 +0100
Message-ID: <20260323134532.000418288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -105,6 +105,8 @@ struct cqspi_st {
 
 	bool			is_jh7110; /* Flag for StarFive JH7110 SoC */
 	bool			disable_stig_mode;
+	refcount_t		refcount;
+	refcount_t		inflight_ops;
 
 	const struct cqspi_driver_platdata *ddata;
 };
@@ -731,6 +733,9 @@ static int cqspi_indirect_read_execute(s
 	u8 *rxbuf_end = rxbuf + n_rx;
 	int ret = 0;
 
+	if (!refcount_read(&cqspi->refcount))
+		return -ENODEV;
+
 	writel(from_addr, reg_base + CQSPI_REG_INDIRECTRDSTARTADDR);
 	writel(remaining, reg_base + CQSPI_REG_INDIRECTRDBYTES);
 
@@ -1058,6 +1063,9 @@ static int cqspi_indirect_write_execute(
 	unsigned int write_bytes;
 	int ret;
 
+	if (!refcount_read(&cqspi->refcount))
+		return -ENODEV;
+
 	writel(to_addr, reg_base + CQSPI_REG_INDIRECTWRSTARTADDR);
 	writel(remaining, reg_base + CQSPI_REG_INDIRECTWRBYTES);
 
@@ -1450,12 +1458,26 @@ static int cqspi_exec_mem_op(struct spi_
 	struct cqspi_st *cqspi = spi_controller_get_devdata(mem->spi->controller);
 	struct device *dev = &cqspi->pdev->dev;
 
+	if (refcount_read(&cqspi->inflight_ops) == 0)
+		return -ENODEV;
+
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
 		dev_err(&mem->spi->dev, "resume failed with %d\n", ret);
 		return ret;
 	}
 
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
+
 	ret = cqspi_mem_process(mem, op);
 
 	pm_runtime_mark_last_busy(dev);
@@ -1464,6 +1486,9 @@ static int cqspi_exec_mem_op(struct spi_
 	if (ret)
 		dev_err(&mem->spi->dev, "operation failed with %d\n", ret);
 
+	if (refcount_read(&cqspi->inflight_ops) > 1)
+		refcount_dec(&cqspi->inflight_ops);
+
 	return ret;
 }
 
@@ -1916,6 +1941,9 @@ static int cqspi_probe(struct platform_d
 		}
 	}
 
+	refcount_set(&cqspi->refcount, 1);
+	refcount_set(&cqspi->inflight_ops, 1);
+
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
 			       pdev->name, cqspi);
 	if (ret) {
@@ -1978,6 +2006,11 @@ static void cqspi_remove(struct platform
 {
 	struct cqspi_st *cqspi = platform_get_drvdata(pdev);
 
+	refcount_set(&cqspi->refcount, 0);
+
+	if (!refcount_dec_and_test(&cqspi->inflight_ops))
+		cqspi_wait_idle(cqspi);
+
 	spi_unregister_controller(cqspi->host);
 	cqspi_controller_enable(cqspi, 0);
 


