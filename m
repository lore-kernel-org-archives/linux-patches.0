Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913CE369D75;
	Wed, 20 May 2026 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295062; cv=none; b=jG2ZEggV3DAaKcVrQNMVTVW3vTOpM7iVrdVGAH0xhjRRD8qxeG46ikiEJVY2L4Obj4UusMA+u3+MGcpzogufYqFMPqEnyZTwCUCZD67Qx0cKJNMe2fLYBLt0Ff1I9l3g0+CfmMgAoQUr0AZuB+U7xXn0Go6BKHdmAYBHOz3PBo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295062; c=relaxed/simple;
	bh=5E/ItrIgErY11hZmNs456bG7nTDEycdWtEWp29/Js1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQJ9HYx9onK4SPjk3dJPx8MOcb0cnQEqcFDuZuzUVW/q02TGrjvW1lGjK6FFoj9ZqBgAUpPR0qjjpk83WCNWCj5HrsOs+rZvgkoy4VsureY2vJpp0f7XkukSRmoBU8wbOfcZYhgEONsdRmrEpTqJsYpeSWVm/Q+67eDEgSTz4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dal51Aq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dal51Aq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBCC1F000E9;
	Wed, 20 May 2026 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295061;
	bh=6sj7ZJ+gRp1VkLkSR1j0nyWVE0sfR6K5PMYNWWoMTrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dal51Aq1fLui70daFIjg3QLoeyprEtvHRk8v2aS4S6YA/HnUQpd5jpyXq/hnlyiP6
	 xEk2aIDjUDFYyxOF/8nU+7QCTOjLgVICdRIOY53Slg3CJM4u3Th4Mo3K3N3HH+UmOq
	 ue2+epQVyUlF2hG2oopm/PqI7guLhcKOBcT2SI4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0276/1146] spi: fsl-qspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:08:46 +0200
Message-ID: <20260520162154.465947847@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a223b4bc6e637..57358851029ba 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -633,7 +633,7 @@ static int fsl_qspi_do_op(struct fsl_qspi *q, const struct spi_mem_op *op)
 	void __iomem *base = q->iobase;
 	int err = 0;
 
-	init_completion(&q->c);
+	reinit_completion(&q->c);
 
 	/*
 	 * Always start the sequence at the same index since we update
@@ -965,6 +965,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	init_completion(&q->c);
 	ret = devm_request_irq(dev, ret,
 			fsl_qspi_irq_handler, 0, pdev->name, q);
 	if (ret) {
-- 
2.53.0



