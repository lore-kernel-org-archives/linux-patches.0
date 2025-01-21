Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601B61F55F3;
	Tue, 21 Jan 2025 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482481; cv=none; b=LTI1gyyQg1WqVN2nOt93oPYtZTL4fi395zUAK3bauZoY785205k+mc8LK5V8AsQs+0azRYaO1TMjoRpUZUd+bsq77h/okCmmMmGdZt90VotME996S+aTK3MqDqkXt2+A6OJv5Yh9PFFzFKbyp+Cpbj57TuxTX57j99n4vFullmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482481; c=relaxed/simple;
	bh=1hkL/RLyctsffJnL/PNO+bveif4uPJOq7LY8k0BHrLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0icam9/iJ5q6ESUMb7AuWAhpUItGBOSSa30WDjmOFYrOjCQ7y0WqSHhurflqsdf/iNw9Q1qLThoukUk4wXuX9PLQt/0MhrIxs5H9xWSUvuG7PVt5eKgA/XmFrQphAE+oiRiUwWUC5FryvYNkTHBO5aDdIM4Gu3OhyLC9QKNI/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOkK6oXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOkK6oXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40EEC4CEDF;
	Tue, 21 Jan 2025 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482481;
	bh=1hkL/RLyctsffJnL/PNO+bveif4uPJOq7LY8k0BHrLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOkK6oXBTLQNmJlOgIcIkeOECCfFicHZMKc44xzfhRGyFx4q/ifNhMpqVYsEpndWw
	 vSo192ULFZkGy65auiqogW4gW3o8F0jxpYBNreUCCqkzwaPBS8LvmLd2RtoEvzA3Cj
	 zANHRg8TMssKWPtB45QYkASL+ahCYZsvb+9bjHlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Potin Lai <potin.lai.pt@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 091/122] net/ncsi: fix locking in Get MAC Address handling
Date: Tue, 21 Jan 2025 18:52:19 +0100
Message-ID: <20250121174536.527206333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Fertser <fercerpav@gmail.com>

commit 9e2bbab94b88295dcc57c7580393c9ee08d7314d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/internal.h    |    2 ++
 net/ncsi/ncsi-manage.c |   16 ++++++++++++++--
 net/ncsi/ncsi-rsp.c    |   19 ++++++-------------
 3 files changed, 22 insertions(+), 15 deletions(-)

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
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1038,7 +1038,7 @@ static void ncsi_configure_channel(struc
 			  : ncsi_dev_state_config_clear_vids;
 		break;
 	case ncsi_dev_state_config_oem_gma:
-		nd->state = ncsi_dev_state_config_clear_vids;
+		nd->state = ncsi_dev_state_config_apply_mac;
 
 		nca.package = np->id;
 		nca.channel = nc->id;
@@ -1050,10 +1050,22 @@ static void ncsi_configure_channel(struc
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
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -628,16 +628,14 @@ static int ncsi_rsp_handler_snfc(struct
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
@@ -646,22 +644,17 @@ static int ncsi_rsp_handler_oem_gma(stru
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


