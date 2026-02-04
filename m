Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D698A28853A;
	Wed,  4 Feb 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217387; cv=none; b=H4xALg8vmEBPBVug6FK1GtBaz9D4jACdyHZK5ARzruXSxI7yLMZfGa4jgIANCckcWQ47nz+bsDG2trC0Q/qcBsuLHoYePK2tw3fMtSB4UoipMNB1dbtDmpnZv2azYetz3mBd0uYs2jZUM8FVMIHdhzmhDjr6rTY/8vFzSP9QD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217387; c=relaxed/simple;
	bh=CZ/z1wxChZnufxPQRYZO11LqyTh30R+NoBPKYgpMncA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1DdYkomNA9fEKpB67w9aKDAjVxa+2b5/MmBoUu+/PtTX+nBALj0I7f7NFz5aoiMx98ATm0uU5l8fdV5kF6KuNysd3bQm8kxaY+ieohNwUvokUyL3TNjQIIgSAvKnSLTQiu7gnktBwnlmpt18VgwjT6lmdvUx+VMXtqIFKkNlL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKSSbiOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKSSbiOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1282EC2BC87;
	Wed,  4 Feb 2026 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217387;
	bh=CZ/z1wxChZnufxPQRYZO11LqyTh30R+NoBPKYgpMncA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKSSbiOZj4jlUAuEhRrwLDStN40aHFVJGXKWRnXTz5Xgv7z6l/Q1Khpz9e94m8a+p
	 6SjBPnUb57xHA8CChb2ryTbhy00neuX6SIkTCJoQjtFUt837Egqq2hc2RJgJ+wi7e1
	 9PgR8lH6pHVi+JybneoqMGGWcq9XYhvb5jaFirVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Johan Hovold <johan@kernel.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/206] dmaengine: stm32: dmamux: fix device leak on route allocation
Date: Wed,  4 Feb 2026 15:39:56 +0100
Message-ID: <20260204143904.148929349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -88,23 +88,25 @@ static void *stm32_dmamux_route_allocate
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
@@ -131,7 +133,6 @@ static void *stm32_dmamux_route_allocate
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", i - 1);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "can't get dma master\n");
-		ret = -EINVAL;
 		goto error;
 	}
 
@@ -158,6 +159,8 @@ static void *stm32_dmamux_route_allocate
 	dev_dbg(&pdev->dev, "Mapping DMAMUX(%u) to DMA%u(%u)\n",
 		mux->request, mux->master, mux->chan_id);
 
+	put_device(&pdev->dev);
+
 	return mux;
 
 err_put_dma_spec_np:
@@ -167,6 +170,9 @@ error:
 
 error_chan_id:
 	kfree(mux);
+err_put_pdev:
+	put_device(&pdev->dev);
+
 	return ERR_PTR(ret);
 }
 


