Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3EA1805B;
	Wed, 19 Feb 2025 09:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956852; cv=none; b=W43nEzZgXfUwqWwgGin3w/mNve+tSkfoEOW2GfBOshREj9yJoj52m9YOqr7F4wU7orgu1aJc0nKQODxx7G8WTz7I9uya0BL1HFN9/hbVEBRVEwrAeQ5yU2Cw60dYP3ARgJTKzGDkd9xrLWdtG+k5934SRwBtOUznHx0J1VMErHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956852; c=relaxed/simple;
	bh=rGGiPVLWjhKreuVjCHKDFU3UG8KMU7QX3WQc7/j7AeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULi7hXPhMygeVQ18nkU7s4S/v38vR1RqSK3hVQH5yYQ9RXzqiMzPeKop0klJqaPhzkDrk3f1lUInoEyZZlC9qNtKSvrnoGmyWIbwqTFwLqKWxiqZAJ5oOU8wnBPU/HY+HUO+n/TRzNw/t0qtCEMziX6JNXWZ8g1mGiBGvpPdzTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQMcS5fK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQMcS5fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA8DC4CED1;
	Wed, 19 Feb 2025 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956851;
	bh=rGGiPVLWjhKreuVjCHKDFU3UG8KMU7QX3WQc7/j7AeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQMcS5fK6B+zwLNRqpE74UK8uavElB1UiYKS2d2giXHqNiqbcnWpTH7CP957EuA5m
	 aZO0DGln2ebNsjNrxtLrctrYVeVWzJ1rEsuGW5gPxXT5h9uF+pwajqQVxgs7tz5xk6
	 Csc/fzlUul9I2JseUpyEpFg5xJaZomgdi68zhp6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Delevoryas <peter@pjd.dev>,
	Patrick Williams <patrick@stwcx.xyz>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 315/578] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
Date: Wed, 19 Feb 2025 09:25:19 +0100
Message-ID: <20250219082705.406856390@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Delevoryas <peter@pjd.dev>

[ Upstream commit b8291cf3d1180b5b61299922f17c9441616a805a ]

This change adds support for the NC-SI 1.2 Get MC MAC Address command,
specified here:

https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2.0.pdf

It serves the exact same function as the existing OEM Get MAC Address
commands, so if a channel reports that it supports NC-SI 1.2, we prefer
to use the standard command rather than the OEM command.

Verified with an invalid MAC address and 2 valid ones:

[   55.137072] ftgmac100 1e690000.ftgmac eth0: NCSI: Received 3 provisioned MAC addresses
[   55.137614] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 0: 00:00:00:00:00:00
[   55.138026] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 1: fa:ce:b0:0c:20:22
[   55.138528] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 2: fa:ce:b0:0c:20:23
[   55.139241] ftgmac100 1e690000.ftgmac eth0: NCSI: Unable to assign 00:00:00:00:00:00 to device
[   55.140098] ftgmac100 1e690000.ftgmac eth0: NCSI: Set MAC address to fa:ce:b0:0c:20:22

