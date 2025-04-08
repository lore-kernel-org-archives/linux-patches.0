Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903FD2686B9;
	Tue,  8 Apr 2025 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111593; cv=none; b=VuvD6Zt906sI9cJ8X9B2de6cYhJnVqnUU5tKpxF1g083xe7wsl6wUCTGtjREWxtAxLftNMTaXJWsCZ+laEXOZa1x8EtBfx1EQhsgINTr+EmCa7vzBcv73qan5YFmhcckj4dtn6yEyMeLLgF0KwM5iP7fLsBDsgqpTpwhp5uDSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111593; c=relaxed/simple;
	bh=cJXRXlp2WqI/ikKvGKTxFsIpPTxEH2OOsstnJ5oRg1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fzraj7C/en/xKpzHhTpLNWjwoq3fSTr0VYC3HeQj6obIIystWztV1YW+g0sghSVbSZfo398x5jltaAEWELWrGCw8Zd/fBm0ShqF+JL4L3g9HpTsBBxvwVWcsrNNMHPxWakB11/VzeFkSxu3CEaW7QLWu40qj7etalnlDntPUw64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynUB38NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynUB38NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EACDC4CEE5;
	Tue,  8 Apr 2025 11:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111593;
	bh=cJXRXlp2WqI/ikKvGKTxFsIpPTxEH2OOsstnJ5oRg1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynUB38NAWHWDZ0ca/29OB1dXQsxrjYc3teq7tN8mEkuqKvIzB0Dcl67zHXpZAQSY9
	 OLdADDCzYsUlf/S0Eb8pphLodGIoQ5Cr2Y94D9qdc2xDyQ49p6t2zTG6twdfWlkdkg
	 fGG1EeMC7NXzY88hWDaBAwkC8CvEdbL9Caz7uQLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 487/731] dmaengine: fsl-edma: cleanup chan after dma_async_device_unregister
Date: Tue,  8 Apr 2025 12:46:24 +0200
Message-ID: <20250408104925.604157119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c9c59da76ce9cb3f215b66eb3708cda1134a5206 ]

There is kernel dump when do module test:
sysfs: cannot create duplicate filename
/devices/platform/soc@0/44000000.bus/44000000.dma-controller/dma/dma0chan0
 __dma_async_device_channel_register+0x128/0x19c
 dma_async_device_register+0x150/0x454
 fsl_edma_probe+0x6cc/0x8a0
 platform_probe+0x68/0xc8

fsl_edma_cleanup_vchan will unlink vchan.chan.device_node, while
dma_async_device_unregister  needs the link to do
__dma_async_device_channel_unregister. So need move fsl_edma_cleanup_vchan
after dma_async_device_unregister to make sure channel could be freed.

So clean up chan after dma_async_device_unregister to address this.

Fixes: 6f93b93b2a1b ("dmaengine: fsl-edma: kill the tasklets upon exit")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20250228071720.3780479-1-peng.fan@oss.nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index f989b6c9c0a98..133bdb48d1a5c 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -802,9 +802,9 @@ static void fsl_edma_remove(struct platform_device *pdev)
 	struct fsl_edma_engine *fsl_edma = platform_get_drvdata(pdev);
 
 	fsl_edma_irq_exit(pdev, fsl_edma);
-	fsl_edma_cleanup_vchan(&fsl_edma->dma_dev);
 	of_dma_controller_free(np);
 	dma_async_device_unregister(&fsl_edma->dma_dev);
+	fsl_edma_cleanup_vchan(&fsl_edma->dma_dev);
 	fsl_disable_clocks(fsl_edma, fsl_edma->drvdata->dmamuxs);
 }
 
-- 
2.39.5



