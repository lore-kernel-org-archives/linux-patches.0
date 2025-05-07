Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF62214813;
	Wed,  7 May 2025 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645171; cv=none; b=KLXm5+Z9E7bwXPQ5PbFDpMzhuH7wJQ7Whkn5xuzScaVw7VJdQUgGenTCQ60AFC96PaAEjrzEXwG6bu9z88xVoLgvhz29Ml7Ko/ZviEwYT92q1LjxveXJT5/jWaXNdpYCXZQkJtxgWn5gSZPX/4IrwiP5HBqxVS7GsGFHmwOarCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645171; c=relaxed/simple;
	bh=JgPVN9ADLSe2zDOkL5Hv5OQ6x4x4sNpxVZcQTvI376Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPV6HgS7HOC3tfevlPT5kU+8I4u/8jAdngN87FiT05hQKDsNKoVpWVJLazF8T5yD0TWqT3FNyK/toAE2rFC9RfpIRh+m2FEFzobU5tPKdXDxHz2vu8Ayv78hk2ge8X1/mpYZaFP6vMdLGn49xhWpujVKiW6nbWP1BaG7qEhXKho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6UWoOnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6UWoOnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFC5C4CEE2;
	Wed,  7 May 2025 19:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645171;
	bh=JgPVN9ADLSe2zDOkL5Hv5OQ6x4x4sNpxVZcQTvI376Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6UWoOnfHE2LkJuxAXBuLym6NtbiID/dIZNScQ/etcA1kQ1atfg0vgLDPMSASpzPe
	 0Loyt4GrSI+cZFPZ3D8Ahybv94/o5hRaj17/MwCIdOOTR2Uj37l/QTuul4EkNO6Y8e
	 pQBhgf66XyKN65pXPtZeX4YaEP2aNLEkS+P3piMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattias Barthel <mattias.barthel@atlascopco.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/129] net: fec: ERR007885 Workaround for conventional TX
Date: Wed,  7 May 2025 20:40:22 +0200
Message-ID: <20250507183816.992105124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattias Barthel <mattias.barthel@atlascopco.com>

[ Upstream commit a179aad12badc43201cbf45d1e8ed2c1383c76b9 ]

Activate TX hang workaround also in
fec_enet_txq_submit_skb() when TSO is not enabled.

Errata: ERR007885

Symptoms: NETDEV WATCHDOG: eth0 (fec): transmit queue 0 timed out

commit 37d6017b84f7 ("net: fec: Workaround for imx6sx enet tx hang when enable three queues")
There is a TDAR race condition for mutliQ when the software sets TDAR
and the UDMA clears TDAR simultaneously or in a small window (2-4 cycles).
This will cause the udma_tx and udma_tx_arbiter state machines to hang.

So, the Workaround is checking TDAR status four time, if TDAR cleared by
    hardware and then write TDAR, otherwise don't set TDAR.

Fixes: 53bb20d1faba ("net: fec: add variable reg_desc_active to speed things up")
Signed-off-by: Mattias Barthel <mattias.barthel@atlascopco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250429090826.3101258-1-mattiasbarthel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d6b50903c923..7261838a09db6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -695,7 +695,12 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
 	txq->bd.cur = bdp;
 
 	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
+	if (!(fep->quirks & FEC_QUIRK_ERR007885) ||
+	    !readl(txq->bd.reg_desc_active) ||
+	    !readl(txq->bd.reg_desc_active) ||
+	    !readl(txq->bd.reg_desc_active) ||
+	    !readl(txq->bd.reg_desc_active))
+		writel(0, txq->bd.reg_desc_active);
 
 	return 0;
 }
-- 
2.39.5



