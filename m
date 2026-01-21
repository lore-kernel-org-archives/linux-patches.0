Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53762364EB2;
	Wed, 21 Jan 2026 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020595; cv=none; b=n1DLuR9alJvcUBN6c/YZgMldoHjVqYX/RNG8imaclX5Hk/gpoLb5xcmWFUBEjc/sKKytpYXsCnh7nxPl9JRDyqaDJrBx9A1kCEf0lXScIBei7EYIJOKyQPgJg/1TeUmFbJh9OhqfkDMhtguZ2YmTMs/6bbBM1DOp2wmRnWAnVPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020595; c=relaxed/simple;
	bh=C+WlxGgHMnIosdc0BUx6vMvMNNKixegea0kwMVjhL8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9uu24Wpusm6gPI5OyzjkJ8/wYsl6RWzjL7GuMavjgKHymVb/W3JZskg8ZtQPtNldq11KnSqD0T1V80Dycg0DYlF63o7kA1WpZv+dAQlqTNESndyDPXh8iotUxxuaCtQ27mJQuEHjv+F5rWsFcarZ1JmPJz8NcjLZdNLAfx0utg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSuR1Ty5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSuR1Ty5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278CEC2BC9E;
	Wed, 21 Jan 2026 18:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020594;
	bh=C+WlxGgHMnIosdc0BUx6vMvMNNKixegea0kwMVjhL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSuR1Ty56yl01aSw3ageRoSXVCLOyj99MGsq89jNklOx/Rn1twxbxFUJEQr9irJNB
	 XlDFuMqRpDw2LkQ0d4I99U5ITMjjiF6cfTKRmWreSiwX7/5hhO4yfkDrl2pKXyVubR
	 Fp3IpSeN1GXPl9oWDbeSEb0fCSVYHIx2dZDHJryE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Johan Hovold <johan@kernel.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 179/198] dmaengine: stm32: dmamux: fix device leak on route allocation
Date: Wed, 21 Jan 2026 19:16:47 +0100
Message-ID: <20260121181424.992861433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dd6e4943889fb354efa3f700e42739da9bddb6ef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32/stm32-dmamux.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/dma/stm32/stm32-dmamux.c
+++ b/drivers/dma/stm32/stm32-dmamux.c
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
 


