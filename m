Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E7619CCF2;
	Thu,  6 Jun 2024 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683425; cv=none; b=RWkKZb6gIwwv6iuUxYt8YbogBHNqtbdyeBOPuW5BFTUh7w8jJEjy2hw0yR2VneQ4taUUAQbYVSL4HXAFBLbmoE/0rVrRi6PCILsJxkabmsngLiBuU/O8El630zQgAzYdr9t/P98YDSLvz3uE/vac4GDN1ExyJ/z4DnxLNOnjUPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683425; c=relaxed/simple;
	bh=0zGKNS01tMtbP4vlQNS4BuRYGlEDshbOnrHYsrbc3h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alNd9GMElWDeJNiPCwRMdzrAM0/3cN0ptF2Iwcdx/8MO3Kfpvxs4vQ213jc1MfEL3Ilirzupu07a8QJ39IRQLVVHqS5LUN47cHB0GMCo0Zvi159N0PbW+siA5wVBLvm8WhKR2aTAutc1ZelNitkK+pUHRWnFlqUYwaRMRVz8V6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qT/haFmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qT/haFmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E4C32781;
	Thu,  6 Jun 2024 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683425;
	bh=0zGKNS01tMtbP4vlQNS4BuRYGlEDshbOnrHYsrbc3h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT/haFmq00gffhbiBeZo+QJ1LvTXPoy03YP46VZT0unq58chj/tKbdFhe/wAvOhbF
	 5zwt/uMqeFQY9ZH+j3fb8/DvlrByqIDDj32R5GteotmnS+heEU9ykESkGgBwcVGu+U
	 yTmulaLcM/7D5SEQxyEMUt1R4xye+8f3iWI+CBM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 370/744] RDMA/bnxt_re: Update the HW interface definitions
Date: Thu,  6 Jun 2024 16:00:42 +0200
Message-ID: <20240606131744.358660785@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 880a5dd1880a296575e92dec9816a7f35a7011d1 ]

