Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93BE230D2B;
	Mon, 10 Mar 2025 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627506; cv=none; b=CfKYutazARxW/gcszqAgw8gWA16KSChWB/pONT31Md4M226hXHfC3GbsQ/6R8GLKbj9yUubAXYU6c+F//XHHAQVb9Im2cLFhh24CbKpnxk33P/AMxE2gxlsZrVtfue81Z4iOQU865mzC3ljroKR7cXcoEGSGv817DwmT/UtlPsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627506; c=relaxed/simple;
	bh=I0iLzMlPIZbnLJOqxWciokRwf/45RgvVYmNxDaEhoBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0g+yWhO2Nc9E1St/WJmDPavBD1xfStbnp+cR4CwNSCnrdWSC75AkbmZ5hFi+gwvK0EUlV/jqgSSIzdsI+ZCk7Z25eKiXZtyLZ8hCuScxf7FlWw/ci7CNsjqtLuftxLhrk8NEpkrEmeGTUldozGl0YzouWMCxnschrLtBcZUzBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5b2eho+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5b2eho+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E32EC4CEE5;
	Mon, 10 Mar 2025 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627506;
	bh=I0iLzMlPIZbnLJOqxWciokRwf/45RgvVYmNxDaEhoBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5b2eho+B0FxMa5gRBOjD7ZlAtxbCZkdAFUfZN90/3aNiMwg856mCyQPScfW5nZIZ
	 qaXZsLlOK8bqvOb914FFP5NjyaWahUveDtTWNOgQe+ZkJYfF57DnC7bEGJO7sht7wC
	 zvm2sxraKgAGbASY6eNYmFphDiMxvnq9xUNHIkWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/269] wifi: iwlwifi: Fix A-MSDU TSO preparation
Date: Mon, 10 Mar 2025 18:04:58 +0100
Message-ID: <20250310170503.496875600@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 3640dbc1f75ce15d128ea4af44226960d894f3fd ]

The TSO preparation assumed that the skb head contained the headers
while the rest of the data was in the fragments. Since this is not
always true, e.g., it is possible that the data was linearised, modify
the TSO preparation to start the data processing after the network
headers.

Fixes: 7f5e3038f029 ("wifi: iwlwifi: map entire SKB when sending AMSDUs")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.75769a4769bf.Iaf79e8538093cdf8c446c292cc96164ad6498f61@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  5 +++--
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  5 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 20 +++++++++++--------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 27a7e0b5b3d51..ebe9b25cc53a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2003-2015, 2018-2024 Intel Corporation
+ * Copyright (C) 2003-2015, 2018-2025 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -643,7 +643,8 @@ dma_addr_t iwl_pcie_get_sgt_tb_phys(struct sg_table *sgt, unsigned int offset,
 				    unsigned int len);
 struct sg_table *iwl_pcie_prep_tso(struct iwl_trans *trans, struct sk_buff *skb,
 				   struct iwl_cmd_meta *cmd_meta,
-				   u8 **hdr, unsigned int hdr_room);
+				   u8 **hdr, unsigned int hdr_room,
+				   unsigned int offset);
 
 void iwl_pcie_free_tso_pages(struct iwl_trans *trans, struct sk_buff *skb,
 			     struct iwl_cmd_meta *cmd_meta);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 7bb74a480d7f1..477a05cd1288b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020, 2023-2024 Intel Corporation
+ * Copyright (C) 2018-2020, 2023-2025 Intel Corporation
  */
 #include <net/tso.h>
 #include <linux/tcp.h>
@@ -188,7 +188,8 @@ static int iwl_txq_gen2_build_amsdu(struct iwl_trans *trans,
 		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr));
 
 	/* Our device supports 9 segments at most, it will fit in 1 page */
-	sgt = iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room);
+	sgt = iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room,
+				snap_ip_tcp_hdrlen + hdr_len);
 	if (!sgt)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9fe050f0ddc16..a74ce5ccf59bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2021, 2023-2024 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2021, 2023-2025 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1853,6 +1853,7 @@ dma_addr_t iwl_pcie_get_sgt_tb_phys(struct sg_table *sgt, unsigned int offset,
  * @cmd_meta: command meta to store the scatter list information for unmapping
  * @hdr: output argument for TSO headers
  * @hdr_room: requested length for TSO headers
+ * @offset: offset into the data from which mapping should start
  *
  * Allocate space for a scatter gather list and TSO headers and map the SKB
  * using the scatter gather list. The SKB is unmapped again when the page is
@@ -1862,18 +1863,20 @@ dma_addr_t iwl_pcie_get_sgt_tb_phys(struct sg_table *sgt, unsigned int offset,
  */
 struct sg_table *iwl_pcie_prep_tso(struct iwl_trans *trans, struct sk_buff *skb,
 				   struct iwl_cmd_meta *cmd_meta,
-				   u8 **hdr, unsigned int hdr_room)
+				   u8 **hdr, unsigned int hdr_room,
+				   unsigned int offset)
 {
 	struct sg_table *sgt;
+	unsigned int n_segments;
 
 	if (WARN_ON_ONCE(skb_has_frag_list(skb)))
 		return NULL;
 
+	n_segments = DIV_ROUND_UP(skb->len - offset, skb_shinfo(skb)->gso_size);
 	*hdr = iwl_pcie_get_page_hdr(trans,
 				     hdr_room + __alignof__(struct sg_table) +
 				     sizeof(struct sg_table) +
-				     (skb_shinfo(skb)->nr_frags + 1) *
-				     sizeof(struct scatterlist),
+				     n_segments * sizeof(struct scatterlist),
 				     skb);
 	if (!*hdr)
 		return NULL;
@@ -1881,11 +1884,11 @@ struct sg_table *iwl_pcie_prep_tso(struct iwl_trans *trans, struct sk_buff *skb,
 	sgt = (void *)PTR_ALIGN(*hdr + hdr_room, __alignof__(struct sg_table));
 	sgt->sgl = (void *)(sgt + 1);
 
-	sg_init_table(sgt->sgl, skb_shinfo(skb)->nr_frags + 1);
+	sg_init_table(sgt->sgl, n_segments);
 
 	/* Only map the data, not the header (it is copied to the TSO page) */
-	sgt->orig_nents = skb_to_sgvec(skb, sgt->sgl, skb_headlen(skb),
-				       skb->data_len);
+	sgt->orig_nents = skb_to_sgvec(skb, sgt->sgl, offset,
+				       skb->len - offset);
 	if (WARN_ON_ONCE(sgt->orig_nents <= 0))
 		return NULL;
 
@@ -1937,7 +1940,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr)) + iv_len;
 
 	/* Our device supports 9 segments at most, it will fit in 1 page */
-	sgt = iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room);
+	sgt = iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room,
+				snap_ip_tcp_hdrlen + hdr_len + iv_len);
 	if (!sgt)
 		return -ENOMEM;
 
-- 
2.39.5



