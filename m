Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C4833F5A7;
	Sat, 12 Sep 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223388; cv=none; b=OYmh+H4EibIn3G6TG+P/GvEbXYOTYXjUvzr2K1D1FZgCL+NFxgixBSCoBcbNntgVw/AGQJcIfij+tn2UZZVHnwxMlfnNNFd6+0aOvxUPFplD906IjGnjfYy6ROk2c2TyvCeyJXZAzPGOo/Og9Hh6fppO6mHO4QDBUWDwl7Wez8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223388; c=relaxed/simple;
	bh=wKy28/wiA/A4FbMgvb/uogf8Cg31CczDzRvQQ9oPl+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuLwR5sVzvXwZNZDEq76NEtQ2ux7uxcaDJn8WWb8e15N4tCnFg7yQX6LiY2gM7VinFlb+ul6QWX1Psco4hVsl1hh6Gjl9aOuRwxMkiVxCge7wNQCo8/3IrtANQL+c7ru/4IFhHdGdr5UrPbChRjbpfX6hutqQZdFioMD+GYw08s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzAkPfdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzAkPfdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A031F000FF;
	Sat, 12 Sep 2026 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223386;
	bh=Qn9trSwUKv/Sc5bl+S93MmGn2B5HYB0766P3HVTYnZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzAkPfdHl6fWrlxBBt6evUeum7B6wtc7wEHv/sDVw32tqHoiov5Q/ackQn9MofxK0
	 SqIHV78qbNRchtzUIIfs7x8jKuJQeH0RAAApMKyskqBdmjKcxVZg6lKkahx3QzPYYk
	 7sriyMR8LyLvuBHGIrGaEQFgd+d4y8sTjKq0aY2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0780/1424] wifi: iwlwifi: mei: add support for SAP version 4
Date: Sat, 12 Sep 2026 08:53:32 +0200
Message-ID: <20260912065624.765613534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 27c8f12e972d3647e9d759d7cafd4c34fa513432 ]

SAP version 4 uses larger Host to MEI notification queue.
Since it is unknown which SAP version is used by the CSME firmware
when the driver loads, try version 4 first. In case the CSME firmware
uses version 3, the memory allocation will fail. In this case the
driver will try again to allocate the memory for version 3.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.8372e040282f.Ia0085784e08a35159c9293f986c3d2774038f4c4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 7d8cc301bcba ("wifi: iwlwifi: mei: check SAP message length before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mei/iwl-mei.h  | 10 ++++
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 58 ++++++++++++++-----
 2 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h b/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
index 655d95d3a068a..19a0bb93aee7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
+++ b/drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
@@ -283,6 +283,16 @@ struct iwl_mei_colloc_info {
 	u8 bssid[ETH_ALEN];
 };
 
+/**
+ * enum iwl_mei_sap_version - SAP version
+ * @IWL_MEI_SAP_VERSION_3: SAP version 3
+ * @IWL_MEI_SAP_VERSION_4: SAP version 4
+ */
+enum iwl_mei_sap_version {
+	IWL_MEI_SAP_VERSION_3 = 3,
+	IWL_MEI_SAP_VERSION_4 = 4,
+};
+
 /*
  * struct iwl_mei_ops - driver's operations called by iwlmei
  * Operations will not be called more than once concurrently.
diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 1dd9106c65136..dce0b7cf7b265 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2021-2023 Intel Corporation
+ * Copyright (C) 2021-2024 Intel Corporation
  */
 
 #include <linux/etherdevice.h>
@@ -58,7 +58,6 @@ bool iwl_mei_is_connected(void)
 }
 EXPORT_SYMBOL_GPL(iwl_mei_is_connected);
 
