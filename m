Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216D530DEAC;
	Wed, 20 May 2026 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302010; cv=none; b=gSW4BlIrEE78Uv4mJrjkjO/F/bDIhPhgOfIg/YEjMaqUGP4u98QescUb8/kXPZHyWllVP88wHKxyOWYPNL+E7/dIvWo9zOJY5xln1BsWkLflFcaIbbsyluKxxoN7YsLQq5YcBoAt3V7mhmmAe1XgwawYLvNSjs6GpwxuFk17wJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302010; c=relaxed/simple;
	bh=ghiHoHM/pXg5kdp/tbrXO+4iEKFw5+VVJtaco1aYKhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAO8e/LgLZo627jbX/rgtA5tpz0U9eyNDFrqU/+zmyP4c3FtiskSRN0yAkwUONKtkGGbjHmay1WPINC2uFMjEt8WCxVKzVV4bb9XPJHijwRwtcyX6gX7fjP3vRt6CV2zuHP5WAMtOZDg+PlKIJstUN85sENeSisXLpLUSYwqBQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNx+5X0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNx+5X0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D521F000E9;
	Wed, 20 May 2026 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302009;
	bh=EOwL5IbpgFhBbM+g6YWinHL5H9fIZJh7+KY1MiOQtac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rNx+5X0pdAEYK4XnkTMsjdlrUU73TG5DutjVIjnzVu3Kf2ImXi2W5YWfOm91MqcKe
	 A9LdUqKv58Rou2le6X7I+6gqsYwj+Z96W5/zoxkWp3C6FKph6nq0UMMO9zFXl5Osng
	 ryXYRNyd/RzXzWnRjn5RYZRMLADrEfjohcExBErY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/508] spi: fsl-qspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:18:47 +0200
Message-ID: <20260520162100.873655566@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 981b080a79724738882b0af1c5bb7ade30d94f24 ]

The driver currently calls init_completion() during every spi_mem_op.
Tchnically it may work, but it's not the recommended pattern.

According to the kernel documentation: Calling init_completion() on
the same completion object twice is most likely a bug as it
re-initializes the queue to an empty queue and enqueued tasks could
get "lost" - use reinit_completion() in that case, but be aware of
other races.

So moves the initial initialization to probe function and uses
reinit_completion() for subsequent operations.

Fixes: 84d043185dbe ("spi: Add a driver for the Freescale/NXP QuadSPI controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20260304-spi-nxp-v2-3-cd7d7726a27e@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 21e357966d2a2..cb2e5413dd32b 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -606,7 +606,7 @@ static int fsl_qspi_do_op(struct fsl_qspi *q, const struct spi_mem_op *op)
 	void __iomem *base = q->iobase;
 	int err = 0;
 
-	init_completion(&q->c);
+	reinit_completion(&q->c);
 
 	/*
 	 * Always start the sequence at the same index since we update
@@ -924,6 +924,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_disable_clk;
 
+	init_completion(&q->c);
 	ret = devm_request_irq(dev, ret,
 			fsl_qspi_irq_handler, 0, pdev->name, q);
 	if (ret) {
-- 
2.53.0



