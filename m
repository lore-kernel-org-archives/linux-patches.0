Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2B717CA12;
	Mon, 10 Mar 2025 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629250; cv=none; b=NpRN/a4dw1F7jsYKyUy/13yYmda6hgaOnPYzXuYHSXaQCwBOVvm79sHSzL60d5RTOMlG5zCZfO9jjDIb0SPGsFg5imB8fmNJTW3AACnyPYTPLEKqusbYJnC4NvGjec1BDbns6wWdjQ458hqrmoBPLVMaC1fkYOugyqIOuY1kcC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629250; c=relaxed/simple;
	bh=dulB4lfa3TIoDXjn2Xf6srooPirTNzSNhRPAnoZ/dI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG1G7ZIzeQWtRRGhmQiR+TfCvB/ImSAtlopbN603vvBqwKXtkHz6eXboIUj6vYyFIjoNx/pdwP1z9Ogzu3sF7IwlDpowlMYhEyKZDtGhxRdzO7eQrGzGj+BzK0izYJuh9l3rEJ0krlVm0SCty3BTgQ4KxJgs3mEv5aN77qXr/80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGchUB3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGchUB3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17EEC4CEE5;
	Mon, 10 Mar 2025 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629250;
	bh=dulB4lfa3TIoDXjn2Xf6srooPirTNzSNhRPAnoZ/dI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGchUB3yKFwgT+dsrMhpGoFXqrlxFK/ZsUeLoLZifD8HtZfzkI2kr4QMxDQySDcBT
	 K5aiut76OSZOMxjyUmf/hbX6f3MWaO1l1V45ogcAgK06HDo6ZFBxJaScV38NnzaX3E
	 kIVjfgZ5I0pzKJCOqFOtdjOQT3M3Cqo7V7Hv1ya8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Potin Lai <potin.lai.pt@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/620] net/ncsi: fix locking in Get MAC Address handling
Date: Mon, 10 Mar 2025 18:01:16 +0100
Message-ID: <20250310170554.713804928@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Paul Fertser <fercerpav@gmail.com>

[ Upstream commit 9e2bbab94b88295dcc57c7580393c9ee08d7314d ]

Obtaining RTNL lock in a response handler is not allowed since it runs
in an atomic softirq context. Postpone setting the MAC address by adding
a dedicated step to the configuration FSM.

Fixes: 790071347a0a ("net/ncsi: change from ndo_set_mac_address to dev_set_mac_address")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20241129-potin-revert-ncsi-set-mac-addr-v1-1-94ea2cb596af@gmail.com
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Tested-by: Potin Lai <potin.lai.pt@gmail.com>
Link: https://patch.msgid.link/20250109145054.30925-1-fercerpav@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h    |  2 ++
 net/ncsi/ncsi-manage.c | 16 ++++++++++++++--
 net/ncsi/ncsi-rsp.c    | 19 ++++++-------------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index ef0f8f73826f5..4e0842df5234e 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -289,6 +289,7 @@ enum {
 	ncsi_dev_state_config_sp	= 0x0301,
 	ncsi_dev_state_config_cis,
 	ncsi_dev_state_config_oem_gma,
+	ncsi_dev_state_config_apply_mac,
 	ncsi_dev_state_config_clear_vids,
 	ncsi_dev_state_config_svf,
 	ncsi_dev_state_config_ev,
@@ -322,6 +323,7 @@ struct ncsi_dev_priv {
 #define NCSI_DEV_RESHUFFLE	4
 #define NCSI_DEV_RESET		8            /* Reset state of NC          */
 	unsigned int        gma_flag;        /* OEM GMA flag               */
+	struct sockaddr     pending_mac;     /* MAC address received from GMA */
 	spinlock_t          lock;            /* Protect the NCSI device    */
 	unsigned int        package_probe_id;/* Current ID during probe    */
 	unsigned int        package_num;     /* Number of packages         */
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index da7013c407012..1104c6ce8d65e 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1038,7 +1038,7 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 			  : ncsi_dev_state_config_clear_vids;
 		break;
 	case ncsi_dev_state_config_oem_gma:
-		nd->state = ncsi_dev_state_config_clear_vids;
+		nd->state = ncsi_dev_state_config_apply_mac;
 
 		nca.package = np->id;
 		nca.channel = nc->id;
@@ -1050,10 +1050,22 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 			nca.type = NCSI_PKT_CMD_OEM;
 			ret = ncsi_gma_handler(&nca, nc->version.mf_id);
 		}
-		if (ret < 0)
+		if (ret < 0) {
+			nd->state = ncsi_dev_state_config_clear_vids;
 			schedule_work(&ndp->work);
+		}
 
 		break;
+	case ncsi_dev_state_config_apply_mac:
+		rtnl_lock();
+		ret = dev_set_mac_address(dev, &ndp->pending_mac, NULL);
+		rtnl_unlock();
+		if (ret < 0)
+			netdev_warn(dev, "NCSI: 'Writing MAC address to device failed\n");
+
+		nd->state = ncsi_dev_state_config_clear_vids;
+
+		fallthrough;
 	case ncsi_dev_state_config_clear_vids:
 	case ncsi_dev_state_config_svf:
 	case ncsi_dev_state_config_ev:
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index e28be33bdf2c4..14bd66909ca45 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -628,16 +628,14 @@ static int ncsi_rsp_handler_snfc(struct ncsi_request *nr)
 static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
+	struct sockaddr *saddr = &ndp->pending_mac;
 	struct net_device *ndev = ndp->ndev.dev;
 	struct ncsi_rsp_oem_pkt *rsp;
-	struct sockaddr saddr;
 	u32 mac_addr_off = 0;
-	int ret = 0;
 
 	/* Get the response header */
 	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
 
-	saddr.sa_family = ndev->type;
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	if (mfr_id == NCSI_OEM_MFR_BCM_ID)
 		mac_addr_off = BCM_MAC_ADDR_OFFSET;
@@ -646,22 +644,17 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 	else if (mfr_id == NCSI_OEM_MFR_INTEL_ID)
 		mac_addr_off = INTEL_MAC_ADDR_OFFSET;
 
-	memcpy(saddr.sa_data, &rsp->data[mac_addr_off], ETH_ALEN);
+	saddr->sa_family = ndev->type;
+	memcpy(saddr->sa_data, &rsp->data[mac_addr_off], ETH_ALEN);
 	if (mfr_id == NCSI_OEM_MFR_BCM_ID || mfr_id == NCSI_OEM_MFR_INTEL_ID)
-		eth_addr_inc((u8 *)saddr.sa_data);
-	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
+		eth_addr_inc((u8 *)saddr->sa_data);
+	if (!is_valid_ether_addr((const u8 *)saddr->sa_data))
 		return -ENXIO;
 
 	/* Set the flag for GMA command which should only be called once */
 	ndp->gma_flag = 1;
 
-	rtnl_lock();
-	ret = dev_set_mac_address(ndev, &saddr, NULL);
-	rtnl_unlock();
-	if (ret < 0)
-		netdev_warn(ndev, "NCSI: 'Writing mac address to device failed\n");
-
-	return ret;
+	return 0;
 }
 
 /* Response handler for Mellanox card */
-- 
2.39.5



