Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039415;
	b=XmhIb0YjaCEr9bhoGt1gmM+I6fIjQ741xmNi2+XY0SYVzFLBJ/e5LY9xMT+kYXTrZOI/
	 3UBBd7f0wT8FMkKfUrzclBbbtFvm8UA7VRGr/7V/eICe/mhQWtS2kN6UioHC7KSQpbjzq
	 bPLtfmd+okf3SMSZRXf1Mw393XQOw4BuGPCFGrsycHF8HOi6T6R96kHDLXfYMY2YwxRJU
	 NvopZCY8WUGl5rnI68f0vnHgn13v8fVdzGP3b561sMphYOna3sYsUREzxo+a9xJH8gfX+
	 v636+hZosjbHVzNhiD7WRdAkeSxaMsiXGFJ0Igw3Vr8whdUvdWvZvtNPPAiSFH88FTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JnThbBES8c/wPbdFvsIP4UkgG2+FLudaByBVANTf1gQ=;
	b=tmHmJ1Q//MlTXTSprIkJ+ijwwVaeccR2Bf6zuIG0PijzYzbUJn3xrGECW3ylcOxcuggz
	 3OvtpslGHPxrQnyQb6HKywv5HdcS+mfaLdcOE1Fv9AzBSJPGwWTYaT8GQLppTt3Ee2wKF
	 +DdwTDlHMxqqADhtEkVqc5sXKmYX1d4lJzB4xw4p8ja1ddWZOmU3kxmX0L0rLaSyhih8c
	 F1zhWM1kOO3Wexx96rY76Xmc/KibmGUE0tRaeXB3Nj0kVXzUK7z4QTKrgv1tIQYH+yvtB
	 sTSi7P2C7WYq5w2BKveYHBjvw+80YOYTkBHAGehz/5mv8664cXmhp9qIIBYXJg9yWTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvRt3RC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDC0606A32A;
	Wed, 18 Nov 2026 22:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvRt3RC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EC71F000C5;
	Wed, 18 Nov 2026 22:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039415;
	bh=JnThbBES8c/wPbdFvsIP4UkgG2+FLudaByBVANTf1gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvRt3RC3i0o5/nvvWnp46W3Qpcu9Y63AwhUv61fluyyikQWAjziKh5b+B2Jh9v7Tz
	 1VFfjLL4kM6BFVpwM9hF1tGby7YyppxIF5IfD8Wes0pVIs1UAnbpIq5Kj8nqpmZY8O
	 G37b2bUiAOy1Z0xg7toNeYr47mNEj+v5WEtKYg54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2090/3318] dmaengine: sun6i-dma: Fix use-after-free in error handling paths
Date: Wed, 18 Nov 2026 15:45:12 +0100
Message-ID: <20261118150424.802478461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f472919f4c0650d7fb22bb230eacaada0c6ee951 ]

In error handling paths, the for loop frees v_lli in the loop body,
then accesses v_lli->v_lli_next and v_lli->p_lli_next in the
increment expression, which is use-after-free.

Fix by refactoring the cleanup into a helper function sun6i_dma_free_desc()
that saves both the next virtual and physical pointers before freeing the
current node, preventing the use-after-free.

Fixes: 555859308723 ("dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260727061142.44195-1-zenghongling@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sun6i-dma.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 50b59c512232a..e39672ab2c04a 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -407,16 +407,12 @@ static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
 		v_lli->len, v_lli->para, v_lli->p_lli_next);
 }
 
-static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
+static void sun6i_dma_free_desc(struct sun6i_dma_dev *sdev,
+				struct sun6i_desc *txd)
 {
-	struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
-	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vd->tx.chan->device);
 	struct sun6i_dma_lli *v_lli, *v_next;
 	dma_addr_t p_lli, p_next;
 
-	if (unlikely(!txd))
-		return;
-
 	p_lli = txd->p_lli;
 	v_lli = txd->v_lli;
 
@@ -433,6 +429,17 @@ static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
 	kfree(txd);
 }
 
+static void sun6i_dma_free_desc_virt(struct virt_dma_desc *vd)
+{
+	struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
+	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vd->tx.chan->device);
+
+	if (unlikely(!txd))
+		return;
+
+	sun6i_dma_free_desc(sdev, txd);
+}
+
 static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
 {
 	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
@@ -789,10 +796,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -860,10 +864,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -1418,7 +1419,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 		struct sun6i_vchan *vchan = &sdc->vchans[i];
 
 		INIT_LIST_HEAD(&vchan->node);
-		vchan->vc.desc_free = sun6i_dma_free_desc;
+		vchan->vc.desc_free = sun6i_dma_free_desc_virt;
 		vchan_init(&vchan->vc, &sdc->slave);
 	}
 
-- 
2.53.0



