Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CDB2505AA;
	Wed, 28 Jan 2026 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614226; cv=none; b=biMrYSQieuq97pUFRlxGcYfQZGZTOqh1t/Wn/U7HqZmcyYcnRo+UgHUhbG04APQF4CZDXKg5vAKFiGWiCB2fvGIicyPFAJyHh8t3o6lVfxp5E47vVRaz4BTjHGO6XbS1pUUVwIgfkKEXTfEwuiYSoRH1M/BAXYH5+wP9q/K82X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614226; c=relaxed/simple;
	bh=9EiC/meF3rCyrbQ04wwIkmjtaGS5yS/r4p1JCQCCZhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgaaIVS2TFvPIp5t12gANABs72cLR7J9kiNXdGDCPFX6mI0d7qDP6aCMNYbQEeEnkzdwFfaajpn3zTIhKPzjidrzYLNIzkru/X0IT9q2+uwOub2JHZ0wvyH9PLFaCiRJdG7fHfr1Y+oXTHRlsMMcVFURtE/cPv4ke71a1LqaHG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndn32o94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndn32o94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D664C4CEF1;
	Wed, 28 Jan 2026 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614226;
	bh=9EiC/meF3rCyrbQ04wwIkmjtaGS5yS/r4p1JCQCCZhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndn32o94ra6c0JqYOq3/uK6FfQIERkq0FyeKsNzkxKTVC0356xGPksYEvf4/ut7f/
	 0T+7uYGyPmcc8DYd22EF69drFSHe4CaIjZE3mvFregQnJINiUzkbK1ySotBsXw072k
	 4r2OJcNR6Sfg2tD0wRo7g5HxyEb1vhMluokHBSFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/254] dmaengine: omap-dma: fix dma_pool resource leak in error paths
Date: Wed, 28 Jan 2026 16:20:17 +0100
Message-ID: <20260128145346.179348455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf96cf915c0c7..efc9093707e5a 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1809,6 +1809,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 	if (rc) {
 		pr_warn("OMAP-DMA: failed to register slave DMA engine device: %d\n",
 			rc);
+		if (od->ll123_supported)
+			dma_pool_destroy(od->desc_pool);
 		omap_dma_free(od);
 		return rc;
 	}
@@ -1824,6 +1826,8 @@ static int omap_dma_probe(struct platform_device *pdev)
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



