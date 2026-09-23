Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9453B5E1;
	Wed, 23 Sep 2026 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174638; cv=none; b=oCNcq8kMZtUmADCEiY4MWBhd+c7uGhOwA+qg2/r0mbrtz79sR6+zEDh44JBNgw2l+bnEquoushx2C/8U3L7x4juDtp7JLz5DJ3oa0GsTP9ugyHjJK+N8xKVkXVJcNWTLh/vK0eHEvXpbt/NGrnfCpKwGs5dBXeR4tSMSS7zF9AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174638; c=relaxed/simple;
	bh=sTM77xjqUxbwP+Uy9pKNOiNHeN1RAMG0n+Lx6K4r/vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4WOoNvfCzinnhhilnUfUICIK9K9b+UfEkS1ceceXJe8Z/kBwISYA1+TJ+8fvvZB+J0+blJGMjbHseFdRowcV0Z0QByxkYLFLwvM2H4f0sGgh+I9N0aZgkNuPsONiSll0q0o4ClB8pAJhAgGgmz3gXWSiPY4XMqWFO+i90zAhXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDWqim/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDWqim/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC611F000FF;
	Wed, 23 Sep 2026 14:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174637;
	bh=HefwMxW37ZbqpRSXJzExNsPQDI38cN35u+P+0+s8d6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDWqim/cvTYfYwUwLxKHyi8wzOYG2ToisdgcO0Ku+Jxxjb/mVDtf/NM938j/N4H2s
	 0AqsxEgVqVs52OvGDWR5sEUbCihWwe9EMp8xT8+xcE8oVgaOae27yG3yD/X9Yl9GmD
	 KXSa4WJWDiR4CgtjvXCrC4bzFF3kR//RW1IFCRFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/398] net: stmmac: propagate FPE preemption-class mapping errors
Date: Wed, 23 Sep 2026 16:04:13 +0200
Message-ID: <20260923140648.072708065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 90e4b849dfa6fc8e6c050bcfe1b331b69c015d28 ]

stmmac_fpe_map_preemption_class() dispatches through the
stmmac_do_void_callback() helper, which forces the callback's return
value to 0 whenever the op pointer is populated. As a result the
-EINVAL returned by dwmac5_fpe_map_preemption_class() (e.g. when a
preemptible TC owns more than one TXQ under SP scheduling) is silently
swallowed by every caller.

Switch the dispatch macro to stmmac_do_callback() so the callback's real
result is propagated, and honour it in the taprio and mqprio qdisc
offload.

Note that the taprio "if (ret)" check in tc_taprio_configure() used to
be dead code and now becomes live: a preemptible TC spanning more than
one TXQ under SP scheduling cannot be programmed in hardware, so a
taprio or mqprio configuration that previously returned success while
leaving the preemption-class register unprogrammed now fails with
-EINVAL. For taprio, the failure also runs the disable path, tearing
down the schedule that was just installed; this is the intended
behaviour.

Fixes: 195e4f409a40 ("net: stmmac: support fp parameter of tc-mqprio")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260911-stmmac-tc_setup_dwmac510_mqprio-error-path-v3-1-a76b1e2547c1@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 19 +++++++++----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 14dbe0685997d..75e915e86c789 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -490,7 +490,7 @@ struct stmmac_ops {
 #define stmmac_set_arp_offload(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_arp_offload, __args)
 #define stmmac_fpe_map_preemption_class(__priv, __args...) \
-	stmmac_do_void_callback(__priv, mac, fpe_map_preemption_class, __args)
+	stmmac_do_callback(__priv, mac, fpe_map_preemption_class, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 0119b4b89fc0a..49161241d0328 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -970,7 +970,7 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 	struct netlink_ext_ack *extack = qopt->mqprio.extack;
 	struct timespec64 time, current_time, qopt_time;
 	ktime_t current_time_ns;
-	int i, ret = 0;
+	int err, i, ret = 0;
 	u64 ctr;
 
 	if (qopt->base_time < 0)
@@ -1120,9 +1120,9 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 		mutex_unlock(&priv->est_lock);
 	}
 
-	stmmac_fpe_map_preemption_class(priv, priv->dev, extack, 0);
+	err = stmmac_fpe_map_preemption_class(priv, priv->dev, extack, 0);
 
-	return ret;
+	return qopt->cmd == TAPRIO_CMD_DESTROY ? err : ret;
 }
 
 static void tc_taprio_stats(struct stmmac_priv *priv,
@@ -1237,14 +1237,15 @@ static int tc_query_caps(struct stmmac_priv *priv,
 	}
 }
 
-static void stmmac_reset_tc_mqprio(struct net_device *ndev,
-				   struct netlink_ext_ack *extack)
+static int stmmac_reset_tc_mqprio(struct net_device *ndev,
+				  struct netlink_ext_ack *extack)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	netdev_reset_tc(ndev);
 	netif_set_real_num_tx_queues(ndev, priv->plat->tx_queues_to_use);
-	stmmac_fpe_map_preemption_class(priv, ndev, extack, 0);
+
+	return stmmac_fpe_map_preemption_class(priv, ndev, extack, 0);
 }
 
 static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
@@ -1257,10 +1258,8 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 	u32 num_tc = qopt->num_tc;
 	int err;
 
-	if (!num_tc) {
-		stmmac_reset_tc_mqprio(ndev, extack);
-		return 0;
-	}
+	if (!num_tc)
+		return stmmac_reset_tc_mqprio(ndev, extack);
 
 	err = netdev_set_num_tc(ndev, num_tc);
 	if (err)
-- 
2.53.0



