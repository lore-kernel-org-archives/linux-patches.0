Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42DD3FD949;
	Fri, 15 May 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861558; cv=none; b=Wf3aahYzFF2fDfodH9Eu+/pJnh4m7uFfJAF7CBqrWvZvaOJ+Oj/QF4LI6BXVzoMIjaBW6+Sf5Jj9BdwOt12KU2Ck9yNcRwd7ptHuVwWKG/jQt1gPHXirIzubRSVVjHTGa2Z6wUvElulCRAZxDCbuIpFtjdlcufSu40d8OZWE//8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861558; c=relaxed/simple;
	bh=hz1BZOeBydhyjIywsSqrFol7mgiT9Hn3cYD1gH5nkYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwRDChseDbgOiHxvAfhkSwAbuxS3g6Rl7BFUkevDAncOsBR6cQQqoVgmWe8Ku9ajsO48yNYZr3tXJwFK+8YXgu7dVYHRe83ojXOjURayF+Frx+69Q6xgv+U1DgMpynv4vAscWdrQh0yvtssAxe4JyOvGsxAkE1SFnblF+X+JBpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5WzxlDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5WzxlDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1EFC2BCB0;
	Fri, 15 May 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861558;
	bh=hz1BZOeBydhyjIywsSqrFol7mgiT9Hn3cYD1gH5nkYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5WzxlDw/L9VMGNqwfl18E9DExkLIXSfW9trZ8Tjn4HIJ0zqYp2D4arn0nETXXJh0
	 MB/BaEwjY1L+KTJeVTQxVrykEqAAwLMjBejEXVqc6+TZmiVgZ4IfFqlbO30V5GM2uw
	 mkGUI9fj8crs1wEbOXx+VdPVTTlRhHWd4JI8ClSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harinik@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 338/474] spi: cadence: fix controller deregistration
Date: Fri, 15 May 2026 17:47:27 +0200
Message-ID: <20260515154722.327419876@linuxfoundation.org>
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
@@ -686,6 +686,10 @@ static void cdns_spi_remove(struct platf
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct cdns_spi *xspi = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	if (!spi_controller_is_target(ctlr)) {
@@ -693,7 +697,7 @@ static void cdns_spi_remove(struct platf
 		pm_runtime_set_suspended(&pdev->dev);
 	}
 
-	spi_unregister_controller(ctlr);
+	spi_controller_put(ctlr);
 }
 
 /**