Adds HW interface definitions to support the new
chip revision.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1701946060-13931-4-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 78cfd17142ef ("bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/roce_hsi.h | 67 ++++++++++++++++++++----
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index 4a10303e03925..2909608f4b5de 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -555,7 +555,12 @@ struct cmdq_modify_qp {
 	__le16	flags;
 	__le16	cookie;
 	u8	resp_size;
-	u8	reserved8;
+	u8	qp_type;
+	#define CMDQ_MODIFY_QP_QP_TYPE_RC            0x2UL
+	#define CMDQ_MODIFY_QP_QP_TYPE_UD            0x4UL
+	#define CMDQ_MODIFY_QP_QP_TYPE_RAW_ETHERTYPE 0x6UL
+	#define CMDQ_MODIFY_QP_QP_TYPE_GSI           0x7UL
+	#define CMDQ_MODIFY_QP_QP_TYPE_LAST         CMDQ_MODIFY_QP_QP_TYPE_GSI
 	__le64	resp_addr;
 	__le32	modify_mask;
 	#define CMDQ_MODIFY_QP_MODIFY_MASK_STATE                   0x1UL
@@ -611,14 +616,12 @@ struct cmdq_modify_qp {
 	#define CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV6  (0x3UL << 6)
 	#define CMDQ_MODIFY_QP_NETWORK_TYPE_LAST        CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV6
 	u8	access;
-	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC_REMOTE_READ_REMOTE_WRITE_LOCAL_WRITE_MASK \
-		0xffUL
-	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC_REMOTE_READ_REMOTE_WRITE_LOCAL_WRITE_SFT	\
-		0
-	#define CMDQ_MODIFY_QP_ACCESS_LOCAL_WRITE	0x1UL
-	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_WRITE	0x2UL
-	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_READ	0x4UL
-	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC	0x8UL
+	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC_REMOTE_READ_REMOTE_WRITE_LOCAL_WRITE_MASK 0xffUL
+	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC_REMOTE_READ_REMOTE_WRITE_LOCAL_WRITE_SFT 0
+	#define CMDQ_MODIFY_QP_ACCESS_LOCAL_WRITE   0x1UL
+	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_WRITE  0x2UL
+	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_READ   0x4UL
+	#define CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC 0x8UL
 	__le16	pkey;
 	__le32	qkey;
 	__le32	dgid[4];
@@ -673,6 +676,13 @@ struct cmdq_modify_qp {
 	#define CMDQ_MODIFY_QP_VLAN_PCP_SFT 13
 	__le64	irrq_addr;
 	__le64	orrq_addr;
+	__le32	ext_modify_mask;
+	#define CMDQ_MODIFY_QP_EXT_MODIFY_MASK_EXT_STATS_CTX     0x1UL
+	#define CMDQ_MODIFY_QP_EXT_MODIFY_MASK_SCHQ_ID_VALID     0x2UL
+	__le32	ext_stats_ctx_id;
+	__le16	schq_id;
+	__le16	unused_0;
+	__le32	reserved32;
 };
 
 /* creq_modify_qp_resp (size:128b/16B) */
@@ -3017,6 +3027,17 @@ struct sq_psn_search_ext {
 	__le32	reserved32;
 };
 
+/* sq_msn_search (size:64b/8B) */
+struct sq_msn_search {
+	__le64	start_idx_next_psn_start_psn;
+	#define SQ_MSN_SEARCH_START_PSN_MASK 0xffffffUL
+	#define SQ_MSN_SEARCH_START_PSN_SFT 0
+	#define SQ_MSN_SEARCH_NEXT_PSN_MASK 0xffffff000000ULL
+	#define SQ_MSN_SEARCH_NEXT_PSN_SFT  24
+	#define SQ_MSN_SEARCH_START_IDX_MASK 0xffff000000000000ULL
+	#define SQ_MSN_SEARCH_START_IDX_SFT 48
+};
+
 /* sq_send (size:1024b/128B) */
 struct sq_send {
 	u8	wqe_type;
@@ -3705,13 +3726,35 @@ struct cq_base {
 	#define CQ_BASE_CQE_TYPE_RES_UD          (0x2UL << 1)
 	#define CQ_BASE_CQE_TYPE_RES_RAWETH_QP1  (0x3UL << 1)
 	#define CQ_BASE_CQE_TYPE_RES_UD_CFA      (0x4UL << 1)
+	#define CQ_BASE_CQE_TYPE_REQ_V3             (0x8UL << 1)
+	#define CQ_BASE_CQE_TYPE_RES_RC_V3          (0x9UL << 1)
+	#define CQ_BASE_CQE_TYPE_RES_UD_V3          (0xaUL << 1)
+	#define CQ_BASE_CQE_TYPE_RES_RAWETH_QP1_V3  (0xbUL << 1)
+	#define CQ_BASE_CQE_TYPE_RES_UD_CFA_V3      (0xcUL << 1)
 	#define CQ_BASE_CQE_TYPE_NO_OP           (0xdUL << 1)
 	#define CQ_BASE_CQE_TYPE_TERMINAL        (0xeUL << 1)
 	#define CQ_BASE_CQE_TYPE_CUT_OFF         (0xfUL << 1)
 	#define CQ_BASE_CQE_TYPE_LAST           CQ_BASE_CQE_TYPE_CUT_OFF
 	u8	status;
+	#define CQ_BASE_STATUS_OK                         0x0UL
+	#define CQ_BASE_STATUS_BAD_RESPONSE_ERR           0x1UL
+	#define CQ_BASE_STATUS_LOCAL_LENGTH_ERR           0x2UL
+	#define CQ_BASE_STATUS_HW_LOCAL_LENGTH_ERR        0x3UL
+	#define CQ_BASE_STATUS_LOCAL_QP_OPERATION_ERR     0x4UL
+	#define CQ_BASE_STATUS_LOCAL_PROTECTION_ERR       0x5UL
+	#define CQ_BASE_STATUS_LOCAL_ACCESS_ERROR         0x6UL
+	#define CQ_BASE_STATUS_MEMORY_MGT_OPERATION_ERR   0x7UL
+	#define CQ_BASE_STATUS_REMOTE_INVALID_REQUEST_ERR 0x8UL
+	#define CQ_BASE_STATUS_REMOTE_ACCESS_ERR          0x9UL
+	#define CQ_BASE_STATUS_REMOTE_OPERATION_ERR       0xaUL
+	#define CQ_BASE_STATUS_RNR_NAK_RETRY_CNT_ERR      0xbUL
+	#define CQ_BASE_STATUS_TRANSPORT_RETRY_CNT_ERR    0xcUL
+	#define CQ_BASE_STATUS_WORK_REQUEST_FLUSHED_ERR   0xdUL
+	#define CQ_BASE_STATUS_HW_FLUSH_ERR               0xeUL
+	#define CQ_BASE_STATUS_OVERFLOW_ERR               0xfUL
+	#define CQ_BASE_STATUS_LAST                      CQ_BASE_STATUS_OVERFLOW_ERR
 	__le16	reserved16;
-	__le32	reserved32;
+	__le32	opaque;
 };
 
 /* cq_req (size:256b/32B) */
@@ -4326,6 +4369,8 @@ struct cq_cutoff {
 	#define CQ_CUTOFF_CQE_TYPE_SFT    1
 	#define CQ_CUTOFF_CQE_TYPE_CUT_OFF  (0xfUL << 1)
 	#define CQ_CUTOFF_CQE_TYPE_LAST    CQ_CUTOFF_CQE_TYPE_CUT_OFF
+	#define CQ_CUTOFF_RESIZE_TOGGLE_MASK 0x60UL
+	#define CQ_CUTOFF_RESIZE_TOGGLE_SFT 5
 	u8	status;
 	#define CQ_CUTOFF_STATUS_OK 0x0UL
 	#define CQ_CUTOFF_STATUS_LAST CQ_CUTOFF_STATUS_OK
@@ -4377,6 +4422,8 @@ struct nq_srq_event {
 	#define NQ_SRQ_EVENT_TYPE_SFT      0
 	#define NQ_SRQ_EVENT_TYPE_SRQ_EVENT  0x32UL
 	#define NQ_SRQ_EVENT_TYPE_LAST      NQ_SRQ_EVENT_TYPE_SRQ_EVENT
+	#define NQ_SRQ_EVENT_TOGGLE_MASK   0xc0UL
+	#define NQ_SRQ_EVENT_TOGGLE_SFT    6
 	u8	event;
 	#define NQ_SRQ_EVENT_EVENT_SRQ_THRESHOLD_EVENT 0x1UL
 	#define NQ_SRQ_EVENT_EVENT_LAST               NQ_SRQ_EVENT_EVENT_SRQ_THRESHOLD_EVENT
-- 
2.43.0



