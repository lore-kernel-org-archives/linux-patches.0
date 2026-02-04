Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E67A2D8777;
	Wed,  4 Feb 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217640; cv=none; b=kREgTDX2qj5cxwi1o8ALK3nqxFStWWyzgIpZzrO9W4pRP/SVPXmJj/ezdpy1Jzx+6LJ04+UfCi5Xvx8Z+LNsyBnuMzFmZxVm7yS+P16DgqtT8BDi9r+fTSauYUv1F4/qDhFJ51M/LNqzcCE8IX8nBgwfx/8QlEPwPpuvqOpJVZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217640; c=relaxed/simple;
	bh=0gi683dkS28fucb8huYn4zGoWbxcR+Qzup/DgeUGJI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opHhYUEiTs/MV7V+LWiS34xc5lXiYmnk4b9HgruadS/R9D68f0NmuRlTqzPjqX0xzMLAFt8DMxNg4T0HMlO/W0gEbvERidhopCATQypyMook6oQNOmgi0Wy/8KCcUg5Uy2cZ4q+lnQtXwrj3uILdWXwp09fBCoKPJsWbMRyjsC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJ3UbItu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJ3UbItu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8CDC4CEF7;
	Wed,  4 Feb 2026 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217640;
	bh=0gi683dkS28fucb8huYn4zGoWbxcR+Qzup/DgeUGJI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJ3UbItuvSAm3vlJwsi3OWHRYGVBm0UUw9GVuVzMVMlMo1j9A2FFDP/zzKVAAqo0P
	 T6v0Krde1sa1Sjb8pCll7ykX2GXODR1A8R8WJZI3B/XikIDD47P41ZggRfJ2JjJAJV
	 0tXY+LQAFCmTjFZwzncXQdmh4Ln+ILnJEanWt2z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 075/280] dmaengine: ti: dma-crossbar: fix device leak on am335x route allocation
Date: Wed,  4 Feb 2026 15:37:29 +0100
Message-ID: <20260204143912.354869170@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4fc17b1c6d2e04ad13fd6c21cfbac68043ec03f9 upstream.

Make sure to drop the reference taken when looking up the crossbar
platform device during am335x route allocation.

Fixes: 42dbdcc6bf96 ("dmaengine: ti-dma-crossbar: Add support for crossbar on AM33xx/AM43xx")
Cc: stable@vger.kernel.org	# 4.4
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-15-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/dma-crossbar.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -78,34 +78,35 @@ static void *ti_am335x_xbar_route_alloca
 {
 	struct platform_device *pdev = of_find_device_by_node(ofdma->of_node);
 	struct ti_am335x_xbar_data *xbar = platform_get_drvdata(pdev);
-	struct ti_am335x_xbar_map *map;
+	struct ti_am335x_xbar_map *map = ERR_PTR(-EINVAL);
 
 	if (dma_spec->args_count != 3)
-		return ERR_PTR(-EINVAL);
+		goto out_put_pdev;
 
 	if (dma_spec->args[2] >= xbar->xbar_events) {
 		dev_err(&pdev->dev, "Invalid XBAR event number: %d\n",
 			dma_spec->args[2]);
-		return ERR_PTR(-EINVAL);
+		goto out_put_pdev;
 	}
 
 	if (dma_spec->args[0] >= xbar->dma_requests) {
 		dev_err(&pdev->dev, "Invalid DMA request line number: %d\n",
 			dma_spec->args[0]);
-		return ERR_PTR(-EINVAL);
+		goto out_put_pdev;
 	}
 
 	/* The of_node_put() will be done in the core for the node */
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", 0);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "Can't get DMA master\n");
-		return ERR_PTR(-EINVAL);
+		goto out_put_pdev;
 	}
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map) {
 		of_node_put(dma_spec->np);
-		return ERR_PTR(-ENOMEM);
+		map = ERR_PTR(-ENOMEM);
+		goto out_put_pdev;
 	}
 
 	map->dma_line = (u16)dma_spec->args[0];
@@ -119,6 +120,9 @@ static void *ti_am335x_xbar_route_alloca
 
 	ti_am335x_xbar_write(xbar->iomem, map->dma_line, map->mux_val);
 
+out_put_pdev:
+	put_device(&pdev->dev);
+
 	return map;
 }
 


