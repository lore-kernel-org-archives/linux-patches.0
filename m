Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2CA1C824B;
	Tue, 27 Aug 2024 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770494; cv=none; b=NxvcsitDIrHSLZANuzdQ9DTzBosjFPjuZowg80ZLAF9kkuwZdf9t/6KoWTgiSyEhBTPeJ8X4McND7UpRfC4HAe4eDxBHli9sP/yrn7ou2aawg5xRVKpF6bh0wD9rXAdMN+TbGNC4sGzIJGd7daXcnqIuF2+kWuQ0R1K+Ilk1Z2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770494; c=relaxed/simple;
	bh=ynMOs2l1fvTBrQAxSrbZvq53pgvtTm9giNhH6qkak6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7fThpKT6UV9X/JrN/TNaxaQCIK/aWXC/JNYC3UUqDBddTX6Bx/9H8qoFlu+ePOYikyC863PQhL00XeQ2s1cKMFaL7UB9S4eAuWeyuiyyRi53aOOP9CxiK4fnfhCpN5K5pQM3gT5ePlk+qwfFCmoWtMVmjtg4KVUqzzq8EJKTL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mqtEODs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mqtEODs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF50BC4E691;
	Tue, 27 Aug 2024 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770494;
	bh=ynMOs2l1fvTBrQAxSrbZvq53pgvtTm9giNhH6qkak6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mqtEODsVfLgt6eu5jnPM7G9nNTn3Td+T6n53m5+wczZb3SvKLhuPO9dN7QuDW5LO
	 bNyKG8Jbq7VQPN4b+9IOapA8mmJohA1AaRXbn5OMAfx7/fbaBCOOB1wSloJp92yB3/
	 92y70mvG+MuWVdzi9/h6eQPJE6DWLJ2iGF+5HG+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/341] net: mscc: ocelot: serialize access to the injection/extraction groups
Date: Tue, 27 Aug 2024 16:37:56 +0200
Message-ID: <20240827143852.731731335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c5e12ac3beb0dd3a718296b2d8af5528e9ab728e ]

As explained by Horatiu Vultur in commit 603ead96582d ("net: sparx5: Add
spinlock for frame transmission from CPU") which is for a similar
hardware design, multiple CPUs can simultaneously perform injection
or extraction. There are only 2 register groups for injection and 2
for extraction, and the driver only uses one of each. So we'd better
serialize access using spin locks, otherwise frame corruption is
possible.

Note that unlike in sparx5, FDMA in ocelot does not have this issue
because struct ocelot_fdma_tx_ring already contains an xmit_lock.

I guess this is mostly a problem for NXP LS1028A, as that is dual core.
I don't think VSC7514 is. So I'm blaming the commit where LS1028A (aka
the felix DSA driver) started using register-based packet injection and
extraction.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c             | 11 +++++
 drivers/net/ethernet/mscc/ocelot.c         | 52 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  4 ++
 include/soc/mscc/ocelot.h                  |  9 ++++
 4 files changed, 76 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9a3e5ec169726..b0b4b4af9a1df 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -528,7 +528,9 @@ static int felix_tag_8021q_setup(struct dsa_switch *ds)
 	 * so we need to be careful that there are no extra frames to be
 	 * dequeued over MMIO, since we would never know to discard them.
 	 */
+	ocelot_lock_xtr_grp_bh(ocelot, 0);
 	ocelot_drain_cpu_queue(ocelot, 0);
+	ocelot_unlock_xtr_grp_bh(ocelot, 0);
 
 	return 0;
 }
@@ -1504,6 +1506,8 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 	int port = xmit_work->dp->index;
 	int retries = 10;
 
+	ocelot_lock_inj_grp(ocelot, 0);
+
 	do {
 		if (ocelot_can_inject(ocelot, 0))
 			break;
@@ -1512,6 +1516,7 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 	} while (--retries);
 
 	if (!retries) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		dev_err(ocelot->dev, "port %d failed to inject skb\n",
 			port);
 		ocelot_port_purge_txtstamp_skb(ocelot, port, skb);
@@ -1521,6 +1526,8 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 
 	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
+	ocelot_unlock_inj_grp(ocelot, 0);
+
 	consume_skb(skb);
 	kfree(xmit_work);
 }
@@ -1671,6 +1678,8 @@ static bool felix_check_xtr_pkt(struct ocelot *ocelot)
 	if (!felix->info->quirk_no_xtr_irq)
 		return false;
 
+	ocelot_lock_xtr_grp(ocelot, grp);
+
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct sk_buff *skb;
 		unsigned int type;
@@ -1707,6 +1716,8 @@ static bool felix_check_xtr_pkt(struct ocelot *ocelot)
 		ocelot_drain_cpu_queue(ocelot, 0);
 	}
 
