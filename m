Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A39534389B;
	Sat, 30 May 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161131; cv=none; b=P4xZdkb/oLgWKapVjcuC6QYiOGbEBPl5cjrLW0HISFBStP6yUo7ihS+WWy4ocM/FGGffY3WxiD50/aYHTduI/hg3gvUF3jtj8eodM3hlWVNRAMNCF59arPKk2FMQhi5aJYPTIl/Dukej3uvUVCrYYHrXLnhzEt+rJ+lbLkAigsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161131; c=relaxed/simple;
	bh=HjW2M/z+2EvvgPvs264eB2jiBTXKUqCDGBPFqxYYCWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvKs8yWVuIfegBDEyYEJ4Hs9kJ2ITXHPWCXuSA+8+EywHIwa3bY5xpgSvjsBR5dU2lkkV2kR+AQ5vWVjfmubxcN6QDkcQIvJuftRHdjkQ+iOrJeVk5oUbF032JKAj8rD5IZeKmWj6IAhWpX192szh7NdivtXthu7CNukbBSC/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8yWF10O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8yWF10O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9D11F00893;
	Sat, 30 May 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161130;
	bh=mnwTO2vQG0lICWdXM+RiDvqfsVoe3/Z+ZRMPx31cW9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8yWF10Ov82NH6xoezTsnlV6g/dlujMB25JqueokDfdnUUxpCz2HJTpdPRueaZsgL
	 BYTQyGvCm920FEQYSopfZAiCmxJobtmH1z6cZFj9y1kunIZ/dFheaAaxj30OKypuvm
	 RNwJ0MV9S/t6rNY5eG+Q451ot+iTRCk3YukpsAbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 504/969] spi: fsl-qspi: Use reinit_completion() for repeated operations
Date: Sat, 30 May 2026 18:00:28 +0200
Message-ID: <20260530160314.247219636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 85cc71ba624a9..aee9993fe09db 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -607,7 +607,7 @@ static int fsl_qspi_do_op(struct fsl_qspi *q, const struct spi_mem_op *op)
 	void __iomem *base = q->iobase;
 	int err = 0;
 
-	init_completion(&q->c);
+	reinit_completion(&q->c);
 
 	/*
 	 * Always start the sequence at the same index since we update
@@ -912,6 +912,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_disable_clk;
 
+	init_completion(&q->c);
 	ret = devm_request_irq(dev, ret,
 			fsl_qspi_irq_handler, 0, pdev->name, q);
 	if (ret) {
-- 
2.53.0



