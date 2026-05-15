Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FC83FF1A2;
	Fri, 15 May 2026 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860312; cv=none; b=A6w1rEhWqINyVViKJJFHqloynbM5RXYxTey0WmCP44BbaM/6bFdrz6kdUp2oIr5yb51WjEifUfs0We+SJzLc1B6j2lin2ZeXV0uPaof+n8JuIpYVd+D6FA6YA45gqAEQYgxPc0YOHEcYb3i5r4oL8PWjqETX4F+6ir39AKOrPLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860312; c=relaxed/simple;
	bh=Bfd1w/qeZU+nCgeOjU3Jp6cl6FLf7MyGkqrZV/dtK/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Btoq2JwR6sd0VoDVD4J3FcdWqX0qEFlJBk+1HTR05XT/4nWW3FOIGbr8fLAGFbQOT/4YPcQvpGci9KDgl7lfZWGp+Txs5hbPUaFpfMxsOB2ETjhJfO0w8ZPbNO/KkDQAN/qVTRtDWGtasxW0jhYgd3wfTdUjPm4VauHrwBe3IIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWw6AlQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWw6AlQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF064C2BCB0;
	Fri, 15 May 2026 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860312;
	bh=Bfd1w/qeZU+nCgeOjU3Jp6cl6FLf7MyGkqrZV/dtK/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWw6AlQNS2dBJkT/3ngahkctmTkLJ8zKxtGiGaDvsPBsDYoATUo1GwWJH88zCFMPg
	 G/IMrHBmLputkUoE9CsHxRvz5Aqwtd93LsXY5EwdA39YYhIzV49z7qF5hCxEk77zKJ
	 KvBmTV0uuosVIc+1s5MAJWp18NVBl0uv7MDoJTLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 040/144] spi: s3c64xx: fix controller deregistration
Date: Fri, 15 May 2026 17:47:46 +0200
Message-ID: <20260515154654.452373108@linuxfoundation.org>
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

commit c1446b61e472da24d1547525193467b4bea4a7cb upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 91800f0e9005 ("spi/s3c64xx: Use managed registration")
Cc: stable@vger.kernel.org	# 3.13: 76fbad410c0f
Cc: stable@vger.kernel.org	# 3.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-12-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-s3c64xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1371,7 +1371,7 @@ static int s3c64xx_spi_probe(struct plat
 	       S3C64XX_SPI_INT_TX_OVERRUN_EN | S3C64XX_SPI_INT_TX_UNDERRUN_EN,
 	       sdd->regs + S3C64XX_SPI_INT_EN);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot register SPI host: %d\n", ret);
 		goto err_pm_put;
@@ -1402,6 +1402,8 @@ static void s3c64xx_spi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(host);
+
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
 	pm_runtime_put_noidle(&pdev->dev);


