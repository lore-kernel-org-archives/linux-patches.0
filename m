Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748A5301707;
	Mon, 27 Oct 2025 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593506; cv=none; b=i1GyFont8urbx4peNrUAI/DLliL5Qc7+10mT/XK7eZUNJ2uNqlEjV30DY0Mob+8nTON2h7CFQ/hFWIvWgRKeUu0GtKzKit6hV1nFzwN1yzhkzyBYbihN4JLrXkH1KQimpJx3jglzpa4Tr05qWAPaWHGi8JKnD6sApQyJWz/mKJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593506; c=relaxed/simple;
	bh=e0QqDenBEaDnjAqoVw6TZMMN8i1gHNEr4TNZEvWwids=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtUyEFimZp+tuYT68puL301FNpgH0fci/k2AyhYuTz8/G2GR6bIbhFe5ULs1mQ00OehCxqr8r6iCUWftWgeg35DFUbHABZapdxBKO+OML1oj52OkDKdgqdrRtELWniBkdPV7UF7n3a2e6erpRvYCZhCpSKDgrn7bvgtUQ9D/6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMP7fqN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMP7fqN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE46C4CEF1;
	Mon, 27 Oct 2025 19:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593506;
	bh=e0QqDenBEaDnjAqoVw6TZMMN8i1gHNEr4TNZEvWwids=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMP7fqN21qSS56aN9ciknPadz7hmh+cOiw/bw3JmFeFKq2PtnAAx0rJFKLjm0JxGb
	 xd+ZNojn8E2ZHKX5N2c/X0eIQb46p+2cCR/Ea5coW5TXUy5cEbcDx/J1DRtlM3NYmz
	 16CdkhwCasuYXQXuaKqC+9vBxhvpIHaQRt72v0bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/184] spi: rockchip-sfc: Fix DMA-API usage
Date: Mon, 27 Oct 2025 19:36:36 +0100
Message-ID: <20251027183518.005265384@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit ee795e82e10197c070efd380dc9615c73dffad6c ]

Use DMA-API dma_map_single() call for getting the DMA address of the
transfer buffer instead of hacking with virt_to_phys().

This fixes the following DMA-API debug warning:
------------[ cut here ]------------
DMA-API: rockchip-sfc fe300000.spi: device driver tries to sync DMA memory it has not allocated [device address=0x000000000cf70000] [size=288 bytes]
WARNING: kernel/dma/debug.c:1106 at check_sync+0x1d8/0x690, CPU#2: systemd-udevd/151
Modules linked in: ...
Hardware name: Hardkernel ODROID-M1 (DT)
pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : check_sync+0x1d8/0x690
lr : check_sync+0x1d8/0x690
..
Call trace:
 check_sync+0x1d8/0x690 (P)
 debug_dma_sync_single_for_cpu+0x84/0x8c
 __dma_sync_single_for_cpu+0x88/0x234
 rockchip_sfc_exec_mem_op+0x4a0/0x798 [spi_rockchip_sfc]
 spi_mem_exec_op+0x408/0x498
 spi_nor_read_data+0x170/0x184
 spi_nor_read_sfdp+0x74/0xe4
 spi_nor_parse_sfdp+0x120/0x11f0
 spi_nor_sfdp_init_params_deprecated+0x3c/0x8c
 spi_nor_scan+0x690/0xf88
 spi_nor_probe+0xe4/0x304
 spi_mem_probe+0x6c/0xa8
 spi_probe+0x94/0xd4
 really_probe+0xbc/0x298
 ...

Fixes: b69386fcbc60 ("spi: rockchip-sfc: Using normal memory for dma")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251003114239.431114-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index 9eba5c0a60f23..b3c2b03b11535 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -704,7 +704,12 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 			ret = -ENOMEM;
 			goto err_dma;
 		}
-		sfc->dma_buffer = virt_to_phys(sfc->buffer);
+		sfc->dma_buffer = dma_map_single(dev, sfc->buffer,
+					    sfc->max_iosize, DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dev, sfc->dma_buffer)) {
+			ret = -ENOMEM;
+			goto err_dma_map;
+		}
 	}
 
 	ret = devm_spi_register_controller(dev, host);
@@ -715,6 +720,9 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 
 	return 0;
 err_register:
+	dma_unmap_single(dev, sfc->dma_buffer, sfc->max_iosize,
+			 DMA_BIDIRECTIONAL);
+err_dma_map:
 	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
 err_dma:
 	pm_runtime_get_sync(dev);
@@ -736,6 +744,8 @@ static void rockchip_sfc_remove(struct platform_device *pdev)
 	struct spi_controller *host = sfc->host;
 
 	spi_unregister_controller(host);
+	dma_unmap_single(&pdev->dev, sfc->dma_buffer, sfc->max_iosize,
+			 DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
 
 	clk_disable_unprepare(sfc->clk);
-- 
2.51.0



