Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0628634E;
	Wed,  5 Feb 2025 14:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765490; cv=none; b=o1gqk6G9kn9ciDJRkCKy5x4z4sqUTIRz5QDwjCGDBIke/WWVtWUxn1b5QOMKv+tSH3Rr7fZkXn1POlH1WgB3XOIYy9lvVPeCOqiLXNrPpYak2RxaWvUCpQ3q4D/ZgyordnYrAprd+gKOzHYLlMWz94sOoDi4Szo5C9u7QagX9q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765490; c=relaxed/simple;
	bh=KLVNfbjW8JJrPmXi9P7ma4NcXd427AqCDkfpp4JmIBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkXQX1U8BHyPinTfBd8WR3iUQdlh4yAYs+hmHhB/hb/W5Oq+ZZr7t1j1hjzOMTPXlaFuXBL+gBiNkkWxt91vt/fhwPeHBWgZLTNeKq+UBD0/Zo+vX8vmnEQK8KVrk5XGonGXflKG6fwo+cD9fdqLGDvJeDdT+Zm7ZMflhaLbk+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDk5NF5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDk5NF5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13157C4CED1;
	Wed,  5 Feb 2025 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765490;
	bh=KLVNfbjW8JJrPmXi9P7ma4NcXd427AqCDkfpp4JmIBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDk5NF5PjG+RX92xIHHRkttDTIkvJnCN/wlLi2tpuGB+6xW4BrUKuI3KJ4XEG1I6R
	 Wd6LPWo4mHKqm4tJBgnf3yJUndn5iaDP9wvlQgqt02+QdCCfOt3vK28WumO0aLqtPN
	 xoNQDEzFqQkx9RmrszneNmrJqO/FE1CAYmrEO/F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinas Rasheed <srasheed@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/590] octeon_ep: remove firmware stats fetch in ndo_get_stats64
Date: Wed,  5 Feb 2025 14:39:39 +0100
Message-ID: <20250205134503.855926677@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Shinas Rasheed <srasheed@marvell.com>

[ Upstream commit 1f64255bb76c11d0c41a7d81d7cec68e49d5362d ]

The firmware stats fetch call that happens in ndo_get_stats64()
is currently not required, and causes a warning to issue.

The warn log is given below:

[  123.316837] ------------[ cut here ]------------
[  123.316840] Voluntary context switch within RCU read-side critical section!
[  123.316917] pc : rcu_note_context_switch+0x2e4/0x300
[  123.316919] lr : rcu_note_context_switch+0x2e4/0x300
[  123.316947] Call trace:
[  123.316949]  rcu_note_context_switch+0x2e4/0x300
[  123.316952]  __schedule+0x84/0x584
[  123.316955]  schedule+0x38/0x90
[  123.316956]  schedule_timeout+0xa0/0x1d4
[  123.316959]  octep_send_mbox_req+0x190/0x230 [octeon_ep]
[  123.316966]  octep_ctrl_net_get_if_stats+0x78/0x100 [octeon_ep]
[  123.316970]  octep_get_stats64+0xd4/0xf0 [octeon_ep]
[  123.316975]  dev_get_stats+0x4c/0x114
[  123.316977]  dev_seq_printf_stats+0x3c/0x11c
[  123.316980]  dev_seq_show+0x1c/0x40
[  123.316982]  seq_read_iter+0x3cc/0x4e0
[  123.316985]  seq_read+0xc8/0x110
[  123.316987]  proc_reg_read+0x9c/0xec
[  123.316990]  vfs_read+0xc8/0x2ec
[  123.316993]  ksys_read+0x70/0x100
[  123.316995]  __arm64_sys_read+0x20/0x30
[  123.316997]  invoke_syscall.constprop.0+0x7c/0xd0
[  123.317000]  do_el0_svc+0xb4/0xd0
[  123.317002]  el0_svc+0xe8/0x1f4
[  123.317005]  el0t_64_sync_handler+0x134/0x150
[  123.317006]  el0t_64_sync+0x17c/0x180
[  123.317008] ---[ end trace 63399811432ab69b ]---

Fixes: 6a610a46bad1 ("octeon_ep: add support for ndo ops")
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Link: https://patch.msgid.link/20250117094653.2588578-2-srasheed@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 549436efc2048..730aa5632ccee 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -995,12 +995,6 @@ static void octep_get_stats64(struct net_device *netdev,
 	struct octep_device *oct = netdev_priv(netdev);
 	int q;
 
-	if (netif_running(netdev))
-		octep_ctrl_net_get_if_stats(oct,
-					    OCTEP_CTRL_NET_INVALID_VFID,
-					    &oct->iface_rx_stats,
-					    &oct->iface_tx_stats);
-
 	tx_packets = 0;
 	tx_bytes = 0;
 	rx_packets = 0;
@@ -1018,10 +1012,6 @@ static void octep_get_stats64(struct net_device *netdev,
 	stats->tx_bytes = tx_bytes;
 	stats->rx_packets = rx_packets;
 	stats->rx_bytes = rx_bytes;
-	stats->multicast = oct->iface_rx_stats.mcast_pkts;
-	stats->rx_errors = oct->iface_rx_stats.err_pkts;
-	stats->collisions = oct->iface_tx_stats.xscol;
-	stats->tx_fifo_errors = oct->iface_tx_stats.undflw;
 }
 
 /**
-- 
2.39.5



