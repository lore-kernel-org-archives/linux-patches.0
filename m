Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C12346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302241; cv=none; b=n6PXbaPI06X/6LPyA411gIjByMMdsJ98ib37cvew2NJ4RIbc4gCYueS2slhgreXo4NHSBIc+817G4AJ/wFfgrp5kfyH9Y48g1iMPCegvQEfeVIAjTug0ydAPd7Gd/5IgOgNYJ6aZFGoP9lVJk0naeBM2uAmCOmLqZZSYFyW7GuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302241; c=relaxed/simple;
	bh=oARXlMaEGs+eko5A11pni1Ur1Wgx8zfLgbhPlzSSEL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWppoQfHzvPKRgSUDvtMiI96ntmsWvy3Q1DvCQRNoEpoj63N1pYgZHS/p1rCCQjMvXDyuNkWskSj8ek9Y2XDGiSRIFuu2/h5vhmhnZXa3KbAXQyLLBhfes+ryZBZroCDfxm3s8IAH5X27awbBIwNS2h71za4s0YPeaXZFmhpvj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6vAbURB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6vAbURB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF634C116D0;
	Sat, 28 Feb 2026 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302241;
	bh=oARXlMaEGs+eko5A11pni1Ur1Wgx8zfLgbhPlzSSEL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6vAbURBskr55IK7zHUskrmfjrBEgtVpEB2ekA7GOeD0FhcyIc6GFWOgcTvfcWwsi
	 EiJVScvyL69D2u64r94f1+slj6+hvE78dfadIzQt+FxmYTxV7/LXTHa6rYq7J5AI39
	 N5YvXWiImLo2MBgNBvKQPuD5xlOpKw7aDy5lA/Pvsukmb8tB7GdsZZGLU0JfKPAsEl
	 JvcdQHAYHGRpjqdx6eYXmOsxn85lk2BQ+23Yl7nGyadkaKwdIZlkHNgZ6gNAniabL0
	 p3GE7tUnURLefPRuL6/Ev4DX+B5VUa7t9XDHbaCaW0czE2FOqDlxAR076W76MclCuy
	 Q2MIYuHr2f5Lw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jared Kangas <jkangas@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/283] dmaengine: fsl-edma: don't explicitly disable clocks in .remove()
Date: Sat, 28 Feb 2026 13:06:35 -0500
Message-ID: <20260228180709.1583486-253-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 7dedd85d74d9b..34b194759d218 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -678,7 +678,6 @@ static void fsl_edma_remove(struct platform_device *pdev)
 	of_dma_controller_free(np);
 	dma_async_device_unregister(&fsl_edma->dma_dev);
 	fsl_edma_cleanup_vchan(&fsl_edma->dma_dev);
-	fsl_disable_clocks(fsl_edma, fsl_edma->drvdata->dmamuxs);
 }
 
 static int fsl_edma_suspend_late(struct device *dev)
-- 
2.51.0

