Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C061DDDB
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13413C433C7;
	Fri, 21 Jul 2023 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955726;
	bh=HOHt3h1k6j4IvmVeEXjr5UPiomF3r1nFxGNIIV+CHsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqlpOw09khxerJbM/Gyag4IX7/7ihjkiKhprR40S6d0YfR81cI802xYNuv+4HJQ6g
	 Jp4DLsl6JNclkpcJ9aw7tW3gbcOQOA6IZbtBXP76KyNkUpJzx/yyU2jDaMnQBO5WiK
	 t+K7fIZXorKuAgVxQO9ymDykN5tDwyBA770wMY+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 001/292] net/ncsi: change from ndo_set_mac_address to dev_set_mac_address
Date: Fri, 21 Jul 2023 18:01:50 +0200
Message-ID: <20230721160528.868026240@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Mikhaylov <fr0st61te@gmail.com>

commit 790071347a0a1a89e618eedcd51c687ea783aeb3 upstream.

Change ndo_set_mac_address to dev_set_mac_address because
dev_set_mac_address provides a way to notify network layer about MAC
change. In other case, services may not aware about MAC change and keep
using old one which set from network adapter driver.

As example, DHCP client from systemd do not update MAC address without
notification from net subsystem which leads to the problem with acquiring
the right address from DHCP server.

Fixes: cb10c7c0dfd9e ("net/ncsi: Add NCSI Broadcom OEM command")
Cc: stable@vger.kernel.org # v6.0+ 2f38e84 net/ncsi: make one oem_gma function for all mfr id
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-rsp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -616,7 +616,6 @@ static int ncsi_rsp_handler_oem_mlx_gma(
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct net_device *ndev = ndp->ndev.dev;
-	const struct net_device_ops *ops = ndev->netdev_ops;
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
 	int ret = 0;
@@ -630,7 +629,9 @@ static int ncsi_rsp_handler_oem_mlx_gma(
 	/* Set the flag for GMA command which should only be called once */
 	ndp->gma_flag = 1;
 
-	ret = ops->ndo_set_mac_address(ndev, &saddr);
+	rtnl_lock();
+	ret = dev_set_mac_address(ndev, &saddr, NULL);
+	rtnl_unlock();
 	if (ret < 0)
 		netdev_warn(ndev, "NCSI: 'Writing mac address to device failed\n");
 


