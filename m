Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FD23FF1DD;
	Fri, 15 May 2026 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860467; cv=none; b=B/oLZOXb0SZNzHWWHBbgdairM9yTKHHlZaRo0rWUwDFVzkzn6eOh3K8pM9V4vIBroutxG2cK8lpQLc/ECS0qwg3+fIgvlnduaIXpx/qwr2c3VB8uMOYNpru9WtQ94TmjFG3gTQFnG6ZgZBylg6wLfgPV2GX7xU5XgK2kREHhBv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860467; c=relaxed/simple;
	bh=TAT8u8GG4xnpUAHzRjiCXdmJ4jduDZo3ZQGGcrDth6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPxqZd1yzJqCpPnP65+o1bQnrwZxu/Ib2l4Vg+63vH6L5wIfcUXwIyrlSEG6C7fSn6a73lHjrZqL3rRW5+FjmAprQvIr/+d2Fvt94+1txRpmdd1FxNPSRbPMitk2K+5PRCshya6PR51kFHGxnGQkMTAOInFAi738DZuTlZNVZdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SO4WEl1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SO4WEl1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764BAC2BCB0;
	Fri, 15 May 2026 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860466;
	bh=TAT8u8GG4xnpUAHzRjiCXdmJ4jduDZo3ZQGGcrDth6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SO4WEl1sqC3XWlMb86EXhbFG+zQrzesCeourObhsZ+tF54QJaomQO772DByiMAdHJ
	 ICvawIYgeRsVaKEHtqJTKy3aEFSBAjb2F4x6slYvgrmxNvIqwA8tgnQR7JzfCTgyXX
	 EUL7pGb7mOl36TGqNdVYqts58BDQ+7ItF+3LwLj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harinik@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 063/144] spi: cadence: fix controller deregistration
Date: Fri, 15 May 2026 17:48:09 +0200
Message-ID: <20260515154655.007976043@linuxfoundation.org>
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
@@ -699,6 +699,10 @@ static void cdns_spi_remove(struct platf
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct cdns_spi *xspi = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	if (!spi_controller_is_target(ctlr)) {
@@ -706,7 +710,7 @@ static void cdns_spi_remove(struct platf
 		pm_runtime_set_suspended(&pdev->dev);
 	}
 
-	spi_unregister_controller(ctlr);
+	spi_controller_put(ctlr);
 }
 
 /**


