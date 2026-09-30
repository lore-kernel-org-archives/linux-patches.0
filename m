Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511802D594F;
	Wed, 30 Sep 2026 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788519; cv=none; b=DaU+z7BMSCIKyC9wONRUf6xYVpw7LatI1jaBxcd9GqmoYFZKX3D1o8w/knbhnROOFAqJXjk/st+N1L3zwu8PE2/UiQ1M5ZyaSQghHJF2tiaE2SkyFNJ3r2UhKDUsaKF503f8Sk0FLC+M1m9SQqFaBxOOZ+hPEZwTcV4apV+EkoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788519; c=relaxed/simple;
	bh=sWA4JGCVYvWAdLdHccyKIppJM+XXRvNzLtXk21R8NIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lclMs9Ytvwzvzu8GjY/NnRPaI4BqAUEEoXVSd6/RSpWgJeL1jK0F+nE4ZlX5oqnRcJZ/xTiGlz4Cgp/4/G6abCzXHMydMUdnh3hM5JSSfZk6rv5O29Lt5C3yfPkJbrAJQRnLwaFMdbabMJI/WUTsu0qCdyDzf00XWdi44/XKrDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEHaneCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEHaneCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CCE1F000FF;
	Wed, 30 Sep 2026 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788518;
	bh=uh++MOMKQtme7O/221cTHpx7srMGkXXQD2GleEWbySQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEHaneCGXrTTugoz3f2LCpexQiZWz3EhqHJsZSZvyfYX6ZVa6Dtbdq8lNG6jP0HSo
	 ZY/lt5nkaPGop9IMENwKu4H71UL276UXwwpXKSUn9zzSj0QgJMucjpYftJ5STOhimg
	 KQHGgeJ3xAEsDryH1QPkP14YVaLc2H1qWPat9mQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/877] net: stmmac: propagate FPE preemption-class mapping errors
Date: Wed, 30 Sep 2026 17:17:42 +0200
Message-ID: <20260930152417.979177514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d5a9f01ecac53..31d7f9375d747 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -541,7 +541,7 @@ struct stmmac_ops {
 #define stmmac_fpe_set_add_frag_size(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, fpe_set_add_frag_size, __args)
 #define stmmac_fpe_map_preemption_class(__priv, __args...) \
-	stmmac_do_void_callback(__priv, mac, fpe_map_preemption_class, __args)
+	stmmac_do_callback(__priv, mac, fpe_map_preemption_class, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 49f133dec810d..65085f9c9290e 100644
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
@@ -1119,9 +1119,9 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 		mutex_unlock(&priv->est_lock);
 	}
 
-	stmmac_fpe_map_preemption_class(priv, priv->dev, extack, 0);
+	err = stmmac_fpe_map_preemption_class(priv, priv->dev, extack, 0);
 
-	return ret;
+	return qopt->cmd == TAPRIO_CMD_DESTROY ? err : ret;
 }
 
 static void tc_taprio_stats(struct stmmac_priv *priv,
@@ -1234,14 +1234,15 @@ static int tc_query_caps(struct stmmac_priv *priv,
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
@@ -1254,10 +1255,8 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
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



