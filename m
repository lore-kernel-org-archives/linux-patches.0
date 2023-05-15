Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86006FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB3DC433D2;
	Mon, 15 May 2023 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170133;
	bh=jJyNus2CwwIY+AAgjOpLx+S5mKMQaBPOy9bff8eWG8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elNfUevw10euiQUlNoIHYJ4frt4K4F279xKwMV/EpzFFeaqoql138sKh1AB/iUWqQ
	 4ctHKNKwpkXE2aij9+kwEiamCSvGmWFVOqK2H1U9qpjwBJGDSpH2LVboeOb0kxvrYv
	 ZGsxOJnCdYWMEa9Dz13S+oWqpyefLTIBH1mhxXOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/239] octeonxt2-af: mcs: Fix per port bypass config
Date: Mon, 15 May 2023 18:24:58 +0200
Message-Id: <20230515161722.768477633@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit c222b292a3568754828ffd30338d2909b14ed160 ]

For each lmac port, MCS has two MCS_TOP_SLAVE_CHANNEL_CONFIGX
registers. For CN10KB both register need to be configured for the
port level mcs bypass to work. This patch also sets bitmap
of flowid/secy entry reserved for default bypass so that these
entries can be shown in debugfs.

Fixes: bd69476e86fc ("octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c       | 11 ++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  5 +++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index f68a6a0e3aa41..492baa0b594ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -494,6 +494,9 @@ int mcs_install_flowid_bypass_entry(struct mcs *mcs)
 
 	/* Flow entry */
 	flow_id = mcs->hw->tcam_entries - MCS_RSRC_RSVD_CNT;
+	__set_bit(flow_id, mcs->rx.flow_ids.bmap);
+	__set_bit(flow_id, mcs->tx.flow_ids.bmap);
+
 	for (reg_id = 0; reg_id < 4; reg_id++) {
 		reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
 		mcs_reg_write(mcs, reg, GENMASK_ULL(63, 0));
@@ -504,6 +507,8 @@ int mcs_install_flowid_bypass_entry(struct mcs *mcs)
 	}
 	/* secy */
 	secy_id = mcs->hw->secy_entries - MCS_RSRC_RSVD_CNT;
+	__set_bit(secy_id, mcs->rx.secy.bmap);
+	__set_bit(secy_id, mcs->tx.secy.bmap);
 
 	/* Set validate frames to NULL and enable control port */
 	plcy = 0x7ull;
@@ -528,6 +533,7 @@ int mcs_install_flowid_bypass_entry(struct mcs *mcs)
 	/* Enable Flowid entry */
 	mcs_ena_dis_flowid_entry(mcs, flow_id, MCS_RX, true);
 	mcs_ena_dis_flowid_entry(mcs, flow_id, MCS_TX, true);
+
 	return 0;
 }
 
@@ -1325,8 +1331,11 @@ void mcs_reset_port(struct mcs *mcs, u8 port_id, u8 reset)
 void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode)
 {
 	u64 reg;
+	int id = lmac_id * 2;
 
-	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(lmac_id * 2);
+	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(id);
+	mcs_reg_write(mcs, reg, (u64)mode);
+	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG((id + 1));
 	mcs_reg_write(mcs, reg, (u64)mode);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index abef0fd4259a3..0cab27448399c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -497,8 +497,9 @@ static int rvu_dbg_mcs_rx_secy_stats_display(struct seq_file *filp, void *unused
 			   stats.octet_validated_cnt);
 		seq_printf(filp, "secy%d: Pkts on disable port: %lld\n", secy_id,
 			   stats.pkt_port_disabled_cnt);
-		seq_printf(filp, "secy%d: Octets validated: %lld\n", secy_id, stats.pkt_badtag_cnt);
-		seq_printf(filp, "secy%d: Octets validated: %lld\n", secy_id, stats.pkt_nosa_cnt);
+		seq_printf(filp, "secy%d: Pkts with badtag: %lld\n", secy_id, stats.pkt_badtag_cnt);
+		seq_printf(filp, "secy%d: Pkts with no SA(sectag.tci.c=0): %lld\n", secy_id,
+			   stats.pkt_nosa_cnt);
 		seq_printf(filp, "secy%d: Pkts with nosaerror: %lld\n", secy_id,
 			   stats.pkt_nosaerror_cnt);
 		seq_printf(filp, "secy%d: Tagged ctrl pkts: %lld\n", secy_id,
-- 
2.39.2



