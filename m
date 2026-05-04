Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4B835A3AD;
	Mon,  4 May 2026 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904509; cv=none; b=tffXKGiqQPoLX3utqTddzrnH7ZDE5Nis/XjDRoBT2gPh+qCl/24IAvMg/zY2D9Y06sDUL6XqbaKwxBsac1uKojMEIdkpWlNcvVfmiff27/wnc0bT0etN3NsfkVPDlnDLkZMQnNDcXB/0fDO1xm9nqdUnyg4IgIcMZH/79O2/RoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904509; c=relaxed/simple;
	bh=Sk6oM56b3r+wg68o4J2VdT4Gb6DJXFH2cECY9d6WdUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2LPOgUqF+yb41G7S1mjZ8Vb+9wLH5+z2pCRPjn8N7c6s39f9/HVnk3Sk9ktAY1RrevjPtAh+YwJMIML3eCaTOYWddvH0r/hqn0We16H4LSm2zbNfWc4vHsjVqd76EU7h4vDgZMvYVYBqtqcvweslGSdWGCdiH7ewMDGp0qDXJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlkBsuqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlkBsuqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20466C2BCB8;
	Mon,  4 May 2026 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904509;
	bh=Sk6oM56b3r+wg68o4J2VdT4Gb6DJXFH2cECY9d6WdUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlkBsuqEBNqbCqHa7CS9I7Jhd48zu1ZNo1FStVOYipExKUhfX1VZR4hSnIDgWRcbI
	 GmUkhCI/kZvOm1cISiyo0GPDVTrVtNmLxXYkneyHGDQI5gfRAuDD5fUw/sti7Hzk70
	 ruQPfZ61pQwGxmwe38McCVZ15yMOQYozkAjhyyvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 033/215] spi: imx: fix use-after-free on unbind
Date: Mon,  4 May 2026 15:50:52 +0200
Message-ID: <20260504135131.384630586@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

commit 1c78c2002380a1fe31bfb01a3d5f29809e55a096 upstream.

The SPI subsystem frees the controller and any subsystem allocated
driver data as part of deregistration (unless the allocation is device
managed).

Take another reference before deregistering the controller so that the
driver data is not freed until the driver is done with it.

Fixes: 307c897db762 ("spi: spi-imx: replace struct spi_imx_data::bitbang by pointer to struct spi_controller")
Cc: stable@vger.kernel.org	# 5.19
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1893,6 +1893,8 @@ static void spi_imx_remove(struct platfo
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(controller);
 	int ret;
 
+	spi_controller_get(controller);
+
 	spi_unregister_controller(controller);
 
 	ret = pm_runtime_get_sync(spi_imx->dev);
@@ -1906,6 +1908,8 @@ static void spi_imx_remove(struct platfo
 	pm_runtime_disable(spi_imx->dev);
 
 	spi_imx_sdma_exit(spi_imx);
+
+	spi_controller_put(controller);
 }
 
 static int spi_imx_runtime_resume(struct device *dev)


