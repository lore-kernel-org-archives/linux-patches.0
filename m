Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0CF1EEF7;
	Mon, 27 May 2024 19:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838279; cv=none; b=LATGEVPR4VJfx+fpcw0ZOsCNABIEmCvtmMv4GnfZmJzyikg59nCSVrTFGebvZvt/bHaaSzf+pG8+ZollPiUVWkJfpdoINQO5HC59fX3PuA6WNtmMk3Z71gnFmHn5btjG1AHmDk0+d6/KrxzrO2h7d0+3sMONbJunZkx6YchfeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838279; c=relaxed/simple;
	bh=0zLAlRCTj0mfKrR7GbvV+OkynWVaPc5pf8QX/HiWKc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8YV0FFpO8sNYNyiX1pOL+CRS4z7JdLLs/nGe9GO+EqJyWSYOc5mv+OUwWnJDTP22mxqFsjULxuS9a8/t5b0fDg9zBSjlNSid25cl6wHtuBD36yCIOpHWmmHQls5ryohXDFx/BdjxVhJG68GGNHVdwKKgmtVEC1aMh/SS64Og4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBmX4Gqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBmX4Gqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC47C32781;
	Mon, 27 May 2024 19:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838279;
	bh=0zLAlRCTj0mfKrR7GbvV+OkynWVaPc5pf8QX/HiWKc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBmX4GqsD7peEzwKzI0Rqz4Zbq6eZVhTKO4tOTANSzFiyroSBoeaNKkF3n44MSwIE
	 wf3/DEvPVtBMhYjI1DbqC7SxPyw/g9ouvz6MNrXuD7wfCnVA8pVp70HR6bMHjAXNBC
	 QmGq4QTqC1XkA+WKhshw73ZDqYOH6zfrsTiiPxNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 333/493] net: stmmac: est: Per Tx-queue error count for HLBF
Date: Mon, 27 May 2024 20:55:35 +0200
Message-ID: <20240527185641.163482467@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohan G Thomas <rohan.g.thomas@intel.com>

[ Upstream commit fd5a6a71313e27c4f601526081b69d4e76f03dea ]

Keep per Tx-queue error count on Head-Of-Line Blocking due to frame
size(HLBF) error. The MAC raises HLBF error on one or more queues
when none of the time Intervals of open-gates in the GCL is greater
than or equal to the duration needed for frame transmission and by
default drops those packets that causes HLBF error. EST_FRM_SZ_ERR
register provides the One Hot encoded Queue numbers that have the
Frame Size related error.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 36ac9e7f2e57 ("net: stmmac: move the EST lock to struct stmmac_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h     | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 2706761955fea..618d455b457c7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -226,6 +226,7 @@ struct stmmac_extra_stats {
 	unsigned long mtl_est_btre;
 	unsigned long mtl_est_btrlm;
 	unsigned long max_sdu_txq_drop[MTL_MAX_TX_QUEUES];
+	unsigned long mtl_est_txq_hlbf[MTL_MAX_TX_QUEUES];
 	/* per queue statistics */
 	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
 	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
index 4da6ccc17c205..c9693f77e1f61 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
@@ -81,6 +81,7 @@ static void est_irq_status(struct stmmac_priv *priv, struct net_device *dev,
 	u32 status, value, feqn, hbfq, hbfs, btrl, btrl_max;
 	void __iomem *est_addr = priv->estaddr;
 	u32 txqcnt_mask = BIT(txqcnt) - 1;
+	int i;
 
 	status = readl(est_addr + EST_STATUS);
 
@@ -125,6 +126,11 @@ static void est_irq_status(struct stmmac_priv *priv, struct net_device *dev,
 
 		x->mtl_est_hlbf++;
 
+		for (i = 0; i < txqcnt; i++) {
+			if (feqn & BIT(i))
+				x->mtl_est_txq_hlbf[i]++;
+		}
+
 		/* Clear Interrupt */
 		writel(feqn, est_addr + EST_FRM_SZ_ERR);
 
-- 
2.43.0



