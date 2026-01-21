Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4A538B9B2;
	Wed, 21 Jan 2026 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020481; cv=none; b=P6sZMHzQTwxFe7cUBC6wGmag30tBBSsuR/h658iEPPSq57YZfbyWKV+RNL9jm9ORfM+JeBzoIIiIjnq4m8ZHyrjAEno44bV/bAgNJJZH68f7YdWAs5Cs+eV8ramrNhMlH4LLdrND5Qm3PVyHm4n4bjXolxsrP3SypRitL5Om6lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020481; c=relaxed/simple;
	bh=gbUmyJgaNoecw1O7E8dSI7x3A740ljcdBmCPOUsAvM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwFEZQvwitCIsMJCB7p5CNcH10e6fZERAogSvdPmtDKweG6AOVt6xryUsoHRLH0Q2/ykyBCP+CeI0xCQRPGehFblmEo46I84o4IkIJ8LLsmzXgXqulgSjs7ERJIbLn1v4KpaUA8HKOY7FQtwwDyagei97o+ikqCITsv/Dm4o8J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty4WhE5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty4WhE5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955C2C4CEF1;
	Wed, 21 Jan 2026 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020481;
	bh=gbUmyJgaNoecw1O7E8dSI7x3A740ljcdBmCPOUsAvM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty4WhE5/iAk5AEMDvRf7a6Tbyiv8TfR4OoZFaztWyTramma2vC3vTUADiFaO/TiLO
	 +K7Fvt1U9+xRGvnzMvJHqC1DZF1/gniKldErydUumd/VTk0nHD0tv8S9r1HW3jl7G6
	 lVDSZYIJu3dKbIzHqJmwGYxMfojMImc+k1VZ47b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 170/198] dmaengine: cv1800b-dmamux: fix device leak on route allocation
Date: Wed, 21 Jan 2026 19:16:38 +0100
Message-ID: <20260121181424.665848759@linuxfoundation.org>
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

commit 7bb7d696e0361bbfc1411462c784998cca0afcbb upstream.

Make sure to drop the reference taken when looking up the DMA mux
platform device during route allocation.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: db7d07b5add4 ("dmaengine: add driver for Sophgo CV18XX/SG200X dmamux")
Cc: stable@vger.kernel.org	# 6.17
Cc: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-5-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/cv1800b-dmamux.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/cv1800b-dmamux.c b/drivers/dma/cv1800b-dmamux.c
index e900d6595617..f7a952fcbc7d 100644
--- a/drivers/dma/cv1800b-dmamux.c
+++ b/drivers/dma/cv1800b-dmamux.c
@@ -102,11 +102,11 @@ static void *cv1800_dmamux_route_allocate(struct of_phandle_args *dma_spec,
 	struct llist_node *node;
 	unsigned long flags;
 	unsigned int chid, devid, cpuid;
-	int ret;
+	int ret = -EINVAL;
 
 	if (dma_spec->args_count != DMAMUX_NCELLS) {
 		dev_err(&pdev->dev, "invalid number of dma mux args\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	devid = dma_spec->args[0];
@@ -115,18 +115,18 @@ static void *cv1800_dmamux_route_allocate(struct of_phandle_args *dma_spec,
 
 	if (devid > MAX_DMA_MAPPING_ID) {
 		dev_err(&pdev->dev, "invalid device id: %u\n", devid);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	if (cpuid > MAX_DMA_CPU_ID) {
 		dev_err(&pdev->dev, "invalid cpu id: %u\n", cpuid);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", 0);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "can't get dma master\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	spin_lock_irqsave(&dmamux->lock, flags);
@@ -136,8 +136,6 @@ static void *cv1800_dmamux_route_allocate(struct of_phandle_args *dma_spec,
 			if (map->peripheral == devid && map->cpu == cpuid)
 				goto found;
 		}
-
-		ret = -EINVAL;
 		goto failed;
 	} else {
 		node = llist_del_first(&dmamux->free_maps);
@@ -171,12 +169,17 @@ static void *cv1800_dmamux_route_allocate(struct of_phandle_args *dma_spec,
 	dev_dbg(&pdev->dev, "register channel %u for req %u (cpu %u)\n",
 		chid, devid, cpuid);
 
+	put_device(&pdev->dev);
+
 	return map;
 
 failed:
 	spin_unlock_irqrestore(&dmamux->lock, flags);
 	of_node_put(dma_spec->np);
 	dev_err(&pdev->dev, "errno %d\n", ret);
+err_put_pdev:
+	put_device(&pdev->dev);
+
 	return ERR_PTR(ret);
 }
 
-- 
2.52.0



