Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB0F2FFFB6;
	Wed, 25 Feb 2026 06:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002721; cv=none; b=Eg265D6rSA2x31pfDyqyc4rZNnMbDYJxP83VPslcms9WA1FKfiVY5Lxws/Nu03Gtb/98uUtvkw1hcsCbG3H+uBAFDlCzm2tW4HRPyODqU5WmgvE4o3oFUunttYevvb1add8iD88B2BLkIZMOZXaVia4Frki5cHlPbCwePGoVT5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002721; c=relaxed/simple;
	bh=GwzGyjFyhibmeyLGyb0gb354MeadJ5KfGndhHZ0rWig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3WDr9VsIRPC1lWFV7HDbe1F4qoWw0S8CAAY9tJUtc0cBPt1eEplrTiMItNSAdoRGxEYcQTSDchUkusqibQiEqMDLrKqMIbLPf1GqJ83+GvE8dJrvDev4elH28wE08DohzJwNQnzDSLZGDpytcTi3Z2AsKMbVrplk9kwcLlKXJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ag614svy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ag614svy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EEBC116D0;
	Wed, 25 Feb 2026 06:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002720;
	bh=GwzGyjFyhibmeyLGyb0gb354MeadJ5KfGndhHZ0rWig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ag614svyR9qB8d16ptO8SSxBHhYBfk9oa50GpqFzt2oDiYEgF2bJaTrlc0AWki9rq
	 lhjWLTY10NaudHeIbxRHr4bWPOdQgwVT2jcRKiJ4gdu8ImHA4UDS4nPwv87T7f9+dH
	 kJrL2pdDpr2OzZn0QMb71SP2HsmUBQW5X8V+6d8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 530/641] eth: fbnic: Configure RDE settings for pause frame
Date: Tue, 24 Feb 2026 17:24:16 -0800
Message-ID: <20260225012401.371664641@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit 0135333914d63181f823bd340ae96737c8a820ca ]

fbnic supports pause frames. When pause frames are enabled presumably
user expects lossless operation from the NIC. Make sure we configure
RDE (Rx DMA Engine) to DROP_NEVER mode to avoid discards due to delays
in fetching Rx descriptors from the host.

While at it enable DROP_NEVER when NIC only has a single queue
configured. In this case the NIC acts as a FIFO so there's no risk
of head-of-line blocking other queues by making RDE wait. If pause
is disabled this just moves the packet loss from the DMA engine to
the Rx buffer.

