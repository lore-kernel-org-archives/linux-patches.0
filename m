Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64034C9570;
	Fri, 15 May 2026 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862585; cv=none; b=muybLRXIsKyNcFzGC84Fs9hiXdILr6GL6Ht1gEN+B8zrJjrNNSGv3ohJ70K3KiEJSDn+I0vaAFm17UQatPEh2AQwJYYtVMFgJWyR/KTaTtvdbqITpCwaKIKNF2skIddfQV6z6ItOO6pJtbN4zvMe9ptsaF1uLUj/SoQlaiu6TIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862585; c=relaxed/simple;
	bh=2Llw+ECCDUIQ3GKdfYpSzbqZKrrg7SYdN+JtTTlJMH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn2Ds3jMgkB73dyFx6R8mIFIIiFpkusbIpNQlWDrQ03UBoXGdmx2VNPl2OKon41WshFLb4EF+IghV1zU+b/8scrsrYQmZ9rIan8GXHDcu7/rOhBNnenL3i3NvBZ+2e5HiV22YGGcg/ftlXG81nuqwPSQthvZFmDd3QkdAGuYLSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJ0yn9Ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJ0yn9Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF04C2BCB0;
	Fri, 15 May 2026 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862585;
	bh=2Llw+ECCDUIQ3GKdfYpSzbqZKrrg7SYdN+JtTTlJMH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ0yn9Ayq1t4h+dfwPRxOzQdPEyES+4GvZNyge5BP+eIkdVFBOsC3sNDAjO1hGFSc
	 d8/aTA+TKPrXWUxOHOGMHz/Rx502gl5evMPq7lS9J1fjU96baiLDDqCVZHOdjkj7BE
	 v8ubE7iaTkUKZ4TRaCBxWBSyh3mBYXQNfAD9t3E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 105/201] spi: img-spfi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:43 +0200
Message-ID: <20260515154700.821906891@linuxfoundation.org>
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

commit fc3a83b0d9c16b941c9028f5a8db9541dce4ddf2 upstream.

Make sure to deregister the controller before disabling and releasing
underlying resources like clocks and DMA during driver unbind.

Fixes: deba25800a12 ("spi: Add driver for IMG SPFI controller")
Cc: stable@vger.kernel.org	# 3.19
Cc: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-16-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-img-spfi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -643,7 +643,7 @@ static int img_spfi_probe(struct platfor
 	pm_runtime_set_active(spfi->dev);
 	pm_runtime_enable(spfi->dev);
 
-	ret = devm_spi_register_controller(spfi->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -669,6 +669,10 @@ static void img_spfi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct img_spfi *spfi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	if (spfi->tx_ch)
 		dma_release_channel(spfi->tx_ch);
 	if (spfi->rx_ch)
@@ -679,6 +683,8 @@ static void img_spfi_remove(struct platf
 		clk_disable_unprepare(spfi->spfi_clk);
 		clk_disable_unprepare(spfi->sys_clk);
 	}
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM


