Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D72C3B4EAF;
	Fri, 15 May 2026 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861455; cv=none; b=huJYY1BDSpHgpvVqIDydVJEZZs8WxU8BADDA+FGeQZQ9GwWOQThiR9qa1NgEraP+YHIZ2pbkDvNDw1HKVK9VGKOpNCOEjrTUK1LZCR2WbVEqzQdflPXZWQbIHyMH9LtWSOAD4xGhSK7KwyY3U3XNz3C8u4oiDj0HfMFEV53rUVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861455; c=relaxed/simple;
	bh=86Jtcb0hXiE6ufyuTEh0u3F/K4ogldepEYlN1878yoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxbZ/2R1a8TBKHhS6Z85+at8H54v50L6Z7gqN81XsIrFjrm1G2lM/ZI/3DB31K6jlgj4xmVldPsOBGbBb+ayRmA82ChvBSuf/iC+wjWcoAPJUVZtWtMUj5RYVj/S689DxEc88JYG43FbdURj6dbvD0/ZOyWDBGlMEN3gfkqHwL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZzVWQEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZzVWQEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAA4C2BCB0;
	Fri, 15 May 2026 16:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861455;
	bh=86Jtcb0hXiE6ufyuTEh0u3F/K4ogldepEYlN1878yoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZzVWQEM0o4Y9yQBmy9bKhGHYv2qqa81dW12paKqECVDkipIb9rt/rOtgmjlt1f4B
	 BfNOLUW7OvwZBzKt/rziiqGBlsikIvdAnRnuhaENYbOPlnG55wl+HBKTKu5or/KilP
	 CWTUWd4yeSx4Khf/44ipkkEtpCNMG2pLTjOHn2Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 333/474] spi: img-spfi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:22 +0200
Message-ID: <20260515154722.219470610@linuxfoundation.org>
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
@@ -644,7 +644,7 @@ static int img_spfi_probe(struct platfor
 	pm_runtime_set_active(spfi->dev);
 	pm_runtime_enable(spfi->dev);
 
-	ret = devm_spi_register_controller(spfi->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -670,6 +670,10 @@ static void img_spfi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct img_spfi *spfi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	if (spfi->tx_ch)
 		dma_release_channel(spfi->tx_ch);
 	if (spfi->rx_ch)
@@ -680,6 +684,8 @@ static void img_spfi_remove(struct platf
 		clk_disable_unprepare(spfi->spfi_clk);
 		clk_disable_unprepare(spfi->sys_clk);
 	}
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM


