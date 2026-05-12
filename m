Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F67F36EAB2;
	Tue, 12 May 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609162; cv=none; b=Ydd3NL/IoOH2sgpWpFAbR95Ms8FEKobH50ZqjiCszx5oGNOUNLmj3R4Y1ZsC+QE1cMj5TOXwTzPZG/9oRJnm+q3gllTDq659WxsNnh3EqfMqDq5fV2MjM0DXmF87IKGw16QiFg/JJJ66arNSCufGSeDFULDDAgbskv7gSfAcDfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609162; c=relaxed/simple;
	bh=Zd10WfvvfQftuAYHoUdbN8nsywPyql9ygTU+LiA8fUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf7r+Lx0Vz0jKCa0oqIBwNjXqlAYyO0WBpy/88+jfKKerexoBGw3nrLbdCxIQ4S5BPaecdyCqnehqN0iQ/x48b441Uw4Q0O5e7IWoK2JO16EflosHT7JSV2kfEzssKpAXLI0YU0NkOFj3SuGZycCbrii/lqFBD8Yl5xOOApGW78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsGtMiWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsGtMiWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDB6C2BCC7;
	Tue, 12 May 2026 18:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609162;
	bh=Zd10WfvvfQftuAYHoUdbN8nsywPyql9ygTU+LiA8fUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsGtMiWEDU6nE/RTAWgecJ19X9vvK49ZAqzKFrkJ3hHn39M5NOerJdur+DT2GHAw9
	 6PAoFMF3SRc/Np7jch1zGxWeFL2n0HiqtQGQM7ek08OvgBfRD42awRHhlx3tSLJCk9
	 K5t19LdIocmjWni2jBtQic9OfU6xITMtU4LsAp70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adithya K V <adithya.kv@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 089/307] spi: s3c64xx: fix NULL-deref on driver unbind
Date: Tue, 12 May 2026 19:38:04 +0200
Message-ID: <20260512173942.007764101@linuxfoundation.org>
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
@@ -1401,11 +1401,6 @@ static void s3c64xx_spi_remove(struct pl
 
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
-	if (!is_polling(sdd)) {
-		dma_release_channel(sdd->rx_dma.ch);
-		dma_release_channel(sdd->tx_dma.ch);
-	}
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


