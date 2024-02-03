Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F135913AC6;
	Sat,  3 Feb 2024 04:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933813; cv=none; b=UnaI9g5B7leO+2kzSZ0fe6anGZ5ueN7mp8IlDXIFvQk5zxzyv/KHb9bBcWBdnIhIty4FAKPXzfByu/ngzkMQTdGuTTQTROm/rSkL9pAIZrYd93yt1o+B9HHNc4/PeYwCG0yDJA5qdzd9BZFcwq8Nn1TurCEdOMZrz09hyDe+SF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933813; c=relaxed/simple;
	bh=ZxWqskc6N1EghgADVPwCPCHmPPSR1RyejHmMBG1dc18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5LYgXjZiCGdMYnexSU+/qeSw43oc0mn2XP4y1x/0IKRQixPF7iRIrIvPVjwn2BtSPC2D3WDaMkFFwzbMvZ8EWW0swxClSc+E8JveOd2ad8aThesBVCpANtqGQs4uepXW4pssJ8goeCH8BHE7ivLk3dL/NIdDziVXbCz1/eD8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxgIBpBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxgIBpBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C50C433F1;
	Sat,  3 Feb 2024 04:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933812;
	bh=ZxWqskc6N1EghgADVPwCPCHmPPSR1RyejHmMBG1dc18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxgIBpBXwblPM3RGakEK8vyKBtAd1LF/lRgqjdPEAysp2RUGvuVQI38XC3R+FUv3j
	 jlYwYHJa7ZufyTnbo8g6h4XhBKtgk5oyKFcWbTgIlXOn+dj8DzD38FyGEFbZhPqRDb
	 UT7kI69Kd4JdHZT9Pu17ZYds6m3WIuilFzWVxJDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Russkikh <irusskikh@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 130/353] net: atlantic: eliminate double free in error handling logic
Date: Fri,  2 Feb 2024 20:04:08 -0800
Message-ID: <20240203035407.836787296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Russkikh <irusskikh@marvell.com>

[ Upstream commit b3cb7a830a24527877b0bc900b9bd74a96aea928 ]

Driver has a logic leak in ring data allocation/free,
where aq_ring_free could be called multiple times on same ring,
if system is under stress and got memory allocation error.

Ring pointer was used as an indicator of failure, but this is
not correct since only ring data is allocated/deallocated.
Ring itself is an array member.

Changing ring allocation functions to return error code directly.
This simplifies error handling and eliminates aq_ring_free
on higher layer.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://lore.kernel.org/r/20231213095044.23146-1-irusskikh@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 28 +++------
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 61 +++++--------------
 .../net/ethernet/aquantia/atlantic/aq_ring.h  | 22 +++----
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 23 +++----
 4 files changed, 47 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 28c9b6f1a54f..abd4832e4ed2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -953,8 +953,6 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
 	unsigned int tx_ring_idx, rx_ring_idx;
-	struct aq_ring_s *hwts;
-	struct aq_ring_s *ring;
 	int err;
 
 	if (!aq_ptp)
@@ -962,29 +960,23 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 
 	tx_ring_idx = aq_ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
-	ring = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
-				tx_ring_idx, &aq_nic->aq_nic_cfg);
-	if (!ring) {
-		err = -ENOMEM;
+	err = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
+			       tx_ring_idx, &aq_nic->aq_nic_cfg);
+	if (err)
 		goto err_exit;
-	}
 
 	rx_ring_idx = aq_ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
-	ring = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
-				rx_ring_idx, &aq_nic->aq_nic_cfg);
-	if (!ring) {
-		err = -ENOMEM;
+	err = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
+			       rx_ring_idx, &aq_nic->aq_nic_cfg);
+	if (err)
 		goto err_exit_ptp_tx;
-	}
 
