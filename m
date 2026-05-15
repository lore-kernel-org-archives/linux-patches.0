Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8183B6354;
	Fri, 15 May 2026 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861364; cv=none; b=nXbONYjem/9/HMzCKUzrYWtc5Utb9bHYXV4EB5pm5pogsONjCC8RvQ4u3lg6U8yyfoAScLXvRBCLEy6jwUetODhq2d542tIFBQ0bXSL05am4jHyMr7OPwRW7gwC+zfUCLCr7LfmWhV1F29mvM9+LIxURbF0pFTyPC2AQiGJZ4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861364; c=relaxed/simple;
	bh=JNokXEwN/4lwGqzCiVNnm3ei7Nyvl4hSgwZNPwijy8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMj14pPF51vue/ePWz2qZU7cr07eiXc43TuDRVEi3w8UBfg+6Nzo/aMS4/cvyWrGs98OhM1F+t74hkotbdH3t7Mx6WKyiiIw+xiAulGo6jKUI7Ih0NSrm5VGECKwCPQxo6hIqjijD41alWkiXNvCQ2EtPBOwL44LsIW7wtWCKoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLzb8i7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLzb8i7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72738C2BCB0;
	Fri, 15 May 2026 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861363;
	bh=JNokXEwN/4lwGqzCiVNnm3ei7Nyvl4hSgwZNPwijy8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLzb8i7qZbGOYe1YtnP6PzQHczcwQixq7BmvlFz2e6GwTGiGtKNcuevMiYm4wvQi5
	 avyWv0aZc1iPZ7qjUuFoonvibgoybebmG5Qxr7upOTaWWIIVxayQmkP5cv4xlfaBnN
	 Gfjujk7C04KqMWs1DO8KzeBnBjMKMW1OWg4Co0k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 301/474] spi: atmel: fix controller deregistration
Date: Fri, 15 May 2026 17:46:50 +0200
Message-ID: <20260515154721.517613498@linuxfoundation.org>
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
@@ -1647,7 +1647,7 @@ static int atmel_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_free_dma;
 
@@ -1679,8 +1679,12 @@ static void atmel_spi_remove(struct plat
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
@@ -1705,6 +1709,8 @@ static void atmel_spi_remove(struct plat
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static int atmel_spi_runtime_suspend(struct device *dev)


