Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A966FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6304DC433EF;
	Mon,  3 Apr 2023 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533362;
	bh=RYYgMYNQ6cY6jef4ZIof9DGslb7v5sSlvFvdBTUm5GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4D9o27VhY5ey9PtCTfUbyUW9J+mmGv12yYp8+A6B6/804lC6xQdsHP/Ucel965JB
	 g7MPavoIbDSQE5PklwYrhk82pdgRwNY+Sl52yhnk/EotBzWqLDUBPjDFMBfscOYlzq
	 Ili7UnQ5YcBLFrNnREv8LoIpXzsBLV4WuV8u37rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Voegtle <tv@lio96.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 114/187] bnx2x: use the right build_skb() helper
Date: Mon,  3 Apr 2023 16:09:19 +0200
Message-Id: <20230403140419.726811156@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8c495270845d6b4854607e946baef3637a8259ed ]

build_skb() no longer accepts slab buffers. Since slab use is fairly
uncommon we prefer the drivers to call a separate slab_build_skb()
function appropriately.

bnx2x uses the old semantics where size of 0 meant buffer from slab.
It sets the fp->rx_frag_size to 0 for MTUs which don't fit in a page.
It needs to call slab_build_skb().

This fixes the WARN_ONCE() of incorrect API use seen with bnx2x.

Reported-by: Thomas Voegtle <tv@lio96.de>
Link: https://lore.kernel.org/all/b8f295e4-ba57-8bfb-7d9c-9d62a498a727@lio96.de/
Fixes: ce098da1497c ("skbuff: Introduce slab_build_skb()")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230329000013.2734957-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 16c490692f422..12083b9679b54 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -672,6 +672,18 @@ static int bnx2x_fill_frag_skb(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 	return 0;
 }
 
+static struct sk_buff *
+bnx2x_build_skb(const struct bnx2x_fastpath *fp, void *data)
+{
+	struct sk_buff *skb;
+
+	if (fp->rx_frag_size)
+		skb = build_skb(data, fp->rx_frag_size);
+	else
+		skb = slab_build_skb(data);
+	return skb;
+}
+
 static void bnx2x_frag_free(const struct bnx2x_fastpath *fp, void *data)
 {
 	if (fp->rx_frag_size)
@@ -779,7 +791,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 	dma_unmap_single(&bp->pdev->dev, dma_unmap_addr(rx_buf, mapping),
 			 fp->rx_buf_size, DMA_FROM_DEVICE);
 	if (likely(new_data))
-		skb = build_skb(data, fp->rx_frag_size);
+		skb = bnx2x_build_skb(fp, data);
 
 	if (likely(skb)) {
 #ifdef BNX2X_STOP_ON_ERROR
@@ -1046,7 +1058,7 @@ static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 						 dma_unmap_addr(rx_buf, mapping),
 						 fp->rx_buf_size,
 						 DMA_FROM_DEVICE);
-				skb = build_skb(data, fp->rx_frag_size);
+				skb = bnx2x_build_skb(fp, data);
 				if (unlikely(!skb)) {
 					bnx2x_frag_free(fp, data);
 					bnx2x_fp_qstats(bp, fp)->
-- 
2.39.2