-	hwts = aq_ring_hwts_rx_alloc(&aq_ptp->hwts_rx, aq_nic, PTP_HWST_RING_IDX,
-				     aq_nic->aq_nic_cfg.rxds,
-				     aq_nic->aq_nic_cfg.aq_hw_caps->rxd_size);
-	if (!hwts) {
-		err = -ENOMEM;
+	err = aq_ring_hwts_rx_alloc(&aq_ptp->hwts_rx, aq_nic, PTP_HWST_RING_IDX,
+				    aq_nic->aq_nic_cfg.rxds,
+				    aq_nic->aq_nic_cfg.aq_hw_caps->rxd_size);
+	if (err)
 		goto err_exit_ptp_rx;
-	}
 
 	err = aq_ptp_skb_ring_init(&aq_ptp->skb_ring, aq_nic->aq_nic_cfg.rxds);
 	if (err != 0) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index e1885c1eb100..cda8597b4e14 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -132,8 +132,8 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf)
 	return 0;
 }
 
-static struct aq_ring_s *aq_ring_alloc(struct aq_ring_s *self,
-				       struct aq_nic_s *aq_nic)
+static int aq_ring_alloc(struct aq_ring_s *self,
+			 struct aq_nic_s *aq_nic)
 {
 	int err = 0;
 
@@ -156,46 +156,29 @@ static struct aq_ring_s *aq_ring_alloc(struct aq_ring_s *self,
 err_exit:
 	if (err < 0) {
 		aq_ring_free(self);
-		self = NULL;
 	}
 
-	return self;
+	return err;
 }
 
-struct aq_ring_s *aq_ring_tx_alloc(struct aq_ring_s *self,
-				   struct aq_nic_s *aq_nic,
-				   unsigned int idx,
-				   struct aq_nic_cfg_s *aq_nic_cfg)
+int aq_ring_tx_alloc(struct aq_ring_s *self,
+		     struct aq_nic_s *aq_nic,
+		     unsigned int idx,
+		     struct aq_nic_cfg_s *aq_nic_cfg)
 {
-	int err = 0;
-
 	self->aq_nic = aq_nic;
 	self->idx = idx;
 	self->size = aq_nic_cfg->txds;
 	self->dx_size = aq_nic_cfg->aq_hw_caps->txd_size;
 
-	self = aq_ring_alloc(self, aq_nic);
-	if (!self) {
-		err = -ENOMEM;
-		goto err_exit;
-	}
-
-err_exit:
-	if (err < 0) {
-		aq_ring_free(self);
-		self = NULL;
-	}
-
-	return self;
+	return aq_ring_alloc(self, aq_nic);
 }
 
-struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *self,
-				   struct aq_nic_s *aq_nic,
-				   unsigned int idx,
-				   struct aq_nic_cfg_s *aq_nic_cfg)
+int aq_ring_rx_alloc(struct aq_ring_s *self,
+		     struct aq_nic_s *aq_nic,
+		     unsigned int idx,
+		     struct aq_nic_cfg_s *aq_nic_cfg)
 {
-	int err = 0;
-
 	self->aq_nic = aq_nic;
 	self->idx = idx;
 	self->size = aq_nic_cfg->rxds;
@@ -217,22 +200,10 @@ struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *self,
 		self->tail_size = 0;
 	}
 
-	self = aq_ring_alloc(self, aq_nic);
-	if (!self) {
-		err = -ENOMEM;
-		goto err_exit;
-	}
-
-err_exit:
-	if (err < 0) {
-		aq_ring_free(self);
-		self = NULL;
-	}
-
-	return self;
+	return aq_ring_alloc(self, aq_nic);
 }
 
-struct aq_ring_s *
+int
 aq_ring_hwts_rx_alloc(struct aq_ring_s *self, struct aq_nic_s *aq_nic,
 		      unsigned int idx, unsigned int size, unsigned int dx_size)
 {
@@ -250,10 +221,10 @@ aq_ring_hwts_rx_alloc(struct aq_ring_s *self, struct aq_nic_s *aq_nic,
 					   GFP_KERNEL);
 	if (!self->dx_ring) {
 		aq_ring_free(self);
-		return NULL;
+		return -ENOMEM;
 	}
 
-	return self;
+	return 0;
 }
 
 int aq_ring_init(struct aq_ring_s *self, const enum atl_ring_type ring_type)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 0a6c34438c1d..52847310740a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -183,14 +183,14 @@ static inline unsigned int aq_ring_avail_dx(struct aq_ring_s *self)
 		self->sw_head - self->sw_tail - 1);
 }
 
