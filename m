Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB5632E13B;
	Tue, 16 Jun 2026 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634676; cv=none; b=eTK8wESTxqS5qS3uOMUOIkhtREaFr2il/2cBOJni0Zx4jxGy31REryv1bYKWOiwhDf4gszUfHor0mnTiri7c3a4YZxLBw8uIlg+tTNCg7oCA9hai0HLBMUJQ/Fz7RD5Yut7RY6Z97eJFV7eakN7tBTIeCOYIdrjvRWS37Z41PPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634676; c=relaxed/simple;
	bh=YteqI0JdaJUbsmTpg6C6ixOiCHUkRFqjSGrIQGyuafw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bu+4dR1sMRvrZnRZjZKuv6PKio/kXEeHsmNnRu/b0zdKMJ+GKaPgF6GB+WrZp/rdB3spkU76LlaO7X0uf5efXxkCLvJbLPV41bKbBVFTJePtwPRmsQyharbYqLyIRYxsTxq6L5LiGM9XzZ0+LgibV6nEIoZ4EsE5HoY9y6C0Duk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcYwT8pB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcYwT8pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D451F000E9;
	Tue, 16 Jun 2026 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634675;
	bh=YRcWNpYq/sxw+4RB6bNMmOPx4WPQkI8IVa0joWGzlkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcYwT8pBbHFYesKrViPW7WEUaUzqWETE73OZIf74CKwUbLTHNTc/BQtf42AZiEGk7
	 l02YD8nD4ri4HMLuYuF/XYNH8FH0EI5gb0hzbvoOtNHFCytOZ/0a8rXuHLHgz0BFuB
	 YuN7Z6FS/Vsas20tL2qr7fyMkl6IdYZh8xLT3YLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahisa Kojima <masahisa.kojima@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/411] spi: syncuacer: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:09 +0530
Message-ID: <20260616145117.677652732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 75d849c3452e9611de031db45b3149ba9a99035f ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Cc: stable@vger.kernel.org	# 5.3
Cc: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-21-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller/host to spi_master/master and kept int return type with `return 0;` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-synquacer.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -719,7 +719,7 @@ static int synquacer_spi_probe(struct pl
 	pm_runtime_set_active(sspi->dev);
 	pm_runtime_enable(sspi->dev);
 
-	ret = devm_spi_register_master(sspi->dev, master);
+	ret = spi_register_master(master);
 	if (ret)
 		goto disable_pm;
 
@@ -740,10 +740,16 @@ static int synquacer_spi_remove(struct p
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct synquacer_spi *sspi = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	pm_runtime_disable(sspi->dev);
 
 	clk_disable_unprepare(sspi->clk);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


