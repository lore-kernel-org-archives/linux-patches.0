Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B6236404E;
	Wed, 20 May 2026 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295059; cv=none; b=TWvRzurY3qrHzYRHDLVzMc0Bhc4urD5kmhWsS7qQkRw5XuNRDgjzDYK43ID+DMRagi/JbYcs+dU/lVkHdVI/Rxh2VSKgrJ3BCAqs8yrzjvg8EHDJeRjxlTbAxXQfm+NzNr0hLllevywJbXRPJAq1XB1W/rfzX9gu/+5c3d/PSmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295059; c=relaxed/simple;
	bh=A3sTNWwYjPeA7cgkIQGAzD2IgxgNkVDRJkE2Hf6Wfr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0E8fmJErJmwxpfP36ltksi9PQmy1DY8ZcyUMXq45QJgsu2bUS14TSSvTn2qc7MiAYtoYYJdE4MbMc/OFdTcGO0qKpAPD995LbYINfTZ70B0cgfS3PEyj6AFLCbvL3DmvcDt05LqoU0dKY0nwA9vq4b3mlekH0ei7fUPAxy7Dj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPOSL++z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPOSL++z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038F51F00893;
	Wed, 20 May 2026 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295058;
	bh=mIPZOvR3grj9gHbCgW9fbO4iVcGI/OZkxv7Eb6TY+Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPOSL++zV2w6eBWrVlI+u0K4bvdSkKNPWBdlUzMJDZjgoRn6LjW3UmJ11h51zajAa
	 XIYuL8cfRHMNNtjxzOzYzvcFRIWiRvpDDCRDyBd7iCCO78slxf6BRz0RrY5jxZyuOT
	 FCNkmxANvT0SBEl+9zLpwOe+ZkaniIAIfZVV7VkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0275/1146] spi: nxp-fspi: Use reinit_completion() for repeated operations
Date: Wed, 20 May 2026 18:08:45 +0200
Message-ID: <20260520162154.443699493@linuxfoundation.org>
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
index 320b3d93df571..1e36ae084dd86 100644
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



