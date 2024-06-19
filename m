Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C1914389C;
	Wed, 19 Jun 2024 13:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802727; cv=none; b=XZvkfv5nxYs98VlG6B7u+G9q5zr49U6isV6n8Xp0RVMSW0gn6lub3xwdywxO5wGgJ+GaI4N8lxC0N2sCpydIyzTvboI/sgRSvxNh4uMX7GGmBQRWLRVFRbugh380K805eCKgzR7I5Jh1S+Z+owBTy3gaNfma4pdBgXl2R2CtqH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802727; c=relaxed/simple;
	bh=uWVVqnQ0KPC/C10kYBgEIVHBFY6t+8WHHp5y093ABXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+aKqE0zjkIFrstSuKlezzNoN++uaSvUaEm0AFG8jcYm8yPaCzeeCs4rXzUc8avsSnu5xMA0hm/gnwegvi3JWapSduoHYe+sFehB/fHt/efom+31d9Z3B3sz1MaZ4WCcGc5TiVNS8424D98iuqlvq42yk65WG3XowxXvkvVBCIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlMnlNoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlMnlNoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BE7C2BBFC;
	Wed, 19 Jun 2024 13:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802727;
	bh=uWVVqnQ0KPC/C10kYBgEIVHBFY6t+8WHHp5y093ABXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlMnlNoOcqhdIlD1O2HK+0UpHO5/nDirbkJEp9KZOnegD33kSrtvnVHbXiFlfIRrv
	 S1OEBX5BfHjFeAHW9v4EBBEoJI7vUiaM1MfYKIxI9bBTxFEoZWlB6RqTTd6YTV+qsE
	 oSVZ6LkLpjaFAWQa2WrjiuBnjUDkgNi55osuxB74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DelphineCCChiu <delphine_cc_chiu@wiwynn.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 026/281] net/ncsi: Fix the multi thread manner of NCSI driver
Date: Wed, 19 Jun 2024 14:53:05 +0200
Message-ID: <20240619125610.852946547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DelphineCCChiu <delphine_cc_chiu@wiwynn.com>

[ Upstream commit e85e271dec0270982afed84f70dc37703fcc1d52 ]

Currently NCSI driver will send several NCSI commands back to back without
waiting the response of previous NCSI command or timeout in some state
when NIC have multi channel. This operation against the single thread
manner defined by NCSI SPEC(section 6.3.2.3 in DSP0222_1.1.1)

According to NCSI SPEC(section 6.2.13.1 in DSP0222_1.1.1), we should probe
one channel at a time by sending NCSI commands (Clear initial state, Get
version ID, Get capabilities...), than repeat this steps until the max
number of channels which we got from NCSI command (Get capabilities) has
been probed.

