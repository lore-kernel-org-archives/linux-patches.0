Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A54210184;
	Tue, 12 Nov 2024 10:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406987; cv=none; b=VP1tDIFmcc8NXEIoFrGt4n8XXBfW95VOjky6JZ2f4DnNfJqg6+2alC9E5qKIs8j5hvBinFGBHTWiTUksfiUGRQJBdu/3a8ytgw4304SNnMFprlmlewz249JMuxpBXA9TIh+m2qtHbWltL8lOFQFwh5Bb3UcBf+LVms3vkXH0eXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406987; c=relaxed/simple;
	bh=CMfq7SW5dsLqWt0mjoT1k96hfe1/eg0N5I6cXqbxrco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b43OEOFL39OPaN5mG7lI825LoIh+mTDVPFniyX1leD+PM21s5H5XyROr9KpcmSTIL+jiX5aU9WzIqjSG/b5pr6Riqjf0DpMu3Wi7t7TFUWg3wXLMNjU6ZiqemeFVLfIj4Vh91bb/DsNwNRfH8U1UMvKomIiHnsJZ1+nN9WQGu/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzSgSbMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzSgSbMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD47C4CECD;
	Tue, 12 Nov 2024 10:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731406986;
	bh=CMfq7SW5dsLqWt0mjoT1k96hfe1/eg0N5I6cXqbxrco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzSgSbMtgCOxyJs1asRhDTtu9mS5IdHL8I72ZiHOl+BkqQxzijPwqHn7rXHNTa/Zz
	 aZEXz0bj2vOPHHT+V1MyCeEaBmsuKjhTZjsYQkbr5nHaGYeVeiYnaKPGR6qEQQzMv2
	 ZYygOknBp2T/z/hCJ+y12I7ElUquzUwqrQyp3fKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/76] net: enetc: set MAC address to the VF net_device
Date: Tue, 12 Nov 2024 11:20:42 +0100
Message-ID: <20241112101840.438861381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit badccd49b93bb945bf4e5cc8707db67cdc5e27e5 ]

The MAC address of VF can be configured through the mailbox mechanism of
ENETC, but the previous implementation forgot to set the MAC address in
net_device, resulting in the SMAC of the sent frames still being the old
MAC address. Since the MAC address in the hardware has been changed, Rx
cannot receive frames with the DMAC address as the new MAC address. The
most obvious phenomenon is that after changing the MAC address, we can
see that the MAC address of eno0vf0 has not changed through the "ifconfig
eno0vf0" command and the IP address cannot be obtained .

root@ls1028ardb:~# ifconfig eno0vf0 down
root@ls1028ardb:~# ifconfig eno0vf0 hw ether 00:04:9f:3a:4d:56 up
root@ls1028ardb:~# ifconfig eno0vf0
eno0vf0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 66:36:2c:3b:87:76  txqueuelen 1000  (Ethernet)
        RX packets 794  bytes 69239 (69.2 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 2226 (2.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Fixes: beb74ac878c8 ("enetc: Add vf to pf messaging support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20241029090406.841836-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index acd4a3167ed6a..88dfcebf2b873 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -78,11 +78,18 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct sockaddr *saddr = addr;
+	int err;
 
 	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	return enetc_msg_vsi_set_primary_mac_addr(priv, saddr);
+	err = enetc_msg_vsi_set_primary_mac_addr(priv, saddr);
+	if (err)
+		return err;
+
+	eth_hw_addr_set(ndev, saddr->sa_data);
+
+	return 0;
 }
 
 static int enetc_vf_set_features(struct net_device *ndev,
-- 
2.43.0



