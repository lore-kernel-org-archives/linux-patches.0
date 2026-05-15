Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1C63FF1A0;
	Fri, 15 May 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860260; cv=none; b=pRwfYt5hdqMghQraQEhBej9Sdp0jsqgfUM5y8t+haKoa4jIteeyOpogY+J4zYi9P/0j3vVeXilXwEjXNvUajHtkxZ5AsDo69J1sOua9lYF1L9zMYyTJcKxHP3gY2Oz6vSILNFxAiiQIleRyd8DkRhf5duF3jb4xW2i3zN/iNwZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860260; c=relaxed/simple;
	bh=tpkED+ZCoh3quozrbYkVyPUX3vR4wvC7m7K9Bs2ZWP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMIxTNFG8e7/P27wq/qwWNl1b4WdcuwCukRUGXlBNTQcvYG0vvC0LXF++1tYeDCE8KW1NavPBZZ4tSiVC4dmIGDOGniGqaZ0eGZW04uWKBMJ+0V+OexmZeMLP0FUXHEchrxpTVoktbeV/AoUEBZ9rXS5OItpb/Jt3zyQ6sPzUxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3gjllUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3gjllUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC7C2BCB0;
	Fri, 15 May 2026 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860260;
	bh=tpkED+ZCoh3quozrbYkVyPUX3vR4wvC7m7K9Bs2ZWP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3gjllUE0twOIN28lMMrjj17QYF3eWPazNnQUJEaefmu7vFgh3YuGYM9PozV6jFMy
	 4ZUHX5RY/mE2WxoowSTuvc3QrqVIBZgRpc6wIufdWDImQCAuFw+wqasUuOsuk414q/
	 zZlbMF8kOmiWsKqP4pcLzJZPmJ7yXhnpPrhTkrCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 009/144] spi: atmel: fix controller deregistration
Date: Fri, 15 May 2026 17:47:15 +0200
Message-ID: <20260515154653.703173005@linuxfoundation.org>
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

commit 8d4de97e83520be89d0ff40610ca633b3963a7de upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 754ce4f29937 ("[PATCH] SPI: atmel_spi driver")
Cc: stable@vger.kernel.org	# 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-atmel.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1640,7 +1640,7 @@ static int atmel_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_free_dma;
 
@@ -1672,8 +1672,12 @@ static void atmel_spi_remove(struct plat
 	struct spi_controller	*host = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(host);
+
 	/* reset the hardware and block queue progress */
 	if (as->use_dma) {
 		atmel_spi_stop_dma(host);
@@ -1698,6 +1702,8 @@ static void atmel_spi_remove(struct plat
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static int atmel_spi_runtime_suspend(struct device *dev)


