Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DCD3B19D1;
	Mon,  4 May 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903843; cv=none; b=nBe1ZINAWXDctqQ2ncyf5uOaFGRHS8XH/9nEXPJsvhpvLrc4Pf2Te0ICX5Gt3ejGE67IDmpxWhvXheKA3Lc/AxzllEfF55ffLQ33Yo0O6n+Z6dLqaCWJ2PB8XzyqRDwKe6TK/GHnRmE/HXRkEMxyIWhbC64jHyogLU2nvWEwzbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903843; c=relaxed/simple;
	bh=Fv3vBVXaowcYQnXStOR2PboPv6emZb4tZ1bwRrMj27g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cMRjwiZePgjOO8jSieZS9aq7AP9OMHsaSrUy4IX6SOlCOfp41j0hZhwlN28BLdied+XhDqV4V15aNJO+0AACIfjTRFGjW0I+4XG3TlMNbYQNtKXwZa2i5fwakJkUlMe+HWKhqaRJSbJJHDDnmyVVnjzSXQI7lTO6/CyqWW92Cww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jx3CdrSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jx3CdrSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C2AC2BCB8;
	Mon,  4 May 2026 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903843;
	bh=Fv3vBVXaowcYQnXStOR2PboPv6emZb4tZ1bwRrMj27g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jx3CdrSzDkS8uP2qumuSztw/6Ttsd7Ko4gh0w7fa7p4sJw2W+7kfIkH57fPK6lDp2
	 YyQXuoUqjx1rK+Q8PZng0qnfBDB4VcCbI7HquUMR1+3ipES06xi9ReXnAar98NcXV9
	 Sd+Dvb/IIyP1gkgjjINyuCfuOexPpfPzaahb7m5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.18 082/275] RDMA/mana_ib: Disable RX steering on RSS QP destroy
Date: Mon,  4 May 2026 15:50:22 +0200
Message-ID: <20260504135145.971029856@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit dbeb256e8dd87233d891b170c0b32a6466467036 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c               |   15 +++++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c |   11 ++++++++++-
 include/net/mana/mana.h                       |    1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -823,6 +823,21 @@ static int mana_ib_destroy_qp_rss(struct
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
@@ -2766,6 +2766,13 @@ static void mana_rss_table_init(struct m
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+int mana_disable_vport_rx(struct mana_port_context *apc)
+{
+	return mana_cfg_vport_steering(apc, TRI_STATE_FALSE, false, false,
+				       false);
+}
+EXPORT_SYMBOL_NS(mana_disable_vport_rx, "NET_MANA");
+
 int mana_config_rss(struct mana_port_context *apc, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab)
 {
@@ -3150,10 +3157,12 @@ static int mana_dealloc_queues(struct ne
 	 */
 
 	apc->rss_state = TRI_STATE_FALSE;
-	err = mana_config_rss(apc, TRI_STATE_FALSE, false, false);
+	err = mana_disable_vport_rx(apc);
 	if (err && mana_en_need_log(apc, err))
 		netdev_err(ndev, "Failed to disable vPort: %d\n", err);
 
+	mana_fence_rqs(apc);
+
 	/* Even in err case, still need to cleanup the vPort */
 	mana_destroy_vport(apc);
 
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -554,6 +554,7 @@ struct mana_port_context {
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
+int mana_disable_vport_rx(struct mana_port_context *apc);
 
 int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);


