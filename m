Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333A23EDE69;
	Tue, 12 May 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608479; cv=none; b=iDcoRgoQC19PdgluGZVUsfgsIgISdW3v+dG+hbcop9xtsklBg0sBH27KUF6yig0m5KvDDRVII17w2cpB9uDVfaKVVMskhGuwt1J4OQYwcbLrnDQtAs5LSeXvGinmGXFtgqBX9uGAzRzCSdpKjIgdPP73ZO7gSjQoRWC2D0pHx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608479; c=relaxed/simple;
	bh=9mWoT2DHU5o8Kxy9hG7iO9N8eoXsjWOLquAUbjFnsWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEpYL9NFPZN7EQAmk6A+uZs1mDyxCJ2DqtitJUNcHX+kJzIEFKT08/moGAcsJju8ZEVguQw6gL5+cUxX2Ud5R/2G27ZMSvWUKLS3+e8sjliCW6gqv9Y8ZKe6XPfkoDY6kwq4YXH6chlmU0JeKbZWy/Hkp72dmZuHifbudhZ3EoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/xnQxIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/xnQxIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBA5C2BCB0;
	Tue, 12 May 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608479;
	bh=9mWoT2DHU5o8Kxy9hG7iO9N8eoXsjWOLquAUbjFnsWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/xnQxIRWNYHmmGLFmpFyv1mDxLX6CB8wHiQ7hp18d3lYjLJ9IDA+fqamCjh4UsBW
	 FgzbnBOVDGzFs7wCpWeCY0szpulgki9wnRwoRxP0wsWl6YoxH9IttptEJAd21tOz4N
	 GYdJJXvJUsz7+Zoixo5XDjYyoTumQeMk0HWx372E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahisa Kojima <masahisa.kojima@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 078/270] spi: syncuacer: fix controller deregistration
Date: Tue, 12 May 2026 19:37:59 +0200
Message-ID: <20260512173940.096718587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

commit 75d849c3452e9611de031db45b3149ba9a99035f upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Cc: stable@vger.kernel.org	# 5.3
Cc: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-21-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-synquacer.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -719,7 +719,7 @@ static int synquacer_spi_probe(struct pl
 	pm_runtime_set_active(sspi->dev);
 	pm_runtime_enable(sspi->dev);
 
-	ret = devm_spi_register_controller(sspi->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -740,9 +740,15 @@ static void synquacer_spi_remove(struct
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(sspi->dev);
 
 	clk_disable_unprepare(sspi->clk);
+
+	spi_controller_put(host);
 }
 
 static int __maybe_unused synquacer_spi_suspend(struct device *dev)


