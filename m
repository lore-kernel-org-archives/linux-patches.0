Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921F32FDC5E;
	Sat, 30 May 2026 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164054; cv=none; b=OydNY1HL4OunwLgUPYj+qFgCjBtbIyMAXB2vd/CjL9x4egB7ZhYGTHj4FXGFgUuqsoX4sN4kedX+VelDd30ubXi7MkMY34kaqVoMjz0nIGNdmLihIdbs6ZISg0ZnHEkRtKpMSJ5yFm17TGr06Wwl9LHIcFpPxhuA39oCA4tMhtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164054; c=relaxed/simple;
	bh=itoob14x5U4Ou5aa60OPAz2PVYnR2PO1PBsPomG4Apg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOZzbZr8r2l/SDDctcNSxcG9hDxjQHS1uxgiU04aNYtSD/iX8FpLhn7vr4Xb8UrO9Z10zXKYjzbYdcHy7BEFPPv9f3Yf+Lv8Xd8yURH3xw7aB38L7Ep5K+gHKrroeBF1Nt/0OBp1DJMR+vjXJMLqUxAtL6gXiCZqVfzwZpEmm8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGwgNPga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGwgNPga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7651F00893;
	Sat, 30 May 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164052;
	bh=TbC3UXcJ6aHicxoOrlpurk/EDs8t7jW4+xc8U7NNomc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGwgNPgaqE26z1HicaMr/6y7mXIURBh70HCCUgsnZfIA9liHD9gdJal7U6pYrtjgG
	 A1aZBwDZ06cTjk5Y3u1DOOwVXSYm3INDWLGycyizIwMOGGEFQujOtjBBS0W2SHgaDJ
	 mTUjsU+t49Csj6giKOdrfSqGJkCxaia8sMy/Dr2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/776] spi: fsl-qspi: Use reinit_completion() for repeated operations
Date: Sat, 30 May 2026 18:02:35 +0200
Message-ID: <20260530160251.813885995@linuxfoundation.org>
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



