Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E792A1D7;
	Wed, 21 Feb 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522967; cv=none; b=LWMOZw5sjUkFNuY5wa/o+eG/ioRjDyQGpFt0wevYrIX65V4WDxNDSfuQYSAs2ga7kpmH15SK5nHigEji73U7gBKaLmqdRZIleXeT9rGtJXuYEyTij5YbFj00RtgVc0mYxxldGh07ZPytPrsXkDeEaY3YYWVXnVAfaGEJ7piFxvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522967; c=relaxed/simple;
	bh=dnA/W/5mOsialqV7SAgxAjVo66y2H/cPpyFzhQDx+No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unDdYZ3711ZTZIhSnYV9J5wf3332f3Ef9kVRrSeBezIoFFVb5Htkr+8XGSo0iPMBBep3ygquiw5aYs40wEc9jIcPm6uO+Lt9YPQtW0R+5u5qsL7qPP0FW4zEtegOw+7WW5B+rIWYQ7LdipRviTwazRWaRvu5homVkrnMulpqHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy6Pacp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy6Pacp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BCFC43390;
	Wed, 21 Feb 2024 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522967;
	bh=dnA/W/5mOsialqV7SAgxAjVo66y2H/cPpyFzhQDx+No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy6Pacp0SCAqb0uDNTymd0AzXPIitU9a+BLV1HbWsPs3RcpmzKaoeFJPW7mu6dv37
	 8UOng3+zNRqVqMbKUzncMDQXsA1uL6tgxHw2k4KgMS9K9j3sy+yB21CUKeaLctehy6
	 naL/7je42tCnfW3NrajkBwOEFcd+j1OQa51CRV0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/476] dmaengine: ti: k3-udma: Report short packet errors
Date: Wed, 21 Feb 2024 14:05:48 +0100
Message-ID: <20240221130018.984484419@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d796e50dfe99..698fb898847c 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3957,6 +3957,7 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 {
 	struct udma_chan *uc = to_udma_chan(&vc->chan);
 	struct udma_desc *d;
+	u8 status;
 
 	if (!vd)
 		return;
@@ -3966,12 +3967,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
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
@@ -3980,7 +3981,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
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



