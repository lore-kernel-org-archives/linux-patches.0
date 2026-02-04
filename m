Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE59280A3B;
	Wed,  4 Feb 2026 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216202; cv=none; b=bGH1D4okaE6gk/O+OxtRJWuxiU7jThsc5VKGzzC0ljgZpuLD0jNQIFeIn/lCS4Xdylbx1RxhfSPJdMCfCerkCAx1lCAtwkfsucKpkYliD6fYP41NDq1se6qHxuoo+rtWcvE4V7ELCHRRXc2+aFl6WTHY4S1YfNw63JFuUeNHEwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216202; c=relaxed/simple;
	bh=04t4UzSMDHRoWrv21fmiH6JWSuMM984bS4f6LXajl3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdMD4JzTKA11zrr+9w3EfLDQoB8V4RQoGGEDDcLXY+z996DaR9mm+07JLZP9/abAEqyOCEzAS/89QZmzsvCaj54bboClIhN6uhgh4X8pNKxN7LcAjxd6YfkiW5EiYnx65Qp7gQsmdq0DOER6nb0qeDTTb7aSEwqpXJX+BjzA5vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwlDC5jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwlDC5jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841E5C4CEF7;
	Wed,  4 Feb 2026 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216202;
	bh=04t4UzSMDHRoWrv21fmiH6JWSuMM984bS4f6LXajl3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwlDC5jEpluKWhP51MQsXVpY6DrhksChPZ4WE8ia07W5EFXzIRXl01s3kDkabPnsn
	 XmJWApbF8J6nXW8UCZT302N4XrZsb1SO8Eo68rLVhexTXXmwNZW2LfbmCRbXIUrKr6
	 xBkdnRsqbCM766iazLA31mi9B+D1k3SEpU+YFNPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/161] dmaengine: omap-dma: fix dma_pool resource leak in error paths
Date: Wed,  4 Feb 2026 15:38:01 +0100
Message-ID: <20260204143852.420325645@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2e1136acf8a8887c29f52e35a77b537309af321f ]

The dma_pool created by dma_pool_create() is not destroyed when
dma_async_device_register() or of_dma_controller_register() fails,
causing a resource leak in the probe error paths.

Add dma_pool_destroy() in both error paths to properly release the
allocated dma_pool resource.

Fixes: 7bedaa553760 ("dmaengine: add OMAP DMA engine driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251103073018.643-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/omap-dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/ti/omap-dma.c b/drivers/dma/ti/omap-dma.c
index 268a080587149..6c6a34265b063 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1803,6 +1803,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 	if (rc) {
 		pr_warn("OMAP-DMA: failed to register slave DMA engine device: %d\n",
 			rc);
+		if (od->ll123_supported)
+			dma_pool_destroy(od->desc_pool);
 		omap_dma_free(od);
 		return rc;
 	}
@@ -1818,6 +1820,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 		if (rc) {
 			pr_warn("OMAP-DMA: failed to register DMA controller\n");
 			dma_async_device_unregister(&od->ddev);
+			if (od->ll123_supported)
+				dma_pool_destroy(od->desc_pool);
 			omap_dma_free(od);
 		}
 	}
-- 
2.51.0



