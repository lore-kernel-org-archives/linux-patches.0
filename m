Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74E91946C8;
	Fri,  9 Jan 2026 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960229; cv=none; b=qKyg+p/tMqliC6A8CGOnEtKOrf93etXP5JCzr02YPa6dpkUBwNpYBjcp7H0pTHkI6IMiiWXAUyef5YGMKSvt2h1ij3YZra2XYn8d4f2LAyrQzLHp3TfRtA6DdHIM9t728PtbOUBBWBHFbaX+90Oai4VsjrQMZf+/xwBymW36kcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960229; c=relaxed/simple;
	bh=QQX9Qw3eE9fzsA3XMmRNGNHqcj7HPZvqvks+goJsylQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVt228HLMaJQ6KD+bTxPov9Iq3CNLglEaBndO+suggPjHEDZnhIacUVstj1DBFlqxdGGNgZkzXCG2ZXOyomJWTLvx2wBgLxKAzNx/AzevlS+PMhSvSPTsBIuTdWfBZ2b/D910aE2LzM7v5Nq9UocH/6KRIAZBSIupiUbTTjyjKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWGgr0f4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWGgr0f4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730E7C4CEF1;
	Fri,  9 Jan 2026 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960228;
	bh=QQX9Qw3eE9fzsA3XMmRNGNHqcj7HPZvqvks+goJsylQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWGgr0f4i8aiA+J9E3e71N8YETdSoLJDI9Whz5g4pYmA011sPDMFJEYmnm/uHFkTs
	 GvPFJWGxrDXU2sxAc1zZTgDL0GcoJ8L9Un3STyIWa8/2LVWZl2Zrqx9RPkxDodjgsq
	 BNrAvqeXj5pnw2vytZAtg3RqeWqHyoDtQxAZa86o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 331/737] net: fec: ERR007885 Workaround for XDP TX path
Date: Fri,  9 Jan 2026 12:37:50 +0100
Message-ID: <20260109112146.445053220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit e8e032cd24dda7cceaa27bc2eb627f82843f0466 ]

The ERR007885 will lead to a TDAR race condition for mutliQ when the
driver sets TDAR and the UDMA clears TDAR simultaneously or in a small
window (2-4 cycles). And it will cause the udma_tx and udma_tx_arbiter
state machines to hang. Therefore, the commit 53bb20d1faba ("net: fec:
add variable reg_desc_active to speed things up") and the commit
a179aad12bad ("net: fec: ERR007885 Workaround for conventional TX") have
added the workaround to fix the potential issue for the conventional TX
path. Similarly, the XDP TX path should also have the potential hang
issue, so add the workaround for XDP TX path.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20251128025915.2486943-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ee0306ab97714..7efe4e81cf320 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3935,7 +3935,12 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
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
2.51.0



