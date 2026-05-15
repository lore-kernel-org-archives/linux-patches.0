Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848F73B7B8B;
	Fri, 15 May 2026 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862622; cv=none; b=auhZmVn8BE5LubpgHJe7rCLQUg/9o+icLYMmXf5WBvF8G6qEU/IEOoXU2SKeampdkHooGdmOo2Mz+3v+S7PNbJe+Zrg1UTp7JHBHH+1ecZbqCBvs/eZw1nC+Tti8Q7a063CVnBNMWa9jpj6rR3wSEOc6WuI5vn0Q3MPRAFLpEig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862622; c=relaxed/simple;
	bh=iBXDVD4CmOkHa7IuSkPlmdjtPGpZrcUY9sPCwflISeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiHESF8YXTOaPk/u5n6vqiESMM+ccfWl66D++/I1AroPnO3qtfcQnhfqdoYCChnnwvtl6RvjFKE5HRC2y9PuRBogmgVGhoBWoxAC2pNRgqPvlW6J3kQsjZ/z7Azbu7UorYNj+yrzh2EltxP/DjBhS7EllNadIM+S/yCMtKigOTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDmhNDbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDmhNDbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD9DC2BD04;
	Fri, 15 May 2026 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862622;
	bh=iBXDVD4CmOkHa7IuSkPlmdjtPGpZrcUY9sPCwflISeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDmhNDbwFRokN2ki7QpwtgPyojWWmD+t6EGxPqgmiRV3fAyVN+wX4y2HwHsOT2WyS
	 ikPHQZRTlMmQAw37CGL0TZ+Ev5M8/sAHf6mOgk97ZI84/ShK5+PZONjn1X3XaLaKw3
	 39MOAFvpJPslPQb1dB9AAESdpcQX7tvbPGgiBUJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 118/201] spi: cadence: fix unclocked access on unbind
Date: Fri, 15 May 2026 17:48:56 +0200
Message-ID: <20260515154701.113263465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5b1689a41f02955c5361944f748a4812a6ff9307 upstream.

Make sure that the controller is runtime resumed before disabling it
during driver unbind to avoid unclocked register access and unbalanced
clock disable.

Also restore the autosuspend setting.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: d36ccd9f7ea4 ("spi: cadence: Runtime pm adaptation")
Cc: stable@vger.kernel.org	# 4.7
Cc: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=1
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421123615.1533617-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -776,16 +776,23 @@ static void cdns_spi_remove(struct platf
 {
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct cdns_spi *xspi = spi_controller_get_devdata(ctlr);
+	int ret = 0;
+
+	if (!spi_controller_is_target(ctlr))
+		ret = pm_runtime_get_sync(&pdev->dev);
 
 	spi_controller_get(ctlr);
 
 	spi_unregister_controller(ctlr);
 
-	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
+	if (ret >= 0)
+		cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	if (!spi_controller_is_target(ctlr)) {
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_set_suspended(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 	}
 
 	spi_controller_put(ctlr);


