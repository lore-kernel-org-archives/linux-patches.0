Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE15417A5A4;
	Mon, 23 Dec 2024 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969854; cv=none; b=YAaxItwoRqTfSkNTqJLRtJW2sWgCjejRRCrb+Yhad7WgwjOfEUDuV3n0eANcS/5VY3JT2VH2NR7L2fcAhgtPIPv8iL+eD8f0P1JU9iDAFXekH3g0wfI5hPa60xHkhr95jzd9iBQw+ZPq7tN1+RGLyrGyiNW918kEKvIULxXK5Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969854; c=relaxed/simple;
	bh=A8wnwEOch3UngFRKmblDYPgQHvkRI1dxpZxoJsyI5zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9fd+a5CM2GFN9EzcR2vtkWT1VgaPt4omLIxEWo584qRlQ6qW/1f7Dr2mkCdoFWXZf/nqN/LjpE9fxUSH3/tTOmUvD44hxyv1abFc6oeUoRFQ01Id5OpoWqSCROfbwLCHnMdwg2R3IcnCqH69k2LLuZyVqF1TQiqfMWaVZnQDrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAZh5JgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAZh5JgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D15EC4CED3;
	Mon, 23 Dec 2024 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969854;
	bh=A8wnwEOch3UngFRKmblDYPgQHvkRI1dxpZxoJsyI5zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAZh5JgNB/ofq2Oq/HB9lbul8yPqpril1HS8YHOXWAfYw4eKJwOAUuZTf8ApPiIiA
	 gvAEIGmWUnPSp97hvHRGfXidxU6ed/JDoBVqwEQyt/vb5IN4xqE0hoLlkNk0e+KAdj
	 k35vTHYLogo1koqliQINF62l515QPuZlJi2do+B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/160] netdev: fix repeated netlink messages in queue dump
Date: Mon, 23 Dec 2024 16:57:37 +0100
Message-ID: <20241223155410.455879601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b1f3a2f5a742c1e939a73031bd31b9e557a2d77d ]

The context is supposed to record the next queue to dump,
not last dumped. If the dump doesn't fit we will restart
from the already-dumped queue, duplicating the message.

Before this fix and with the selftest improvements later
in this series we see:

  # ./run_kselftest.sh -t drivers/net:queues.py
  timeout set to 45
  selftests: drivers/net: queues.py
  KTAP version 1
  1..2
  # Check| At /root/ksft-net-drv/drivers/net/./queues.py, line 32, in get_queues:
  # Check|     ksft_eq(queues, expected)
  # Check failed 102 != 100
  # Check| At /root/ksft-net-drv/drivers/net/./queues.py, line 32, in get_queues:
  # Check|     ksft_eq(queues, expected)
  # Check failed 101 != 100
  not ok 1 queues.get_queues
  ok 2 queues.addremove_queues
  # Totals: pass:1 fail:1 xfail:0 xpass:0 skip:0 error:0
  not ok 1 selftests: drivers/net: queues.py # exit=1

With the fix:

  # ./ksft-net-drv/run_kselftest.sh -t drivers/net:queues.py
  timeout set to 45
  selftests: drivers/net: queues.py
  KTAP version 1
  1..2
  ok 1 queues.get_queues
  ok 2 queues.addremove_queues
  # Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0

Fixes: 6b6171db7fc8 ("netdev-genl: Add netlink framework functions for queue")
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241213152244.3080955-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index d2baa1af9df0..71359922ae8b 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -417,24 +417,21 @@ netdev_nl_queue_dump_one(struct net_device *netdev, struct sk_buff *rsp,
 			 struct netdev_nl_dump_ctx *ctx)
 {
 	int err = 0;
-	int i;
 
 	if (!(netdev->flags & IFF_UP))
 		return err;
 
-	for (i = ctx->rxq_idx; i < netdev->real_num_rx_queues;) {
-		err = netdev_nl_queue_fill_one(rsp, netdev, i,
+	for (; ctx->rxq_idx < netdev->real_num_rx_queues; ctx->rxq_idx++) {
+		err = netdev_nl_queue_fill_one(rsp, netdev, ctx->rxq_idx,
 					       NETDEV_QUEUE_TYPE_RX, info);
 		if (err)
 			return err;
-		ctx->rxq_idx = i++;
 	}
-	for (i = ctx->txq_idx; i < netdev->real_num_tx_queues;) {
-		err = netdev_nl_queue_fill_one(rsp, netdev, i,
+	for (; ctx->txq_idx < netdev->real_num_tx_queues; ctx->txq_idx++) {
+		err = netdev_nl_queue_fill_one(rsp, netdev, ctx->txq_idx,
 					       NETDEV_QUEUE_TYPE_TX, info);
 		if (err)
 			return err;
-		ctx->txq_idx = i++;
 	}
 
 	return err;
-- 
2.39.5



