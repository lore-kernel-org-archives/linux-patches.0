Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0D9370D47;
	Sat, 12 Sep 2026 10:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208524; cv=none; b=X5a0Z4HFfhAURflwJaNgDCXSr4g7OTwbCalPB4BroM62UKOucCspj7r/pmQSyiCADv21996NhfDTPkmXN/R32bAt1aCfY4ojGLW7bqmE2MK49Rf6uqt2E8JtBmB6+g47CxfrIYJvp5x+BtT4XvtVK3azSJziXO0gyIF2IS1T/kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208524; c=relaxed/simple;
	bh=6zAn0uRrATqQsLuhx9l5tP6ERNaBGd+fzBJs+Ge9cgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adegP/8PvIY14NFyyvSd6jWRNkQ+R9i6EWk2++/BO8JNtB5nViUnkPSvy2Ph3Tc6UEZ67eqDJKFA7TCf9V57vwvHqrpuKF//qPWmV9iEvyIBdGds5KDBRpi7EdxhI7O/bymRfuMkXsxm7gHbjKzl5nXjIy8s0tw2RVADLIVLYmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNZJSCYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNZJSCYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0BC1F000FF;
	Sat, 12 Sep 2026 10:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208510;
	bh=1PDPN2Hfgzr+jpELCnmKNVRBqvumQYXJZaEQxCMPydQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNZJSCYD1PEEZEJkQPxFjUsWiMU8i1EL3eoWnxc0DZunhRhbYW0J9IdFT9WxwTnOD
	 ae5pYxSwLKQ2zJNFJwMrF2HnJAwks8H98Whg6cUxHT9oDpQABvtaqv0BbuHG+82Veo
	 7RdCAoaLHctFawgvtlChwWuM581R61oEpir+q2bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0631/1518] spi: davinci: switch to managed controller allocation
Date: Sat, 12 Sep 2026 08:46:40 +0200
Message-ID: <20260912065637.704961027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit ea408a05dc8f18b4a184b88d6e19d2fd1acc1527 ]

The controller is allocated with the non-managed spi_alloc_host() while
the interrupt is registered with devm_request_threaded_irq().  During
removal, spi_bitbang_stop() only unregisters the controller; the
subsequent spi_controller_put() then frees the controller together with
its embedded davinci_spi devdata, which is the IRQ handler's dev_id.
The devm_request_threaded_irq() release action (free_irq()), which
drains the handler, does not run until after .remove() returns.  A late
or latched interrupt can therefore reach davinci_spi_irq() and
dereference already-freed memory.

Switch to devm_spi_alloc_host() so that the devres LIFO order releases
the controller only after free_irq() has drained the handler, and drop
the now-redundant spi_controller_put() from .remove().  The probe error
path is simplified to direct returns.

The clock is acquired with devm_clk_get_enabled(), which is registered
after the IRQ and thus released before it by the devres LIFO order.
Drain the interrupt explicitly with devm_free_irq() before disabling the
controller so that a late interrupt cannot access the registers of a
clock-gated controller.

This issue was found by an in-house static analysis tool.

Fixes: 5b3bb5963ff2 ("spi: davinci: Use devm_*() functions")
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260719010014.3163356-2-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-davinci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index a29934422356b..c0963483e05c8 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -868,7 +868,7 @@ static int davinci_spi_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 spipc0;
 
-	host = spi_alloc_host(&pdev->dev, sizeof(struct davinci_spi));
+	host = devm_spi_alloc_host(&pdev->dev, sizeof(struct davinci_spi));
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -998,7 +998,6 @@ static int davinci_spi_probe(struct platform_device *pdev)
 		dma_release_channel(dspi->dma_tx);
 	}
 free_host:
-	spi_controller_put(host);
 err:
 	return ret;
 }
@@ -1022,6 +1021,8 @@ static void davinci_spi_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&dspi->bitbang);
 
+	devm_free_irq(&pdev->dev, dspi->irq, dspi);
+
 	/* This bit needs to be cleared to disable dpsi->clk */
 	clear_io_bits(dspi->base + SPIGCR1, SPIGCR1_POWERDOWN_MASK);
 
@@ -1029,8 +1030,6 @@ static void davinci_spi_remove(struct platform_device *pdev)
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
 	}
-
-	spi_controller_put(host);
 }
 
 static struct platform_driver davinci_spi_driver = {
-- 
2.53.0



