Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4265E1DB125;
	Mon, 29 Dec 2025 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024988; cv=none; b=WQJb7VM8g+1DSQc0DNdcIuqKxrahC3AmoAquwpWkE6uwLHHPy+ipfsecy0wMlCbyN7uu4MEKsaE1pkMF/R6/G+AaDjDkHYNLAG0KKvJJ1Q2L4jvZdw5iIRV+Ngseh7bzBH0aufUb+O9EwBYF83RoEfLbQd2VhY2FU9SiET25cgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024988; c=relaxed/simple;
	bh=TOSwGYWpbcPTK36blh5g4jyk1AZwVmNalhC6zm3vMzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfzK7S/b/OXd+NcCRIRrETJ+BP31Tj6BjtkK96/At+pN0zNSAGJG5I8QiBCucvHEPdKK96sLat3SLGhAHuAJaa95CvckWhHOhYSdTC+zpaE4fiYt5eRDyIWIS1P10DIkjf1xH6oqyezY2pY+Md35UDS8FGP3MO8RyB4X5EwJoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNVayUwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNVayUwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A6C4CEF7;
	Mon, 29 Dec 2025 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024988;
	bh=TOSwGYWpbcPTK36blh5g4jyk1AZwVmNalhC6zm3vMzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNVayUwoULMaENUz1LRm+1bboeBKXWUmbaglJ4LjVkjN/02+qemwZnNYO7NPLOMHc
	 wQmibEV1Bh3ThB0r3ElCEs6wSMY6BXaDzIgk5pTmTc0m9BNAPXu6l+U1XWjARxM+fV
	 7VlNyb9yU4qcjRJlhhLKGjaWSl1vyzN7cF4cGz4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/430] net: fec: ERR007885 Workaround for XDP TX path
Date: Mon, 29 Dec 2025 17:07:35 +0100
Message-ID: <20251229160726.319965782@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3222359ac15b7..e2b75d1970ae6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3948,7 +3948,12 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
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



