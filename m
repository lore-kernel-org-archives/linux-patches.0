Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44B61170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D4DC433C7;
	Mon, 11 Sep 2023 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440802;
	bh=E31aYrD/5A04Z8Z662/aPgpCjXNkqAYynxLlvflrBrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWhn75fXTDeDnoYBNPt9S4y32IhkmThRfS82gAhq85PVS8ScLV9hip/OgD0Q3pfx1
	 2YTJUzwxHKrz+VVsgf6Anz3URAxOwPTbWvCBPL7CnX+FmhKk6znGdBdm2XrN+vGTX4
	 47p6LzAN/b6t6rVXcDvwQQnO+ygeBFvox+rjQ0Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 190/739] octeontx2-af: CN10KB: fix PFC configuration
Date: Mon, 11 Sep 2023 15:39:49 +0200
Message-ID: <20230911134656.500824091@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 47bcc9c1cf6aa60156c7532983090e86d9d171b6 ]

Suppose user has enabled pfc with prio 0,1 on a PF netdev(eth0)
	dcb pfc set dev eth0 prio-pfc o:on 1:on
later user enabled pfc priorities 2 and 3 on the VF interface(eth1)
	dcb pfc set dev eth1 prio-pfc 2:on 3:on

Instead of enabling pfc on all priorities (0..3), the driver only
enables on priorities 2,3. This patch corrects the issue by using
the proper CSR address.

Fixes: b9d0fedc6234 ("octeontx2-af: cn10kb: Add RPM_USX MAC support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230824081032.436432-3-sumang@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index b4fcb20c3f4fd..af21e2030cff2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -355,8 +355,8 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 
 void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 {
+	u64 cfg, pfc_class_mask_cfg;
 	rpm_t *rpm = rpmd;
-	u64 cfg;
 
 	/* ALL pause frames received are completely ignored */
 	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
@@ -380,9 +380,11 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 		rpm_write(rpm, 0, RPMX_CMR_CHAN_MSK_OR, ~0ULL);
 
 	/* Disable all PFC classes */
-	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
+	pfc_class_mask_cfg = is_dev_rpm2(rpm) ? RPM2_CMRX_PRT_CBFC_CTL :
+						RPMX_CMRX_PRT_CBFC_CTL;
+	cfg = rpm_read(rpm, lmac_id, pfc_class_mask_cfg);
 	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, 0, cfg);
-	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
+	rpm_write(rpm, lmac_id, pfc_class_mask_cfg, cfg);
 }
 
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
@@ -605,8 +607,11 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 p
 	if (!is_lmac_valid(rpm, lmac_id))
 		return -ENODEV;
 
+	pfc_class_mask_cfg = is_dev_rpm2(rpm) ? RPM2_CMRX_PRT_CBFC_CTL :
+						RPMX_CMRX_PRT_CBFC_CTL;
+
 	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-	class_en = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
+	class_en = rpm_read(rpm, lmac_id, pfc_class_mask_cfg);
 	pfc_en |= FIELD_GET(RPM_PFC_CLASS_MASK, class_en);
 
 	if (rx_pause) {
@@ -635,10 +640,6 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 p
 		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE;
 
 	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-	pfc_class_mask_cfg = is_dev_rpm2(rpm) ? RPM2_CMRX_PRT_CBFC_CTL :
-						RPMX_CMRX_PRT_CBFC_CTL;
-
 	rpm_write(rpm, lmac_id, pfc_class_mask_cfg, class_en);
 
 	return 0;
-- 
2.40.1



