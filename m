Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F6352F86;
	Tue, 12 May 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609360; cv=none; b=pIFrcTG4weNuQACArttf9IshiyJE44uhPfV/ulTG2TZTq8UkS0/MkGvuNurK5yZG4j3j8GY9QKtexLAiWonDeZThmjXvgboEqcn+5ipTmE9tRfB35yhQdSPgn1NzoT2NTTmJ/DPQtkgjB3a1SVQw3jfanVAXXOlzBrVeGX7QR6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609360; c=relaxed/simple;
	bh=H7bDQFZToqXg6f4GO7mcAf2ZoE5oI22ggOEmNTrQrqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/H8qC46v/+VUUiBkvzZdBj8/3phN1JLDPvhvCwLBxVstdbNYmHAA1h7oPw3wLUXno8FL15itT8KssYjeJpyO+i+1iAb9Bn9SvleV9qF9++oH5UPOri2GZYwUJZxJ/X13OKm5/a78MkNf3dwN0qAhsHQkkOkC57WQ4W1owRcM0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJFtdhnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJFtdhnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0455CC2BCFA;
	Tue, 12 May 2026 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609360;
	bh=H7bDQFZToqXg6f4GO7mcAf2ZoE5oI22ggOEmNTrQrqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJFtdhnI7a6N9K/OC5uzOfSv66eMRqoQv72PLqFqrJAFwEheTA6UkuTr4B61NAXG5
	 UDOEo+6Lk+qSepNJG2k0lGTI3vio7AYpXmJKgNvAUo1lKI+1xld90UDQSy4dFwsNw7
	 ZJeu+dlOr5Q8oOe9L1sO0Yu3JYASAgGf6RTiqw9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 158/307] spi: topcliff-pch: fix controller deregistration
Date: Tue, 12 May 2026 19:39:13 +0200
Message-ID: <20260512173943.458243149@linuxfoundation.org>
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