+	ocelot_unlock_xtr_grp(ocelot, grp);
+
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4e01abf6cc72c..c2118bde908b1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1099,6 +1099,48 @@ void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(ocelot_ptp_rx_timestamp);
 
+void ocelot_lock_inj_grp(struct ocelot *ocelot, int grp)
+			 __acquires(&ocelot->inj_lock)
+{
+	spin_lock(&ocelot->inj_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_lock_inj_grp);
+
+void ocelot_unlock_inj_grp(struct ocelot *ocelot, int grp)
+			   __releases(&ocelot->inj_lock)
+{
+	spin_unlock(&ocelot->inj_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_unlock_inj_grp);
+
+void ocelot_lock_xtr_grp(struct ocelot *ocelot, int grp)
+			 __acquires(&ocelot->inj_lock)
+{
+	spin_lock(&ocelot->inj_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_lock_xtr_grp);
+
+void ocelot_unlock_xtr_grp(struct ocelot *ocelot, int grp)
+			   __releases(&ocelot->inj_lock)
+{
+	spin_unlock(&ocelot->inj_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_unlock_xtr_grp);
+
+void ocelot_lock_xtr_grp_bh(struct ocelot *ocelot, int grp)
+			    __acquires(&ocelot->xtr_lock)
+{
+	spin_lock_bh(&ocelot->xtr_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_lock_xtr_grp_bh);
+
+void ocelot_unlock_xtr_grp_bh(struct ocelot *ocelot, int grp)
+			      __releases(&ocelot->xtr_lock)
+{
+	spin_unlock_bh(&ocelot->xtr_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_unlock_xtr_grp_bh);
+
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 {
 	u64 timestamp, src_port, len;
@@ -1109,6 +1151,8 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 	u32 val, *buf;
 	int err;
 
+	lockdep_assert_held(&ocelot->xtr_lock);
+
 	err = ocelot_xtr_poll_xfh(ocelot, grp, xfh);
 	if (err)
 		return err;
@@ -1184,6 +1228,8 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 {
 	u32 val = ocelot_read(ocelot, QS_INJ_STATUS);
 
+	lockdep_assert_held(&ocelot->inj_lock);
+
 	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))))
 		return false;
 	if (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp)))
@@ -1236,6 +1282,8 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 	u32 ifh[OCELOT_TAG_LEN / 4];
 	unsigned int i, count, last;
 
+	lockdep_assert_held(&ocelot->inj_lock);
+
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
 			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
 
@@ -1272,6 +1320,8 @@ EXPORT_SYMBOL(ocelot_port_inject_frame);
 
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 {
+	lockdep_assert_held(&ocelot->xtr_lock);
+
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 		ocelot_read_rix(ocelot, QS_XTR_RD, grp);
 }
@@ -2954,6 +3004,8 @@ int ocelot_init(struct ocelot *ocelot)
 	mutex_init(&ocelot->fwd_domain_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
 	spin_lock_init(&ocelot->ts_id_lock);
+	spin_lock_init(&ocelot->inj_lock);
+	spin_lock_init(&ocelot->xtr_lock);
 
 	ocelot->owq = alloc_ordered_workqueue("ocelot-owq", 0);
 	if (!ocelot->owq)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 151b424653483..bc20bd1ef05c7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -51,6 +51,8 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 	struct ocelot *ocelot = arg;
 	int grp = 0, err;
 
+	ocelot_lock_xtr_grp(ocelot, grp);
+
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct sk_buff *skb;
 
@@ -69,6 +71,8 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 	if (err < 0)
 		ocelot_drain_cpu_queue(ocelot, 0);
 
+	ocelot_unlock_xtr_grp(ocelot, grp);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0297bc2277927..846132ca5503d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -813,6 +813,9 @@ struct ocelot {
 	const u32 *const		*map;
 	struct list_head		stats_regions;
 
+	spinlock_t			inj_lock;
+	spinlock_t			xtr_lock;
+
 	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
 	int				packet_buffer_size;
 	int				num_frame_refs;
@@ -966,6 +969,12 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset);
 
 /* Packet I/O */
+void ocelot_lock_inj_grp(struct ocelot *ocelot, int grp);
+void ocelot_unlock_inj_grp(struct ocelot *ocelot, int grp);
+void ocelot_lock_xtr_grp(struct ocelot *ocelot, int grp);
+void ocelot_unlock_xtr_grp(struct ocelot *ocelot, int grp);
+void ocelot_lock_xtr_grp_bh(struct ocelot *ocelot, int grp);
+void ocelot_unlock_xtr_grp_bh(struct ocelot *ocelot, int grp);
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
-- 
2.43.0



