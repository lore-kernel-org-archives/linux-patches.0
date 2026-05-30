Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A897331200;
	Sat, 30 May 2026 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166290; cv=none; b=MX7moaI5sOkThiwPBTXa3ll6hRQkk4JuncsfKAm6xhMyNqjNRQoBZiBucqB4Q08nBlGH+PMu7Y+kvvOW4h7arTiKmxV8bTGrADSlPu+IkIYtsB+mK432NgdMw4XUbaYwXYvjo4byVQQ2whX25z7tKljpoq2BMvL0egxEA/heM3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166290; c=relaxed/simple;
	bh=n8IEI4vqrCahX335iGsv6iWfUxpUK22O6KR4EpalfHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKWRs/rynZG+UzGh/NI8IXHNaKbWO64o40hFTmZslSDomdks2O6SuSspNa4rOmzGhbpLrfSnNocwrTXvgCZg0AB6ASUim3C+2BH7/3SVfX+6luxidJtCzX1kZn+Mi6BKCJqEaNqrbq9n4X0ZmFVUpQO4W692Cb43I/k8XOFm/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6I/hD18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6I/hD18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D343B1F00893;
	Sat, 30 May 2026 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166289;
	bh=5W29QDOgW1jH4vAEBOuB7OPWNSr45h0MA/s2lckztlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6I/hD18sp3iqZuHSHHuSdUQTT1uQZ9/cQGxNeIQ4CnV7NESi0FR6LYc6lJh/ClEy
	 0iA7pkuGJN8yuedoqwy1/pxEHsl311daHl2x9PTaZDXttpn21iwVx6xtnZH3j/2sZ9
	 +MF1rj0HBhz3sYFTjx2YCI5NhBImnNTK606fzZ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/589] spi: fsl-qspi: Use reinit_completion() for repeated operations
Date: Sat, 30 May 2026 18:03:31 +0200
Message-ID: <20260530160233.586500317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 46ae46a944c5c..2ff26027aafd2 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -607,7 +607,7 @@ static int fsl_qspi_do_op(struct fsl_qspi *q, const struct spi_mem_op *op)
 	void __iomem *base = q->iobase;
 	int err = 0;
 
-	init_completion(&q->c);
+	reinit_completion(&q->c);
 
 	/*
 	 * Always start the sequence at the same index since we update
@@ -913,6 +913,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_disable_clk;
 
+	init_completion(&q->c);
 	ret = devm_request_irq(dev, ret,
 			fsl_qspi_irq_handler, 0, pdev->name, q);
 	if (ret) {
-- 
2.53.0



