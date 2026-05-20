Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F293D75C7;
	Wed, 20 May 2026 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300354; cv=none; b=qihW+HC9VfytD2bQOLv4AcHx2rWMIVBVZmj1Xbob1PSRuuIldfATq4BMYM+/Pld2YX3fV/7/gYDOGLr0WJegZU9Th+vgPtPMRCwor95XGiyjJn6GmvmFvHGKxugzi7YYNCDQ4/8cKaD9pAyBzwRLp4F0WvthjzkwpA2C2f1aXSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300354; c=relaxed/simple;
	bh=wSE3MeLHBM0RJN8Dic/7Igy1DZD3pA9/PtgDNL1LyQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/2cS0IK4QoBvRo804doV5IFteARJe60do/AJ5Atrj21XvDYWrZxhkr4yGSXNRSxFBzQJ0qk0JaqNP6F2KxPTFLKgdakbibby/V/8y8qFuMuUuxsL5eyH3uW5eqV9Rg7g3++2vHHBe97Vs1eh2Qj3JS4Bk5BreJnZv66FWNfCp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfKHfrqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfKHfrqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464D01F000E9;
	Wed, 20 May 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300353;
	bh=hYhMBDpBSfthNMPUQ3TAKzc5Ih9KKY4LHfRDW4dIRG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfKHfrqpSmiV/e/yKrGgpCodvL3vfluYpxOoIQuAVCufubQy9inaHuC0TtjeNpKDY
	 /ejnLUjeVt+oMyZpN9Fy+MRzNlWI0N2D82Fm69eoEJCUv2wyEeZ/M/QmfVerxCBlbh
	 xzORr0IFLfzYsKxHEZLXgVfYkcbtZxeYymqfDueo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/666] spi: nxp-fspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:15:54 +0200
Message-ID: <20260520162114.308167416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 68c8c93fdb0de7e528dc3dfb1d17eb0f652259b8 ]

The driver currently calls init_completion() during every spi_mem_op.
Tchnically it may work, but it's not the recommended pattern.

According to the kernel documentation: Calling init_completion() on
the same completion object twice is most likely a bug as it
re-initializes the queue to an empty queue and enqueued tasks
could get "lost" - use reinit_completion() in that case, but be
aware of other races.

So moves the initial initialization to probe function and uses
reinit_completion() for subsequent operations.

Fixes: a5356aef6a90 ("spi: spi-mem: Add driver for NXP FlexSPI controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20260304-spi-nxp-v2-2-cd7d7726a27e@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 67bcc6d351326..b7dbc015d88fa 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -907,7 +907,7 @@ static int nxp_fspi_do_op(struct nxp_fspi *f, const struct spi_mem_op *op)
 	reg = reg | FSPI_IPRXFCR_CLR;
 	fspi_writel(f, reg, base + FSPI_IPRXFCR);
 
-	init_completion(&f->c);
+	reinit_completion(&f->c);
 
 	fspi_writel(f, op->addr.val, base + FSPI_IPCR0);
 	/*
@@ -1267,6 +1267,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Failed to disable clock");
 
+	init_completion(&f->c);
 	ret = devm_request_irq(dev, irq,
 			nxp_fspi_irq_handler, 0, pdev->name, f);
 	if (ret)
-- 
2.53.0



