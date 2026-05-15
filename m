Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CAE3C9EED;
	Fri, 15 May 2026 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860989; cv=none; b=i/7XvEF/PH0UM9JkjQ6mfubAEELnv1F2L8r2mPSrcBT6Hr5QY668hgq7IBN2575/+VXi6PJcrNfwvid/6RcDBJeHxtRF05lNyV21NvB25F87E7YlhXYCC5bsUsA3N1yNOgG5iNtq4L/1AfSVf6M7EyHWhxO0dVvbwBUCuM109cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860989; c=relaxed/simple;
	bh=WoMQgjhaG69PCO2pd+XZfpwkmWzaH5ubC7QXe63NlFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDCAXAxiig8TOyav9606vnK4iMaZ6Ln9c8x+8F7FLm411DJTWiojIGQOj4TxsKY1C+IOjJ1zVz+WMHOXYkA1pmAEcXIoeIwcD7bUCCLk2iQdknRhJIYYHW9KEXPESWFT3fpcsqdZHGQdOrTjXG+jDqXUXaSnAQssEokh0oLlj1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaOHYfRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaOHYfRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73464C2BCC9;
	Fri, 15 May 2026 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860988;
	bh=WoMQgjhaG69PCO2pd+XZfpwkmWzaH5ubC7QXe63NlFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaOHYfREhn+g1zXqGlNc+yqGleWEBNjngRKJifr1LMWRc9wBOoW11LHt5nnC0yi2b
	 MzaI366kubZvM8CWBR4qHf3Cr2kXZYFLZMBRNyqfHa5J7IV76BUKmRPYAqjAmzMJNc
	 baE3GRXqWRk6SLA5SQ4yZjZZCFJn/vJ7vK04PFcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 154/474] spi: rockchip: fix controller deregistration
Date: Fri, 15 May 2026 17:44:23 +0200
Message-ID: <20260515154718.357908359@linuxfoundation.org>
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

commit 53e7a16070feb7d1d4d81a583eaac5e25048b9c3 upstream.

Make sure to deregister the controller before freeing underlying
resources like DMA channels during driver unbind.

Fixes: 64e36824b32b ("spi/rockchip: add driver for Rockchip RK3xxx SoCs integrated SPI")
Cc: stable@vger.kernel.org	# 3.17
Cc: addy ke <addy.ke@rock-chips.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rockchip.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -921,7 +921,7 @@ static int rockchip_spi_probe(struct pla
 		break;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register controller\n");
 		goto err_free_dma_rx;
@@ -957,6 +957,8 @@ static void rockchip_spi_remove(struct p
 	clk_disable_unprepare(rs->spiclk);
 	clk_disable_unprepare(rs->apb_pclk);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


