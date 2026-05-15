Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B945311956;
	Fri, 15 May 2026 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862617; cv=none; b=XTNzpnLpg7WgEx0XsNhmsnOT4yG4TtVO7hnYpDIsULsVvgnBGNp4SszKUN5T5ePhBVGFNDtnY+Kh/LnvgAP+Pp8PiK9DfZQaJHqFnwzKCG5O0bR8l4J9g34ZEFGrFqShParY7wseRqytxFAwUWLM+myivFLlqVAfW8whn5HBxL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862617; c=relaxed/simple;
	bh=h+TX+ZvyDD6GpXpvS5/HUdL5nuBhFeoH/AkmHBhjbmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olGGZ0vrNeuYALN40F7l8vOL2Q115YI2+d0zoWwcSEvd4NNxhUONtlTVyYVgOmzt3bGj/VY67TPs9uAygygAIwl/7rPKflxFbuD1PUn219TcsiCMDvWd3bkCr6pkq71uM9t0gPcD1WTP1a/6v86B+XtvuP+kQa0NNMrf5CPJkLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNASKJB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNASKJB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F532C2BCB0;
	Fri, 15 May 2026 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862617;
	bh=h+TX+ZvyDD6GpXpvS5/HUdL5nuBhFeoH/AkmHBhjbmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNASKJB6YuOONe8g/EU67RYxR8y03wCR73wqwfP9RNZlsiYRA0+gvPZ5bdNeXoex9
	 duHPZ5paLZ5U7yBFdu8Pgjic2Ar8YvKAFtUf0q+5imJoUTDFrU2js2D9b17xWMv00t
	 FhHaOsBs4QmxxMi8T5hIZb2nQ68MxO6RN35I3uPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harinik@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 116/201] spi: cadence: fix controller deregistration
Date: Fri, 15 May 2026 17:48:54 +0200
Message-ID: <20260515154701.067746145@linuxfoundation.org>
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
@@ -777,6 +777,10 @@ static void cdns_spi_remove(struct platf
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct cdns_spi *xspi = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	if (!spi_controller_is_target(ctlr)) {
@@ -784,7 +788,7 @@ static void cdns_spi_remove(struct platf
 		pm_runtime_set_suspended(&pdev->dev);
 	}
 
-	spi_unregister_controller(ctlr);
+	spi_controller_put(ctlr);
 }
 
 /**


