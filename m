Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064A9352067;
	Tue, 26 Aug 2025 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218843; cv=none; b=a65xSTOHD6nMLhHvtYLzXyvX0P8+lP7isVxV6SNdOG9bU1y0kkOeRcpyhs/x3zS/RimYAPm1nOy/nv117cgCBRyDutcUMHkb0RbwQHdvUgmHm+D4IGoVM1cEgqXYHemzklfnq+tLkO5cdADlJPHhNirKClB1VStrCfog/QtHtgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218843; c=relaxed/simple;
	bh=VcYAK23N3d3ADjwJT5ZlLXDRK8otY/rZU202d6dN/Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvXraLxE7K4b8P/L6zwpxeKO1CjEGQC7pdyt0fPpR47KGpFAQF4bYhr4qJDg+kCay/6pVPLOvnqLC253cDNR+n0krlamdRQjFDZ4PZoFhyUSsKCr2tR5Wo5XZaMvIDZT83mocYW/qleC2mcgxcb+dbDlTeKEHG3iGcRiS48wOZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeLiKUMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeLiKUMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8DAC113CF;
	Tue, 26 Aug 2025 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218842;
	bh=VcYAK23N3d3ADjwJT5ZlLXDRK8otY/rZU202d6dN/Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeLiKUMjfC5XIVWMLW7qt08cVsz/K22yZAw1TIvR/TM5mWYFZgVThtPzEJjWCPCld
	 JbfHOPOJm1Te54ciLzj+TRbhKjorXUxq0ajki5I6bEJ0ezrx7R+0teGoswp68EGk+i
	 4nzKkXpeVvXVIVOC+re/w1VQYIJoZJ3QsFbxn3D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/403] dmaengine: nbpfaxi: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:07:29 +0200
Message-ID: <20250826110910.133778263@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c6ee78fc8f3e653bec427cfd06fec7877ee782bd ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, unmap and return an error.

Fixes: b45b262cefd5 ("dmaengine: add a driver for AMBA AXI NBPF DMAC IP cores")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250707075752.28674-2-fourier.thomas@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/nbpfaxi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index b9a36a6a3852..0a8b04798b98 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -705,6 +705,9 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 		list_add_tail(&ldesc->node, &lhead);
 		ldesc->hwdesc_dma_addr = dma_map_single(dchan->device->dev,
 					hwdesc, sizeof(*hwdesc), DMA_TO_DEVICE);
+		if (dma_mapping_error(dchan->device->dev,
+				      ldesc->hwdesc_dma_addr))
+			goto unmap_error;
 
 		dev_dbg(dev, "%s(): mapped 0x%p to %pad\n", __func__,
 			hwdesc, &ldesc->hwdesc_dma_addr);
@@ -731,6 +734,16 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 	spin_unlock_irq(&chan->lock);
 
 	return ARRAY_SIZE(dpage->desc);
+
+unmap_error:
+	while (i--) {
+		ldesc--; hwdesc--;
+
+		dma_unmap_single(dchan->device->dev, ldesc->hwdesc_dma_addr,
+				 sizeof(hwdesc), DMA_TO_DEVICE);
+	}
+
+	return -ENOMEM;
 }
 
 static void nbpf_desc_put(struct nbpf_desc *desc)
-- 
2.39.5



