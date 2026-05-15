Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4D3FF1AC;
	Fri, 15 May 2026 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860503; cv=none; b=IJF2+mCNe7BRRMLy9FmvzsIrNI4nSAHyU7QuE104PQB1ILUJphhgK9UH9xokoOH5BgpQBrh4NjpdTNQ0FGPXx1IzOg1RfOQbT8ZYnzqU0n7J/Xtmqnm6BOzCJonnc9gxe2Lb8FltkUFWpvimOGTFQRONyIuD4MAUD1ufL/Ifg8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860503; c=relaxed/simple;
	bh=m/owKDMFn3JZZdEFKUbdWDxqL1x34rzNQ+7qf1Z57HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDz8rhEs9hIm5Ss731g+KOlpHJFkKHLBYoGhHilSaTVrD0Nxxw97Px9mqxZk+c1J3NbJGmNEC/VUpQky2FiaGB1g21ZJX7cRk2SY1qv5RymcYZ6CHMY0HZW1R8wOrypZrQL36oStHuM0ky/ku8qhMk7XZMJ1wouePAZOrAwhvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5S67yMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5S67yMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20632C2BCB0;
	Fri, 15 May 2026 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860503;
	bh=m/owKDMFn3JZZdEFKUbdWDxqL1x34rzNQ+7qf1Z57HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5S67yMcW1NKq0N13AeoqgPdsfkNq5AWujGXv5JPzcAa2ud58hlHaG2lJjpFZk/C/
	 LVSCyMDINwzHNQslDUFukiDGN5gxqaqv3dDJXNY8rye87P/MUneF3+P3QES3R+d1cx
	 JJlOlkeFiOlgb11pGhDjwb594HULgkSo/Bkj9EAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keiji Hayashibara <hayashibara.keiji@socionext.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/144] spi: uniphier: fix controller deregistration
Date: Fri, 15 May 2026 17:49:01 +0200
Message-ID: <20260515154656.161324447@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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


