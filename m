Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E703F23A4;
	Wed, 20 May 2026 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299462; cv=none; b=OFPOOmMSKcVSk9ZBD3pcpKH+yYRlTuGzZAKg7GR99L6/tuZchai3A52hKIWoFJO8L9MuYeQaRzKkECBShp8ldZ6lss/Ts2xERRQ/Jmf2dv0Bm+sMe2GM2X0Ayd8ifSdavF7v8ij5q5UBl3K63PkGnvBJkpKOvUR966A6aiKsQkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299462; c=relaxed/simple;
	bh=sZtTUeGnzrH0BPLLI0ucZvnZESmi2JxuF9mSS7wzdRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/HDf8xihCdHkpRuCaS1aK1+dDmuDQttcxpFnwH6V7M/1QYNrivWicoSCkf9SlPweq8xVxv0WqU3D5Svqe4ucWXRtEdpcE6iHJ96UmC31pn4PmA2oeiPYoOldq4NLgWJdTfR/R1EnxCV3i/WIFZY3TasL/lJedWr1PVc3h2lL/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfONHmQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfONHmQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABEC1F000E9;
	Wed, 20 May 2026 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299460;
	bh=TbIsWLaXJHdzQ2u0oKQEeo208n4qv/qbWIImjfrz+I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfONHmQlkNui+MWuLlAOJOlM+K8bra4WHthfUYAIIfiQ93P2W+JAp9RhZoUyUHow4
	 cK6ovZP1oeYbPRgkRqB11PBqhoTPAmdNh6gJ1M5KQHzZ6Enjo32QuMwmi84ZaqMJcJ
	 ydcKGHREhAnWKOvVNdaCgr/UCail0h5HzQku1YTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 780/957] spi: amlogic-spisg: initialize completion before requesting IRQ
Date: Wed, 20 May 2026 18:21:03 +0200
Message-ID: <20260520162151.475382325@linuxfoundation.org>
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
index 56a6cf8471b9f..970fddbb25857 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -795,6 +795,7 @@ static int aml_spisg_probe(struct platform_device *pdev)
 
 	dma_set_max_seg_size(&pdev->dev, SPISG_BLOCK_MAX);
 
+	init_completion(&spisg->completion);
 	ret = devm_request_irq(&pdev->dev, irq, aml_spisg_irq, 0, NULL, spisg);
 	if (ret) {
 		dev_err(&pdev->dev, "irq request failed\n");
@@ -807,8 +808,6 @@ static int aml_spisg_probe(struct platform_device *pdev)
 		goto out_clk;
 	}
 
-	init_completion(&spisg->completion);
-
 	pm_runtime_put(&spisg->pdev->dev);
 
 	return 0;
-- 
2.53.0



