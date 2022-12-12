Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ABD28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74F9C433EF;
	Mon, 12 Dec 2022 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852845;
	bh=stlH3YwswwWR77+RahrJDDTxC592/yWstWgAgdWcPyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agt+4tieB5QxnyAXUiQKuaHkuOFMe0d7O5j39Nh2hk7EUS1cSjmX2Lwdn/bb0Dfma
	 9ibS/ztRW2Endkwj29DwuoAZzBzkWuiPG0GuwEAU3tqgY0omYjYE0XbO08KaX9ejiW
	 z0W6jTTsNqnenEPCipVhcAb/GAWztMFrG7LWiWmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 153/157] net: thunderbolt: fix memory leak in tbnet_open()
Date: Mon, 12 Dec 2022 14:18:21 +0100
Message-Id: <20221212130941.406350950@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit ed14e5903638f6eb868e3e2b4e610985e6a6c876 ]

When tb_ring_alloc_rx() failed in tbnet_open(), ida that allocated in
tb_xdomain_alloc_out_hopid() is not released. Add
tb_xdomain_release_out_hopid() to the error path to release ida.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20221207015001.1755826-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 8391f8303499..1f4dcadc284c 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -902,6 +902,7 @@ static int tbnet_open(struct net_device *dev)
 				tbnet_start_poll, net);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Rx ring\n");
+		tb_xdomain_release_out_hopid(xd, hopid);
 		tb_ring_free(net->tx_ring.ring);
 		net->tx_ring.ring = NULL;
 		return -ENOMEM;
-- 
2.35.1



