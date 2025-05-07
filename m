Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDA128E582;
	Wed,  7 May 2025 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644783; cv=none; b=XqY9fIO4Xs9IDoVvzI//ji3IuZkFvPf0FmWjuGmHTa0pjU5GALdBgZm7G62Z/BwG6AAw1Um48VODkCFqh6weTlVhF912uycAt0PFI6HxSdXLoZ6TB2z6erEiQpGHp4JQ3yMKsQa6c5dFQ7Lc0/J/igDODGRYccuLkyDVot7I5q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644783; c=relaxed/simple;
	bh=H28PrMFCFJx6lSwqDZkQNISsGjbmBDM9miqf+Zy7vbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA7jUhB2B7V8CgL4cysJC3hvqsKhN3UIsmvJpQ6hFU0x/3dPFRk0+/vu8z1jVfWer8dAVXBKC0+iLQ0Q7OxYosORtsykOooT4w9ESJXjBN2Hpgql6/1NCYO2I4hfkaixXYXAmowX3Qmu+0a4saHIgwNd28EkVu50cZqKpdy++7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq//EF5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq//EF5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EBBC4CEE2;
	Wed,  7 May 2025 19:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644783;
	bh=H28PrMFCFJx6lSwqDZkQNISsGjbmBDM9miqf+Zy7vbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cq//EF5khEKmV75ljQN1AXLGfOZDeVxPan/TEKZVkH0xlb81qaItsSEfx0ap1z5iK
	 ZNAXtk31Chc5InSA2iyDvAzaV4fSYuHvnlF+cNaJZQuHWHZE166PZKCIfQ9qzYjE7Q
	 2pnqpPyQm5u/dUVckN1EcB9D4vpCAbKN3LlvqfRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattias Barthel <mattias.barthel@atlascopco.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/164] net: fec: ERR007885 Workaround for conventional TX
Date: Wed,  7 May 2025 20:40:11 +0200
Message-ID: <20250507183826.069882410@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b05d9c6c21a4..04906897615d8 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -714,7 +714,12 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
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



