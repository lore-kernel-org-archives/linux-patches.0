Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0B1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D7BC433C8;
	Mon, 21 Aug 2023 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647998;
	bh=MwlQfi/ZRlONaV4G+ZNJqyULcWstpvnPnU2Ks1lJKTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCNBeKc+TduYQIR0MACztcqagjo2MfiBWEwdq4sau+gar8AmDSSrWXfC6hD6SYTjj
	 bGm7kSpXllbN/mdkg2aKiTum0E7azZTFbOKmwpsa9G0cQ2s6PbCyVhVvBQrBMSeGGs
	 Er2gEJj7lLSYU8FnLZQHdwjFvIovKzOhGtd8V264=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 019/234] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to enable RX coalescing
Date: Mon, 21 Aug 2023 21:39:42 +0200
Message-ID: <20230821194129.603880626@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

[ Upstream commit 2145328515c8fa9b8a9f7889250bc6c032f2a0e6 ]

With RX coalescing, one CQE entry can be used to indicate multiple packets
on the receive queue. This saves processing time and PCI bandwidth over
the CQ.

The MANA Ethernet driver also uses the v2 version of the protocol. It
doesn't use RX coalescing and its behavior is not changed.

Link: https://lore.kernel.org/r/1684045095-31228-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/qp.c               | 5 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 5 ++++-
 include/net/mana/mana.h                       | 4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 54b61930a7fdb..4b3b5b274e849 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -13,7 +13,7 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 				      u8 *rx_hash_key)
 {
 	struct mana_port_context *mpc = netdev_priv(ndev);
-	struct mana_cfg_rx_steer_req *req = NULL;
+	struct mana_cfg_rx_steer_req_v2 *req;
 	struct mana_cfg_rx_steer_resp resp = {};
 	mana_handle_t *req_indir_tab;
 	struct gdma_context *gc;
@@ -33,6 +33,8 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
 			     sizeof(resp));
 
+	req->hdr.req.msg_version = GDMA_MESSAGE_V2;
+
 	req->vport = mpc->port_handle;
 	req->rx_enable = 1;
 	req->update_default_rxobj = 1;
@@ -46,6 +48,7 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 	req->num_indir_entries = MANA_INDIRECT_TABLE_SIZE;
 	req->indir_tab_offset = sizeof(*req);
 	req->update_indir_tab = true;
+	req->cqe_coalescing_enable = 1;
 
 	req_indir_tab = (mana_handle_t *)(req + 1);
 	/* The ind table passed to the hardware must have
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 96c78f7db2543..7441577294bad 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -973,7 +973,7 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 				   bool update_tab)
 {
 	u16 num_entries = MANA_INDIRECT_TABLE_SIZE;
-	struct mana_cfg_rx_steer_req *req = NULL;
+	struct mana_cfg_rx_steer_req_v2 *req;
 	struct mana_cfg_rx_steer_resp resp = {};
 	struct net_device *ndev = apc->ndev;
 	mana_handle_t *req_indir_tab;
@@ -988,6 +988,8 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
 			     sizeof(resp));
 
+	req->hdr.req.msg_version = GDMA_MESSAGE_V2;
+
 	req->vport = apc->port_handle;
 	req->num_indir_entries = num_entries;
 	req->indir_tab_offset = sizeof(*req);
@@ -997,6 +999,7 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 	req->update_hashkey = update_key;
 	req->update_indir_tab = update_tab;
 	req->default_rxobj = apc->default_rxobj;
+	req->cqe_coalescing_enable = 0;
 
 	if (update_key)
 		memcpy(&req->hashkey, apc->hashkey, MANA_HASH_KEY_SIZE);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 9eef199728454..024ad8ddb27e5 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -579,7 +579,7 @@ struct mana_fence_rq_resp {
 }; /* HW DATA */
 
 /* Configure vPort Rx Steering */
-struct mana_cfg_rx_steer_req {
+struct mana_cfg_rx_steer_req_v2 {
 	struct gdma_req_hdr hdr;
 	mana_handle_t vport;
 	u16 num_indir_entries;
@@ -592,6 +592,8 @@ struct mana_cfg_rx_steer_req {
 	u8 reserved;
 	mana_handle_t default_rxobj;
 	u8 hashkey[MANA_HASH_KEY_SIZE];
+	u8 cqe_coalescing_enable;
+	u8 reserved2[7];
 }; /* HW DATA */
 
 struct mana_cfg_rx_steer_resp {
-- 
2.40.1