-#define SAP_VERSION	3
 #define SAP_CONTROL_BLOCK_ID 0x21504153 /* SAP! in ASCII */
 
 struct iwl_sap_q_ctrl_blk {
@@ -110,16 +109,19 @@ struct iwl_sap_shared_mem_ctrl_blk {
 
 #define SAP_H2M_DATA_Q_SZ	48256
 #define SAP_M2H_DATA_Q_SZ	24128
-#define SAP_H2M_NOTIF_Q_SZ	2240
+#define SAP_H2M_NOTIF_Q_SZ_VER3	2240
+#define SAP_H2M_NOTIF_Q_SZ_VER4	32768
 #define SAP_M2H_NOTIF_Q_SZ	62720
 
-#define _IWL_MEI_SAP_SHARED_MEM_SZ \
+#define _IWL_MEI_SAP_SHARED_MEM_SZ_VER3 \
 	(sizeof(struct iwl_sap_shared_mem_ctrl_blk) + \
-	 SAP_H2M_DATA_Q_SZ + SAP_H2M_NOTIF_Q_SZ + \
+	 SAP_H2M_DATA_Q_SZ + SAP_H2M_NOTIF_Q_SZ_VER3 + \
 	 SAP_M2H_DATA_Q_SZ + SAP_M2H_NOTIF_Q_SZ + 4)
 
-#define IWL_MEI_SAP_SHARED_MEM_SZ \
-	(roundup(_IWL_MEI_SAP_SHARED_MEM_SZ, PAGE_SIZE))
+#define _IWL_MEI_SAP_SHARED_MEM_SZ_VER4 \
+	(sizeof(struct iwl_sap_shared_mem_ctrl_blk) + \
+	 SAP_H2M_DATA_Q_SZ + SAP_H2M_NOTIF_Q_SZ_VER4 + \
+	 SAP_M2H_DATA_Q_SZ + SAP_M2H_NOTIF_Q_SZ + 4)
 
 struct iwl_mei_shared_mem_ptrs {
 	struct iwl_sap_shared_mem_ctrl_blk *ctrl;
@@ -206,6 +208,7 @@ struct iwl_mei {
  * @mac_address: interface MAC address.
  * @nvm_address: NVM MAC address.
  * @priv: A pointer to iwlwifi.
+ * @sap_version: The SAP version to use. enum iwl_mei_sap_version.
  *
  * This used to cache the configurations coming from iwlwifi's way. The data
  * is cached here so that we can buffer the configuration even if we don't have
@@ -220,6 +223,7 @@ struct iwl_mei_cache {
 	u16 mcc;
 	u8 mac_address[6];
 	u8 nvm_address[6];
+	enum iwl_mei_sap_version sap_version;
 	void *priv;
 };
 
@@ -238,14 +242,17 @@ static void iwl_mei_free_shared_mem(struct mei_cl_device *cldev)
 
 #define HBM_DMA_BUF_ID_WLAN 1
 
-static int iwl_mei_alloc_shared_mem(struct mei_cl_device *cldev)
+static int iwl_mei_alloc_mem_for_version(struct mei_cl_device *cldev,
+					 enum iwl_mei_sap_version version)
 {
 	struct iwl_mei *mei = mei_cldev_get_drvdata(cldev);
 	struct iwl_mei_shared_mem_ptrs *mem = &mei->shared_mem;
+	u32 mem_size = roundup(version == IWL_MEI_SAP_VERSION_4 ?
+			       _IWL_MEI_SAP_SHARED_MEM_SZ_VER4 :
+			       _IWL_MEI_SAP_SHARED_MEM_SZ_VER3, PAGE_SIZE);
 
-	mem->ctrl = mei_cldev_dma_map(cldev, HBM_DMA_BUF_ID_WLAN,
-				       IWL_MEI_SAP_SHARED_MEM_SZ);
-
+	iwl_mei_cache.sap_version = version;
+	mem->ctrl = mei_cldev_dma_map(cldev, HBM_DMA_BUF_ID_WLAN, mem_size);
 	if (IS_ERR(mem->ctrl)) {
 		int ret = PTR_ERR(mem->ctrl);
 
@@ -254,11 +261,30 @@ static int iwl_mei_alloc_shared_mem(struct mei_cl_device *cldev)
 		return ret;
 	}
 
-	memset(mem->ctrl, 0, IWL_MEI_SAP_SHARED_MEM_SZ);
+	memset(mem->ctrl, 0, mem_size);
 
 	return 0;
 }
 
+static int iwl_mei_alloc_shared_mem(struct mei_cl_device *cldev)
+{
+	int ret;
+
+	/*
+	 * SAP version 4 uses a larger Host to MEI notif queue.
+	 * Since it is unknown at this stage which SAP version is used by the
+	 * CSME firmware on this platform, try to allocate the version 4 first.
+	 * If the CSME firmware uses version 3, this allocation is expected to
+	 * fail because the CSME firmware allocated less memory for our driver.
+	 */
+	ret = iwl_mei_alloc_mem_for_version(cldev, IWL_MEI_SAP_VERSION_4);
+	if (ret)
+		ret = iwl_mei_alloc_mem_for_version(cldev,
+						    IWL_MEI_SAP_VERSION_3);
+
+	return ret;
+}
+
 static void iwl_mei_init_shared_mem(struct iwl_mei *mei)
 {
 	struct iwl_mei_shared_mem_ptrs *mem = &mei->shared_mem;
@@ -277,7 +303,9 @@ static void iwl_mei_init_shared_mem(struct iwl_mei *mei)
 	h2m->q_ctrl_blk[SAP_QUEUE_IDX_DATA].size =
 		cpu_to_le32(SAP_H2M_DATA_Q_SZ);
 	h2m->q_ctrl_blk[SAP_QUEUE_IDX_NOTIF].size =
-		cpu_to_le32(SAP_H2M_NOTIF_Q_SZ);
+		iwl_mei_cache.sap_version == IWL_MEI_SAP_VERSION_3 ?
+		cpu_to_le32(SAP_H2M_NOTIF_Q_SZ_VER3) :
+		cpu_to_le32(SAP_H2M_NOTIF_Q_SZ_VER4);
 	m2h->q_ctrl_blk[SAP_QUEUE_IDX_DATA].size =
 		cpu_to_le32(SAP_M2H_DATA_Q_SZ);
 	m2h->q_ctrl_blk[SAP_QUEUE_IDX_NOTIF].size =
@@ -647,7 +675,7 @@ iwl_mei_handle_rx_start_ok(struct mei_cl_device *cldev,
 		return;
 	}
 
-	if (rsp->supported_version != SAP_VERSION) {
+	if (rsp->supported_version != iwl_mei_cache.sap_version) {
 		dev_err(&cldev->dev,
 			"didn't get the expected version: got %d\n",
 			rsp->supported_version);
@@ -1281,7 +1309,7 @@ static int iwl_mei_send_start(struct mei_cl_device *cldev)
 		.hdr.type = cpu_to_le32(SAP_ME_MSG_START),
 		.hdr.seq_num = cpu_to_le32(atomic_inc_return(&mei->seq_no)),
 		.hdr.len = cpu_to_le32(sizeof(msg)),
-		.supported_versions[0] = SAP_VERSION,
+		.supported_versions[0] = iwl_mei_cache.sap_version,
 		.init_data_seq_num = cpu_to_le16(0x100),
 		.init_notif_seq_num = cpu_to_le16(0x800),
 	};
-- 
2.53.0



