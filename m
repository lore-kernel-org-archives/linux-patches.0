Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2594A3DC85B;
	Tue, 12 May 2026 17:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607867; cv=none; b=SEEVVugUUS5l/+SAHCUw/zp2At6m/rwqbsgliA0j86CVzMrk3JRdEyoFVo/qZfte20FRK/WQig2Ffs0iVmAFdE7k3F5uwB+JZVIvqbRjlX+mytl/ECBCji8m5BTnqzRcKUw8Ds7W1vkjesoahCW1O/DWEhMkdDe3sRjm0f5G+98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607867; c=relaxed/simple;
	bh=Aq4KItGy3IkCf4WomuX8WX3cjBlOO3JkGQWmnaK/Sl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPElAQsZ15xsHRvaeg4G++OJJqcv/Z739ixAZk68BTUlkKw+2GWf8PqId2ZFO/oievHtZbbcoSxG3HasgNdDIejHRHNU7z0Lb/rMdszr3/KtXA/J0JapuJ11DMXp6okZO4y6wbw65nZCArop0tTRDnf2Xn0fb5xw6Prz1kzTn8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/A8SAJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/A8SAJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAC7C2BCB0;
	Tue, 12 May 2026 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607867;
	bh=Aq4KItGy3IkCf4WomuX8WX3cjBlOO3JkGQWmnaK/Sl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/A8SAJPwutsYvOaDxoUQ6JmFS2R4t74uchl5EfxdY1vcBqpQ7QTqadrPYfCJhrgn
	 iZfmEJF4dJFBGXRoWXFWWs5FY0ciVV5DT4OmJ9z/GLGLdejo8R7txNEnRnPOsVrBMy
	 JqJHil6vC422BYs7ONskeFxMxgKEpLm1XYEaFRgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahisa Kojima <masahisa.kojima@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 067/206] spi: syncuacer: fix controller deregistration
Date: Tue, 12 May 2026 19:38:39 +0200
Message-ID: <20260512173934.263701794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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


