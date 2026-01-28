Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D2113B7A3;
	Wed, 28 Jan 2026 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614253; cv=none; b=h/n9kCFSGsm4OCvedXEAvb4hmk/h5JMQEK0gNMNDPxVPvpAzxVFEIZeMu8MMf/K4sZv/xpihc8buqULri8n9wG4614wPG65zqI7qKl1h4GyNnq1p5+5PlK8XVq8GfQ4Qhz23USOpc64TgX4L4tdvbnu2CaWw9GX0q66z+VpnVG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614253; c=relaxed/simple;
	bh=9/nPAM6bhJKlOac0r+IBNFuSZh1MYwp8Z2826sauD0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRgBX+67wRoBQ15rpWkfodM1ejRrmTiFfknmUQ2xDeQsm+JAmZ1vsJakTAcZhAzpzegfUlKSz3o18udjrm28geFnp0Vo0Aor82s9QMLVmFsxW1pnoXyDsZI5b2qHl9ypYh8SZ+VSvRf1T1BrHvBGhBSjzMitk1UGIxEXa2HOpos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ryw3ZCHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ryw3ZCHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0157C4CEF7;
	Wed, 28 Jan 2026 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614253;
	bh=9/nPAM6bhJKlOac0r+IBNFuSZh1MYwp8Z2826sauD0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ryw3ZCHOxpCsjfo+YYeBeO4PNkIft7jptZe1FAvRFoCMJPJiXAV3P4fLIC85kDTbX
	 PTnStGqP4jA5e/yOoDF03Bq0n8q0ePnp4Ab20DaHGHQtR5mtDNaQrXuru2P+UrQc9N
	 Zd3f1ZS7pV8PXoOHELAjnt4GENOQ1XghFY+Rv8Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 081/254] dmaengine: dw: dmamux: fix OF node leak on route allocation failure
Date: Wed, 28 Jan 2026 16:20:57 +0100
Message-ID: <20260128145347.609259864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

commit ec25e60f9f95464aa11411db31d0906b3fb7b9f2 upstream.

Make sure to drop the reference taken to the DMA master OF node also on
late route allocation failures.

Fixes: 134d9c52fca2 ("dmaengine: dw: dmamux: Introduce RZN1 DMA router support")
Cc: stable@vger.kernel.org	# 5.19
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20251117161258.10679-6-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw/rzn1-dmamux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/dw/rzn1-dmamux.c
+++ b/drivers/dma/dw/rzn1-dmamux.c
@@ -90,7 +90,7 @@ static void *rzn1_dmamux_route_allocate(
 
 	if (test_and_set_bit(map->req_idx, dmamux->used_chans)) {
 		ret = -EBUSY;
-		goto free_map;
+		goto put_dma_spec_np;
 	}
 
 	mask = BIT(map->req_idx);
@@ -103,6 +103,8 @@ static void *rzn1_dmamux_route_allocate(
 
 clear_bitmap:
 	clear_bit(map->req_idx, dmamux->used_chans);
+put_dma_spec_np:
+	of_node_put(dma_spec->np);
 free_map:
 	kfree(map);
 put_device:


