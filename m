Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B976D3F9267;
	Fri, 15 May 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861423; cv=none; b=CFSCCTJJtYxcguZG+ow2cVOXPwEYGHvsqxEYzKHz+n8Wx2H8uc6yM6nfVLAbyHINdGRpOK3Mu237OGaKeEw68mR8ymny8dMm26g7NSkMU90ocJzCBbhfpqAcFPM9uB7MqF2iFOukbZ70B71mKN5UMu+Y5vDMspK/He0IdEggxDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861423; c=relaxed/simple;
	bh=7adJOyR0JqXgTkvvu06otyfMudTPMWzFAyGtjyyqHN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShiVmfgJ3oqfbbMXOqbHlzLS2X2zr/3wBdKIJfivbS7xNq6EYE4CtNuGZVYptrlxQbsIPpY01w/o9zShoon19G1ModGTl0assFem+TICg0IjA8go2WAOA9F7NRdVO47Q3N7PQdygDxXaXKW9wVgoE3oOnPWekPyFdVeh0oMFLB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcQl7BKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcQl7BKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E051CC2BCB0;
	Fri, 15 May 2026 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861423;
	bh=7adJOyR0JqXgTkvvu06otyfMudTPMWzFAyGtjyyqHN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcQl7BKDLX8P1Vy+erc5Bld7ws1M3KkZ5KhzcKsHWHEM7F8dG8yn7I5QWcKjLzeI1
	 jI1KTsJpSiA758GkqVqa9HH128YEwHYPk6MApE9AZH4wwP1kpbkIKUHOBmlOKt1Ybf
	 +BKzoO4k2V1hK3X+MRKqPHd8vvtMILk1II8ra+B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Palcu <laurentiu.palcu@intel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 322/474] spi: dln2: fix controller deregistration
Date: Fri, 15 May 2026 17:47:11 +0200
Message-ID: <20260515154721.977434125@linuxfoundation.org>
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

commit c353020fbfa8514ee91a6de2d88de4e5edca5803 upstream.

Make sure to deregister the controller before disabling it to allow
SPI device drivers to do I/O during deregistration.

Fixes: 3d8c0d749da3 ("spi: add support for DLN-2 USB-SPI adapter")
Cc: stable@vger.kernel.org	# 4.0
Cc: Laurentiu Palcu <laurentiu.palcu@intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-12-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-dln2.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -761,7 +761,7 @@ static int dln2_spi_probe(struct platfor
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register host\n");
 		goto exit_register;
@@ -786,10 +786,16 @@ static void dln2_spi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct dln2_spi *dln2 = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 
 	if (dln2_spi_enable(dln2, false) < 0)
 		dev_err(&pdev->dev, "Failed to disable SPI module\n");
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


