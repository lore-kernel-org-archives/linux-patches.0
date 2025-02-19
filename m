Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710421E048F;
	Wed, 19 Feb 2025 09:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957342; cv=none; b=QLTWlA7MWSHjYmH70/rqzdhlk61txrrAJPeOCEysCEgxSLnsJkJaw1ztqBTaiaxtUEKFrOOh+4ATHEwAXRbV615XNFzc++3w4TXGK/S8OyqVZ6/0zFfEzRwWP36WImJzFJMzU7kf+kAX9oQgeuE9ehFwiNn+zRb8SQrBOzvg+WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957342; c=relaxed/simple;
	bh=h99fds2MaTiwVgc4ocVn+fbgyNdB+VFdJT6loanjCj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvi8aUKQyeYMupq+7I+NIgHp4h7CvV3dNDBx+aPMLOpFieCiaWajkZm+PWr0CbbJK+tuODhkGSVw5PHIYTDgmHsVxIG5VJg/1FEs+djg+9SsXiOWo3pKMlUTI6FaEfSbmT+6ohIWc2Kr0mx3hdnsm27lRKSN8oazHbASAewHR0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AznXJufc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AznXJufc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF45DC4CED1;
	Wed, 19 Feb 2025 09:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957342;
	bh=h99fds2MaTiwVgc4ocVn+fbgyNdB+VFdJT6loanjCj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AznXJufcIEAivHMArxskWa7IAIBKFqsPBtZvEX901Zq+rZDxlW3MjDGSLUF4flzv4
	 raQ8k4MiKvLXkXxKKCaqbS/c7M2YXOoTIbQ06oQ1XfTD6DENDZbaXfrkwsmAMSDGsf
	 5gGjnVKS2Kez3G3tnwtGqeYZFCq33yYb1j2D83mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 450/578] net/ncsi: use dev_set_mac_address() for Get MC MAC Address handling
Date: Wed, 19 Feb 2025 09:27:34 +0100
Message-ID: <20250219082710.696175549@linuxfoundation.org>
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

From: Paul Fertser <fercerpav@gmail.com>

commit 05d91cdb1f9108426b14975ef4eeddf15875ca05 upstream.

Copy of the rationale from 790071347a0a1a89e618eedcd51c687ea783aeb3:

Change ndo_set_mac_address to dev_set_mac_address because
dev_set_mac_address provides a way to notify network layer about MAC
change. In other case, services may not aware about MAC change and keep
using old one which set from network adapter driver.

As example, DHCP client from systemd do not update MAC address without
notification from net subsystem which leads to the problem with acquiring
the right address from DHCP server.

Since dev_set_mac_address requires RTNL lock the operation can not be
performed directly in the response handler, see
9e2bbab94b88295dcc57c7580393c9ee08d7314d.

The way of selecting the first suitable MAC address from the list is
changed, instead of having the driver check it this patch just assumes
any valid MAC should be good.

Fixes: b8291cf3d118 ("net/ncsi: Add NC-SI 1.2 Get MC MAC Address command")
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-rsp.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1089,14 +1089,12 @@ static int ncsi_rsp_handler_netlink(stru
 static int ncsi_rsp_handler_gmcma(struct ncsi_request *nr)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
+	struct sockaddr *saddr = &ndp->pending_mac;
 	struct net_device *ndev = ndp->ndev.dev;
 	struct ncsi_rsp_gmcma_pkt *rsp;
-	struct sockaddr saddr;
-	int ret = -1;
 	int i;
 
 	rsp = (struct ncsi_rsp_gmcma_pkt *)skb_network_header(nr->rsp);
-	saddr.sa_family = ndev->type;
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	netdev_info(ndev, "NCSI: Received %d provisioned MAC addresses\n",
@@ -1108,20 +1106,20 @@ static int ncsi_rsp_handler_gmcma(struct
 			    rsp->addresses[i][4], rsp->addresses[i][5]);
 	}
 
+	saddr->sa_family = ndev->type;
 	for (i = 0; i < rsp->address_count; i++) {
-		memcpy(saddr.sa_data, &rsp->addresses[i], ETH_ALEN);
-		ret = ndev->netdev_ops->ndo_set_mac_address(ndev, &saddr);
-		if (ret < 0) {
+		if (!is_valid_ether_addr(rsp->addresses[i])) {
 			netdev_warn(ndev, "NCSI: Unable to assign %pM to device\n",
-				    saddr.sa_data);
+				    rsp->addresses[i]);
 			continue;
 		}
-		netdev_warn(ndev, "NCSI: Set MAC address to %pM\n", saddr.sa_data);
+		memcpy(saddr->sa_data, rsp->addresses[i], ETH_ALEN);
+		netdev_warn(ndev, "NCSI: Will set MAC address to %pM\n", saddr->sa_data);
 		break;
 	}
 
-	ndp->gma_flag = ret == 0;
-	return ret;
+	ndp->gma_flag = 1;
+	return 0;
 }
 
 static struct ncsi_rsp_handler {