Remove redundant call to fbnic_config_drop_mode_rcq(), introduced by
commit 0cb4c0a13723 ("eth: fbnic: Implement Rx queue
alloc/start/stop/free"). This call does not add value as
fbnic_enable_rcq(), which is called immediately afterward, already
handles this.

Although we do not support autoneg at this time, preserve tx_pause in
.mac_link_up instead of fbnic_phylink_get_pauseparam()

Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251113232610.1151712-1-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bbeb3bfbffe0 ("eth: fbnic: set FBNIC_QUEUE_RDE_CTL0_EN_HDR_SPLIT on RDE_CTL0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/meta/fbnic/fbnic_netdev.h    |  2 ++
 .../net/ethernet/meta/fbnic/fbnic_phylink.c   |  3 +++
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c  | 26 ++++++++++++++++---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h  |  1 +
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h
index b0a87c57910f2..e6ca23a9957d9 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h
@@ -73,6 +73,8 @@ struct fbnic_net {
 
 	/* Time stamping filter config */
 	struct kernel_hwtstamp_config hwtstamp_config;
+
+	bool tx_pause;
 };
 
 int __fbnic_open(struct fbnic_net *fbn);
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_phylink.c b/drivers/net/ethernet/meta/fbnic/fbnic_phylink.c
index 7ce3fdd252828..62701923cfe96 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_phylink.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_phylink.c
@@ -208,6 +208,9 @@ fbnic_phylink_mac_link_up(struct phylink_config *config,
 	struct fbnic_net *fbn = netdev_priv(netdev);
 	struct fbnic_dev *fbd = fbn->fbd;
 
+	fbn->tx_pause = tx_pause;
+	fbnic_config_drop_mode(fbn, tx_pause);
+
 	fbd->mac->link_up(fbd, tx_pause, rx_pause);
 }
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index b1e8ce89870f7..e99d17660230c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -2573,11 +2573,15 @@ static void fbnic_enable_bdq(struct fbnic_ring *hpq, struct fbnic_ring *ppq)
 }
 
 static void fbnic_config_drop_mode_rcq(struct fbnic_napi_vector *nv,
-				       struct fbnic_ring *rcq)
+				       struct fbnic_ring *rcq, bool tx_pause)
 {
+	struct fbnic_net *fbn = netdev_priv(nv->napi.dev);
 	u32 drop_mode, rcq_ctl;
 
-	drop_mode = FBNIC_QUEUE_RDE_CTL0_DROP_IMMEDIATE;
+	if (!tx_pause && fbn->num_rx_queues > 1)
+		drop_mode = FBNIC_QUEUE_RDE_CTL0_DROP_IMMEDIATE;
+	else
+		drop_mode = FBNIC_QUEUE_RDE_CTL0_DROP_NEVER;
 
 	/* Specify packet layout */
 	rcq_ctl = FIELD_PREP(FBNIC_QUEUE_RDE_CTL0_DROP_MODE_MASK, drop_mode) |
@@ -2587,6 +2591,21 @@ static void fbnic_config_drop_mode_rcq(struct fbnic_napi_vector *nv,
 	fbnic_ring_wr32(rcq, FBNIC_QUEUE_RDE_CTL0, rcq_ctl);
 }
 
+void fbnic_config_drop_mode(struct fbnic_net *fbn, bool tx_pause)
+{
+	int i, t;
+
+	for (i = 0; i < fbn->num_napi; i++) {
+		struct fbnic_napi_vector *nv = fbn->napi[i];
+
+		for (t = 0; t < nv->rxt_count; t++) {
+			struct fbnic_q_triad *qt = &nv->qt[nv->txt_count + t];
+
+			fbnic_config_drop_mode_rcq(nv, &qt->cmpl, tx_pause);
+		}
+	}
+}
+
 static void fbnic_config_rim_threshold(struct fbnic_ring *rcq, u16 nv_idx, u32 rx_desc)
 {
 	u32 threshold;
@@ -2636,7 +2655,7 @@ static void fbnic_enable_rcq(struct fbnic_napi_vector *nv,
 	u32 hds_thresh = fbn->hds_thresh;
 	u32 rcq_ctl = 0;
 
-	fbnic_config_drop_mode_rcq(nv, rcq);
+	fbnic_config_drop_mode_rcq(nv, rcq, fbn->tx_pause);
 
 	/* Force lower bound on MAX_HEADER_BYTES. Below this, all frames should
 	 * be split at L4. It would also result in the frames being split at
@@ -2699,7 +2718,6 @@ static void __fbnic_nv_enable(struct fbnic_napi_vector *nv)
 						  &nv->napi);
 
 		fbnic_enable_bdq(&qt->sub0, &qt->sub1);
-		fbnic_config_drop_mode_rcq(nv, &qt->cmpl);
 		fbnic_enable_rcq(nv, &qt->cmpl);
 	}
 }
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index ca37da5a0b179..27776e844e29b 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -184,6 +184,7 @@ void fbnic_reset_netif_queues(struct fbnic_net *fbn);
 irqreturn_t fbnic_msix_clean_rings(int irq, void *data);
 void fbnic_napi_enable(struct fbnic_net *fbn);
 void fbnic_napi_disable(struct fbnic_net *fbn);
+void fbnic_config_drop_mode(struct fbnic_net *fbn, bool tx_pause);
 void fbnic_enable(struct fbnic_net *fbn);
 void fbnic_disable(struct fbnic_net *fbn);
 void fbnic_flush(struct fbnic_net *fbn);
-- 
2.51.0



