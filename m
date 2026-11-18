Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054807;
	b=sBLK9wBPj5Ej75/usHWgnghCkqsHkNt7owdiS1nIM5PWZb7CgQiqoaJa6pRMzcJ9hJMI
	 sHi8q2/VssOcNQXQtlmJ/R5wicVsj1ZaNWXAKZEftQqKhgTYIZsqjWJhckcx2WcrOHuqZ
	 i5aDUyr7VROsO2rzt/jeC5HnaKm5wXajaCt50WgiouyAS8ruEG5lW+nclv7Z5XrKhWiy/
	 CREJkv1vMZHP2cf4lBY1rBeHvrmKFzQX2/gA7BPW8q664pv8C3duaceknMEzuSzolknmq
	 XExSqZXfxYKawhNRvGEa4PdlvZSOK23p70cVklKpEYYQniewSYOpzz96NhBdC9GkJyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URCWLMYJpAUhRNXShpDIQbd78Xr1FR0vldoztjFjsH0=;
	b=2XML51FlS0WkXPboft/sgiS+UMGRb18gJOIRFBly6mFWYJbSRLZeXTsMV7ksR/r/+iDJ
	 oXd1RFCiZu4fH3xowq/YQnX7mYsbZVQE3MbcM/kVcvh/ebJiQBb7v+5fE0rZJw9tGF1e/
	 q//MjIF50RvaU5g3iVb4W3ydIW+loS9rH8wqt/OQUVvJFuAMlsxCauXLiUo1GfNTLQ33A
	 +grpev9UQ/ta4yx8Bh+/IIaXItJeM7xkN3IeMpr0b3/P/rT26PGYotckMmIODpw7J/7ZI
	 55fpR1xF7gU5S2GnIlhhSv+TZgqhVHH1w3cW0aBFV6ulLrjhTEDvkIh3VZMLzichT2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3cqAv0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14DC606A32A;
	Thu, 19 Nov 2026 02:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3cqAv0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5008E1F000C4;
	Thu, 19 Nov 2026 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054806;
	bh=URCWLMYJpAUhRNXShpDIQbd78Xr1FR0vldoztjFjsH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3cqAv0WrSVkhibisoQm0zv/ic7HcuzavKoPb0IAANQtiAcjwNpb2n1zqBxBfK4JB
	 iioQlbuZbUxwM/NUfBk61OLzJwIpWzbewZHvAaDZ8OMKMh7dNtW75XYNbOLSM2rjkg
	 vD953gOnS1RMdAuJHZnPPAUGXRTD0khDXnuZLLH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1405/2214] dmaengine: sun6i-dma: Fix use-after-free in error handling paths
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150107.477648403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4f331c30f83ed..3b3fbee2952ed 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -397,16 +397,12 @@ static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
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
 
@@ -423,6 +419,17 @@ static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
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
@@ -752,10 +759,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -821,10 +825,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -1379,7 +1380,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 		struct sun6i_vchan *vchan = &sdc->vchans[i];
 
 		INIT_LIST_HEAD(&vchan->node);
-		vchan->vc.desc_free = sun6i_dma_free_desc;
+		vchan->vc.desc_free = sun6i_dma_free_desc_virt;
 		vchan_init(&vchan->vc, &sdc->slave);
 	}
 
-- 
2.53.0



