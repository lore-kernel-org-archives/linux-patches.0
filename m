Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B310B3D2FF3;
	Wed, 21 Jan 2026 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020515; cv=none; b=XPeMwLGuroffnoQKjrSph5rzdmoknM8i5g2H+zdPXX10rb3q9hxUMX03jfV6ZiYtAlYIpRDGvDWQ7xEfw9C1DTYzpz9Ey07SP4AmMf/x0/Vo7U67Qx1+ygMTY5DQq8sXN+bSPKCNIQM0VnD6wTqCXXPZotrsSKWRQbRv22/D4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020515; c=relaxed/simple;
	bh=BfXN6PWF+OOyRjCK3FXSfhaB8FNzlJNkD/op3vtyo2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAVCzX5LpnhpJvovNYv5mopjK8YgReXHoXJD2tJZYjsAp62UvPzNXKKNtgoslB6JhamUjNF7+4XDGPTraMPXTvPSpRYLYj2ChFKUzWEs2Dy67CXzDtl2x/4J4QQR9rVdOMAzI0UrMdBDF01nIjOp9CRP0ZTEANeChycURX2RU5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYYOq53n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYYOq53n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36D7C4CEF1;
	Wed, 21 Jan 2026 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020515;
	bh=BfXN6PWF+OOyRjCK3FXSfhaB8FNzlJNkD/op3vtyo2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYYOq53n/EPIgdO38/n8ue2efj1uEUDFjxv5p8TBElmzL6MMLRV3I5HefeWhe3JvL
	 K+D0YwVgrST41ncVQaNQOuH1K7rwK4rhn0o2gagpsEv3QrhNox4nq/vLBdm5qtXVvR
	 6o5wNn1UcYYXgFJK7jrX2mNOCJmNfmjkUXNfXbEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 182/198] dmaengine: ti: dma-crossbar: fix device leak on am335x route allocation
Date: Wed, 21 Jan 2026 19:16:50 +0100
Message-ID: <20260121181425.101631727@linuxfoundation.org>
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
@@ -79,34 +79,35 @@ static void *ti_am335x_xbar_route_alloca
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
@@ -120,6 +121,9 @@ static void *ti_am335x_xbar_route_alloca
 
 	ti_am335x_xbar_write(xbar->iomem, map->dma_line, map->mux_val);
 
+out_put_pdev:
+	put_device(&pdev->dev);
+
 	return map;
 }
 


