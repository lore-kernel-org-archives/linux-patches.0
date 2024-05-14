Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BAB7F48C;
	Tue, 14 May 2024 11:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686803; cv=none; b=M8v33DRO2JhbzlRYHEltPe1GGtjqCX4gtIRfDkPqmbTpf9c/AF9NhU/Il7/LyTb7l5NhscFDa9rQiD+6wjuMQHtTDqA3wtDRbR1r2W0zYOAEtqMXLvHJdUWPfh1wCuUrKEajPkYNV3qBNwlDFSSkWVuWRdGQbdevIlIMJcEmzvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686803; c=relaxed/simple;
	bh=dDxeDBnVpscxIYtDtz2Gpa/GMzENWAjypTHcxNEXens=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoTB8qukPMabdPzPrwIwnmfFhWIOstynZVtj+tEYEtaAhoR7IFgAwMrWY5zLfjAmQLinhYqn5pim86UA7jkMBuh1RKnne8asTbbuwpATIEfSSmzb0yBcovAIdZwrz+AdOlQ0J5+Zg3YJAt4oq6ORz1MTOcOtxoxPG7UjHvSRPVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/MepVJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/MepVJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071B2C2BD10;
	Tue, 14 May 2024 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686803;
	bh=dDxeDBnVpscxIYtDtz2Gpa/GMzENWAjypTHcxNEXens=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/MepVJlDevfnxFVLXAbegKA+K7wh3S7j3wU2AGguadbTyIRT7VdaqOOLkDdwCP1X
	 gHNjp0oUn09GnTrrY882Ye3Zz9EtJWUGzK4r+3LueEyi2T2bsZWVigqx+LD6cE4jfI
	 78mmcIv91InbKxmVLhRDcerlnAv1AQs+EgPRYQnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Maarten Vanraes <maarten@rmail.be>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/63] net: bcmgenet: Reset RBUF on first open
Date: Tue, 14 May 2024 12:19:49 +0200
Message-ID: <20240514100949.081224630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8bbc5dcf8cb43..9fded8a862d46 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2806,7 +2806,7 @@ static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
 }
 
 /* Returns a reusable dma control register value */
-static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
+static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv, bool flush_rx)
 {
 	unsigned int i;
 	u32 reg;
@@ -2831,6 +2831,14 @@ static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
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
 
@@ -2926,8 +2934,8 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	/* Disable RX/TX DMA and flush TX queues */
-	dma_ctrl = bcmgenet_dma_disable(priv);
+	/* Disable RX/TX DMA and flush TX and RX queues */
+	dma_ctrl = bcmgenet_dma_disable(priv, true);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv);
@@ -3682,7 +3690,7 @@ static int bcmgenet_resume(struct device *d)
 		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
 
 	/* Disable RX/TX DMA and flush TX queues */
-	dma_ctrl = bcmgenet_dma_disable(priv);
+	dma_ctrl = bcmgenet_dma_disable(priv, false);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv);
-- 
2.43.0



