Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3837346E55;
	Sat, 30 May 2026 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163505; cv=none; b=ccRoVRfy/fJIDyVPc8pUuFIOwkikxe//WT3nXn9+AjCvLvsopFOHDoKC62nlomYicB1kDIrhvpFbu6aHcsQJJ9FXlybHHTosnIZ1Ri2hZOGCELCwlqHm37j48JLouQFTbAoIUXPKz5wQMDKWbyLRsSO6ElEYM/5iiHAuIE/Ys8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163505; c=relaxed/simple;
	bh=9lDoUSY0LoMa/qIGjPZXW7BlrNwiG51nLEn6FoOjWsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGAuKMtnJotQI3iKwBP7gzalgHptaMdtgM8Os3CWISOO9tBvvRl0slMuwZtc9B3I8Rlw3/qG3YnQkyJiV1ceNsVFJb58b01Ny/hnBF7MwYUc+EOq4NEVEYmvbXAqjtPcDk0X+6YHkIDlEzNJ8aeY0H7vdRQfF8CDm9FLzVwOqWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8a3djFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8a3djFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320251F00893;
	Sat, 30 May 2026 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163504;
	bh=JA30y6Ct5xtFx9N222i7wiCtakH30chbK6gATq5HPZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8a3djFzxNJ63900sIfZCX8Po921Ug5AWQjnUJy5iMSnh9tM7+m0FWIffYZ3QYk7G
	 tJsd/WKOkV6zqQ0DH6ko5k+k0s5iJkLogtddyKxAiqViJeYfPts11pTX/fj66QJp/A
	 9Cv6B3RRh8oGlXHg3lh6ZRYrCoIZ93nRUQDE/WCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 279/776] spi: rockchip: fix controller deregistration
Date: Sat, 30 May 2026 17:59:53 +0200
Message-ID: <20260530160247.767519712@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -917,7 +917,7 @@ static int rockchip_spi_probe(struct pla
 		break;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register controller\n");
 		goto err_free_dma_rx;
@@ -953,6 +953,8 @@ static int rockchip_spi_remove(struct pl
 	clk_disable_unprepare(rs->spiclk);
 	clk_disable_unprepare(rs->apb_pclk);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


