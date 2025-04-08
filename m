Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF63B26B961;
	Tue,  8 Apr 2025 12:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116562; cv=none; b=jfyYNXCfx+um/vRnnAYizq6Yx43I5H+E8nkSuiHOc5h2RZrBPwoAMnJ/lsPDCrcHMZryOs55FJNPuR3WSwNUZDF1ctejPzGMQsgq89BjTcf7O5eq/yzHc+/JHIuQ1P+V2KYO8qdM9kSS4rDjP7tl9I2LFFgM5XqFDVgbRtv0kls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116562; c=relaxed/simple;
	bh=WUKT7pDTHBVA+p75P90PLNRhT7YZfuKlV4IKmqYoMR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmxcWvOGxgb4LBoiRokA3/Oq6/rDrc6ec1eF/v3k7++N+fpzCI7HnEF1CgocpSpcDjSOuVsTjd5AxaggbalgCCDxrnaZSehnz391ed38rQjot9SNq7ehw2s3fgR5oiu1rePekPHfzEnax/SHoW0DDls+PBlvpknwS+cKjwMt7jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V808kqmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V808kqmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B729C4CEE7;
	Tue,  8 Apr 2025 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116561;
	bh=WUKT7pDTHBVA+p75P90PLNRhT7YZfuKlV4IKmqYoMR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V808kqmqn+a8mEUnTvlw1zTKNPnSjRZLTYBw5ruxD9EwSZXVds+JH+qnpi82Zdvfa
	 SO3NiLp1M6bEqkg032Tm9NchTHKgOvBw4W9QeWgZETYHPsg5HnY6S5/WaXVBIpcdlU
	 8rBOpSOufHPzLACa3m0SnVYrUIkR5AqHCefII3qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/423] dmaengine: fsl-edma: cleanup chan after dma_async_device_unregister
Date: Tue,  8 Apr 2025 12:48:32 +0200
Message-ID: <20250408104850.073717846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 70cb7fda757a9..db5f06b8575db 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -699,9 +699,9 @@ static void fsl_edma_remove(struct platform_device *pdev)
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



