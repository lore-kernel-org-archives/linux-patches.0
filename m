Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD5432D42B;
	Sat, 30 May 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160257; cv=none; b=TzKsuHUEXGU5oWvrlbU9alzlI7zmetoRD8gLoJkNEoi8WXeD71mrvNGU/7QKeiwJqdbNeGQM7BB4OL8asOHd8R3TNRWa5qgwVIJcKLJ2AeocSw0p5QKvyjPma1a/V3T3g1kKs/HbKoyxm2fRN1YoepuP4oOM2CSGsk/8lI1iN9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160257; c=relaxed/simple;
	bh=iH4SW8glhgr2wGCa3b0BDT2bGgzgdGgAF/XtqRFKa/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc2dEEn6yEXJWAdufEKK+UNgyhXpX8EZi0e3h6kNaWlcksJMR7uusN2Q1v5Vy3eRrOAxfSwSr0wOuUEUdHeGwidQXe44ZM6AgVjR+l7H6kacUHnKr2IGUcoFIpoGOgjrtPhny3Qnn0ExGQ81CKLZeQnz+SUGWCk75FZPbcZBy+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBJxRo5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBJxRo5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFA11F00893;
	Sat, 30 May 2026 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160256;
	bh=i3LvgY+4xRTHL6DpoEPNbrtkGiS27VZiD2f/eKer1tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBJxRo5Znd2A6UQ3s4+duj2kiGRYX9HlAzyl9j8lfX9g5VaFXTCHj9EtuVWVZE8uM
	 DtDQNUsZeoTa38viEFSLZ0Drd3prACVAA/S4K+DdlzBDoTyrpDMww+UVvDLAjosS3m
	 b3Wm2Pk2TL6uKZOTrOxLwP+NeU5kZY8e/KoucFgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 288/969] spi: rockchip: fix controller deregistration
Date: Sat, 30 May 2026 17:56:52 +0200
Message-ID: <20260530160308.410244242@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -957,6 +957,8 @@ static int rockchip_spi_remove(struct pl
 	clk_disable_unprepare(rs->spiclk);
 	clk_disable_unprepare(rs->apb_pclk);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


