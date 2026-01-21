Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054133A9E5;
	Wed, 21 Jan 2026 18:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019641; cv=none; b=clFxpuxjGifL+NqDH/9rqXdFFpSn1B6FeQTxTdKt4yg9SlpGGnqg7hZSLde2OzF/E+NOiAiON7lKfFcmr8D7t58A9NIUIuN1Bm1wlvlCrJvyriP6i8iJerM6An0UPJlAK1JvxtydvFlP5JTxHSsj+5wSQpWq0nECNLggJRhh0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019641; c=relaxed/simple;
	bh=GHZFzdeFxI/OfH96HTTgCmCxvp34mnCr0Ar3DWa2SDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGr11mfx3P1GO/FaZdbVp/B9R+HycStlwpQTwUeyki4tCW4kdkMDiF3n7ohXft5Cvtd19+m7mugA2gueGFk/FOyGtVl8wmdIAB7CyyMPYowbm/6dBYXdWK4bufownT5F71UdoZVZOHepdEPr/7DErAsaNLWepX8v2O2drGAlFec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iRKZN9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iRKZN9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4C3C4CEF1;
	Wed, 21 Jan 2026 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019640;
	bh=GHZFzdeFxI/OfH96HTTgCmCxvp34mnCr0Ar3DWa2SDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iRKZN9DfPjHBjQ4vmR0ojlwMgH238J4wIxPl4W+Vkv5NlBZcbnkbKKbz58mk4LRS
	 SPVxLtmRC2sxW7vNHdnrBP3fnM8KZFkzi1MWuI8BmY54aITLBxeOUoqvGYi28WfIHw
	 Ftb/V3POaLrlEkHf9uEoIQVQvFQX5wMGVO3wXyVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/139] dmaengine: omap-dma: fix dma_pool resource leak in error paths
Date: Wed, 21 Jan 2026 19:15:05 +0100
Message-ID: <20260121181413.505954496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6ab9bfbdc4809..d0c2fd5c62074 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1808,6 +1808,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 	if (rc) {
 		pr_warn("OMAP-DMA: failed to register slave DMA engine device: %d\n",
 			rc);
+		if (od->ll123_supported)
+			dma_pool_destroy(od->desc_pool);
 		omap_dma_free(od);
 		return rc;
 	}
@@ -1823,6 +1825,8 @@ static int omap_dma_probe(struct platform_device *pdev)
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



