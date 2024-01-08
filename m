Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CDE4C3A0;
	Mon,  8 Jan 2024 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGZO27Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0BDC433C8;
	Mon,  8 Jan 2024 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728359;
	bh=srhO7ABH3q+NZ2S8d6x2CjSPY496FAbhGpxb/LANUMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGZO27MhZSG8it4camZc7kx1UNMVMj2oU62Vt2Bc7rT82anuKKOhZq09Mb7gRRPRA
	 X8NV6hx12g7l5D4GQoK5tuPPk3FadnxNKB6TDkMCA5PMQYPdmB+r8/3JhUkFhRapcv
	 nPPJoAraZJHcTcWkLoCdw6UvVv7CJ4VeUtUMwvgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/150] octeontx2-af: Re-enable MAC TX in otx2_stop processing
Date: Mon,  8 Jan 2024 16:35:02 +0100
Message-ID: <20240108153513.569830590@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Mamindlapalli <naveenm@marvell.com>

[ Upstream commit 818ed8933bd17bc91a9fa8b94a898189c546fc1a ]

During QoS scheduling testing with multiple strict priority flows, the
netdev tx watchdog timeout routine is invoked when a low priority QoS
queue doesn't get a chance to transmit the packets because other high
priority flows are completely subscribing the transmit link. The netdev
tx watchdog timeout routine will stop MAC RX and TX functionality in
otx2_stop() routine before cleanup of HW TX queues which results in SMQ
flush errors because the packets belonging to low priority queues will
never gets flushed since MAC TX is disabled. This patch fixes the issue
by re-enabling MAC TX to ensure the packets in HW pipeline gets flushed
properly.

Fixes: a7faa68b4e7f ("octeontx2-af: Start/Stop traffic in CGX along with NPC")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 17 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c |  8 +++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 95a7bc396e8ea..ab78e9d020751 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -850,6 +850,7 @@ u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 void *rvu_first_cgx_pdata(struct rvu *rvu);
 int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id);
 int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable);
+int rvu_cgx_tx_enable(struct rvu *rvu, u16 pcifunc, bool enable);
 int rvu_cgx_prio_flow_ctrl_cfg(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause,
 			       u16 pfc_en);
 int rvu_cgx_cfg_pause_frm(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index c60b9580ca969..fa658bd4dfb3b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -456,6 +456,23 @@ int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 	return mac_ops->mac_rx_tx_enable(cgxd, lmac_id, start);
 }
 
+int rvu_cgx_tx_enable(struct rvu *rvu, u16 pcifunc, bool enable)
+{
+	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return LMAC_AF_ERR_PERM_DENIED;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	mac_ops = get_mac_ops(cgxd);
+
+	return mac_ops->mac_tx_enable(cgxd, lmac_id, enable);
+}
+
 int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable)
 {
 	struct mac_ops *mac_ops;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 15f698020ec44..7f9581ce7f1fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4506,7 +4506,13 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	clear_bit(NIXLF_INITIALIZED, &pfvf->flags);
 
-	return rvu_cgx_start_stop_io(rvu, pcifunc, false);
+	err = rvu_cgx_start_stop_io(rvu, pcifunc, false);
+	if (err)
+		return err;
+
+	rvu_cgx_tx_enable(rvu, pcifunc, true);
+
+	return 0;
 }
 
 #define RX_SA_BASE  GENMASK_ULL(52, 7)
-- 
2.43.0