Signed-off-by: Peter Delevoryas <peter@pjd.dev>
Signed-off-by: Patrick Williams <patrick@stwcx.xyz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9e2bbab94b88 ("net/ncsi: fix locking in Get MAC Address handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-cmd.c    |  3 ++-
 net/ncsi/ncsi-manage.c |  9 +++++++--
 net/ncsi/ncsi-pkt.h    | 10 ++++++++++
 net/ncsi/ncsi-rsp.c    | 41 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index dda8b76b77988..7be177f551731 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -269,7 +269,8 @@ static struct ncsi_cmd_handler {
 	{ NCSI_PKT_CMD_GPS,    0, ncsi_cmd_handler_default },
 	{ NCSI_PKT_CMD_OEM,   -1, ncsi_cmd_handler_oem     },
 	{ NCSI_PKT_CMD_PLDM,   0, NULL                     },
-	{ NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default }
+	{ NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default },
+	{ NCSI_PKT_CMD_GMCMA,  0, ncsi_cmd_handler_default }
 };
 
 static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 760b33fa03a8b..4583b29971933 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1040,11 +1040,16 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 	case ncsi_dev_state_config_oem_gma:
 		nd->state = ncsi_dev_state_config_clear_vids;
 
-		nca.type = NCSI_PKT_CMD_OEM;
 		nca.package = np->id;
 		nca.channel = nc->id;
 		ndp->pending_req_num = 1;
-		ret = ncsi_gma_handler(&nca, nc->version.mf_id);
+		if (nc->version.major >= 1 && nc->version.minor >= 2) {
+			nca.type = NCSI_PKT_CMD_GMCMA;
+			ret = ncsi_xmit_cmd(&nca);
+		} else {
+			nca.type = NCSI_PKT_CMD_OEM;
+			ret = ncsi_gma_handler(&nca, nc->version.mf_id);
+		}
 		if (ret < 0)
 			schedule_work(&ndp->work);
 
diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
index c9d1da34dc4dc..f2f3b5c1b9412 100644
--- a/net/ncsi/ncsi-pkt.h
+++ b/net/ncsi/ncsi-pkt.h
@@ -338,6 +338,14 @@ struct ncsi_rsp_gpuuid_pkt {
 	__be32                  checksum;
 };
 
+/* Get MC MAC Address */
+struct ncsi_rsp_gmcma_pkt {
+	struct ncsi_rsp_pkt_hdr rsp;
+	unsigned char           address_count;
+	unsigned char           reserved[3];
+	unsigned char           addresses[][ETH_ALEN];
+};
+
 /* AEN: Link State Change */
 struct ncsi_aen_lsc_pkt {
 	struct ncsi_aen_pkt_hdr aen;        /* AEN header      */
@@ -398,6 +406,7 @@ struct ncsi_aen_hncdsc_pkt {
 #define NCSI_PKT_CMD_GPUUID	0x52 /* Get package UUID                 */
 #define NCSI_PKT_CMD_QPNPR	0x56 /* Query Pending NC PLDM request */
 #define NCSI_PKT_CMD_SNPR	0x57 /* Send NC PLDM Reply  */
+#define NCSI_PKT_CMD_GMCMA	0x58 /* Get MC MAC Address */
 
 
 /* NCSI packet responses */
@@ -433,6 +442,7 @@ struct ncsi_aen_hncdsc_pkt {
 #define NCSI_PKT_RSP_GPUUID	(NCSI_PKT_CMD_GPUUID + 0x80)
 #define NCSI_PKT_RSP_QPNPR	(NCSI_PKT_CMD_QPNPR   + 0x80)
 #define NCSI_PKT_RSP_SNPR	(NCSI_PKT_CMD_SNPR   + 0x80)
+#define NCSI_PKT_RSP_GMCMA	(NCSI_PKT_CMD_GMCMA  + 0x80)
 
 /* NCSI response code/reason */
 #define NCSI_PKT_RSP_C_COMPLETED	0x0000 /* Command Completed        */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index f22d67cb04d37..e28be33bdf2c4 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1093,6 +1093,44 @@ static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)
 	return ret;
 }
 
+static int ncsi_rsp_handler_gmcma(struct ncsi_request *nr)
+{
+	struct ncsi_dev_priv *ndp = nr->ndp;
+	struct net_device *ndev = ndp->ndev.dev;
+	struct ncsi_rsp_gmcma_pkt *rsp;
+	struct sockaddr saddr;
+	int ret = -1;
+	int i;
+
+	rsp = (struct ncsi_rsp_gmcma_pkt *)skb_network_header(nr->rsp);
+	saddr.sa_family = ndev->type;
+	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+
+	netdev_info(ndev, "NCSI: Received %d provisioned MAC addresses\n",
+		    rsp->address_count);
+	for (i = 0; i < rsp->address_count; i++) {
+		netdev_info(ndev, "NCSI: MAC address %d: %02x:%02x:%02x:%02x:%02x:%02x\n",
+			    i, rsp->addresses[i][0], rsp->addresses[i][1],
+			    rsp->addresses[i][2], rsp->addresses[i][3],
+			    rsp->addresses[i][4], rsp->addresses[i][5]);
+	}
+
+	for (i = 0; i < rsp->address_count; i++) {
+		memcpy(saddr.sa_data, &rsp->addresses[i], ETH_ALEN);
+		ret = ndev->netdev_ops->ndo_set_mac_address(ndev, &saddr);
+		if (ret < 0) {
+			netdev_warn(ndev, "NCSI: Unable to assign %pM to device\n",
+				    saddr.sa_data);
+			continue;
+		}
+		netdev_warn(ndev, "NCSI: Set MAC address to %pM\n", saddr.sa_data);
+		break;
+	}
+
+	ndp->gma_flag = ret == 0;
+	return ret;
+}
+
 static struct ncsi_rsp_handler {
 	unsigned char	type;
 	int             payload;
@@ -1129,7 +1167,8 @@ static struct ncsi_rsp_handler {
 	{ NCSI_PKT_RSP_PLDM,   -1, ncsi_rsp_handler_pldm    },
 	{ NCSI_PKT_RSP_GPUUID, 20, ncsi_rsp_handler_gpuuid  },
 	{ NCSI_PKT_RSP_QPNPR,  -1, ncsi_rsp_handler_pldm    },
-	{ NCSI_PKT_RSP_SNPR,   -1, ncsi_rsp_handler_pldm    }
+	{ NCSI_PKT_RSP_SNPR,   -1, ncsi_rsp_handler_pldm    },
+	{ NCSI_PKT_RSP_GMCMA,  -1, ncsi_rsp_handler_gmcma   },
 };
 
 int ncsi_rcv_rsp(struct sk_buff *skb, struct net_device *dev,
-- 
2.39.5



