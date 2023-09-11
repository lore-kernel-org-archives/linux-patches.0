Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA581171F
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAFAC433C8;
	Mon, 11 Sep 2023 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442701;
	bh=UOecShaOzp8JxMHSxaewzzFg4u99UawBaELI7VCEWLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUBXwo/cTGBZlgu6dYsAg8iqCYNDaYIES2PTqJzdWnCvUBuNe+jp9ICcRag13v1zh
	 e0cJDsTeWuiNNnrM4SW8/tG/7IQBhps10h4jYOpZz48dlm0wxspWRvPRpigjU5XUXy
	 iMczzvIT1MCwSPQvxy42RgReCJ0B+pfsP+TFUWH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Hilda Wu <hildawu@realtek.com>,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.4 091/737] Bluetooth: btrtl: Load FW v2 otherwise FW v1 for RTL8852C
Date: Mon, 11 Sep 2023 15:39:10 +0200
Message-ID: <20230911134653.048792279@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Chou <max.chou@realtek.com>

commit bd003fb338afee97c76f13c3e9144a7e4ad37179 upstream.

In this commit, prefer to load FW v2 if available. Fallback to FW v1
otherwise. This behavior is only for RTL8852C.

Fixes: 9a24ce5e29b1 ("Bluetooth: btrtl: Firmware format v2 support")
Cc: stable@vger.kernel.org
Suggested-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Tested-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[juergh: Adjusted context due to missing .hw_info struct element]
Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btrtl.c |   70 +++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 25 deletions(-)

--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -101,21 +101,21 @@ static const struct id_table ic_id_table
 	{ IC_INFO(RTL_ROM_LMP_8723A, 0xb, 0x6, HCI_USB),
 	  .config_needed = false,
 	  .has_rom_version = false,
-	  .fw_name = "rtl_bt/rtl8723a_fw.bin",
+	  .fw_name = "rtl_bt/rtl8723a_fw",
 	  .cfg_name = NULL },
 
 	/* 8723BS */
 	{ IC_INFO(RTL_ROM_LMP_8723B, 0xb, 0x6, HCI_UART),
 	  .config_needed = true,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723bs_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723bs_fw",
 	  .cfg_name = "rtl_bt/rtl8723bs_config" },
 
 	/* 8723B */
 	{ IC_INFO(RTL_ROM_LMP_8723B, 0xb, 0x6, HCI_USB),
 	  .config_needed = false,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723b_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723b_fw",
 	  .cfg_name = "rtl_bt/rtl8723b_config" },
 
 	/* 8723CS-CG */
@@ -126,7 +126,7 @@ static const struct id_table ic_id_table
 	  .hci_bus = HCI_UART,
 	  .config_needed = true,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723cs_cg_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723cs_cg_fw",
 	  .cfg_name = "rtl_bt/rtl8723cs_cg_config" },
 
 	/* 8723CS-VF */
@@ -137,7 +137,7 @@ static const struct id_table ic_id_table
 	  .hci_bus = HCI_UART,
 	  .config_needed = true,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723cs_vf_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723cs_vf_fw",
 	  .cfg_name = "rtl_bt/rtl8723cs_vf_config" },
 
 	/* 8723CS-XX */
@@ -148,28 +148,28 @@ static const struct id_table ic_id_table
 	  .hci_bus = HCI_UART,
 	  .config_needed = true,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723cs_xx_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723cs_xx_fw",
 	  .cfg_name = "rtl_bt/rtl8723cs_xx_config" },
 
 	/* 8723D */
 	{ IC_INFO(RTL_ROM_LMP_8723B, 0xd, 0x8, HCI_USB),
 	  .config_needed = true,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723d_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723d_fw",
 	  .cfg_name = "rtl_bt/rtl8723d_config" },
 
 	/* 8723DS */
 	{ IC_INFO(RTL_ROM_LMP_8723B, 0xd, 0x8, HCI_UART),
 	  .config_needed = true,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8723ds_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8723ds_fw",
 	  .cfg_name = "rtl_bt/rtl8723ds_config" },
 
 	/* 8821A */
 	{ IC_INFO(RTL_ROM_LMP_8821A, 0xa, 0x6, HCI_USB),
 	  .config_needed = false,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8821a_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8821a_fw",
 	  .cfg_name = "rtl_bt/rtl8821a_config" },
 
 	/* 8821C */
@@ -177,7 +177,7 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8821c_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8821c_fw",
 	  .cfg_name = "rtl_bt/rtl8821c_config" },
 
 	/* 8821CS */
@@ -185,14 +185,14 @@ static const struct id_table ic_id_table
 	  .config_needed = true,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8821cs_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8821cs_fw",
 	  .cfg_name = "rtl_bt/rtl8821cs_config" },
 
 	/* 8761A */
 	{ IC_INFO(RTL_ROM_LMP_8761A, 0xa, 0x6, HCI_USB),
 	  .config_needed = false,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8761a_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8761a_fw",
 	  .cfg_name = "rtl_bt/rtl8761a_config" },
 
 	/* 8761B */
