Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA31C433C1;
	Wed, 30 Nov 2022 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833412;
	bh=WWLO71QKS9Ajryf19r7Vm3Y0ptJxOhkJbniFxsUuhrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tbADbOnaR9bm6+/sx3Ppo9iN7YV7vjcdGoXm9DOZC9su1QQ57ACDm/bKdTOKtI2i
	 dPAvQhgYb0Ziq5tyPHG2bzI4EscWznci5oI2krDyeJzWqV5eTMcoZNyotPj2WTfugC
	 cVDxIe4FMVQBpvzRl1aUU/t+xlWytMGrJNx3dtlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaco Coetzee <jaco.coetzee@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/206] nfp: add port from netdev validation for EEPROM access
Date: Wed, 30 Nov 2022 19:22:28 +0100
Message-Id: <20221130180535.474631631@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaco Coetzee <jaco.coetzee@corigine.com>

[ Upstream commit 0873016d46f6dfafd1bdf4d9b935b3331b226f7c ]

Setting of the port flag `NFP_PORT_CHANGED`, introduced
to ensure the correct reading of EEPROM data, causes a
fatal kernel NULL pointer dereference in cases where
the target netdev type cannot be determined.

Add validation of port struct pointer before attempting
to set the `NFP_PORT_CHANGED` flag. Return that operation
is not supported if the netdev type cannot be determined.

Fixes: 4ae97cae07e1 ("nfp: ethtool: fix the display error of `ethtool -m DEVNAME`")
Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 865865adfefc..d295942968f3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1219,6 +1219,9 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
 	/* update port state to get latest interface */
 	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
-- 
2.35.1



