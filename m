Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6363E00BB;
	Fri, 15 May 2026 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861699; cv=none; b=twxHNYwRTlj72x/ta38Q6Ak2wd0EftXfT/zPh0Q7HV/a7+m1zuKoZQ/3bppC76VurgHWoj8ZRBbVBoekKKA1X09LNj2M7yfymuo235iUukfmO0iuv/zgGEmC4h4DXjlNdjbGk8icPJt7oeB17m6Fc7vGGl8a8q6CdGXzJKKTpJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861699; c=relaxed/simple;
	bh=Cr47Bp7537D/N2idiw1NigfNmEzaCiTjZpe7YNzibD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nlhMCmI5Y4GBxSzfkLrtyJ3FlQAy0yJ7yAx72JsAqK+9mLGK2G4XeJBXYiQCtof7f7K6QKI4YiJ31vyTG74PDCI9wTHQyqX9g64Cx2+WfRpT5juqrPt8k6mDNT4y38sj4MdyFdu1OEv8xY9HpvPrISPnazHodjqqcyWO0V/3Gis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OReuD0YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OReuD0YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFCFC2BCC9;
	Fri, 15 May 2026 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861698;
	bh=Cr47Bp7537D/N2idiw1NigfNmEzaCiTjZpe7YNzibD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OReuD0YCOGuU4qAQ6lxWhfDE7rC2lgnWBVmnN5wtpgzikQpKSl2w3T7OtBEaomhGM
	 3UvOAVwTayKeM2mPGLO634dU/+ZfHswRgAH2nZez66TXPJja0o/gwqqoJUNs5Jt0rT
	 s1AWEa7FuK6p2Ikn2RwM2d7dbBYUgfESRzUN6oFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 387/474] RDMA/mana_ib: Disable RX steering on RSS QP destroy
Date: Fri, 15 May 2026 17:48:16 +0200
Message-ID: <20260515154723.413716067@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -449,6 +449,21 @@ static int mana_ib_destroy_qp_rss(struct
 	ndev = mc->ports[qp->port - 1];
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
@@ -2380,6 +2380,13 @@ static void mana_rss_table_init(struct m
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
@@ -2620,12 +2627,14 @@ static int mana_dealloc_queues(struct ne
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
@@ -437,6 +437,7 @@ struct mana_port_context {
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
+int mana_disable_vport_rx(struct mana_port_context *apc);
 
 int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);


