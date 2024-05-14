Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C596BB39;
	Tue, 14 May 2024 11:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687699; cv=none; b=rwwiJmt1qfis6KMJY/ClEArJbqH2bUJU38IKjO+zwaCFrwxR5iwiws0hBkwn0OWTHVoyHvGLXuh8YBGbv/+UOEIg+DfI2rmIHnARBvVACxnDaip5WSZXw6O71HncaTRtVP2ClU4WuSKu5fMJXktJlTU2T1L9d2A8Q+WctPHQ0ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687699; c=relaxed/simple;
	bh=dGr60cel/2giwY6sXb8PWAbJyyocT+9TnOXeFOSfJWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCZvAhtgmfxi+PJ2XDt39hvZC1I/s31nWLI5Tx+w6lVOV1bNFPEpSbjvYEtSzkQ/JHctN/Mz7Qjwis/TkA6gp8X54HYMC+n6MRq6pEKA0eZfTLXhb+2iMfPYLdjrRjlwsZ5hbkrrhmdUD2MadWIkLvvaVo1t2BJrcgaglkOs6X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K48vbDIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K48vbDIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3671C32781;
	Tue, 14 May 2024 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687699;
	bh=dGr60cel/2giwY6sXb8PWAbJyyocT+9TnOXeFOSfJWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K48vbDIfU1RrhYoVl4atsQKon25luD+dMc+xbTVUxDYrtcUyNE2oXACHmXJxRNchc
	 l103P1jl6eTo3+UK1VskHez3uYF8VWyhXLLsOMkWV0QXYohW/dM1DNruo4ACqmzWYm
	 kOP+NO51c6hhnW+/dqZJ/lBZu73/iTTk+PCxMgHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Maarten Vanraes <maarten@rmail.be>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/168] net: bcmgenet: Reset RBUF on first open
Date: Tue, 14 May 2024 12:19:31 +0200
Message-ID: <20240514101009.451522854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 0a6380cb4c6b5c1d6dad226ba3130f9090f0ccea ]

If the RBUF logic is not reset when the kernel starts then there
may be some data left over from any network boot loader. If the
64-byte packet headers are enabled then this can be fatal.

Extend bcmgenet_dma_disable to do perform the reset, but not when
called from bcmgenet_resume in order to preserve a wake packet.

N.B. This different handling of resume is just based on a hunch -
why else wouldn't one reset the RBUF as well as the TBUF? If this
isn't the case then it's easy to change the patch to make the RBUF
reset unconditional.

See: https://github.com/raspberrypi/linux/issues/3850
See: https://github.com/raspberrypi/firmware/issues/1882

Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Maarten Vanraes <maarten@rmail.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index a2b736a9d20cc..9db391e5b4f4f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3256,7 +3256,7 @@ static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
 }
 
 /* Returns a reusable dma control register value */
-static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
+static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv, bool flush_rx)
 {
 	unsigned int i;
 	u32 reg;
@@ -3281,6 +3281,14 @@ static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 	udelay(10);
 	bcmgenet_umac_writel(priv, 0, UMAC_TX_FLUSH);
 
+	if (flush_rx) {
+		reg = bcmgenet_rbuf_ctrl_get(priv);
+		bcmgenet_rbuf_ctrl_set(priv, reg | BIT(0));
+		udelay(10);
+		bcmgenet_rbuf_ctrl_set(priv, reg);
+		udelay(10);
+	}
+
 	return dma_ctrl;
 }
 
@@ -3344,8 +3352,8 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	/* Disable RX/TX DMA and flush TX queues */
-	dma_ctrl = bcmgenet_dma_disable(priv);
+	/* Disable RX/TX DMA and flush TX and RX queues */
+	dma_ctrl = bcmgenet_dma_disable(priv, true);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv);
@@ -4201,7 +4209,7 @@ static int bcmgenet_resume(struct device *d)
 			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 
 	/* Disable RX/TX DMA and flush TX queues */
-	dma_ctrl = bcmgenet_dma_disable(priv);
+	dma_ctrl = bcmgenet_dma_disable(priv, false);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv);
-- 
2.43.0



