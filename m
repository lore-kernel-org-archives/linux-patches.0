Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9A914A4C7;
	Wed,  7 May 2025 18:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643366; cv=none; b=CbRFeXBCmVKGIM435vYCnO9Y5qqRvURVD+PnFLsrsNvM6+4a5L7l2zzzaq+iOVgZmTVTCs3Y/R1MXJvWtawg9kRkizYh3keEaYHKJiJ7qtebcNMfgFcFw4PAnm3PrPisZeRvNJ35/5st0CsYWWIrRczzvQ7kL92MdFEAe8ua0Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643366; c=relaxed/simple;
	bh=lTfiaaPAXjo/1nii0kBLiMc1ItUe2ULfFX65xttx/PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIs9imOZznO2zQRkxdEi3KSEhCHFGeOpq+14srrL4K6DPrcRdVH9DYKhogiYBoW1R0E/Q/8pv/sIdOwZj/kvlD5S71K1WY/qraWWhbs0GQMQEe+8HDOtyusQKTraQ0MU8pkdFMbpPNQKDaTwJfcOKsSo3GEgC/j8YhXN4tFJseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2jVeetP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2jVeetP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFA8C4CEE2;
	Wed,  7 May 2025 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643365;
	bh=lTfiaaPAXjo/1nii0kBLiMc1ItUe2ULfFX65xttx/PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2jVeetPu9E66Q2sDvwdzuPCJUK3mYQ0UaXwGGpHFmxfd4p3hJidDlGn+e2zQnfZf
	 k9soGFKo70fO9wM2eIPyuwnsQmeYUPxfyRjGYsN1j7RTEBJVbSBfL4iEcPNBQ81U83
	 0Ay8nKp/BDJb5RYdHgqlhjETzYtvvwbDphDGIyAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattias Barthel <mattias.barthel@atlascopco.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/55] net: fec: ERR007885 Workaround for conventional TX
Date: Wed,  7 May 2025 20:39:37 +0200
Message-ID: <20250507183800.492969108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b5585bc21d8f..5c860eef03007 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -635,7 +635,12 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
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



