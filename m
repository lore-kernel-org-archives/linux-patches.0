Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3218B3DE455;
	Mon,  4 May 2026 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904838; cv=none; b=HaEGD097ETm+mZs6oWqHmO2Co4mgIX3+YlICexI6iJOt52m1iBU3D9IYYK9VX35+KhAs3W22r18DkOVAMav0z9hvoyhHRs/Mmyt05GD0jIDE4SnmAKIDGDOClZRz1zB21AVjQdaEf3BOj7ugc2mTIGgc/44MdsptuINOgJYKNyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904838; c=relaxed/simple;
	bh=OOsXTCSLyrR75eAGyRmb0aZhIxEY8JJQIRG4PXx+xUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjS+5eZ6GL1YTCp5/pUtDnStZQs9Y47eaae3chyJXCX6OR0m0v1vUkjAyE4X/0Qa3tg6wi1/wW+tSr3iRe8dOkS4nlNdb9sHBg4Cu5oWqrNkd8/A5iaKfOvHOcI9U//Zb4fDDUPvYRp/O6aUqpEp46o+B1nZIu9/JSdCzmOAR0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p31mgqWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p31mgqWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72410C2BCB8;
	Mon,  4 May 2026 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904837;
	bh=OOsXTCSLyrR75eAGyRmb0aZhIxEY8JJQIRG4PXx+xUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p31mgqWhKKnswyD4ZPkT+ZyQuq4U3Q7xgNWDzO+RMvo2A3928S+8vmfbbsux4f1cs
	 aae9iFN8jq0nTP3zi208OktP0FkyGhTC1rhWT81zQ3W0mRyN8KjOFbG0D+O3uSpP9X
	 GydCIvTJREQqkpuUj7ipASvdRgBh4tiJQ/hZxP00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/215] RDMA/mana_ib: Disable RX steering on RSS QP destroy
Date: Mon,  4 May 2026 15:53:32 +0200
Message-ID: <20260504135137.478112460@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit dbeb256e8dd87233d891b170c0b32a6466467036 ]

When an RSS QP is destroyed (e.g. DPDK exit), mana_ib_destroy_qp_rss()
destroys the RX WQ objects but does not disable vPort RX steering in
firmware. This leaves stale steering configuration that still points to
the destroyed RX objects.

If traffic continues to arrive (e.g. peer VM is still transmitting) and
the VF interface is subsequently brought up (mana_open), the firmware
may deliver completions using stale CQ IDs from the old RX objects.
These CQ IDs can be reused by the ethernet driver for new TX CQs,
causing RX completions to land on TX CQs:

  WARNING: mana_poll_tx_cq+0x1b8/0x220 [mana]  (is_sq == false)
  WARNING: mana_gd_process_eq_events+0x209/0x290 (cq_table lookup fails)

Fix this by disabling vPort RX steering before destroying RX WQ objects.
Note that mana_fence_rqs() cannot be used here because the fence
completion is delivered on the CQ, which is polled by user-mode (e.g.
DPDK) and not visible to the kernel driver.

Refactor the disable logic into a shared mana_disable_vport_rx() in
mana_en, exported for use by mana_ib, replacing the duplicate code.
The ethernet driver's mana_dealloc_queues() is also updated to call
this common function.

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Cc: stable@vger.kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/20260325194100.1929056-1-longli@microsoft.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ kept early-return error handling and used unquoted NET_MANA namespace in EXPORT_SYMBOL_NS ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c               |   15 +++++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c |   11 ++++++++++-
 include/net/mana/mana.h                       |    1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -601,6 +601,21 @@ static int mana_ib_destroy_qp_rss(struct
 	ndev = mana_ib_get_netdev(qp->ibqp.device, qp->port);
 	mpc = netdev_priv(ndev);
 
+	/* Disable vPort RX steering before destroying RX WQ objects.
+	 * Otherwise firmware still routes traffic to the destroyed queues,
+	 * which can cause bogus completions on reused CQ IDs when the
+	 * ethernet driver later creates new queues on mana_open().
+	 *
+	 * Unlike the ethernet teardown path, mana_fence_rqs() cannot be
+	 * used here because the fence completion CQE is delivered on the
+	 * CQ which is polled by userspace (e.g. DPDK), so there is no way
+	 * for the kernel to wait for fence completion.
+	 *
+	 * This is best effort — if it fails there is not much we can do,
+	 * and mana_cfg_vport_steering() already logs the error.
+	 */
+	mana_disable_vport_rx(mpc);
+
 	for (i = 0; i < (1 << ind_tbl->log_ind_tbl_size); i++) {
 		ibwq = ind_tbl->ind_tbl[i];
 		wq = container_of(ibwq, struct mana_ib_wq, ibwq);
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2392,6 +2392,13 @@ static void mana_rss_table_init(struct m
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+int mana_disable_vport_rx(struct mana_port_context *apc)
+{
+	return mana_cfg_vport_steering(apc, TRI_STATE_FALSE, false, false,
+				       false);
+}
+EXPORT_SYMBOL_NS(mana_disable_vport_rx, NET_MANA);
+
 int mana_config_rss(struct mana_port_context *apc, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab)
 {
@@ -2676,12 +2683,14 @@ static int mana_dealloc_queues(struct ne
 	 */
 
 	apc->rss_state = TRI_STATE_FALSE;
-	err = mana_config_rss(apc, TRI_STATE_FALSE, false, false);
+	err = mana_disable_vport_rx(apc);
 	if (err) {
 		netdev_err(ndev, "Failed to disable vPort: %d\n", err);
 		return err;
 	}
 
+	mana_fence_rqs(apc);
+
 	mana_destroy_vport(apc);
 
 	return 0;
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -473,6 +473,7 @@ struct mana_port_context {
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
+int mana_disable_vport_rx(struct mana_port_context *apc);
 
 int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);


