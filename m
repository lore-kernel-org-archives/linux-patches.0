Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75E3B9D91;
	Fri, 15 May 2026 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862067; cv=none; b=N7TvQV4Xy5A+l6nBBkDjCssbU7rlO7Kd9+Q2vCB32I8or1BIYEdtIsMVLq/wSz22nbWBdBrqj1NNlarP+nlkJ4UV4ticyvDNcy6LsK3CQhGAOCBUwzJ78xoYQyraSm3NVthvtE1S+TM9hB5LpGs0cH98TUYk+cJsouwkldn81hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862067; c=relaxed/simple;
	bh=UXvRjPFuJnsAu/nFO8NTtskQAA0/d9UP8S8kv/rb75E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm8sHx1Du4hPZ/dwIL9NgdY2iNVONYR/1ODOkNkRMNV1LEHWekAIgVdIdDhKQ/69b5pmAEWzxFTFZNjOtPDeYfPh0YRk5BYd3ijzvZakcqM7UcB8T1RR63mv6K9VIqlqg4pzYvbfVtOjFleNiQGnWICZ3F7jaXl7wAFsc8bm5sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSPI3hwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSPI3hwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A436AC2BCB0;
	Fri, 15 May 2026 16:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862067;
	bh=UXvRjPFuJnsAu/nFO8NTtskQAA0/d9UP8S8kv/rb75E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSPI3hwWMfwUTLEWHjQfjy//KzpWsPy+jFfVHt8QNEcHbLZMdV3mRE9KSbE60LtAG
	 OBJwuFKnR5PI5oAf58zIHiOyqUM0LEVQ+VqQwA73jeH6+8Yu8B2mK3QTGjB9G3VBYQ
	 P9AnKVnDBH4LpLUK5DstjvTfe61YJN0v1mk8WF5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harinik@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 094/188] spi: cadence: fix controller deregistration
Date: Fri, 15 May 2026 17:48:31 +0200
Message-ID: <20260515154659.367481098@linuxfoundation.org>
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

commit 666fa7e9ca98e71c880086ca24147ae843f1ed6e upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: c474b3866546 ("spi: Add driver for Cadence SPI controller")
Cc: stable@vger.kernel.org	# 3.16
Cc: Harini Katakam <harinik@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -698,6 +698,10 @@ static void cdns_spi_remove(struct platf
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct cdns_spi *xspi = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	if (!spi_controller_is_target(ctlr)) {
@@ -705,7 +709,7 @@ static void cdns_spi_remove(struct platf
 		pm_runtime_set_suspended(&pdev->dev);
 	}
 
-	spi_unregister_controller(ctlr);
+	spi_controller_put(ctlr);
 }
 
 /**


