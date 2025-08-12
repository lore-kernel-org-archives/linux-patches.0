Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D512E972E;
	Tue, 12 Aug 2025 17:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020820; cv=none; b=RmdEK867qF8qDnORlnTMBYqvAaOI4p1F5ayPChrRSUxh8Af+DoKG9vUiuL2Avm9vXoMUKto/77TOoeAxGqlOkXhNz8ng2IDGXfvAXkImkBvJ7/9aw762J9NcDMFPiC6YL6RPB6of3yKRcZ8O+mpS7m+fOTL+J6y2c2ipYXkPzYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020820; c=relaxed/simple;
	bh=0h7vHR9vWfWhvK4FZiqg/QnTr+2J/0SUetvW5bzJsLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTxpDzmC7p7SO3IC9vu7rD5Ncj3Umgtxxn3hDnNwFxChkQiCW5cCMoiU3pMBi5CJ2VbCESuVNhp5V/H2G6usmeLNfskaEVsUY5kAlgPQ5HeOaqPNoXWQdOZzcQit6w7WSpAUzDwIBT2JZj4s6nrejcN0dGxzKdRXL1f4cx6UFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMKGl9/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMKGl9/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C429EC4CEF0;
	Tue, 12 Aug 2025 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020820;
	bh=0h7vHR9vWfWhvK4FZiqg/QnTr+2J/0SUetvW5bzJsLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMKGl9/xerus/Pu0/WxBn1AyZuFPZAeDJ4GT1h1GoD91h6xSeNhGkBQDGkd7GTkZd
	 t4LarrlV4O+IAqPPRmVThxKE7F8IQGD82CErCWYjf0DL2+wk+nD2M8pZVyTSQqHAbb
	 HhArF5XdXVGl9oV64zyGcwOWYR+W/b0iLRUl0C2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/253] dmaengine: nbpfaxi: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:29:21 +0200
Message-ID: <20250812172956.099367275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e389945e36f2..256ae956b55e 100644
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



