Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410C12ECE87;
	Tue, 15 Jul 2025 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587727; cv=none; b=ipSH0br1kVJULnUInEqL4Q16wIw7GBjLCnGVGCNyXrvswnd2p4DODWSieRBAaiY6JB+gRR4ny8Cq3XYA3NmzDyINBt3yM25SAvAHockrONPXTJ203T7W3lOeAvMkg6CiA4sy/TeqbSrpS1e09CZp4LEFZc6nXVNPtzHVEndcSt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587727; c=relaxed/simple;
	bh=e/UqlI1oWbYHDiHS7FKOBPh8C+iFNmjTBpTwiPDsGG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/5PWh4kQ1COtOVmxToR8Uwg2F4F2oKbyaXogs5M5qhe5y+SNnnpeaOniZUob+X7Rd0syTC9mvvjFUIXWh7nNXBALybODHC8wgDjeCepU1La8QSDm+RXocvrFiqVoxH8Y3g8yFD9g+ZytDKlDg9axoZfsHuOfEsqq6Ke+8LP45s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZ8NdyGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ8NdyGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0E9C4CEE3;
	Tue, 15 Jul 2025 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587727;
	bh=e/UqlI1oWbYHDiHS7FKOBPh8C+iFNmjTBpTwiPDsGG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ8NdyGHQBUoexX17o1rMBfWxnu5gG1VcjDYvQeIG1fPXkuVO1Q3ooM6Vu95A14Eu
	 EhEnOjwxWy4HKMqfSKTL0qC0jP1beaAvLqILdnkByaoZOxptQcfN9wvYp4qzXeOiw2
	 b4Nz3j7IqT78mLrO0L5FQJTQ3xF4CJNYdkNvcJp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Bulie <radu-andrei.bulie@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/208] dpaa2-eth: Update dpni_get_single_step_cfg command
Date: Tue, 15 Jul 2025 15:13:49 +0200
Message-ID: <20250715130815.751585825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Bulie <radu-andrei.bulie@nxp.com>

[ Upstream commit 9572594ecf027a2b1828e42c26fb55cbd3219708 ]

dpni_get_single_step_cfg is an MC firmware command used for
retrieving the contents of SINGLE_STEP 1588 register available
in a DPMAC.

This patch adds a new version of this command that returns as an extra
argument the physical base address of the aforementioned register.
The address will be used to directly modify the contents of the
SINGLE_STEP register instead of invoking the MC command
dpni_set_single_step_cgf. The former approach introduced huge delays on
the TX datapath when one step PTP events were transmitted. This led to low
throughput and high latencies observed in the PTP correction field.

Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2def09ead4ad ("dpaa2-eth: fix xdp_rxq_info leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h | 6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.c     | 2 ++
 drivers/net/ethernet/freescale/dpaa2/dpni.h     | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 90453dc7baefe..a0dfd25c6bd4a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -94,7 +94,7 @@
 #define DPNI_CMDID_GET_LINK_CFG				DPNI_CMD(0x278)
 
 #define DPNI_CMDID_SET_SINGLE_STEP_CFG			DPNI_CMD(0x279)
-#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD(0x27a)
+#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD_V2(0x27a)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPNI_MASK(field)	\
@@ -654,12 +654,16 @@ struct dpni_cmd_single_step_cfg {
 	__le16 flags;
 	__le16 offset;
 	__le32 peer_delay;
+	__le32 ptp_onestep_reg_base;
+	__le32 pad0;
 };
 
 struct dpni_rsp_single_step_cfg {
 	__le16 flags;
 	__le16 offset;
 	__le32 peer_delay;
+	__le32 ptp_onestep_reg_base;
+	__le32 pad0;
 };
 
 #endif /* _FSL_DPNI_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 6ea7db66a6322..d248a40fbc3f8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -2037,6 +2037,8 @@ int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
 	ptp_cfg->ch_update = dpni_get_field(le16_to_cpu(rsp_params->flags),
 					    PTP_CH_UPDATE) ? 1 : 0;
 	ptp_cfg->peer_delay = le32_to_cpu(rsp_params->peer_delay);
+	ptp_cfg->ptp_onestep_reg_base =
+				  le32_to_cpu(rsp_params->ptp_onestep_reg_base);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index e7b9e195b534b..f854450983983 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1096,12 +1096,18 @@ int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
  * @peer_delay:	For peer-to-peer transparent clocks add this value to the
  *		correction field in addition to the transient time update.
  *		The value expresses nanoseconds.
+ * @ptp_onestep_reg_base: 1588 SINGLE_STEP register base address. This address
+ *			  is used to update directly the register contents.
+ *			  User has to create an address mapping for it.
+ *
+ *
  */
 struct dpni_single_step_cfg {
 	u8	en;
 	u8	ch_update;
 	u16	offset;
 	u32	peer_delay;
+	u32	ptp_onestep_reg_base;
 };
 
 int dpni_set_single_step_cfg(struct fsl_mc_io *mc_io,
-- 
2.39.5