-struct aq_ring_s *aq_ring_tx_alloc(struct aq_ring_s *self,
-				   struct aq_nic_s *aq_nic,
-				   unsigned int idx,
-				   struct aq_nic_cfg_s *aq_nic_cfg);
-struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *self,
-				   struct aq_nic_s *aq_nic,
-				   unsigned int idx,
-				   struct aq_nic_cfg_s *aq_nic_cfg);
+int aq_ring_tx_alloc(struct aq_ring_s *self,
+		     struct aq_nic_s *aq_nic,
+		     unsigned int idx,
+		     struct aq_nic_cfg_s *aq_nic_cfg);
+int aq_ring_rx_alloc(struct aq_ring_s *self,
+		     struct aq_nic_s *aq_nic,
+		     unsigned int idx,
+		     struct aq_nic_cfg_s *aq_nic_cfg);
 
 int aq_ring_init(struct aq_ring_s *self, const enum atl_ring_type ring_type);
 void aq_ring_rx_deinit(struct aq_ring_s *self);
@@ -207,9 +207,9 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		     int budget);
 int aq_ring_rx_fill(struct aq_ring_s *self);
 
-struct aq_ring_s *aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
-		struct aq_nic_s *aq_nic, unsigned int idx,
-		unsigned int size, unsigned int dx_size);
+int aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
+			  struct aq_nic_s *aq_nic, unsigned int idx,
+			  unsigned int size, unsigned int dx_size);
 void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic);
 
 unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f5db1c44e9b9..9769ab4f9bef 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -136,35 +136,32 @@ int aq_vec_ring_alloc(struct aq_vec_s *self, struct aq_nic_s *aq_nic,
 		const unsigned int idx_ring = AQ_NIC_CFG_TCVEC2RING(aq_nic_cfg,
 								    i, idx);
 
-		ring = aq_ring_tx_alloc(&self->ring[i][AQ_VEC_TX_ID], aq_nic,
-					idx_ring, aq_nic_cfg);
-		if (!ring) {
-			err = -ENOMEM;
+		ring = &self->ring[i][AQ_VEC_TX_ID];
+		err = aq_ring_tx_alloc(ring, aq_nic, idx_ring, aq_nic_cfg);
+		if (err)
 			goto err_exit;
-		}
 
 		++self->tx_rings;
 
 		aq_nic_set_tx_ring(aq_nic, idx_ring, ring);
 
-		if (xdp_rxq_info_reg(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq,
+		ring = &self->ring[i][AQ_VEC_RX_ID];
+		if (xdp_rxq_info_reg(&ring->xdp_rxq,
 				     aq_nic->ndev, idx,
 				     self->napi.napi_id) < 0) {
 			err = -ENOMEM;
 			goto err_exit;
 		}
-		if (xdp_rxq_info_reg_mem_model(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq,
+		if (xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 					       MEM_TYPE_PAGE_SHARED, NULL) < 0) {
-			xdp_rxq_info_unreg(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq);
+			xdp_rxq_info_unreg(&ring->xdp_rxq);
 			err = -ENOMEM;
 			goto err_exit;
 		}
 
-		ring = aq_ring_rx_alloc(&self->ring[i][AQ_VEC_RX_ID], aq_nic,
-					idx_ring, aq_nic_cfg);
-		if (!ring) {
-			xdp_rxq_info_unreg(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq);
-			err = -ENOMEM;
+		err = aq_ring_rx_alloc(ring, aq_nic, idx_ring, aq_nic_cfg);
+		if (err) {
+			xdp_rxq_info_unreg(&ring->xdp_rxq);
 			goto err_exit;
 		}
 
-- 
2.43.0



