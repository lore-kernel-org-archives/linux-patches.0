Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F33D3F54DA;
	Wed, 20 May 2026 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296825; cv=none; b=ohv7DfgXVAHBh33CsfPszyeU+P6aaC4yFkNXCcpXbkNXdlsmlFjhRvv47UQ7q2PLkEUJMWdAczB33D1+0OrYak1MuEoXFWvVnhh5+zpCK6irDZSFHOb8mx0szn0BlLMiEocO6YtXCi/AuH90paza3T45xOdJQFeKtLIgFwRaZ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296825; c=relaxed/simple;
	bh=Avfau9X31vKvl99SV6FBXTtR8ecWdyTtPbKbL6+max0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qe4DcNIEwHkksOWLq4w3BWmGb4Z1KfkZEkr5usIe+qo0WFli3/oPg7vTt4Z2YB6DsxeQl0XOymWmC1ppXlE4sDJslTHikyOs8z2dJRKAqaYl1rRuUa81v6I3oYL/g97/tLdJsOjUyy8c+YQKvr60HlSyQ1TaSaXPW65xGRRxQ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcqwhWvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcqwhWvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9921F000E9;
	Wed, 20 May 2026 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296822;
	bh=T4s1S0jiy/bX07vFfu5kvxJkpajs0WgcZ/NOr253BfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcqwhWvs++psD8/4MPlSr5bGHlzvJoHO/ThXuuHsjX8kvuKD+gNXgCRBRryOFk82t
	 gN9bh2M7seL7350vs4OCffx2UXnms4J99qG/PYD5YLzdtfp6JS4cFujCrPiw/QKwHj
	 prQOBWFZ+/PGb6lonvY6IAX3VN1v7aSWNETcAAFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0944/1146] spi: amlogic-spisg: initialize completion before requesting IRQ
Date: Wed, 20 May 2026 18:19:54 +0200
Message-ID: <20260520162209.596814062@linuxfoundation.org>
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

[ Upstream commit 8d0189c1ea98b56481eb809e3d1bdbf85557e819 ]

Move init_completion(&spisg->completion) to before devm_request_irq()
to avoid a potential race condition where an interrupt could fire
before the completion structure is initialized.

Fixes: cef9991e04ae ("spi: Add Amlogic SPISG driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260428-amlogic-spisg-v1-1-8eecc3b446d6@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index e15d7112bb55c..0280868f7edf5 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -794,6 +794,7 @@ static int aml_spisg_probe(struct platform_device *pdev)
 
 	dma_set_max_seg_size(&pdev->dev, SPISG_BLOCK_MAX);
 
+	init_completion(&spisg->completion);
 	ret = devm_request_irq(&pdev->dev, irq, aml_spisg_irq, 0, NULL, spisg);
 	if (ret) {
 		dev_err(&pdev->dev, "irq request failed\n");
@@ -806,8 +807,6 @@ static int aml_spisg_probe(struct platform_device *pdev)
 		goto out_clk;
 	}
 
-	init_completion(&spisg->completion);
-
 	pm_runtime_put(&spisg->pdev->dev);
 
 	return 0;
-- 
2.53.0



