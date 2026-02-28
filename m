Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87433A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301919; cv=none; b=Ec7dWaZx9wru98D4W7m6m0E3kL7EJUCpYZTM1l/DJxx/OWbds+TdnD9IjLmBXIwsFDTmJbmErZkqLT1UA0rs0wJCIBTjUlID5KwdxJ+VyaO/Pltq8IC4n1lSz58i53YfpjT9lP+EG9ciu9bvt8eUFFP5BznqdspePtwohnHew58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301919; c=relaxed/simple;
	bh=co4JHvBozU7WZM6Uf50Rk40xdfS4dNgPmhGfavnVKSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD6HyQqVtaKaTANPnkcIx/c1LqEk/4uXwwmO41fv9EQ4HYhYap47F/8mtd1X8NnlW1V2U8Q3VilCtWpGi2sFryPjaH0KdX5LF+CBKupG4LYqYd3qs5MfM4BTF5iJK2fENL6Zr9/yZIjcwrjH3ztNW7p4s+yf8E6OOTkHFibsTVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noBPBvt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noBPBvt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99E4C19424;
	Sat, 28 Feb 2026 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301919;
	bh=co4JHvBozU7WZM6Uf50Rk40xdfS4dNgPmhGfavnVKSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noBPBvt2s//YXjRutImSQrSzCtc29pAmD5jLX2/XSP8sjMGchXy9ZfJUj9yq5z65F
	 UBKXMxtGKdXdC2Z6qohqIH89LgkFPZKwhUy2GyHno9PITlJzpBTXteyEpeXlBTlf4H
	 h3naactgF3hY9m5q5fsQCLVlpoCpKxI7YvF5kcoWlWPEPkzRGJItm/Mmdeeef++oRZ
	 V8kHesj4FUWPOscvQ/irzgluQiXJVNEGBxd38OKOSzQ54WBmyQlwKl07jKfPey+dT+
	 9PO/JeyJ4or//HKtSS53eFXKW/fUQPQBAMcnGmVLfLzUDA5F+VCH7rOlK0r8oXSB9v
	 /rMai36I2QAaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jared Kangas <jkangas@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/385] dmaengine: fsl-edma: don't explicitly disable clocks in .remove()
Date: Sat, 28 Feb 2026 12:59:34 -0500
Message-ID: <20260228180011.1568201-352-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 666c53e94c1d0bf0bdf14c49505ece9ddbe725bc ]

The clocks in fsl_edma_engine::muxclk are allocated and enabled with
devm_clk_get_enabled(), which automatically cleans these resources up,
but these clocks are also manually disabled in fsl_edma_remove(). This
causes warnings on driver removal for each clock:

        edma_module already disabled
        WARNING: CPU: 0 PID: 418 at drivers/clk/clk.c:1200 clk_core_disable+0x198/0x1c8
        [...]
        Call trace:
         clk_core_disable+0x198/0x1c8 (P)
         clk_disable+0x34/0x58
         fsl_edma_remove+0x74/0xe8 [fsl_edma]
         [...]
        ---[ end trace 0000000000000000 ]---
        edma_module already unprepared
        WARNING: CPU: 0 PID: 418 at drivers/clk/clk.c:1059 clk_core_unprepare+0x1f8/0x220
        [...]
        Call trace:
         clk_core_unprepare+0x1f8/0x220 (P)
         clk_unprepare+0x34/0x58
         fsl_edma_remove+0x7c/0xe8 [fsl_edma]
         [...]
        ---[ end trace 0000000000000000 ]---

Fix these warnings by removing the unnecessary fsl_disable_clocks() call
in fsl_edma_remove().

Fixes: a9903de3aa16 ("dmaengine: fsl-edma: refactor using devm_clk_get_enabled")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113-fsl-edma-clock-removal-v1-1-2025b49e7bcc@redhat.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 4794d58dab556..540b47c520dce 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -708,7 +708,6 @@ static void fsl_edma_remove(struct platform_device *pdev)
 	of_dma_controller_free(np);
 	dma_async_device_unregister(&fsl_edma->dma_dev);
 	fsl_edma_cleanup_vchan(&fsl_edma->dma_dev);
-	fsl_disable_clocks(fsl_edma, fsl_edma->drvdata->dmamuxs);
 }
 
 static int fsl_edma_suspend_late(struct device *dev)
-- 
2.51.0

