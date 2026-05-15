Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05753CD8C1;
	Fri, 15 May 2026 16:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862651; cv=none; b=T3poWmkUSASKr1Xg+2vfPEJVXqVA1SWSRv8iRizfZ9hVKAyayi3H4vlUmGkC1vze1qR843eUDvD8tFb7P2qPZRD7ZHbmJ24b92cGIr+TzHWUf1Mr9KoSBFN3hnfSuXcdQkeNuhbC2aSGkpIk1HfkMTVGXa0Xhe8tHj6yPG/Dejw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862651; c=relaxed/simple;
	bh=z944eDKl+siqxv3RMb0ppA9UnmmZ53vo2xBFNoJgI/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4U67R6m46Yma5OthpRkRgEANu/mi/Ox0LW3NZOyAY5deg7UwGO/dh71xwd/fAxtl8UaNzZdM1/PtQ6lA04BuB34c2vN8AeTrj145bw7md/W27Dyy+wZ/KJ28JLUhANmEIdMOw/FCIy80purryJKwN0cTjLMmgV7SdOSahkcTv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5vNSAUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5vNSAUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D87C2BCB0;
	Fri, 15 May 2026 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862650;
	bh=z944eDKl+siqxv3RMb0ppA9UnmmZ53vo2xBFNoJgI/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5vNSAUjBmujAaefzYUG+VGtGUt/K+Tcdw7Qivp3VXCnzWE2bB92YdsmvsO3SiNfl
	 nPzpTjfW2HlJ6VAOpZL8bJRiV5IDesXw5NgmCxrs9FmSIymTh3kO9BYW0KuQYCuq2Q
	 ho2EMqWpiCgC0DmL92EEMt6OOlbguxm8IJpgfnkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 089/201] spi: pic32: fix controller deregistration
Date: Fri, 15 May 2026 17:48:27 +0200
Message-ID: <20260515154700.459504768@linuxfoundation.org>
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

commit 6b627bfe0c44e064aba464839e430dc1ca2b0bb8 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 1bcb9f8ceb67 ("spi: spi-pic32: Add PIC32 SPI master driver")
Cc: stable@vger.kernel.org	# 4.7
Cc: Purna Chandra Mandal <purna.mandal@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pic32.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -821,7 +821,7 @@ static int pic32_spi_probe(struct platfo
 	}
 
 	/* register host */
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&host->dev, "failed registering spi host\n");
 		goto err_bailout;
@@ -840,11 +840,16 @@ err_host:
 
 static void pic32_spi_remove(struct platform_device *pdev)
 {
-	struct pic32_spi *pic32s;
+	struct pic32_spi *pic32s = platform_get_drvdata(pdev);
+
+	spi_controller_get(pic32s->host);
+
+	spi_unregister_controller(pic32s->host);
 
-	pic32s = platform_get_drvdata(pdev);
 	pic32_spi_disable(pic32s);
 	pic32_spi_dma_unprep(pic32s);
+
+	spi_controller_put(pic32s->host);
 }
 
 static const struct of_device_id pic32_spi_of_match[] = {


