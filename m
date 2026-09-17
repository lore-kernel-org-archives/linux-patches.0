Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5654ABBCC;
	Thu, 17 Sep 2026 18:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670471; cv=none; b=bk6AFRU2hwiBCf9VY4MDUWuk5i9lLeyq2UD+I7je/vEgcruzhNhnrf7H72d0N9CQyQ42HPPEZa50qzmdia/5R0GZ8IC43h2JEYqcowwhi7G8Oisd1znUdXpIeYPiCaSF5pYkTsZ8HanPNY91lssZrJ7mLOh5OfV9uDJdoMkhvnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670471; c=relaxed/simple;
	bh=J5G0e+6Ro/OCF8AT67EsE35vh6Lv5W0sWDKhtZnwgFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtxLl+0pbNqkHJowpJo8YeDghPBwHpZD8a8e1aQY6fZKLK/Pg85hTpk8QxX5c9KvtBhLWA6cZdF9+NENviNFZVX0DRG3tMPoJ83wgelgOv9MoxdoRAAV5l5tfK8QytgQG2lutaEt2rv06SkaFG2Dv/Va8SdJCsr+I8lw0tx94rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTFfjpne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTFfjpne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34841F000FF;
	Thu, 17 Sep 2026 18:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670469;
	bh=z6zMA+VajhvQle0oYZ14gtZ8fM+jzbiNhCvLwuJ3XeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTFfjpneRbU26mF+Nia9bNG/F34RMC4gz01UZpluEf859qYJqUIgS65PjjforGJU9
	 OB7WR1LhU6ZT94GM23WVYdwkMRBgZN1AG6Pi489IgibP41dMYesLub9PGyAUUv/Tcd
	 CkJrs2GRoVXQnwDzIJNWFpvFptTu0k1OR2O0rckU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Peens <louis.peens@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0670/1102] eth: nfp: migrate to new RXFH callbacks
Date: Thu, 17 Sep 2026 16:10:13 +0100
Message-ID: <20260917151557.041545757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6bfd8cf33859ae23ec9e07a5bdbb55315305962a ]

Migrate to new callbacks added by commit 9bb00786fc61 ("net: ethtool:
add dedicated callbacks for getting and setting rxfh fields").

Acked-by: Louis Peens <louis.peens@corigine.com>
Link: https://patch.msgid.link/20250618203823.1336156-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1986bf87b07 ("eth: nfp: bound the ntuple rule dump by the caller's buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c    | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 37a46596268a0..16c828dd5c1a3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1303,9 +1303,10 @@ static u32 ethtool_flow_to_nfp_flag(u32 flow_type)
 	return xlate_ethtool_to_nfp[flow_type];
 }
 
-static int nfp_net_get_rss_hash_opts(struct nfp_net *nn,
-				     struct ethtool_rxnfc *cmd)
+static int nfp_net_get_rxfh_fields(struct net_device *netdev,
+				   struct ethtool_rxfh_fields *cmd)
 {
+	struct nfp_net *nn = netdev_priv(netdev);
 	u32 nfp_rss_flag;
 
 	cmd->data = 0;
@@ -1451,16 +1452,16 @@ static int nfp_net_get_rxnfc(struct net_device *netdev,
 	case ETHTOOL_GRXCLSRLALL:
 		cmd->data = NFP_FS_MAX_ENTRY;
 		return nfp_net_get_fs_loc(nn, rule_locs);
-	case ETHTOOL_GRXFH:
-		return nfp_net_get_rss_hash_opts(nn, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-static int nfp_net_set_rss_hash_opt(struct nfp_net *nn,
-				    struct ethtool_rxnfc *nfc)
+static int nfp_net_set_rxfh_fields(struct net_device *netdev,
+				   const struct ethtool_rxfh_fields *nfc,
+				   struct netlink_ext_ack *extack)
 {
+	struct nfp_net *nn = netdev_priv(netdev);
 	u32 new_rss_cfg = nn->rss_cfg;
 	u32 nfp_rss_flag;
 	int err;
@@ -1763,8 +1764,6 @@ static int nfp_net_set_rxnfc(struct net_device *netdev,
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	switch (cmd->cmd) {
-	case ETHTOOL_SRXFH:
-		return nfp_net_set_rss_hash_opt(nn, cmd);
 	case ETHTOOL_SRXCLSRLINS:
 		return nfp_net_fs_add(nn, cmd);
 	case ETHTOOL_SRXCLSRLDEL:
@@ -2506,6 +2505,8 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.get_rxfh_key_size	= nfp_net_get_rxfh_key_size,
 	.get_rxfh		= nfp_net_get_rxfh,
 	.set_rxfh		= nfp_net_set_rxfh,
+	.get_rxfh_fields	= nfp_net_get_rxfh_fields,
+	.set_rxfh_fields	= nfp_net_set_rxfh_fields,
 	.get_regs_len		= nfp_net_get_regs_len,
 	.get_regs		= nfp_net_get_regs,
 	.set_dump		= nfp_app_set_dump,
-- 
2.53.0



