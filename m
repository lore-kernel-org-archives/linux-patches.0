Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AF834A322;
	Tue, 26 Aug 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215909; cv=none; b=oTPS/T+ijCXNI9lHwlW611rFJ6pT1ZNeavCV6ZfG7dtSRsugi2HSebi37/AP2hspCjnK21TwJ3VU3luxxogPVRmLS0wcRiDs7qBzWId3ANFkhSqGs/bFei9Hjua2ln+tgXv47uM72jdikpuXmqmwsUKIkBaKByCnKW1AihUxZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215909; c=relaxed/simple;
	bh=whvJc9C5EDg6+EbMIHis0cXEPqUeVYL55dgx66v03Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHgzhFMBS2SKBZFxq4kxR63xqUruHJMVvbEbWT4NAjSW9xC/5Qh0c/9TgBD+czTgUxi8/FreO8Scb+gdf7s2F74lFPBb7H0nCBCUcUQ4q5cvYuiDAPGHcVW/XCo1EdtWiMI+DjOETPhGbl+MWCINZaNfkCb5u0cNdPFJKwG1lpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srko8t4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srko8t4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980C3C116B1;
	Tue, 26 Aug 2025 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215909;
	bh=whvJc9C5EDg6+EbMIHis0cXEPqUeVYL55dgx66v03Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srko8t4F6Wo2IliLf3lxXwi/KR8cnfylRwtZxnYerJvY6n71T3l8cUf/BpEGS4JlD
	 2bFMce17KuyfjoGju4PSA5rLPpRhG7h/CuBV8mMwSk2ia5gVKHU2ZfwNDI+8t90M35
	 qMZhYvWhASeTFi0nDPELcjJfucb4M1KWNrvtLfvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/644] dmaengine: nbpfaxi: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:04:45 +0200
Message-ID: <20250826110951.259951241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bbedf57e3612..94e7e3290691 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -712,6 +712,9 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 		list_add_tail(&ldesc->node, &lhead);
 		ldesc->hwdesc_dma_addr = dma_map_single(dchan->device->dev,
 					hwdesc, sizeof(*hwdesc), DMA_TO_DEVICE);
+		if (dma_mapping_error(dchan->device->dev,
+				      ldesc->hwdesc_dma_addr))
+			goto unmap_error;
 
 		dev_dbg(dev, "%s(): mapped 0x%p to %pad\n", __func__,
 			hwdesc, &ldesc->hwdesc_dma_addr);
@@ -738,6 +741,16 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
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



