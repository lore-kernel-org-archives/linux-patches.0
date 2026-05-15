Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF1D20297C;
	Fri, 15 May 2026 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861431; cv=none; b=HmjZh5cHLdBeb8HoL5o3NS5N5WZn5dg16YUlICuuEWQA+YGhWcGhmhvKy9CIcKGi514DGleOhfStyXKcFsbZxqYtXzl8D6/deggc6FUPxSBM5dfS6bUEgtlMRNGfZheHc0yTwRwXAvSWpkXlmciI8fa8+LbcSv8OL8h8gCiZ5gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861431; c=relaxed/simple;
	bh=J1V6yrtQcE8i0JWcdec+pbvB6/7csoEQy4Oxzj++owU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuRW/DUVMUb04ShkStVA64tlUwz5+NX0TWiAuyxf41/3H3um3voVrFFRH3+yUYG8Sq+0+n7kKRUZpR7bOjo6vtpz+jlViM2qXy9uQfWahnDO4zkty4qCPkKWKZiS3ehreeBQskfZZ8ZfgNSbF+txmM2eU7SD3aBMR7W2BpCg+No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgraOs29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgraOs29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9306C2BCB0;
	Fri, 15 May 2026 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861431;
	bh=J1V6yrtQcE8i0JWcdec+pbvB6/7csoEQy4Oxzj++owU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgraOs29ppzr5M0JWZSk5hqR1f2dTpgA9iftVVXH/hV0XF5UK5/yOxHi8iLbrepat
	 BQCKKnesyIuZjx7qi8wtWpDSSx71+CAySobKj9q99G+cMt9vJ1nS/EICom1Ptfn7ne
	 O1aoh9a5m0SEhUJ75JK/od4Y9HCU+eojrEFTlYVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 325/474] spi: omap2-mcspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:14 +0200
Message-ID: <20260515154722.043110272@linuxfoundation.org>
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
@@ -1541,7 +1541,7 @@ static int omap2_mcspi_probe(struct plat
 	if (status < 0)
 		goto disable_pm;
 
-	status = devm_spi_register_controller(&pdev->dev, ctlr);
+	status = spi_register_controller(ctlr);
 	if (status < 0)
 		goto disable_pm;
 
@@ -1562,11 +1562,17 @@ static void omap2_mcspi_remove(struct pl
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