Fixes: e6f44ed6d04d ("net/ncsi: Package and channel management")
Signed-off-by: DelphineCCChiu <delphine_cc_chiu@wiwynn.com>
Link: https://lore.kernel.org/r/20240529065856.825241-1-delphine_cc_chiu@wiwynn.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h    |  2 ++
 net/ncsi/ncsi-manage.c | 73 +++++++++++++++++++++---------------------
 net/ncsi/ncsi-rsp.c    |  4 ++-
 3 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 374412ed780b6..ef0f8f73826f5 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -325,6 +325,7 @@ struct ncsi_dev_priv {
 	spinlock_t          lock;            /* Protect the NCSI device    */
 	unsigned int        package_probe_id;/* Current ID during probe    */
 	unsigned int        package_num;     /* Number of packages         */
+	unsigned int        channel_probe_id;/* Current cahnnel ID during probe */
 	struct list_head    packages;        /* List of packages           */
 	struct ncsi_channel *hot_channel;    /* Channel was ever active    */
 	struct ncsi_request requests[256];   /* Request table              */
@@ -343,6 +344,7 @@ struct ncsi_dev_priv {
 	bool                multi_package;   /* Enable multiple packages   */
 	bool                mlx_multi_host;  /* Enable multi host Mellanox */
 	u32                 package_whitelist; /* Packages to configure    */
+	unsigned char       channel_count;     /* Num of channels to probe   */
 };
 
 struct ncsi_cmd_arg {
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 745c788f1d1df..5ecf611c88200 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -510,17 +510,19 @@ static void ncsi_suspend_channel(struct ncsi_dev_priv *ndp)
 
 		break;
 	case ncsi_dev_state_suspend_gls:
-		ndp->pending_req_num = np->channel_num;
+		ndp->pending_req_num = 1;
 
 		nca.type = NCSI_PKT_CMD_GLS;
 		nca.package = np->id;
+		nca.channel = ndp->channel_probe_id;
+		ret = ncsi_xmit_cmd(&nca);
+		if (ret)
+			goto error;
+		ndp->channel_probe_id++;
 
-		nd->state = ncsi_dev_state_suspend_dcnt;
-		NCSI_FOR_EACH_CHANNEL(np, nc) {
-			nca.channel = nc->id;
-			ret = ncsi_xmit_cmd(&nca);
-			if (ret)
-				goto error;
+		if (ndp->channel_probe_id == ndp->channel_count) {
+			ndp->channel_probe_id = 0;
+			nd->state = ncsi_dev_state_suspend_dcnt;
 		}
 
 		break;
@@ -1345,7 +1347,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 {
 	struct ncsi_dev *nd = &ndp->ndev;
 	struct ncsi_package *np;
-	struct ncsi_channel *nc;
 	struct ncsi_cmd_arg nca;
 	unsigned char index;
 	int ret;
@@ -1423,23 +1424,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_cis;
 		break;
-	case ncsi_dev_state_probe_cis:
-		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
-
-		/* Clear initial state */
-		nca.type = NCSI_PKT_CMD_CIS;
-		nca.package = ndp->active_package->id;
-		for (index = 0; index < NCSI_RESERVED_CHANNEL; index++) {
-			nca.channel = index;
-			ret = ncsi_xmit_cmd(&nca);
-			if (ret)
-				goto error;
-		}
-
-		nd->state = ncsi_dev_state_probe_gvi;
-		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
-			nd->state = ncsi_dev_state_probe_keep_phy;
-		break;
 	case ncsi_dev_state_probe_keep_phy:
 		ndp->pending_req_num = 1;
 
@@ -1452,14 +1436,17 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_gvi;
 		break;
+	case ncsi_dev_state_probe_cis:
 	case ncsi_dev_state_probe_gvi:
 	case ncsi_dev_state_probe_gc:
 	case ncsi_dev_state_probe_gls:
 		np = ndp->active_package;
-		ndp->pending_req_num = np->channel_num;
+		ndp->pending_req_num = 1;
 
-		/* Retrieve version, capability or link status */
-		if (nd->state == ncsi_dev_state_probe_gvi)
+		/* Clear initial state Retrieve version, capability or link status */
+		if (nd->state == ncsi_dev_state_probe_cis)
+			nca.type = NCSI_PKT_CMD_CIS;
+		else if (nd->state == ncsi_dev_state_probe_gvi)
 			nca.type = NCSI_PKT_CMD_GVI;
 		else if (nd->state == ncsi_dev_state_probe_gc)
 			nca.type = NCSI_PKT_CMD_GC;
@@ -1467,19 +1454,29 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 			nca.type = NCSI_PKT_CMD_GLS;
 
 		nca.package = np->id;
-		NCSI_FOR_EACH_CHANNEL(np, nc) {
-			nca.channel = nc->id;
-			ret = ncsi_xmit_cmd(&nca);
-			if (ret)
-				goto error;
-		}
+		nca.channel = ndp->channel_probe_id;
 
-		if (nd->state == ncsi_dev_state_probe_gvi)
+		ret = ncsi_xmit_cmd(&nca);
+		if (ret)
+			goto error;
+
+		if (nd->state == ncsi_dev_state_probe_cis) {
+			nd->state = ncsi_dev_state_probe_gvi;
+			if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY) && ndp->channel_probe_id == 0)
+				nd->state = ncsi_dev_state_probe_keep_phy;
+		} else if (nd->state == ncsi_dev_state_probe_gvi) {
 			nd->state = ncsi_dev_state_probe_gc;
-		else if (nd->state == ncsi_dev_state_probe_gc)
+		} else if (nd->state == ncsi_dev_state_probe_gc) {
 			nd->state = ncsi_dev_state_probe_gls;
-		else
+		} else {
+			nd->state = ncsi_dev_state_probe_cis;
+			ndp->channel_probe_id++;
+		}
+
+		if (ndp->channel_probe_id == ndp->channel_count) {
+			ndp->channel_probe_id = 0;
 			nd->state = ncsi_dev_state_probe_dp;
+		}
 		break;
 	case ncsi_dev_state_probe_dp:
 		ndp->pending_req_num = 1;
@@ -1780,6 +1777,7 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 		ndp->requests[i].ndp = ndp;
 		timer_setup(&ndp->requests[i].timer, ncsi_request_timeout, 0);
 	}
+	ndp->channel_count = NCSI_RESERVED_CHANNEL;
 
 	spin_lock_irqsave(&ncsi_dev_lock, flags);
 	list_add_tail_rcu(&ndp->node, &ncsi_dev_list);
@@ -1813,6 +1811,7 @@ int ncsi_start_dev(struct ncsi_dev *nd)
 
 	if (!(ndp->flags & NCSI_DEV_PROBED)) {
 		ndp->package_probe_id = 0;
+		ndp->channel_probe_id = 0;
 		nd->state = ncsi_dev_state_probe;
 		schedule_work(&ndp->work);
 		return 0;
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index bee290d0f48b6..e28be33bdf2c4 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -795,12 +795,13 @@ static int ncsi_rsp_handler_gc(struct ncsi_request *nr)
 	struct ncsi_rsp_gc_pkt *rsp;
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct ncsi_channel *nc;
+	struct ncsi_package *np;
 	size_t size;
 
 	/* Find the channel */
 	rsp = (struct ncsi_rsp_gc_pkt *)skb_network_header(nr->rsp);
 	ncsi_find_package_and_channel(ndp, rsp->rsp.common.channel,
-				      NULL, &nc);
+				      &np, &nc);
 	if (!nc)
 		return -ENODEV;
 
@@ -835,6 +836,7 @@ static int ncsi_rsp_handler_gc(struct ncsi_request *nr)
 	 */
 	nc->vlan_filter.bitmap = U64_MAX;
 	nc->vlan_filter.n_vids = rsp->vlan_cnt;
+	np->ndp->channel_count = rsp->channel_cnt;
 
 	return 0;
 }
-- 
2.43.0



