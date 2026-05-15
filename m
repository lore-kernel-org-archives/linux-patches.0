Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EBF2949E0;
	Fri, 15 May 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862578; cv=none; b=o9nQjsGTOpPYothk2TBAHffDoiDltuOfvWNSwQR9YtXFCUC0TDsp6wdA+C3IjFMUIHJ+x5FzVNjreQ0qLk9sYxANoq/W60PPy0x8paGlz7ZGkdPZnXwd/gDIV5XGDL4kjGEWhWvphwLaW/+U83RT+866xxkGqCaRlvLacUu9LaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862578; c=relaxed/simple;
	bh=vLFVHXXGWkh74aW8bHanoS+Bm8zFTfxWj+gisegowMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaliQAZrNgqHFn8OFQZhB7JiG7uzMvLSbxoOgZxtrU6GbAP7tgAn2CGbQiYkZbX+DqiKEwT9Ls5yb4PNQaY7hZX4vpUHUkCwC53/2pc3fUkSAAO88gCeysMVggY+NjmxnNEYhg+kTM1K7SQldFuf1IoqJrpqiJV/kC8NLRTU9yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vk9mQzx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vk9mQzx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F7CC2BCB0;
	Fri, 15 May 2026 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862577;
	bh=vLFVHXXGWkh74aW8bHanoS+Bm8zFTfxWj+gisegowMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vk9mQzx/FwopmBTl6oDQFlJ5uYc03L31fpXAjWFLLZMgm2BMJ7Ws1564Czp95tqJv
	 y85bIAwYW+JVH77lx2Axj4PNJttTPEvDuSn7h3MCNTm5Fr4f1ah2VuUWIdNOoS9xg7
	 hr3L19BFSnUt5YgU4xMnA94L3uNtIr5GPS1FzPSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 103/201] spi: sh-msiof: fix controller deregistration
Date: Fri, 15 May 2026 17:48:41 +0200
Message-ID: <20260515154700.774608146@linuxfoundation.org>
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

commit 45170f67a08b912ead6ccc387ba06954d1d4e53a upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 1bd6363bc0c6 ("spi: sh-msiof: Use core message handling instead of spi-bitbang")
Cc: stable@vger.kernel.org	# 3.15
Cc: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-14-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sh-msiof.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -1289,9 +1289,9 @@ static int sh_msiof_spi_probe(struct pla
 	if (ret < 0)
 		dev_warn(dev, "DMA not available, using PIO\n");
 
-	ret = devm_spi_register_controller(dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
-		dev_err(dev, "devm_spi_register_controller error.\n");
+		dev_err(dev, "failed to register controller\n");
 		goto err2;
 	}
 
@@ -1309,8 +1309,14 @@ static void sh_msiof_spi_remove(struct p
 {
 	struct sh_msiof_spi_priv *p = platform_get_drvdata(pdev);
 
+	spi_controller_get(p->ctlr);
+
+	spi_unregister_controller(p->ctlr);
+
 	sh_msiof_release_dma(p);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(p->ctlr);
 }
 
 static const struct platform_device_id spi_driver_ids[] = {


