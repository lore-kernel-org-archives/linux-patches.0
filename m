Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47A23D669A;
	Tue, 16 Jun 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632409; cv=none; b=H1ETSjwTzWq2jFRyf3p4YseiHgOzDDLxIIHpZKhHVqm0vn4Nv1kSHazQKPl+RIhYqJkcewfNDj13xA/1TZEDg4tuEwstjAaj5v1AssSQMfu9v61dhe1dENjgkjFd0+PdFp8VoMVxBVgaELtSoM2zL2KkkdYdo6ik/ppoL8OSKq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632409; c=relaxed/simple;
	bh=xNHuCgiaH3/+noeRukcgo8d59qU/glc4ICv2Q5WjrD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RS1vj8QS1w0Bd7GX84GqMjlUltDrzuQAcqvR38Fmc7MQ67VlkJYvCeHDAPVCjoN0nCjk6yYwxLNIU9gMzz1u97f1mn3QnTRqIAigAJUPJIkY5XTlo4gjHqSd0HTz6Bxs3O6g/1IC+VMvh+GOx3XHh8kAp/XmCmPUfQqmaR18+NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOEj4epU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOEj4epU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2751F000E9;
	Tue, 16 Jun 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632408;
	bh=eyEDhLtxMztfLbT3c7LP5zBbNQjL0vkG7d5XdWgX7vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOEj4epUU+w99d7t3rkvAs4Asu/qrF/r5SIboz1O9kMOrlxbBBnRGAJrgMsTi/EIF
	 U/M8onkVadllTOz6P+PGZcX2oTOZ8NiApPdnZkleiiseC8LRQmeFovayxgeBm97aSF
	 9HJHnSX/R5HGLhjdJ/sq+EF4h8dl0kSTuZI8+6hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keiji Hayashibara <hayashibara.keiji@socionext.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 404/522] spi: uniphier: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:11 +0530
Message-ID: <20260616145144.966899825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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


