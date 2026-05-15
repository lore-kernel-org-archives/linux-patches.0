Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E923BB11C;
	Fri, 15 May 2026 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861722; cv=none; b=ib9cTHq/VgoTdRwr0XJFqxJbOF3jy2tExJjtVrpHjfaI3RiFheL5XR/Di8AJnSZqOOZbehFVhLQ5We6jFnoBwl1XrUemurYcVtaV4cFT5ucVMrWMwBL8+B16m9W1A5mrqf4gkq3FRwMPn/A3ut8IxcDhjcK2LVRSDe05ZpWJ0ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861722; c=relaxed/simple;
	bh=obHWxQmiauvKR5bSutOXt62DsjJ7A71fV+JCaeP/j18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai3EhTgXchydt4u6XND/CbYHjUGcgE2yh1Weba/he2eiuIFY5GZ5WurXYFlRKgxNq/ygxwWj/+PK73c3O6OLwGWG8nEVosToWybj2bjSVnv3FsndH+ALwKiLcv2uJZ8oVVRxvvOM2ElRsk7l4KyPI5OdLGkLZXggONhxkR6G/kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWqvDkZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWqvDkZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD692C2BCB0;
	Fri, 15 May 2026 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861722;
	bh=obHWxQmiauvKR5bSutOXt62DsjJ7A71fV+JCaeP/j18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWqvDkZLPrhv+qdwa8h+BX9FDvOn5ddcFvKKPzr+p5tmqinVoUciB0ZPs3ccNdD6/
	 6M2kpUEfPiO2H1f4VB11Lr0zHyrEKvWfIkRPXK+lga9TOFqUKVHxI2v6LI5EjAu7Ow
	 4J4zKA6359v4S69/1pIK6Uvc7kzFN8kT3l9nI0WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keiji Hayashibara <hayashibara.keiji@socionext.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 439/474] spi: uniphier: fix controller deregistration
Date: Fri, 15 May 2026 17:49:08 +0200
Message-ID: <20260515154724.583941109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

[ Upstream commit 0245435f777264ac45945ed2f325dd095a41d1af ]

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Note that clocks were also disabled before the recent commit
fdca270f8f87 ("spi: uniphier: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: 5ba155a4d4cc ("spi: add SPI controller driver for UniPhier SoC")
Cc: stable@vger.kernel.org	# 4.19
Cc: Keiji Hayashibara <hayashibara.keiji@socionext.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-25-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -747,7 +747,7 @@ static int uniphier_spi_probe(struct pla
 
 	host->max_dma_len = min(dma_tx_burst, dma_rx_burst);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_release_dma;
 
@@ -772,10 +772,16 @@ static void uniphier_spi_remove(struct p
 {
 	struct spi_controller *host = platform_get_drvdata(pdev);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	if (host->dma_tx)
 		dma_release_channel(host->dma_tx);
 	if (host->dma_rx)
 		dma_release_channel(host->dma_rx);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id uniphier_spi_match[] = {


