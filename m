Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D8B3F7875;
	Wed, 20 May 2026 17:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297944; cv=none; b=DF97V6BjBPZaGvXYEhUDjAX/dq+54mRiTUO2b/Ljk0K9mQvyKUpb1V4rWfvjUMyh1EuL3SbKmMsRqbJjNpROZxf1RI/5C5+2EVg8N7jQn1hm7+1jXQ5MdvIcRIttonXs1iDrpOTkd0my5I7Ds/i5Q+/8kmXioIY4JA6moU5A5Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297944; c=relaxed/simple;
	bh=4QqzNQGg362x7TuWigSO6gpkLRFqGPN2Npr24g6t41o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHboMwORLCjJlsk8DonSKG8ztB/HkEil1fNRDJTEEJ0hMaRl3V1mmHnNw3rFFW0m8Rqm50s86gW7yt1OI0L6ztu32YgdVOE9vCn8/c8mIj37vscsPicvuGmreEn1U7iceCRQxgzCN0vpKMdpIXPQepXxDKGhrrWy8D8lnbIIlLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te0cfeej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te0cfeej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D4C1F000E9;
	Wed, 20 May 2026 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297943;
	bh=rLZxndDt5pijnVfJeTB2brDg0QQ96jHaBPJbCZ7wKvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=te0cfeej29Cdb0bTG7tjnbEzD/tjJ/pvMJ0HU0HJp2YCnhjNgyFn/yzd2M/nQM3OB
	 J6gG2DFtdeMP8nPoGkx+2iITNjP9vHXx5Ikjpf0hB/nU1niakWKN86m+IsloRtsHW8
	 YTV/uIhMDd3fmgiGXF5Cntm04h8tzBnHq3Uvl4s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/957] spi: fsl-qspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:11:39 +0200
Message-ID: <20260520162139.224817531@linuxfoundation.org>
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
index c887abb028d77..3904d64ed4334 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -607,7 +607,7 @@ static int fsl_qspi_do_op(struct fsl_qspi *q, const struct spi_mem_op *op)
 	void __iomem *base = q->iobase;
 	int err = 0;
 
-	init_completion(&q->c);
+	reinit_completion(&q->c);
 
 	/*
 	 * Always start the sequence at the same index since we update
@@ -928,6 +928,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	init_completion(&q->c);
 	ret = devm_request_irq(dev, ret,
 			fsl_qspi_irq_handler, 0, pdev->name, q);
 	if (ret) {
-- 
2.53.0



