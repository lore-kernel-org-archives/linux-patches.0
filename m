Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349932253F3;
	Mon,  2 Jun 2025 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875124; cv=none; b=n4P6pkuYPq+1eEu6v8kqofjf4NdJ5ftVvaZ/eAcsOMcVy02LyGPnhaS891JtT6waMX0J27FN0sUcTrIl4OZ/JYxpYVkgjyu5qO6S7ApKcjK2aPx/bceRiqh0CXlGJXvPg2gygcgH/Cw6Fk8tmNajX1uqBLFEnE/AXJwNO3aHdJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875124; c=relaxed/simple;
	bh=b3V3kuJzZPTtEv3u9ZYzjdEi1Ha9mzti05lQM8jPhoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaS8iJ/P0fbri6+AgyzxuGlMiLP8D3dvgmbGtVbvokneIxyx0DLmNK9P7+7g9ftvkVF2FP1rAe48zf6dxcMCdC0tbpPqqcZQKFXXiHjRntM70BcvV4HfvJ0eS9/syBVzS0YSCH7nUHpST0Ta9zTq/SOe4b+9k2yydxSnwTqOekU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5rIm6NI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5rIm6NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BFCC4CEEE;
	Mon,  2 Jun 2025 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875124;
	bh=b3V3kuJzZPTtEv3u9ZYzjdEi1Ha9mzti05lQM8jPhoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5rIm6NIcY6ORiPl2L0AVgoHyAhLvy3cwQtpgu9KLedkFe+s+/7hnAE6Bxug/lQuY
	 jLRjk7X8YW4Tb78gsb9b4l/FLdveZmdzjjW8jilCcR18pHeTZt184t6xLAN4fxkdJ1
	 AWFIwJ30NXlrASQ9kwZvDIXaYA4VEbkwc+vtiXWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattias Barthel <mattias.barthel@atlascopco.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/270] net: fec: ERR007885 Workaround for conventional TX
Date: Mon,  2 Jun 2025 15:45:13 +0200
Message-ID: <20250602134308.353800761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8e30e999456d4..805434ba3035b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -602,7 +602,12 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
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