@@ -200,14 +200,14 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8761b_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8761b_fw",
 	  .cfg_name = "rtl_bt/rtl8761b_config" },
 
 	/* 8761BU */
 	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
 	  .config_needed = false,
 	  .has_rom_version = true,
-	  .fw_name  = "rtl_bt/rtl8761bu_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8761bu_fw",
 	  .cfg_name = "rtl_bt/rtl8761bu_config" },
 
 	/* 8822C with UART interface */
@@ -215,7 +215,7 @@ static const struct id_table ic_id_table
 	  .config_needed = true,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8822cs_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8822cs_fw",
 	  .cfg_name = "rtl_bt/rtl8822cs_config" },
 
 	/* 8822C with UART interface */
@@ -223,7 +223,7 @@ static const struct id_table ic_id_table
 	  .config_needed = true,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8822cs_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8822cs_fw",
 	  .cfg_name = "rtl_bt/rtl8822cs_config" },
 
 	/* 8822C with USB interface */
@@ -231,7 +231,7 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8822cu_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8822cu_fw",
 	  .cfg_name = "rtl_bt/rtl8822cu_config" },
 
 	/* 8822B */
@@ -239,7 +239,7 @@ static const struct id_table ic_id_table
 	  .config_needed = true,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8822b_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8822b_fw",
 	  .cfg_name = "rtl_bt/rtl8822b_config" },
 
 	/* 8852A */
@@ -247,7 +247,7 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8852au_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8852au_fw",
 	  .cfg_name = "rtl_bt/rtl8852au_config" },
 
 	/* 8852B with UART interface */
@@ -255,7 +255,7 @@ static const struct id_table ic_id_table
 	  .config_needed = true,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8852bs_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8852bs_fw",
 	  .cfg_name = "rtl_bt/rtl8852bs_config" },
 
 	/* 8852B */
@@ -263,7 +263,7 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8852bu_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8852bu_fw",
 	  .cfg_name = "rtl_bt/rtl8852bu_config" },
 
 	/* 8852C */
@@ -271,7 +271,7 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = true,
-	  .fw_name  = "rtl_bt/rtl8852cu_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8852cu_fw",
 	  .cfg_name = "rtl_bt/rtl8852cu_config" },
 
 	/* 8851B */
@@ -279,7 +279,7 @@ static const struct id_table ic_id_table
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .has_msft_ext = false,
-	  .fw_name  = "rtl_bt/rtl8851bu_fw.bin",
+	  .fw_name  = "rtl_bt/rtl8851bu_fw",
 	  .cfg_name = "rtl_bt/rtl8851bu_config" },
 	};
 
@@ -967,6 +967,7 @@ struct btrtl_device_info *btrtl_initiali
 	struct btrtl_device_info *btrtl_dev;
 	struct sk_buff *skb;
 	struct hci_rp_read_local_version *resp;
+	char fw_name[40];
 	char cfg_name[40];
 	u16 hci_rev, lmp_subver;
 	u8 hci_ver, lmp_ver, chip_type = 0;
@@ -1079,8 +1080,26 @@ next:
 			goto err_free;
 	}
 
-	btrtl_dev->fw_len = rtl_load_file(hdev, btrtl_dev->ic_info->fw_name,
-					  &btrtl_dev->fw_data);
+	if (!btrtl_dev->ic_info->fw_name) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	btrtl_dev->fw_len = -EIO;
+	if (lmp_subver == RTL_ROM_LMP_8852A && hci_rev == 0x000c) {
+		snprintf(fw_name, sizeof(fw_name), "%s_v2.bin",
+				btrtl_dev->ic_info->fw_name);
+		btrtl_dev->fw_len = rtl_load_file(hdev, fw_name,
+				&btrtl_dev->fw_data);
+	}
+
+	if (btrtl_dev->fw_len < 0) {
+		snprintf(fw_name, sizeof(fw_name), "%s.bin",
+				btrtl_dev->ic_info->fw_name);
+		btrtl_dev->fw_len = rtl_load_file(hdev, fw_name,
+				&btrtl_dev->fw_data);
+	}
+
 	if (btrtl_dev->fw_len < 0) {
 		rtl_dev_err(hdev, "firmware file %s not found",
 			    btrtl_dev->ic_info->fw_name);
@@ -1382,6 +1401,7 @@ MODULE_FIRMWARE("rtl_bt/rtl8852bs_config
 MODULE_FIRMWARE("rtl_bt/rtl8852bu_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852bu_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852cu_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8852cu_fw_v2.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852cu_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8851bu_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8851bu_config.bin");


