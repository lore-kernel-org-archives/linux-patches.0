Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D0D2D839C;
	Wed, 25 Feb 2026 06:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002699; cv=none; b=B7n+LL5mcebwZ8Mmy341ONtfMjsrQcXChQulX/sGGI7fJjkHkxKVkyIE7NzQs25wSAVB0EW/F1SyYHm+rq9Yo+xr8Ymh33KbbPXkTQMlexGB3hhAPl5j3GtRqXHUmAGqaydXyps/W78u9NAkJkYYOHc3ccNPlWR0b4stybyWxmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002699; c=relaxed/simple;
	bh=yW4HXEb/BVJHlzacvMcaQpgPhAABFUYIW9RsOaUaulg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XokjwL5uL1ArDfzyi9BHqD8zMS/LSsUhC04tuiqEv040mriTgn+3LMeeVSsbHPTBC2PQGia0XerNNJbeAKS/HRsSndXrTnReOInx22C71zMsZUpNbmTUgmq9nU2CJvD1m+hjtJ4xgRDw5y87amduO0V53S6vkCsqGnxIKOMzIkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkOMvec0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkOMvec0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407FBC116D0;
	Wed, 25 Feb 2026 06:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002699;
	bh=yW4HXEb/BVJHlzacvMcaQpgPhAABFUYIW9RsOaUaulg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkOMvec04A9mDB3zcT/iQKwj3ZDdoTajoQWyljfxah5+9AJnQN9fcJ/GEIX+yJnzQ
	 vCZ5Wi9QlVxINz+f1V0EO1YASzYWWcQ0jjUHT7GfambkYz06xiqhX4Fm0w//QTuh6D
	 TPbciRjBBradbIEx42aMYaqdOqU0zJVJd3ndcqXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 496/641] dmaengine: fsl-edma: dont explicitly disable clocks in .remove()
Date: Tue, 24 Feb 2026 17:23:42 -0800
Message-ID: <20260225012400.541291309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 97583c7d51a2e..093185768ad8e 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -915,7 +915,6 @@ static void fsl_edma_remove(struct platform_device *pdev)
 	of_dma_controller_free(np);
 	dma_async_device_unregister(&fsl_edma->dma_dev);
 	fsl_edma_cleanup_vchan(&fsl_edma->dma_dev);
-	fsl_disable_clocks(fsl_edma, fsl_edma->drvdata->dmamuxs);
 }
 
 static int fsl_edma_suspend_late(struct device *dev)
-- 
2.51.0



