Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED8B30BF68;
	Wed, 20 May 2026 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298061; cv=none; b=ua1hv9fOZGS/795l4kWGLbaRCv3DZKEX2gCeD9x0teBR2P+SMcatCmsQI7aQ9gTIQHdqEvb5HMd4VRtKzjU3BZ5ZavwsPsF1AxKaOLtNldxtpzpOnqXaQcDhh9gN3cWPSNRyS+czjQW/yty2FZ0u1uqNJETqIHzuGOdLEGgdtqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298061; c=relaxed/simple;
	bh=8amC+pnH0WAYAHiBny84p0og1f6jj9ZWRtpQX8WyczM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsgyVWfVFig9fqFbQygzs0O+tNz4clfWHSnVjsdYGaaPA7I9IyRqpTgXLKSjbGj7Wux1ysvV8FKP107DbJj7fgQTg7El4yisNLchq9Dxcqn6VkV9XONpmklynidanO8lXCyCVI097jqr1EJJdpAmsdGjAC7PJ1LuuNT6tk4pjE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=retZS467; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="retZS467"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BD61F000E9;
	Wed, 20 May 2026 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298059;
	bh=BzUv42fATrzApdaH4xOM7kVfoLkNEcuRfDv3ZVjPLJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=retZS467aWytkrySOT9me3rD/S2n/FkmnQGt3T6sBGTo3w1INS/uiQ/b1tKHcnY43
	 yASR48TJmIXrfnZJQ/BofKnGG4JoDCHfXCHrNYAy3O84rKh9oBQjv/lsnGRQUPi2on
	 mHuLw65v5YLixL4Wx9RMehy54n8INhvBygzvfwtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/957] spi: nxp-fspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:11:38 +0200
Message-ID: <20260520162139.202254745@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 50a7e4916a600..95ccb1f7dfafa 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -996,7 +996,7 @@ static int nxp_fspi_do_op(struct nxp_fspi *f, const struct spi_mem_op *op)
 	reg = reg | FSPI_IPRXFCR_CLR;
 	fspi_writel(f, reg, base + FSPI_IPRXFCR);
 
-	init_completion(&f->c);
+	reinit_completion(&f->c);
 
 	fspi_writel(f, op->addr.val, base + FSPI_IPCR0);
 	/*
@@ -1365,6 +1365,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Failed to disable clock");
 
+	init_completion(&f->c);
 	ret = devm_request_irq(dev, irq,
 			nxp_fspi_irq_handler, 0, pdev->name, f);
 	if (ret)
-- 
2.53.0



