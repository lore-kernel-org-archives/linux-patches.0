Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589E62EF652;
	Sat, 30 May 2026 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165909; cv=none; b=jIDIRM5rR+otpQEeH7JqkBnYmUW1kEJObcXliNa/OxL9/UAkTwAGHMbH6ktyhCSlCqyg1LFEu1/15rg2Z5/BnCaUHqJ5V+9HY3E6qDK2imEb3s4y9zHLbQ5TIZT86vMuKvWgafhIutd+PiHn1MACXJXGXmwMpRkiz2nYTYZqsSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165909; c=relaxed/simple;
	bh=fAmkElquu7l9KVHw1u9Z8unmCeElkVp6j29sIqLRhAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qACfkLDWVHpxWRBRx1toUaKu4YhfPnpwi9bEFtaxQOsEH33QM7uPnZlqPNYfQcfcs49yfBUzfmyUmGn5GATe+Kx4uY6bMaRzTXoes+mxyCXzjPVrO1PDlrKlqJjvJaumIn9XrnPyWAW9dhPghkTc02iAmhtCGoovZtDt347B8Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBcsbFya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBcsbFya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986DE1F00893;
	Sat, 30 May 2026 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165908;
	bh=D7/6Y8nKBDk2Blw16ds+ENDmdAT8KD/3Vs3hwQbpS/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBcsbFyavvRjL2ST6BVld/Qv4X2a1EE7xQeWvb/rQ0qMYZ2WESCkYWGYfagxwf+S6
	 INqEnc5d7leKHgjkV4/JPb76v71XDnbWGKSWvDy4+TNpri0ffJdCwXRoc/DP1wvvLN
	 WpM727ARRNOVsy6hM18hfacACCqE+ervqt2s3Xds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 210/589] spi: rockchip: fix controller deregistration
Date: Sat, 30 May 2026 18:01:31 +0200
Message-ID: <20260530160230.478262786@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -792,7 +792,7 @@ static int rockchip_spi_probe(struct pla
 		ctlr->can_dma = rockchip_spi_can_dma;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register controller\n");
 		goto err_free_dma_rx;
@@ -828,6 +828,8 @@ static int rockchip_spi_remove(struct pl
 	clk_disable_unprepare(rs->spiclk);
 	clk_disable_unprepare(rs->apb_pclk);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


