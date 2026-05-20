Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F79E363097;
	Wed, 20 May 2026 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295058; cv=none; b=nqp2Lm/Sj0QH/bE8VmIfKw6b8MS0rYYLPTpfVo49wiPrCqvOJ3xYarw6L/wDP3ELEWreUcsFvyMCqMle0gKq9eJWN1mfQCds+Rxj8LLeRnWFkCAdUEAq/toXHSbDclu51t4TmkorF6Ez52YdgprWZqq8YKJ/rqInBOwNGxAoZAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295058; c=relaxed/simple;
	bh=lujw3PnuDE66nN/ee8/EhL/2T8lgAVV/ez5Hzlq5fIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5ns7W24r0JeHTerubqCL6AZNP5LIjo1qjQugzBD9QtUytg9GYsfw7kr/K8w7mrxhzpY1D5LLTxv5RLMRWABtattE8pxbc4nyqqsusw46i+c7Y5a5ywMIrLaViFE9WalGmKpJ4zg0N6I/kuTYZIp47NlphBGJn4CXHLXANOCu5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3qam6PR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3qam6PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF1D1F000E9;
	Wed, 20 May 2026 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295055;
	bh=Do5/Jbs8DnJeHu+F5pND/8nqh5cuVotXTEQNy+0pAeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3qam6PR9dCfkHdcq8FCeg+xwL4LsLiOOy/Bd8C3gsBaJqFQWeRyATrR+o4Q9FdLr
	 ixZf8IgWRMPpq5q2jU6cgXy9Iz76bN1KWSXFPfchOd9KLNsIuleim900+4b3tJd5Rh
	 IWddtCplJGXGELSpdVJnl6yv8VRC/t37FqxlMJtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0274/1146] spi: nxp-xspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:08:44 +0200
Message-ID: <20260520162154.421647083@linuxfoundation.org>
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

[ Upstream commit 40f9bc646db5aa89fb85f2cda1e55a2bf9d6a30c ]

The driver currently calls init_completion() during every spi_mem_op.
Tchnically it may work, but it's not the recommended pattern.

According to the kernel documentation: Calling init_completion() on
the same completion object twice is most likely a bug as it
re-initializes the queue to an empty queue and enqueued tasks
could get "lost" - use reinit_completion() in that case, but be
aware of other races.

So moves the initial initialization to probe function and uses
reinit_completion() for subsequent operations.

Fixes: 29c8c00d9f9d ("spi: add driver for NXP XSPI controller")
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260304-spi-nxp-v2-1-cd7d7726a27e@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-xspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-nxp-xspi.c b/drivers/spi/spi-nxp-xspi.c
index 06fcdf22990b8..385302a6e62f2 100644
--- a/drivers/spi/spi-nxp-xspi.c
+++ b/drivers/spi/spi-nxp-xspi.c
@@ -958,7 +958,7 @@ static int nxp_xspi_do_op(struct nxp_xspi *xspi, const struct spi_mem_op *op)
 		writel(reg, base + XSPI_RBCT);
 	}
 
-	init_completion(&xspi->c);
+	reinit_completion(&xspi->c);
 
 	/* Config the data address */
 	writel(op->addr.val + xspi->memmap_phy, base + XSPI_SFP_TG_SFAR);
@@ -1273,6 +1273,7 @@ static int nxp_xspi_probe(struct platform_device *pdev)
 
 	nxp_xspi_default_setup(xspi);
 
+	init_completion(&xspi->c);
 	ret = devm_request_irq(dev, irq,
 			nxp_xspi_irq_handler, 0, pdev->name, xspi);
 	if (ret)
-- 
2.53.0



