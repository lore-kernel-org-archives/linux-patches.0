Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB15822B586;
	Mon,  2 Jun 2025 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874422; cv=none; b=rSKYBFEjgE0xaL/FCzHpztn4PXNBHJ3C6I/NMfVxyAz2MyUDsMfJ04yHi9wnnMjXzVMALFCC4n+7vi+3uzgiUi6XPJtiTK/vW7Tnv5/ZPq6h/a86B7HnqzwOszC7j2jiKnUVNG2NVqh8OjYqrbx8gAeZ9VuPIBBRmRexHrIKlrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874422; c=relaxed/simple;
	bh=hb9NRIHHihtPHUGKzqQLUIs9hqR1sxmK9qAcHkBSd2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZC8TrpM6sV6MNp6I/t5DW/kUTGb9toSMmZc8K5ysHKrRazdTfclcDC8HIDzMHP4kgrus1ivY6KoXT5cYAWPRGe47p4o1HDT6KnTv3LbsDRlFZGg536ve0455Mm/GSg+5gaLeXx20dNwTW7EEbTJ0tGqZwlsS6qKNTEJIG2PS4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZO7BFV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZO7BFV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA55BC4CEEE;
	Mon,  2 Jun 2025 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874422;
	bh=hb9NRIHHihtPHUGKzqQLUIs9hqR1sxmK9qAcHkBSd2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZO7BFV3nEzITCXqsJq7k9etz/+f0CczBDtjNslmImDawIzEs//JzNtFOlgmEQIJU
	 YdFLhm7HSrZ4Iwalp3kH4+LWJB63V6I/Ls/4M0lXGjzVvE9vIX+hCaOsAgPukUqL9b
	 l4uBmFxGGfl4a0go5VjL6GCOQtzXVHfAc2pQupiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattias Barthel <mattias.barthel@atlascopco.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/204] net: fec: ERR007885 Workaround for conventional TX
Date: Mon,  2 Jun 2025 15:45:52 +0200
Message-ID: <20250602134256.256222608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5660a83356eb0..fd7c504b44f2e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -605,7 +605,12 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
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



