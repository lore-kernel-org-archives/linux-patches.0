Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC0AD55;
	Tue, 13 Feb 2024 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845657; cv=none; b=JDms+tehY15SE/dnSiXWhiikGDTnZiP/avWIsbM4lO/hTA9aVQnjEyrLdrPqDst1DDcaL1jIA8libiC6eiY0ilyzv+dZuUFTtRmHEFaIevdCfGNotQNxBIhmPKZee+iLf6CDmt93zlFVEN/aT2EuQyDBHQUxzt3jjg7Y9GFd420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845657; c=relaxed/simple;
	bh=pUJc5tq5iLXUbW3sqqq/9y7ycfxzSqkXZ2jwiwyB2fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHO0E52rudB4gjujKTuvZaX81b9yr/aINi62SMJ/hWPanUdwrehS+lP+ZD2KHjEjDx04Lx1vDdPnCvZyMJDInnSls+8iOFWikfxhvcTjI2qI1FXxF4/8f2FMvzWCXzllNdL7YGE0kFuLhxHTFfAzVMSUCdelI9LLvWE/hLYFqjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaQYO6Ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaQYO6Ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F60C433C7;
	Tue, 13 Feb 2024 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845657;
	bh=pUJc5tq5iLXUbW3sqqq/9y7ycfxzSqkXZ2jwiwyB2fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaQYO6BaG99ksq9iFsCYBvzKT4Xu4twa2icHKjnXeC+3WnNQtIhNxIAynS6c7lAWz
	 1R3p1jrgG6gizG9P6EN4XRnRs+8x6a2bthqdpmGvnwqb3qOGVqv7mcigH6xo2PO2yQ
	 WSKM254JBOgA4pFO2J9cM9NVwv7i3y21nnjz8rX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 003/124] dmaengine: ti: k3-udma: Report short packet errors
Date: Tue, 13 Feb 2024 18:20:25 +0100
Message-ID: <20240213171853.827451822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit bc9847c9ba134cfe3398011e343dcf6588c1c902 ]

Propagate the TR response status to the device using BCDMA
split-channels. For example CSI-RX driver should be able to check if a
frame was not transferred completely (short packet) and needs to be
discarded.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20240103-tr_resp_err-v1-1-2fdf6d48ab92@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 30fd2f386f36..037f1408e798 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3968,6 +3968,7 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 {
 	struct udma_chan *uc = to_udma_chan(&vc->chan);
 	struct udma_desc *d;
+	u8 status;
 
 	if (!vd)
 		return;
@@ -3977,12 +3978,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 	if (d->metadata_size)
 		udma_fetch_epib(uc, d);
 
-	/* Provide residue information for the client */
 	if (result) {
 		void *desc_vaddr = udma_curr_cppi5_desc_vaddr(d, d->desc_idx);
 
 		if (cppi5_desc_get_type(desc_vaddr) ==
 		    CPPI5_INFO0_DESC_TYPE_VAL_HOST) {
+			/* Provide residue information for the client */
 			result->residue = d->residue -
 					  cppi5_hdesc_get_pktlen(desc_vaddr);
 			if (result->residue)
@@ -3991,7 +3992,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 				result->result = DMA_TRANS_NOERROR;
 		} else {
 			result->residue = 0;
-			result->result = DMA_TRANS_NOERROR;
+			/* Propagate TR Response errors to the client */
+			status = d->hwdesc[0].tr_resp_base->status;
+			if (status)
+				result->result = DMA_TRANS_ABORTED;
+			else
+				result->result = DMA_TRANS_NOERROR;
 		}
 	}
 }
-- 
2.43.0



