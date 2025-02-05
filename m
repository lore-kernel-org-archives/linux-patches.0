Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302AEDF59;
	Wed,  5 Feb 2025 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768179; cv=none; b=ts4FFfGGDKSWvMb7W5re6Kb/Ss85W9gApCgVkAwGwRuXe0w2o0sAJHlK8pDHFuJr04UpmLRH21w05FUeInLpo4yc9qkCnTFP7Ha0un6AtbFpXE53m5d6lV1OfFFMtShcmhnTV/YezQ27fNLTQHlD2rdSMp1slghN8ZAGMxODTqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768179; c=relaxed/simple;
	bh=snUfOgxdXxUp76H+xEI2OV6VcPyq+3fsmNPwhc5HEg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mObEo2iTDc6J4j19eYptIptIn5weDAMXa11R7L4v+1lfJdUyuYFtPMXCS1PXTGthHu5841tFbLr1hl6xLaIPmQnDOBNQXofBw40v9WyWiK0m5hL6U6vap2o4llY5780aNYNSm4e/M1AWGNvhuqcwhTZfn7LOa0DNnI+13OW04DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEUt94aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEUt94aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C20FC4CED1;
	Wed,  5 Feb 2025 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768178;
	bh=snUfOgxdXxUp76H+xEI2OV6VcPyq+3fsmNPwhc5HEg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEUt94awamOYCwdmZXI68UCHoHuZ8wrGHSZdwB6RCK2302W1lTuB0Sz7SUH7trYad
	 a06KELuaR0SPsZE6NvxTG1uSg7MwB1kPrqcp6761jWD5RQRLcZYaK5iHDHkXrnhRnH
	 FnLrMU2qrDWKQjZnXb1k0AaWyMoe/sX/+ejG7ybU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 508/623] net: fec: implement TSO descriptor cleanup
Date: Wed,  5 Feb 2025 14:44:10 +0100
Message-ID: <20250205134515.653571872@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>

[ Upstream commit 61dc1fd9205bc9d9918aa933a847b08e80b4dc20 ]

Implement cleanup of descriptors in the TSO error path of
fec_enet_txq_submit_tso(). The cleanup

- Unmaps DMA buffers for data descriptors skipping TSO header
- Clears all buffer descriptors
- Handles extended descriptors by clearing cbd_esc when enabled

Fixes: 79f339125ea3 ("net: fec: Add software TSO support")
Signed-off-by: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250120085430.99318-1-dheeraj.linuxdev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 31 ++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4566848e1d7c6..2f706d0848199 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -840,6 +840,8 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	int hdr_len, total_len, data_left;
 	struct bufdesc *bdp = txq->bd.cur;
+	struct bufdesc *tmp_bdp;
+	struct bufdesc_ex *ebdp;
 	struct tso_t tso;
 	unsigned int index = 0;
 	int ret;
@@ -913,7 +915,34 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	return 0;
 
 err_release:
-	/* TODO: Release all used data descriptors for TSO */
+	/* Release all used data descriptors for TSO */
+	tmp_bdp = txq->bd.cur;
+
+	while (tmp_bdp != bdp) {
+		/* Unmap data buffers */
+		if (tmp_bdp->cbd_bufaddr &&
+		    !IS_TSO_HEADER(txq, fec32_to_cpu(tmp_bdp->cbd_bufaddr)))
+			dma_unmap_single(&fep->pdev->dev,
+					 fec32_to_cpu(tmp_bdp->cbd_bufaddr),
+					 fec16_to_cpu(tmp_bdp->cbd_datlen),
+					 DMA_TO_DEVICE);
+
+		/* Clear standard buffer descriptor fields */
+		tmp_bdp->cbd_sc = 0;
+		tmp_bdp->cbd_datlen = 0;
+		tmp_bdp->cbd_bufaddr = 0;
+
+		/* Handle extended descriptor if enabled */
+		if (fep->bufdesc_ex) {
+			ebdp = (struct bufdesc_ex *)tmp_bdp;
+			ebdp->cbd_esc = 0;
+		}
+
+		tmp_bdp = fec_enet_get_nextdesc(tmp_bdp, &txq->bd);
+	}
+
+	dev_kfree_skb_any(skb);
+
 	return ret;
 }
 
-- 
2.39.5



