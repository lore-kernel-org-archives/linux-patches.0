Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6963328F6;
	Thu, 20 Nov 2025 12:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763640546; cv=none; b=RzvpUYL2fep7yGDlQT2IIv92piJw69dJiAYYI7I+f4z8vVZhPLhSsctYLj9CpHbFZJy/CaSh1jAv56MzGxgMm1bUNDKclQEgMGpcEGt+gEJBvNZvEKzfQdPWQEM0ZNHr6RkxU1UOD0aIxBRSDIDBwSG76MpAsoMeoYJSXrSybvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763640546; c=relaxed/simple;
	bh=/2p2ILd/7NDc2viIoyOdRtNZ0j3kKPoiUHLvMIp8aHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJp/N77BbcLXmo4a7tj+KV82m7LzLr0ohQkcYfDXkxKnePJcCovlBKHlvphwP4qEYLl+xMjzH+cM3Vh+AN9UN7vDtw0fLYLsOsVoYM5eLTD+3IzWI0g3cvsZRXC8YiXYwP3BVKar40LsuHwAcb35SVRs11blXIIS/bK+4cBAXs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMTr/fic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMTr/fic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D503C116B1;
	Thu, 20 Nov 2025 12:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763640546;
	bh=/2p2ILd/7NDc2viIoyOdRtNZ0j3kKPoiUHLvMIp8aHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMTr/fica/oqN5K3MO9d6rBFcv4DgIfJ02PqPKA6FtG7C/MvHoFCkwiBGy0jihCPk
	 e91Ybg3zmpUU37lmiIQNpxtpa8xXyB7RsHlKdxs4YILNXdmw3qSYZl65uIqnn9GLnO
	 f4Vg3gU3Rphe5XrjIZFxXjkz58oC7hanoDpzoX2H/PJjGJFSRp0aNgbAdKaZkfGzB1
	 /zobSQz0GUpwRRR110IpaQUPNn2Sp2FqCUbD2D5EzAK9kQANI1hZI+G+IRkZYbmhv7
	 j31L5JaeYoRAychNQ8gbqUnJ9T4oCTgK+byDlCcDUcLbTjDutQonSvudYJ0+dvgeBb
	 AEyK3pgwA9Ztg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Max Chou <max.chou@realtek.com>,
	Hilda Wu <hildawu@realtek.com>,
	Nial Ni <niall_ni@realsil.com.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] Bluetooth: btrtl: Avoid loading the config file on security chips
Date: Thu, 20 Nov 2025 07:08:24 -0500
Message-ID: <20251120120838.1754634-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120120838.1754634-1-sashal@kernel.org>
References: <20251120120838.1754634-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Max Chou <max.chou@realtek.com>

[ Upstream commit cd8dbd9ef600435439bb0e70af0a1d9e2193aecb ]

For chips with security enabled, it's only possible to load firmware
with a valid signature pattern.
If key_id is not zero, it indicates a security chip, and the driver will
not load the config file.

- Example log for a security chip.

Bluetooth: hci0: RTL: examining hci_ver=0c hci_rev=000a
  lmp_ver=0c lmp_subver=8922
Bluetooth: hci0: RTL: rom_version status=0 version=1
Bluetooth: hci0: RTL: btrtl_initialize: key id 1
Bluetooth: hci0: RTL: loading rtl_bt/rtl8922au_fw.bin
Bluetooth: hci0: RTL: cfg_sz 0, total sz 71301
Bluetooth: hci0: RTL: fw version 0x41c0c905

- Example log for a normal chip.

Bluetooth: hci0: RTL: examining hci_ver=0c hci_rev=000a
  lmp_ver=0c lmp_subver=8922
Bluetooth: hci0: RTL: rom_version status=0 version=1
Bluetooth: hci0: RTL: btrtl_initialize: key id 0
Bluetooth: hci0: RTL: loading rtl_bt/rtl8922au_fw.bin
Bluetooth: hci0: RTL: loading rtl_bt/rtl8922au_config.bin
Bluetooth: hci0: RTL: cfg_sz 6, total sz 71307
Bluetooth: hci0: RTL: fw version 0x41c0c905

Tested-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Nial Ni <niall_ni@realsil.com.cn>
Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

 drivers/bluetooth/btrtl.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 1d4a7887abccf..52794db2739bf 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -50,7 +50,7 @@
 
 #define	RTL_CHIP_SUBVER (&(struct rtl_vendor_cmd) {{0x10, 0x38, 0x04, 0x28, 0x80}})
 #define	RTL_CHIP_REV    (&(struct rtl_vendor_cmd) {{0x10, 0x3A, 0x04, 0x28, 0x80}})
-#define	RTL_SEC_PROJ    (&(struct rtl_vendor_cmd) {{0x10, 0xA4, 0x0D, 0x00, 0xb0}})
+#define	RTL_SEC_PROJ    (&(struct rtl_vendor_cmd) {{0x10, 0xA4, 0xAD, 0x00, 0xb0}})
 
 #define RTL_PATCH_SNIPPETS		0x01
 #define RTL_PATCH_DUMMY_HEADER		0x02
@@ -534,7 +534,6 @@ static int rtlbt_parse_firmware_v2(struct hci_dev *hdev,
 {
 	struct rtl_epatch_header_v2 *hdr;
 	int rc;
-	u8 reg_val[2];
 	u8 key_id;
 	u32 num_sections;
 	struct rtl_section *section;
@@ -549,14 +548,7 @@ static int rtlbt_parse_firmware_v2(struct hci_dev *hdev,
 		.len  = btrtl_dev->fw_len - 7, /* Cut the tail */
 	};
 
-	rc = btrtl_vendor_read_reg16(hdev, RTL_SEC_PROJ, reg_val);
-	if (rc < 0)
-		return -EIO;
-	key_id = reg_val[0];
-
-	rtl_dev_dbg(hdev, "%s: key id %u", __func__, key_id);
-
-	btrtl_dev->key_id = key_id;
+	key_id = btrtl_dev->key_id;
 
 	hdr = rtl_iov_pull_data(&iov, sizeof(*hdr));
 	if (!hdr)
@@ -1070,6 +1062,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 	u16 hci_rev, lmp_subver;
 	u8 hci_ver, lmp_ver, chip_type = 0;
 	int ret;
+	int rc;
+	u8 key_id;
 	u8 reg_val[2];
 
 	btrtl_dev = kzalloc(sizeof(*btrtl_dev), GFP_KERNEL);
@@ -1180,6 +1174,14 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 		goto err_free;
 	}
 
+	rc = btrtl_vendor_read_reg16(hdev, RTL_SEC_PROJ, reg_val);
+	if (rc < 0)
+		goto err_free;
+
+	key_id = reg_val[0];
+	btrtl_dev->key_id = key_id;
+	rtl_dev_info(hdev, "%s: key id %u", __func__, key_id);
+
 	btrtl_dev->fw_len = -EIO;
 	if (lmp_subver == RTL_ROM_LMP_8852A && hci_rev == 0x000c) {
 		snprintf(fw_name, sizeof(fw_name), "%s_v2.bin",
@@ -1202,7 +1204,7 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 		goto err_free;
 	}
 
-	if (btrtl_dev->ic_info->cfg_name) {
+	if (btrtl_dev->ic_info->cfg_name && !btrtl_dev->key_id) {
 		if (postfix) {
 			snprintf(cfg_name, sizeof(cfg_name), "%s-%s.bin",
 				 btrtl_dev->ic_info->cfg_name, postfix);
-- 
2.51.0

