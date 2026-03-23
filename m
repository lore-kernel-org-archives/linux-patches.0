Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7FC3BD62B;
	Mon, 23 Mar 2026 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283079; cv=none; b=T4O7EWInANwvpfbhGh9zHAQFS80f/MGxUE5k66Hv0fqN+wKeV9Kd6MvwknTzJymMG5KNHmaE3t6FcgsOhRmEUybxf2+LgwERLrJsPxKLyq7hK4UIe0T4QuESMq+rDMoN5ipEnBLqOJdoWnecKRDOqnLnoAFRh5zPxLx+j6C6X+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283079; c=relaxed/simple;
	bh=UWbgahRqjX0qCXtCla2NK4WIS/nx+vexzkb6TnhRxiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rweYmfzRxKiQaNE5VCSXeQZDJ/y0lJo+9EbtxuIqBE5qqdyHtwfah9XtJkVYtl/ov8phXnr5J1xE3IMTUd1C/bB+jIA5B/hVGALaZ82922fBX4aXjNReVk/ReYao8nibmuFef6E4ahxXNYeQnprYUuFrghANEEtDQ3ap3ICVj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCz+6sd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCz+6sd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14D6C2BCB0;
	Mon, 23 Mar 2026 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283079;
	bh=UWbgahRqjX0qCXtCla2NK4WIS/nx+vexzkb6TnhRxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCz+6sd/OMUYwe/GiGRpfch7vvrfxmnQ3F/73Yr+m/5LlnccMZPNda9e4xiKfN9kL
	 Zc54hmeo7v3fox+ILyTS06NdxfARyxgs2HH1rWVqrqLqtM6SlBP+u+kVG2XMHk83AP
	 rC3PwnvgwTAOA3ICC9MG5YvWAuzl3hoDy3n6z+HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Khairul Anuar Romli" <khairul.anuar.romli@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Niravkumar L Rabara <nirav.rabara@altera.com>,
	Mark Brown <broonie@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 394/481] spi: cadence-quadspi: Implement refcount to handle unbind during busy
Date: Mon, 23 Mar 2026 14:46:16 +0100
Message-ID: <20260323134534.764683785@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
@@ -100,6 +100,8 @@ struct cqspi_st {
 	bool			apb_ahb_hazard;
 
 	bool			is_jh7110; /* Flag for StarFive JH7110 SoC */
+	refcount_t		refcount;
+	refcount_t		inflight_ops;
 };
 
 struct cqspi_driver_platdata {
@@ -686,6 +688,9 @@ static int cqspi_indirect_read_execute(s
 	u8 *rxbuf_end = rxbuf + n_rx;
 	int ret = 0;
 
+	if (!refcount_read(&cqspi->refcount))
+		return -ENODEV;
+
 	writel(from_addr, reg_base + CQSPI_REG_INDIRECTRDSTARTADDR);
 	writel(remaining, reg_base + CQSPI_REG_INDIRECTRDBYTES);
 
@@ -973,6 +978,9 @@ static int cqspi_indirect_write_execute(
 	unsigned int write_bytes;
 	int ret;
 
+	if (!refcount_read(&cqspi->refcount))
+		return -ENODEV;
+
 	writel(to_addr, reg_base + CQSPI_REG_INDIRECTWRSTARTADDR);
 	writel(remaining, reg_base + CQSPI_REG_INDIRECTWRBYTES);
 
@@ -1365,11 +1373,29 @@ static int cqspi_mem_process(struct spi_
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
 
@@ -1800,6 +1826,9 @@ static int cqspi_probe(struct platform_d
 		}
 	}
 
+	refcount_set(&cqspi->refcount, 1);
+	refcount_set(&cqspi->inflight_ops, 1);
+
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
 			       pdev->name, cqspi);
 	if (ret) {
@@ -1852,6 +1881,11 @@ static int cqspi_remove(struct platform_
 {
 	struct cqspi_st *cqspi = platform_get_drvdata(pdev);
 
+	refcount_set(&cqspi->refcount, 0);
+
+	if (!refcount_dec_and_test(&cqspi->inflight_ops))
+		cqspi_wait_idle(cqspi);
+
 	spi_unregister_master(cqspi->master);
 	cqspi_controller_enable(cqspi, 0);
 


