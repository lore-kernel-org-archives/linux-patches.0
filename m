Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159B919535
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B47AC433D2;
	Wed,  7 Jun 2023 20:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170356;
	bh=fus6kvoYf66Mlu0H8F9u+qdP27PGHhe707CwuCQQRYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/U7Gmz/6Zbu5RwBpyL5w7uICfweQp6cW8c8qsCxZejnhStTNzSPZtEMu7meJzDaO
	 IHHdNC/bmbs6yyqSzCU0jMHAf54KTX552hzwmXSBXtsfgw1Ax0k5+SNJPaVcEhkdOE
	 P8dbLVGDhiBCg9y/wWdLuSKtkwlL6kHhPqSkqE/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 052/225] rtnetlink: call validate_linkmsg in rtnl_create_link
Date: Wed,  7 Jun 2023 22:14:05 +0200
Message-ID: <20230607200916.062923753@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

commit b0ad3c179059089d809b477a1d445c1183a7b8fe upstream.

validate_linkmsg() was introduced by commit 1840bb13c22f5b ("[RTNL]:
Validate hardware and broadcast address attribute for RTM_NEWLINK")
to validate tb[IFLA_ADDRESS/BROADCAST] for existing links. The same
check should also be done for newly created links.

This patch adds validate_linkmsg() call in rtnl_create_link(), to
avoid the invalid address set when creating some devices like:

  # ip link add dummy0 type dummy
  # ip link add link dummy0 name mac0 address 01:02 type macsec

Fixes: 0e06877c6fdb ("[RTNETLINK]: rtnl_link: allow specifying initial device address")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3212,6 +3212,7 @@ struct net_device *rtnl_create_link(stru
 	struct net_device *dev;
 	unsigned int num_tx_queues = 1;
 	unsigned int num_rx_queues = 1;
+	int err;
 
 	if (tb[IFLA_NUM_TX_QUEUES])
 		num_tx_queues = nla_get_u32(tb[IFLA_NUM_TX_QUEUES]);
@@ -3247,13 +3248,18 @@ struct net_device *rtnl_create_link(stru
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	err = validate_linkmsg(dev, tb, extack);
+	if (err < 0) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
+
 	dev_net_set(dev, net);
 	dev->rtnl_link_ops = ops;
 	dev->rtnl_link_state = RTNL_LINK_INITIALIZING;
 
 	if (tb[IFLA_MTU]) {
 		u32 mtu = nla_get_u32(tb[IFLA_MTU]);
-		int err;
 
 		err = dev_validate_mtu(dev, mtu, extack);
 		if (err) {


