Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF2E3EDE55;
	Tue, 12 May 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609138; cv=none; b=hFoTlf/sZ//pMvw2EXDw1NJaGvUgKlTvE4e3qvuRDU4W4WnZhchzv2ziAWa4OdjyzlTbuwH3RPDX3g963kzAWA0kzFOcLa4j29wTjaQkGHwOPiD9M3d5MpaFZNca2nIUM6kj5XNLwVXDcHMjuD+yl+NpAYWHPM1Auf8q/CV+e24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609138; c=relaxed/simple;
	bh=lc0lQVdLNpp5DbhSqSS3L69E2SUOW+VSW8vMJHBxijo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMIwtboZ2lu0GfSSbwx9/IUI2cknkHDK8TVpjJYo0JsY0VXEKUSxtjtoG+yQk9Jd4ZZMfB3RAdgLHdlx1YouxTrQjr35EqlNQgZCSkDL8MACOsc91+YUujGUbb/VfebxgNcKC5VNLmw1af+9MS+/0FqPSobMgRWru2FbTEtiPWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeQbOPN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeQbOPN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CB7C2BCB0;
	Tue, 12 May 2026 18:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609138;
	bh=lc0lQVdLNpp5DbhSqSS3L69E2SUOW+VSW8vMJHBxijo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeQbOPN+otmQ9s/zSGxpKZgTfUPhwHxUNiD/LX06vfuRCIUzAc/KT42BPhq/POJLs
	 tCr+GroS4cFtaRs5E7D4R3hSookIHT4B0qs3lOCa8wsdK34P7EQ6iBfKKnFtIsunlA
	 QD83vfUUvpUjTYyWAcF7CjhYzdb/++xkX4/nynrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahisa Kojima <masahisa.kojima@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 081/307] spi: syncuacer: fix controller deregistration
Date: Tue, 12 May 2026 19:37:56 +0200
Message-ID: <20260512173941.829062808@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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
@@ -716,7 +716,7 @@ static int synquacer_spi_probe(struct pl
 	pm_runtime_set_active(sspi->dev);
 	pm_runtime_enable(sspi->dev);
 
-	ret = devm_spi_register_controller(sspi->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -737,9 +737,15 @@ static void synquacer_spi_remove(struct
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


