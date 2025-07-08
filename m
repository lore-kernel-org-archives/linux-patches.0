Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAB2DCF48;
	Tue,  8 Jul 2025 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994151; cv=none; b=rnKKUj2jsu70cU5tqYGFbtyPbfZpbxv5usLuMyA/G2Ow9m86tYt+k4k2DkuJGZPgCgkg6TcBvd/iN8V8qlpON/GSsv6IZOnGaCjFJzITOHmCASHvbiCm+h/x0v/Fq29UFuS4Z/X8MW1E+RfCHJw074pXa57KQeLD+QjUEefIMm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994151; c=relaxed/simple;
	bh=kPQJNN6zG8hk5Hzf8byaZCNlJc5gV+jgv8KUrPNf21M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN4ibd69pADvofPwg+alhdzdcS6N2i2Jz5YQq3dzBgk/srtuNEc2RthMC+WlOlTwQjR76VrxqQf4bXMY91pm0NdIN+EoxxADMTJ9XKFlZBsM0wjpW87Kc0fpFMrZNou/gJZCcP0uINot01oThSA6ofoJomkKdaTa2bH1AIy+dzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOrHGBMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOrHGBMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3612C4CEF5;
	Tue,  8 Jul 2025 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994151;
	bh=kPQJNN6zG8hk5Hzf8byaZCNlJc5gV+jgv8KUrPNf21M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOrHGBMc3lMTWzadt6Fnnh/i818GQqJ+mIfqGFY6fjYYnAnh6FaDNBukFdT6P2S5o
	 /RN7RpriXzQwyk6LypmI+KwFju3Bp0d6im1S3m6PXhu/ux63r9mdZs+BxEqto6YbLZ
	 PHy5tuBGJf245N9wI+O7ChEjwF+eKZzQ9anQl420=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Bulie <radu-andrei.bulie@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/160] dpaa2-eth: Update dpni_get_single_step_cfg command
Date: Tue,  8 Jul 2025 18:23:00 +0200
Message-ID: <20250708162235.315961124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f80bdfeedece..828f538097af8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -98,7 +98,7 @@
 #define DPNI_CMDID_GET_LINK_CFG				DPNI_CMD(0x278)
 
 #define DPNI_CMDID_SET_SINGLE_STEP_CFG			DPNI_CMD(0x279)
-#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD(0x27a)
+#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD_V2(0x27a)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPNI_MASK(field)	\
@@ -658,12 +658,16 @@ struct dpni_cmd_single_step_cfg {
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
 
 struct dpni_cmd_enable_vlan_filter {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index d6afada99fb66..6c3b36f20fb80 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -2136,6 +2136,8 @@ int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
 	ptp_cfg->ch_update = dpni_get_field(le16_to_cpu(rsp_params->flags),
 					    PTP_CH_UPDATE) ? 1 : 0;
 	ptp_cfg->peer_delay = le32_to_cpu(rsp_params->peer_delay);
+	ptp_cfg->ptp_onestep_reg_base =
+				  le32_to_cpu(rsp_params->ptp_onestep_reg_base);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 7de0562bbf59c..6fffd519aa00e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1074,12 +1074,18 @@ int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
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



