Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E02C1DB34C;
	Tue, 27 May 2025 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366926; cv=none; b=mOoK0fCeOOXT8pDsnpspJSwnU2GrLgx19K5xF+BdXp59DKlVX5qBnWoQTCKbVyezvEKTduS7TBTHfJ0NMYI342tnYDH/J5EjyOCdWoCMXdpXA8ZFJBH0U4eETxJzDcWwZWeI4mBM8sM3zGy+ricn79ceLSOwM6ykU/XYeE5YBkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366926; c=relaxed/simple;
	bh=MMFpDHr3Sf3nyAUKXDf63CnRRYY7zAwtVpV1V2G7V6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJTj3NrwkgxGoNEm9hxUmx7mqeggnBgJ+bWC06C9KbjjpH/yB2O6ML4nz7PNDcyXvOmcTVJDf/MEHDOab+5a8cu1TJQs9qYgIWnwHKrGJzuzR2PY7JjulCCD42lwcna70HJnV/lppZPxo+69xKiUJOeX5OeJV57XACGYPirwtQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KeSmj1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KeSmj1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1330C4CEE9;
	Tue, 27 May 2025 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366926;
	bh=MMFpDHr3Sf3nyAUKXDf63CnRRYY7zAwtVpV1V2G7V6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KeSmj1V7+NsfRmz0LrHJNVFhfXR9ZXjLHExrcIW1stRY/bSKt6q2XVIOuIWbp3Z3
	 GQAwbe/dxdefgtP+bUHKMT6k5g/NfkjiimcmFSUF85XLYhXhqiAqu8U4kQbOm9egJx
	 2CA9wkG0e79N8rf/rVAnhai6ADhRUBgid5FHiKyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 181/783] net/smc: use the correct ndev to find pnetid by pnetid table
Date: Tue, 27 May 2025 18:19:38 +0200
Message-ID: <20250527162520.528385590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit bfc6c67ec2d64d0ca4e5cc3e1ac84298a10b8d62 ]

When using smc_pnet in SMC, it will only search the pnetid in the
base_ndev of the netdev hierarchy(both HW PNETID and User-defined
sw pnetid). This may not work for some scenarios when using SMC in
container on cloud environment.
In container, there have choices of different container network,
such as directly using host network, virtual network IPVLAN, veth,
etc. Different choices of container network have different netdev
hierarchy. Examples of netdev hierarchy show below. (eth0 and eth1
in host below is the netdev directly related to the physical device).
            _______________________________
           |   _________________           |
           |  |POD              |          |
           |  |                 |          |
           |  | eth0_________   |          |
           |  |____|         |__|          |
           |       |         |             |
           |       |         |             |
           |   eth1|base_ndev| eth0_______ |
           |       |         |    | RDMA  ||
           | host  |_________|    |_______||
           ---------------------------------
     netdev hierarchy if directly using host network
           ________________________________
           |   _________________           |
           |  |POD  __________  |          |
           |  |    |upper_ndev| |          |
           |  |eth0|__________| |          |
           |  |_______|_________|          |
           |          |lower netdev        |
           |        __|______              |
           |   eth1|         | eth0_______ |
           |       |base_ndev|    | RDMA  ||
           | host  |_________|    |_______||
           ---------------------------------
            netdev hierarchy if using IPVLAN
            _______________________________
           |   _____________________       |
           |  |POD        _________ |      |
           |  |          |base_ndev||      |
           |  |eth0(veth)|_________||      |
           |  |____________|________|      |
           |               |pairs          |
           |        _______|_              |
           |       |         | eth0_______ |
           |   veth|base_ndev|    | RDMA  ||
           |       |_________|    |_______||
           |        _________              |
           |   eth1|base_ndev|             |
           | host  |_________|             |
           ---------------------------------
             netdev hierarchy if using veth
Due to some reasons, the eth1 in host is not RDMA attached netdevice,
pnetid is needed to map the eth1(in host) with RDMA device so that POD
can do SMC-R. Because the eth1(in host) is managed by CNI plugin(such
as Terway, network management plugin in container environment), and in
cloud environment the eth(in host) can dynamically be inserted by CNI
when POD create and dynamically be removed by CNI when POD destroy and
no POD related to the eth(in host) anymore. It is hard to config the
pnetid to the eth1(in host). But it is easy to config the pnetid to the
netdevice which can be seen in POD. When do SMC-R, both the container
directly using host network and the container using veth network can
successfully match the RDMA device, because the configured pnetid netdev
is a base_ndev. But the container using IPVLAN can not successfully
match the RDMA device and 0x03030000 fallback happens, because the
configured pnetid netdev is not a base_ndev. Additionally, if config
pnetid to the eth1(in host) also can not work for matching RDMA device
when using veth network and doing SMC-R in POD.

To resolve the problems list above, this patch extends to search user
-defined sw pnetid in the clc handshake ndev when no pnetid can be found
in the base_ndev, and the base_ndev take precedence over ndev for backward
compatibility. This patch also can unify the pnetid setup of different
network choices list above in container(Config user-defined sw pnetid in
the netdevice can be seen in POD).

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_pnet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 716808f374a8d..b391c2ef463f2 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -1079,14 +1079,16 @@ static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
 					 struct smc_init_info *ini)
 {
 	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
+	struct net_device *base_ndev;
 	struct net *net;
 
-	ndev = pnet_find_base_ndev(ndev);
+	base_ndev = pnet_find_base_ndev(ndev);
 	net = dev_net(ndev);
-	if (smc_pnetid_by_dev_port(ndev->dev.parent, ndev->dev_port,
+	if (smc_pnetid_by_dev_port(base_ndev->dev.parent, base_ndev->dev_port,
 				   ndev_pnetid) &&
+	    smc_pnet_find_ndev_pnetid_by_table(base_ndev, ndev_pnetid) &&
 	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid)) {
-		smc_pnet_find_rdma_dev(ndev, ini);
+		smc_pnet_find_rdma_dev(base_ndev, ini);
 		return; /* pnetid could not be determined */
 	}
 	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini, NULL, net);
-- 
2.39.5



