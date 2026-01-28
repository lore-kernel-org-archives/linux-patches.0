Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B038F2DC76D;
	Wed, 28 Jan 2026 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614760; cv=none; b=ozN4J4npON3DmXyyBT0tYeo+dmkNF6gae7oF0iSRu0lLLPQrwQZ6ciYrXReTlDHduL9gQSRMZUcWJtuIDiNvLjcEqu7PNK6Nd034+vmXXK6TSTbP2sJH8d0jq0LECIDL+WYDHQl7xb5pnINHraxQ7RYObNIUDTqQEn4Oh3k7+Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614760; c=relaxed/simple;
	bh=HQ4I+udmuK4eKAKFvoT6RuOgrfY9PuDysVRS0oDBvjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjLKuJg9T2mDB+iGVZwGpZG9bEXJ68m586N3PPjE+ef5WMfJZ1G7JKWGZkiaPuKCxQ9NzvcxhVCRQIckK09C77NLzsKKBmBOTJJO1Yw0SbFjax8VBrrjV9SvXWhFXYMnu1/HOn2WTSB6m30gWEcEExWm3lPIr5wInyFPTms/3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeJHz7Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeJHz7Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2816CC4CEF1;
	Wed, 28 Jan 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614760;
	bh=HQ4I+udmuK4eKAKFvoT6RuOgrfY9PuDysVRS0oDBvjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeJHz7Ir6p+ZSb/VOra+zCzYlabf4IZXvH2fnAuzmp5sHcEXtCh5AblMvAl6YKrT7
	 rGEJOAzHSDB2ZVAZH1xNaoabPHd7v0cMtz/k6Y42HcMi8ITXRuLiwlAT7e6GWjs5JR
	 Tm3o/RLMrruTd9xCzfpp4b9gcmIRSsDvjBUHKoic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Johan Hovold <johan@kernel.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/254] dmaengine: stm32: dmamux: fix device leak on route allocation
Date: Wed, 28 Jan 2026 16:23:29 +0100
Message-ID: <20260128145353.173840695@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit dd6e4943889fb354efa3f700e42739da9bddb6ef ]

Make sure to drop the reference taken when looking up the DMA mux
platform device during route allocation.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: df7e762db5f6 ("dmaengine: Add STM32 DMAMUX driver")
Cc: stable@vger.kernel.org	# 4.15
Cc: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/20251117161258.10679-11-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-dmamux.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/dma/stm32-dmamux.c
+++ b/drivers/dma/stm32-dmamux.c
@@ -90,23 +90,25 @@ static void *stm32_dmamux_route_allocate
 	struct stm32_dmamux_data *dmamux = platform_get_drvdata(pdev);
 	struct stm32_dmamux *mux;
 	u32 i, min, max;
-	int ret;
+	int ret = -EINVAL;
 	unsigned long flags;
 
 	if (dma_spec->args_count != 3) {
 		dev_err(&pdev->dev, "invalid number of dma mux args\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	if (dma_spec->args[0] > dmamux->dmamux_requests) {
 		dev_err(&pdev->dev, "invalid mux request number: %d\n",
 			dma_spec->args[0]);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
-	if (!mux)
-		return ERR_PTR(-ENOMEM);
+	if (!mux) {
+		ret = -ENOMEM;
+		goto err_put_pdev;
+	}
 
 	spin_lock_irqsave(&dmamux->lock, flags);
 	mux->chan_id = find_first_zero_bit(dmamux->dma_inuse,
@@ -133,7 +135,6 @@ static void *stm32_dmamux_route_allocate
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", i - 1);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "can't get dma master\n");
-		ret = -EINVAL;
 		goto error;
 	}
 
@@ -160,6 +161,8 @@ static void *stm32_dmamux_route_allocate
 	dev_dbg(&pdev->dev, "Mapping DMAMUX(%u) to DMA%u(%u)\n",
 		mux->request, mux->master, mux->chan_id);
 
+	put_device(&pdev->dev);
+
 	return mux;
 
 error:
@@ -167,6 +170,9 @@ error:
 
 error_chan_id:
 	kfree(mux);
+err_put_pdev:
+	put_device(&pdev->dev);
+
 	return ERR_PTR(ret);
 }
 


