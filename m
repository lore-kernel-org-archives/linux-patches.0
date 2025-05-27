Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D761642A9B;
	Tue, 27 May 2025 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367646; cv=none; b=DbUlUM8/72gASqbwwZVChdfTmt9XLkcCbE0bFmzFpaiIFXAsOi+s3vp3JqtEosw+4T58I0BqABgCUKHaL9de+a1cPqonDNmy76TLGvI8zo1+NGOmHDjKNYCzIx4bOtVx8iqiHZBE1Cc1YlWMoCLkRq4/XH00OKsdPm3+Lu+/nQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367646; c=relaxed/simple;
	bh=FUMHNKFiqWWGnNVTw3gD+4KzixZdz9Tr2mn0mDqc/MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3N931ercNm7jor0XCq3y5QNwtgro5MRzPmLCuUNZhuJ9Y81YLMd61nhrt38bGj5huaqytkAKQ8gFwzL1gWNu8+QJEysj24FI5HNVGifzLkTx+A7Q/BP0TzqJYOKWIWPOpcgHPOGWSWSpSraPyCIS4HWMKJnq/R3FRLZkxbbQRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0J1d/clQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0J1d/clQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C71C4CEE9;
	Tue, 27 May 2025 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367645;
	bh=FUMHNKFiqWWGnNVTw3gD+4KzixZdz9Tr2mn0mDqc/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0J1d/clQe7oxHOXPRmR14bEc886VztXkGLaez6gQsLVRKrBspBT+ZyFbpRSI4k9Be
	 MHsHliQZggNqsPaOjagPXMuL5sk2cQUaY1w45yinUhBYnUB4BiL5uKnitALSyl8fgo
	 7RSPdEt0zPGXJviMRJ1TgfXi8g5Jy1T3RgNCLDbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 454/783] bnxt_en: Set NPAR 1.2 support when registering with firmware
Date: Tue, 27 May 2025 18:24:11 +0200
Message-ID: <20250527162531.613800398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit ebdf7fe488c512b18add66b6c26e11e4d3830213 ]

NPAR (Network interface card partitioning)[1] 1.2 adds a transparent
VLAN tag for all packets between the NIC and the switch.  Because of
that, RX VLAN acceleration cannot be supported for any additional
host configured VLANs.  The driver has to acknowledge that it can
support no RX VLAN acceleration and set the NPAR 1.2 supported flag
when registering with the FW.  Otherwise, the FW call will fail and
the driver will abort on these NPAR 1.2 NICs with this error:

bnxt_en 0000:26:00.0 (unnamed net_device) (uninitialized): hwrm req_type 0x1d seq id 0xb error 0x2

[1] https://techdocs.broadcom.com/us/en/storage-and-ethernet-connectivity/ethernet-nic-controllers/bcm957xxx/adapters/introduction/features/network-partitioning-npar.html

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250213011240.1640031-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1a19c922009d1..d844cf621dd23 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5589,6 +5589,8 @@ int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap, int bmap_size,
 	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
 		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT |
 			 FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT;
+	if (bp->fw_cap & BNXT_FW_CAP_NPAR_1_2)
+		flags |= FUNC_DRV_RGTR_REQ_FLAGS_NPAR_1_2_SUPPORT;
 	req->flags = cpu_to_le32(flags);
 	req->ver_maj_8b = DRV_VER_MAJ;
 	req->ver_min_8b = DRV_VER_MIN;
@@ -8389,6 +8391,7 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 
 	switch (resp->port_partition_type) {
 	case FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_0:
+	case FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_2:
 	case FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_5:
 	case FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR2_0:
 		bp->port_partition_type = resp->port_partition_type;
@@ -9553,6 +9556,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET_IF;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED))
 		bp->fw_cap |= BNXT_FW_CAP_LIVEPATCH;
+	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_NPAR_1_2_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_NPAR_1_2;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_DFLT_VLAN_TPID_PCP_SUPPORTED))
 		bp->fw_cap |= BNXT_FW_CAP_DFLT_VLAN_TPID_PCP;
 	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_BS_V2_SUPPORTED)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d621fb621f30c..f91d9d8eacb97 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2498,6 +2498,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V3	BIT_ULL(39)
 	#define BNXT_FW_CAP_VNIC_RE_FLUSH		BIT_ULL(40)
 	#define BNXT_FW_CAP_SW_MAX_RESOURCE_LIMITS	BIT_ULL(41)
+	#define BNXT_FW_CAP_NPAR_1_2			BIT_ULL(42)
 
 	u32			fw_dbg_cap;
 
-- 
2.39.5



