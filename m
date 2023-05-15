Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E77FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F2CC433D2;
	Mon, 15 May 2023 17:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170139;
	bh=aK0fBBLaA6SW7pn+EZaHy29Lo+abtaSbv0DSqMG8/2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rhp0jVIjgggE8bCjXhMh0Gut2J7jKKe0opKM02ghGCN5ufap8FBfTbYGzXrTc7g55
	 JM138d/mbyGCcn67Dl3MGyGlulwBBTsJPmspzCL+/tmBxrs5vBXKr5sKiu1bOsvdpa
	 msOB3DioH4eIpTGO87hnWib4UV0427dQElGSQj30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/239] octeontx2-af: mcs: Config parser to skip 8B header
Date: Mon, 15 May 2023 18:25:00 +0200
Message-Id: <20230515161722.827509303@linuxfoundation.org>
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

[ Upstream commit 65cdc2b637a5749c7dec0ce14fe2c48f1f91f671 ]

When ptp timestamp is enabled in RPM, RPM will append 8B
timestamp header for all RX traffic. MCS need to skip these
8 bytes header while parsing the packet header, so that
correct tcam key is created for lookup.
This patch fixes the mcs parser configuration to skip this
8B header for ptp packets.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/mcs_reg.h   |  1 +
 .../marvell/octeontx2/af/mcs_rvu_if.c         | 37 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 +
 4 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index c95a8b8f5eaf7..7427e3b1490f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -97,6 +97,7 @@
 #define MCSX_PEX_TX_SLAVE_VLAN_CFGX(a)          (0x46f8ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_CUSTOM_TAG_REL_MODE_SEL(a)	(0x788ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_PORT_CONFIG(a)		(0x4738ull + (a) * 0x8ull)
+#define MCSX_PEX_RX_SLAVE_PORT_CFGX(a)		(0x3b98ull + (a) * 0x8ull)
 #define MCSX_PEX_RX_SLAVE_RULE_ETYPE_CFGX(a) ({	\
 	u64 offset;					\
 							\
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index eb25e458266ca..dfd23580e3b8e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -11,6 +11,7 @@
 
 #include "mcs.h"
 #include "rvu.h"
+#include "mcs_reg.h"
 #include "lmac_common.h"
 
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
@@ -32,6 +33,42 @@ static struct _req_type __maybe_unused					\
 MBOX_UP_MCS_MESSAGES
 #undef M
 
+void rvu_mcs_ptp_cfg(struct rvu *rvu, u8 rpm_id, u8 lmac_id, bool ena)
+{
+	struct mcs *mcs;
+	u64 cfg;
+	u8 port;
+
+	if (!rvu->mcs_blk_cnt)
+		return;
+
+	/* When ptp is enabled, RPM appends 8B header for all
+	 * RX packets. MCS PEX need to configure to skip 8B
+	 * during packet parsing.
+	 */
+
+	/* CNF10K-B */
+	if (rvu->mcs_blk_cnt > 1) {
+		mcs = mcs_get_pdata(rpm_id);
+		cfg = mcs_reg_read(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION);
+		if (ena)
+			cfg |= BIT_ULL(lmac_id);
+		else
+			cfg &= ~BIT_ULL(lmac_id);
+		mcs_reg_write(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION, cfg);
+		return;
+	}
+	/* CN10KB */
+	mcs = mcs_get_pdata(0);
+	port = (rpm_id * rvu->hw->lmac_per_cgx) + lmac_id;
+	cfg = mcs_reg_read(mcs, MCSX_PEX_RX_SLAVE_PORT_CFGX(port));
+	if (ena)
+		cfg |= BIT_ULL(0);
+	else
+		cfg &= ~BIT_ULL(0);
+	mcs_reg_write(mcs, MCSX_PEX_RX_SLAVE_PORT_CFGX(port), cfg);
+}
+
 int rvu_mbox_handler_mcs_set_lmac_mode(struct rvu *rvu,
 				       struct mcs_set_lmac_mode *req,
 				       struct msg_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index b07c6f51b461b..3ca8d2e5f979b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -892,6 +892,7 @@ int rvu_get_hwvf(struct rvu *rvu, int pcifunc);
 /* CN10K MCS */
 int rvu_mcs_init(struct rvu *rvu);
 int rvu_mcs_flr_handler(struct rvu *rvu, u16 pcifunc);
+void rvu_mcs_ptp_cfg(struct rvu *rvu, u8 rpm_id, u8 lmac_id, bool ena);
 void rvu_mcs_exit(struct rvu *rvu);
 
 #endif /* RVU_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index addc69f4b65c6..9eca38547b783 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -761,6 +761,8 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	/* This flag is required to clean up CGX conf if app gets killed */
 	pfvf->hw_rx_tstamp_en = enable;
 
+	/* Inform MCS about 8B RX header */
+	rvu_mcs_ptp_cfg(rvu, cgx_id, lmac_id, enable);
 	return 0;
 }
 
-- 
2.39.2



