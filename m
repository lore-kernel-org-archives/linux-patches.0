Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815793C0A13;
	Tue, 12 May 2026 17:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608103; cv=none; b=ZTriJQiKqTlWcLzLmMMNIGY7kNag8hGwDwlaVq5LEp92UvtVmOr9BYV4H6y1fxquRUjYyuw6vzoUc187wJK2o0ptcnel9kQsXTX/pLWw19Wwuc7ysF38yoKDuyX7rieMoGYgFCvf9i2TncC25SlnQLXrhuUbU7c7pm3jIxt38UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608103; c=relaxed/simple;
	bh=YKqk3EFKN+917GklLsEjtzqWAMFVt17gWH5J5k1tj2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os9ulo5fvpDdl7WkkuMTeAg3Bdzvn839NGgBY1PkkALNbwz1fUdeVS/OpJBztDWXnksenpA8NvMKJBY3/2eTo9JUiSl9DzqcATt8HLHYR9JiyKGuHrrh9CzBOUHh4N36JTU0T1TnuayNHW42WmlSdjkNGK5L2wEaBJO2hIamkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbLF3/Z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbLF3/Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18405C2BCB0;
	Tue, 12 May 2026 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608103;
	bh=YKqk3EFKN+917GklLsEjtzqWAMFVt17gWH5J5k1tj2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbLF3/Z3KMchjYKdpC7o/tn+Q+A48eE9gHJC3waexWd8XFzLWjS1docqjbjvOOcAS
	 XsKwF1FPE/q1ons8RvyPSh7Y1jZe7+t8SYONC39uI5WO9XwEjE4XtX+o33r15O+RTI
	 1yHM1nDCvsxgtKs55vtK/UUafQv0Y9sEOLMILaok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 103/206] spi: topcliff-pch: fix controller deregistration
Date: Tue, 12 May 2026 19:39:15 +0200
Message-ID: <20260512173935.038689925@linuxfoundation.org>
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

commit 5d6f477d6fc0767c57c5e1e6f55a1662820eef87 upstream.

Make sure to deregister the controller before disabling and releasing
underlying resources like interrupts and DMA during driver unbind.

Fixes: e8b17b5b3f30 ("spi/topcliff: Add topcliff platform controller hub (PCH) spi bus driver")
Cc: stable@vger.kernel.org	# 2.6.37
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-topcliff-pch.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1406,6 +1406,10 @@ static void pch_spi_pd_remove(struct pla
 	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d\n",
 		__func__, plat_dev->id, board_dat->pdev->irq);
 
+	spi_controller_get(data->host);
+
+	spi_unregister_controller(data->host);
+
 	if (use_dma)
 		pch_free_dma_buf(board_dat, data);
 
@@ -1433,7 +1437,8 @@ static void pch_spi_pd_remove(struct pla
 	}
 
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
-	spi_unregister_controller(data->host);
+
+	spi_controller_put(data->host);
 }
 #ifdef CONFIG_PM
 static int pch_spi_pd_suspend(struct platform_device *pd_dev,


