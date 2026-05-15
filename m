Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6463FF1D1;
	Fri, 15 May 2026 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860317; cv=none; b=d5wo/5XDvC9l64bJ2+e2kNNc2p+c+8wMDVkSyorXaSZ3Vgie5wKMy6VXUjCQAuq4Gy4fvaBN3r1Ry81NAZSe2r1uWKiD+oMycI6jaJ4ihTkNizHIqLcPRvJooLJq9gcC/mBjdC/qXkXxBvPFMCW6kKaDVLp0U51uohwMNtdw9OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860317; c=relaxed/simple;
	bh=rZRi+c+w5kt18S/TtR7dmriHVXIjmcRIAV5p7gDnNCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+3s0HcyNf8EfoBlZLE2aAMZsLXV9Gzc1zYx9Ut8M7XhI4O36fG2+dUXWNb+TCc5LDM2RYCgHNzdKGdmNcBJ21zB8myQn1NtG0sGx4oAWB+nJPjq0uVJ7RmPw4nET70jBfQhncXXfd+8OTAe+7LxoONxRHERztRP+jPnm8ZzAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJmLLyR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJmLLyR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5409C2BCB0;
	Fri, 15 May 2026 15:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860317;
	bh=rZRi+c+w5kt18S/TtR7dmriHVXIjmcRIAV5p7gDnNCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJmLLyR6RGlAvS4Un92G+1baYVE+EyGNwFlaVb8Rqq/AdRDix93q/kiaP9yF0ewV3
	 x7XXX7BSP54VhszvRccJgFLjxznbFdimjcjMtiti9WPmg60RmKCfF3g+e7tlFSDXze
	 CwkBRVc1n4J1/dJeEdnXSaZvILOMTQ9leLyBLe5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 042/144] spi: omap2-mcspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:48 +0200
Message-ID: <20260515154654.501268700@linuxfoundation.org>
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

commit fb45f95c377e4a4bdece2c5e17643b459c9c13e7 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: ccdc7bf92573 ("SPI: omap2_mcspi driver")
Cc: stable@vger.kernel.org	# 2.6.23
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-6-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-omap2-mcspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1587,7 +1587,7 @@ static int omap2_mcspi_probe(struct plat
 	if (status < 0)
 		goto disable_pm;
 
-	status = devm_spi_register_controller(&pdev->dev, ctlr);
+	status = spi_register_controller(ctlr);
 	if (status < 0)
 		goto disable_pm;
 
@@ -1608,11 +1608,17 @@ static void omap2_mcspi_remove(struct pl
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct omap2_mcspi *mcspi = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	omap2_mcspi_release_dma(ctlr);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
 	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(ctlr);
 }
 
 /* work with hotplug and coldplug */


