Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35483A961B;
	Fri, 15 May 2026 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862638; cv=none; b=BjlINXDubwIDSLWgMfSkrOGM3Ppo8GmsI7UwTf+0p4QGno3EXvfquAaBFvQ4drAgHF5GU7Hks6Cls5MNi8UvE0QExZm9005N+/t9y2Vu2rUfOXsdefl51vZXTMZVHz+ngW4bIzHUGZw+jstLvzoLmHjoytL53+wb9r6d3QYooTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862638; c=relaxed/simple;
	bh=4881bcLvj+J+S6PVLPTOnNb+wVWNA8sUhBC7RvypAk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nObpcABUONSJaxBrtdz6qDz98zxmvnQNK0ztIgTVzU77+9wom/2NoiSM2k4OxS8dHT9OKLfK+k9c2QVQct54Bb6FP8DF3dvD8qV1eaAPtzoCIBQwgGE1B7epCY5/CcYLzPGwR7JVD0uLkzpFDE8HicL2VT83XJb+XoYgv5ff1/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDF6oCQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDF6oCQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77991C2BCB0;
	Fri, 15 May 2026 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862637;
	bh=4881bcLvj+J+S6PVLPTOnNb+wVWNA8sUhBC7RvypAk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDF6oCQfQO3XYNBH1CpXDu5CkcQDgMvOVlcjy1MJXN+NASvU2fC3k516O/tJX3PAO
	 MKEDK1lxui+nb0qNCpj1Pf/9V17ZbBg1eqtGPLzNq9VYDEjJeZTBRRtD16ZLxyqU7C
	 BZkbYXRp0f4Yz+ByNzs2HSWcMr861hsCa5OjVmP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 088/201] spi: omap2-mcspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:26 +0200
Message-ID: <20260515154700.438046120@linuxfoundation.org>
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
@@ -1585,7 +1585,7 @@ static int omap2_mcspi_probe(struct plat
 	if (status < 0)
 		goto disable_pm;
 
-	status = devm_spi_register_controller(&pdev->dev, ctlr);
+	status = spi_register_controller(ctlr);
 	if (status < 0)
 		goto disable_pm;
 
@@ -1606,11 +1606,17 @@ static void omap2_mcspi_remove(struct pl
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


