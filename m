Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8BF2609EE;
	Fri, 15 May 2026 16:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862105; cv=none; b=Ex3z8CqoN4R8a89Kc5zd/Ymn3L4RUHn9nlOPQqh43jgm3x572z7YfXAcDK2aZgmMmT6Ng7O568/otJ/tGfjGqvUZIVxX/iZpOBFYORCd8IFFPoskoOcBLspYSSV5LW1S4N2Y8cHBdjNo1qasyt+J/k3f5/To7rDxI6wl5IDLJCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862105; c=relaxed/simple;
	bh=fRQTdDxLx8ThgLSrAUu27d9Tu+qJ5N/ca5cXPDQpLJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmvAQqSEsuqYJZlD1gjDl5ZE8EkJQ2QNlUvdBhC3ZJzKqytN8OndbWk9z8YcjjnjxHhBfEmiunCpvwQAzbpKTa5Z2RyuHpPohhlW5xgtCNqgV72qBUii348lShcxh3kmWxqSzAJ+t3ekFBZqAKzu49C5t1aKXd4WV7jVboetnYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3quAmG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3quAmG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34752C2BCB0;
	Fri, 15 May 2026 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862105;
	bh=fRQTdDxLx8ThgLSrAUu27d9Tu+qJ5N/ca5cXPDQpLJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3quAmG9BfD/BUQ71wegsU5YeZ1jAF6zLef3ra3gx1eoAdFOtDFTlMyo4HLcaE56h
	 UaUfLMB6WyHpixtctjo4OVPQpLFyTHS+6HtIFV/z5CBS0yLDxY/MV+zo5QKpPG16d4
	 2Cn3DyCQIxjPxr9cvtNv7MEUn56yA/HPdDz644aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 069/188] spi: pic32: fix controller deregistration
Date: Fri, 15 May 2026 17:48:06 +0200
Message-ID: <20260515154658.815848784@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


