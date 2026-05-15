Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156D53E0098;
	Fri, 15 May 2026 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861138; cv=none; b=b7K6n7eRzq1YnddyuDyASkMPvcqXf+OzBN610YciSQauTinp17QovhTXATEHCTiM/jlt4sNW9ylncb+xt5a6ggPfz1YfDDY6X6CPmBzXDr/dbhbTTjEz5HEARH183MuZncRIM0plNW3BJ4v/sAQk7xkF4g2A/RNk1aToVm4nFU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861138; c=relaxed/simple;
	bh=+gYvBEM/cIrzxDDLrIBIakASMP/2OmwvMU5QYF8Dz7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZkZ6aUvRtY0t4RPT7xy+qj1fMMu/UCQPypB5jHbD9/hxMopzCVizPHDeXcqUTbKLnnY5jd3s1vd5CBIi2vcwSMT8f4e67oTmTMnDJobWFMzO/q8GygR/QSNUAD0RDJWfQ1fkj53l3kAOsmIUChUAZ5O3ip6VFMUSLMTnwbhbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJNnMABw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJNnMABw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9002CC2BCB0;
	Fri, 15 May 2026 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861137;
	bh=+gYvBEM/cIrzxDDLrIBIakASMP/2OmwvMU5QYF8Dz7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJNnMABwdZgG0WngasQfaI/satGY/VXKR6k9KBf4PLJY/A6oLPLSpZ+GSdLgjRZaP
	 9Bbq6XqxwZcUywIEyIPXbupFZ1FFj7MAxaWXVgU/ZesPp4F5NkBnylpSbm0hTNk+q9
	 7Cg4Lj6NUffa3nTgWHPZ6UEb+++35zHZHL5zqqEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adithya K V <adithya.kv@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 214/474] spi: s3c64xx: fix NULL-deref on driver unbind
Date: Fri, 15 May 2026 17:45:23 +0200
Message-ID: <20260515154719.640187510@linuxfoundation.org>
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

commit 45daacbead8a009844bd5dba6cfa731332184d17 upstream.

A change moving DMA channel allocation from probe() back to
s3c64xx_spi_prepare_transfer() failed to remove the corresponding
deallocation from remove().

Drop the bogus DMA channel release from remove() to avoid triggering a
NULL-pointer dereference on driver unbind.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: f52b03c70744 ("spi: s3c64xx: requests spi-dma channel only during data transfer")
Cc: stable@vger.kernel.org	# 6.0
Cc: Adithya K V <adithya.kv@samsung.com>
Link: https://sashiko.dev/#/patchset/20260410081757.503099-1-johan%40kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410094925.518343-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-s3c64xx.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1338,11 +1338,6 @@ static void s3c64xx_spi_remove(struct pl
 
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
-	if (!is_polling(sdd)) {
-		dma_release_channel(sdd->rx_dma.ch);
-		dma_release_channel(sdd->tx_dma.ch);
-	}
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


