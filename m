Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D685917727;
	Mon, 27 May 2024 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838282; cv=none; b=LE40Eb231iW6vbmujL0oUX6JaO0nbSRcm94dB7Ewvv6ZbvDBlA0KgEUmf14EnaF/Rr4mdMHoencJPgT15PIwHSa9ZPxKUUZt2wQIMc9v4nIKTYob463/OIjZE6HbKHsOPgcvL6+ylzM9AhoBLbVRQn9+IxlpNoPpLIDKH9BLNpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838282; c=relaxed/simple;
	bh=y7ltu8d9q1H5QS/Ar6kVi0aZGyPMjduY1Y3OnBWMxkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf0J8KQE9Z71eFkKOZSfZycMse+FW+rWyqOkpdwczRmYjbXU22781nhnSb2Fq8+hxJ2HG2F7sQrLc/WI7riYIEhP69f5Hls+X/Gbd92Gn2Qxk3XWfx+qcVU6JvlB2EzoEnHsyDoETi9qzjsRYZHolgX8fMr8bPjArhPhELJu0Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBzO1Cfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBzO1Cfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147CCC2BBFC;
	Mon, 27 May 2024 19:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838282;
	bh=y7ltu8d9q1H5QS/Ar6kVi0aZGyPMjduY1Y3OnBWMxkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBzO1CfkRPxCc0/a7KR1+3i+JHbpwi79WCaEozaAk/l4AS5lQNoywHRg7ZPctmfH4
	 Pax00AuCRidEgcIJwXDaebNHny9ROzWq47zrF+RQL4Ft/b2jwEezTuKrxJMgN1jesr
	 fH8qGd+KkM5ocygFr4njYcgeWVI34izhTE8C3hmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 334/493] net: stmmac: Report taprio offload status
Date: Mon, 27 May 2024 20:55:36 +0200
Message-ID: <20240527185641.197036046@linuxfoundation.org>
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

[ Upstream commit 5ca63ffdb94ba2bac4c23c8609aabd7edd03c312 ]

Report taprio offload status. This includes per txq and global
counters of window_drops and tx_overruns.

Window_drops count include count of frames dropped because of
queueMaxSDU setting and HLBF error. Transmission overrun counter
inform the user application whether any packets are currently being
transmitted on a particular queue during a gate-close event.DWMAC IPs
takes care Transmission overrun won't happen hence this is always 0.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 36ac9e7f2e57 ("net: stmmac: move the EST lock to struct stmmac_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 62 +++++++++++++++++--
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 07aa3a3089dc2..cce00719937db 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -937,8 +937,8 @@ static void tc_taprio_map_maxsdu_txq(struct stmmac_priv *priv,
 	}
 }
 
-static int tc_setup_taprio(struct stmmac_priv *priv,
-			   struct tc_taprio_qopt_offload *qopt)
+static int tc_taprio_configure(struct stmmac_priv *priv,
+			       struct tc_taprio_qopt_offload *qopt)
 {
 	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
 	struct plat_stmmacenet_data *plat = priv->plat;
@@ -990,8 +990,6 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 
 	if (qopt->cmd == TAPRIO_CMD_DESTROY)
 		goto disable;
-	else if (qopt->cmd != TAPRIO_CMD_REPLACE)
-		return -EOPNOTSUPP;
 
 	if (qopt->num_entries >= dep)
 		return -EINVAL;
@@ -1102,6 +1100,11 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 		priv->plat->est->enable = false;
 		stmmac_est_configure(priv, priv, priv->plat->est,
 				     priv->plat->clk_ptp_rate);
+		/* Reset taprio status */
+		for (i = 0; i < priv->plat->tx_queues_to_use; i++) {
+			priv->xstats.max_sdu_txq_drop[i] = 0;
+			priv->xstats.mtl_est_txq_hlbf[i] = 0;
+		}
 		mutex_unlock(&priv->plat->est->lock);
 	}
 
@@ -1119,6 +1122,57 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return ret;
 }
 
+static void tc_taprio_stats(struct stmmac_priv *priv,
+			    struct tc_taprio_qopt_offload *qopt)
+{
+	u64 window_drops = 0;
+	int i = 0;
+
+	for (i = 0; i < priv->plat->tx_queues_to_use; i++)
+		window_drops += priv->xstats.max_sdu_txq_drop[i] +
+				priv->xstats.mtl_est_txq_hlbf[i];
+	qopt->stats.window_drops = window_drops;
+
+	/* Transmission overrun doesn't happen for stmmac, hence always 0 */
+	qopt->stats.tx_overruns = 0;
+}
+
+static void tc_taprio_queue_stats(struct stmmac_priv *priv,
+				  struct tc_taprio_qopt_offload *qopt)
+{
+	struct tc_taprio_qopt_queue_stats *q_stats = &qopt->queue_stats;
+	int queue = qopt->queue_stats.queue;
+
+	q_stats->stats.window_drops = priv->xstats.max_sdu_txq_drop[queue] +
+				      priv->xstats.mtl_est_txq_hlbf[queue];
+
+	/* Transmission overrun doesn't happen for stmmac, hence always 0 */
+	q_stats->stats.tx_overruns = 0;
+}
+
+static int tc_setup_taprio(struct stmmac_priv *priv,
+			   struct tc_taprio_qopt_offload *qopt)
+{
+	int err = 0;
+
+	switch (qopt->cmd) {
+	case TAPRIO_CMD_REPLACE:
+	case TAPRIO_CMD_DESTROY:
+		err = tc_taprio_configure(priv, qopt);
+		break;
+	case TAPRIO_CMD_STATS:
+		tc_taprio_stats(priv, qopt);
+		break;
+	case TAPRIO_CMD_QUEUE_STATS:
+		tc_taprio_queue_stats(priv, qopt);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 static int tc_setup_etf(struct stmmac_priv *priv,
 			struct tc_etf_qopt_offload *qopt)
 {
-- 
2.43.0



