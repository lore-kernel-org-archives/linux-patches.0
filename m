Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CDB38F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302166; cv=none; b=qbQ/1kPgp595t3npnvHee1YG2jRt25ARO1bBIkwvT6XnOR3h/wpXgmPXOXWQLaxzyXW9No7y3T7XA1M+LzyiZlwTAB3NMEsBWeQuqjnRwb6EmiVF0Iv9sjkr1ll3rqVD9gEurhf6rI9E2DtRQHWLzZLCQH4hTTQQohegspGK0wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302166; c=relaxed/simple;
	bh=XzpKapDkOWrc7TVlTelX58CQ9Exyao72Hn6IB8FycEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFqlGOXD0TdH7L+PmnhGHxVL7eW4xGeS3SgC+XsdoWeiJIO0knBLaXNzv1OZ5mz35Jice3xF5d0+L4XYhU12BYCfMbeZX9sheD7MWm66LxRq//0/ySw2ceHc13+xUwS8U32qtg/Ld0buaZRXAX0qA5NisAykdHu0W3GE/sfqfAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u2jzZrk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u2jzZrk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52897C116D0;
	Sat, 28 Feb 2026 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302165;
	bh=XzpKapDkOWrc7TVlTelX58CQ9Exyao72Hn6IB8FycEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2jzZrk9InUncLz7y3vCem4qCrqBYIGUm04pEWWLf0rsJiblGCtQ95bFpp+0c8SzT
	 U0V/MI4FTCSE7E1nxdeHBgFeF7EgjHqNeZbyrS0wLX48seh4x/UVhytmgV7gbmh0ot
	 5thQdLomXACfueiXzBxi5/QhRen8Yv82wWCdG9kVVcLRofHre/d65BcMkp1vE3fo/2
	 dYjrGcNkHJcXeMjNFShPmr9jNcT6n+YMO9vymI4cwBwWubLtx0kkw+rhnu8L62RY+o
	 9iX1/lCSYbJ7l2jmIkyiNchX834RbdcjOo+6qZuVc6vDQRJ3duxuZ6fkLQum0l2AXG
	 4X2r2nw6BggQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shinas Rasheed <srasheed@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/283] octeon_ep: set backpressure watermark for RX queues
Date: Sat, 28 Feb 2026 13:05:04 -0500
Message-ID: <20260228180709.1583486-162-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shinas Rasheed <srasheed@marvell.com>

[ Upstream commit 15bc81212f593fbd7bda787598418b931842dc14 ]

Set backpressure watermark for hardware RX queues. Backpressure
gets triggered when the available buffers of a hardware RX queue
falls below the set watermark. This backpressure will propagate
to packet processing pipeline in the OCTEON card, so that the host
receives fewer packets and prevents packet dropping at host.

Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ce8fe3fc4f99 ("octeon_ep: ensure dbell BADDR updation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c |  7 +++++++
 drivers/net/ethernet/marvell/octeon_ep/octep_config.h  | 10 ++++++++++
 .../ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h    |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
index 633d39690eec8..38a03cef314e3 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
@@ -258,6 +258,7 @@ static void octep_init_config_cnxk_pf(struct octep_device *oct)
 	conf->oq.refill_threshold = OCTEP_OQ_REFILL_THRESHOLD;
 	conf->oq.oq_intr_pkt = OCTEP_OQ_INTR_PKT_THRESHOLD;
 	conf->oq.oq_intr_time = OCTEP_OQ_INTR_TIME_THRESHOLD;
+	conf->oq.wmark = OCTEP_OQ_WMARK_MIN;
 
 	conf->msix_cfg.non_ioq_msix = CNXK_NUM_NON_IOQ_INTR;
 	conf->msix_cfg.ioq_msix = conf->pf_ring_cfg.active_io_rings;
@@ -378,6 +379,12 @@ static void octep_setup_oq_regs_cnxk_pf(struct octep_device *oct, int oq_no)
 	reg_val = ((u64)time_threshold << 32) |
 		  CFG_GET_OQ_INTR_PKT(oct->conf);
 	octep_write_csr64(oct, CNXK_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
+
+	/* set watermark for backpressure */
+	reg_val = octep_read_csr64(oct, CNXK_SDP_R_OUT_WMARK(oq_no));
+	reg_val &= ~0xFFFFFFFFULL;
+	reg_val |= CFG_GET_OQ_WMARK(oct->conf);
+	octep_write_csr64(oct, CNXK_SDP_R_OUT_WMARK(oq_no), reg_val);
 }
 
 /* Setup registers for a PF mailbox */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
index 1622a6ebf0362..ecc2947931410 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
@@ -19,6 +19,9 @@
 /* Packet threshold for Tx queue interrupt */
 #define OCTEP_IQ_INTR_THRESHOLD     0x0
 
+/* Minimum watermark for backpressure */
+#define OCTEP_OQ_WMARK_MIN 256
+
 /* Rx Queue: maximum descriptors per ring */
 #define OCTEP_OQ_MAX_DESCRIPTORS   1024
 
@@ -68,6 +71,7 @@
 #define CFG_GET_OQ_REFILL_THRESHOLD(cfg)  ((cfg)->oq.refill_threshold)
 #define CFG_GET_OQ_INTR_PKT(cfg)          ((cfg)->oq.oq_intr_pkt)
 #define CFG_GET_OQ_INTR_TIME(cfg)         ((cfg)->oq.oq_intr_time)
+#define CFG_GET_OQ_WMARK(cfg)             ((cfg)->oq.wmark)
 
 #define CFG_GET_PORTS_MAX_IO_RINGS(cfg)    ((cfg)->pf_ring_cfg.max_io_rings)
 #define CFG_GET_PORTS_ACTIVE_IO_RINGS(cfg) ((cfg)->pf_ring_cfg.active_io_rings)
@@ -137,6 +141,12 @@ struct octep_oq_config {
 	 * default. The time is specified in microseconds.
 	 */
 	u32 oq_intr_time;
+
+	/* Water mark for backpressure.
+	 * Output queue sends backpressure signal to source when
+	 * free buffer count falls below wmark.
+	 */
+	u32 wmark;
 };
 
 /* Tx/Rx configuration */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h
index 214aab88bb427..f0b3937002b62 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h
@@ -143,6 +143,9 @@
 #define    CNXK_SDP_R_OUT_SLIST_DBELL(ring)          \
 	(CNXK_SDP_R_OUT_SLIST_DBELL_START + ((ring) * CNXK_RING_OFFSET))
 
+#define    CNXK_SDP_R_OUT_WMARK(ring)         \
+	(CNXK_SDP_R_OUT_WMARK_START + ((ring) * CNXK_RING_OFFSET))
+
 #define    CNXK_SDP_R_OUT_CNTS(ring)          \
 	(CNXK_SDP_R_OUT_CNTS_START + ((ring) * CNXK_RING_OFFSET))
 
-- 
2.51.0

