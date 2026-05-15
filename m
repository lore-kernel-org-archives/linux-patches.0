Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C53C0607;
	Fri, 15 May 2026 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862038; cv=none; b=K6OXPADZYkWIXMMbvR03vno+1Tpjr5vcBymxkUhnTgfKDPYGbrxvhuhbCAytYB8GFImy/x46Cy3EdCH1yAWZm7QnSz3BpGEYTCwUUAwEnOa1wgQHwmhgw31grnjZQ26bz6QHH78D5g6Oq1QaIq/llXWuXusSWMJK89mwPTt91Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862038; c=relaxed/simple;
	bh=8PPB5QwOfP2LOkW0M6Lalr7TToPXNp5FvYmk3YP+DiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/8nDPqAtARy+k0tSv1loyGzXfxaRhUDXEA0B8UCNFotshlfRL7xSJcCtXANRDA0QoRYT4/jP338FepmsTHmJRdjoFFpQ8fBLNPBw5Cn5Xie9nm9Wl+sO+lfN6wrV/Af+p75F7k/8RtpKxqQiumgsornCuQaa4Dxq3S7iq8vdP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUoF2z2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUoF2z2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8E0C2BCB0;
	Fri, 15 May 2026 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862038;
	bh=8PPB5QwOfP2LOkW0M6Lalr7TToPXNp5FvYmk3YP+DiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUoF2z2h7kFYlJtRWkl2Zck78Rxc0F6q4N/ek/2FAtskwg6et5Dv5/6mprGqIVb3o
	 Rb5TeIDnu0V2/p7ro6x1C11jXWX51QHOtfretO2OpPMmifLCzQ69skIqbu6KBjGnxZ
	 v0+wurv067ik2GsUVeli4cRfmrrgH6d1EhnP4utY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 084/188] spi: img-spfi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:21 +0200
Message-ID: <20260515154659.146777873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


