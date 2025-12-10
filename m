Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A861F301702;
	Wed, 10 Dec 2025 07:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352035; cv=none; b=QyrR4RDLOLeCKQBHuJ6CG+rixoSIaOpF+Ri5OnyLMV2XT7gewezi4ARpNhyeHje4BRJK5F4gMRWMAHZbGwTcTiqpXFogoTemp9L732u8aAw3DmE9ZXgs1SsS8/6bsNJoZMyw+Vhhv/5QGO4fZk7GZRxPgKEe5ioUSkRnGcbt2Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352035; c=relaxed/simple;
	bh=9au1OswdeyviRUuJ4KEHQCPSed5fosWdkiS6E69BveI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt63DZN/k7RcPHryjYRA2xc+5UswLNRuLbXPmmyDHLNfuxtwfKSEX8hAja08P9OXC3I7dMGt+8tNSrmd2xFAXTlPXWBgVHVFZLre1zfBzbUDeJFy/kMthssFkYls0C8QdbNTJJP29m0edM4VdEq/95/2ob/u8PsXEKnZhWqMQRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drKS7are; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drKS7are"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA50C4CEF1;
	Wed, 10 Dec 2025 07:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352035;
	bh=9au1OswdeyviRUuJ4KEHQCPSed5fosWdkiS6E69BveI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drKS7are9CtjGw2GPoCrvGW8fWJXW7XRBO0arvEjICDsQoefeGjJ2rXe3pupX7Ck3
	 cgoYCgXzQ0qHpy/ZJmVdiS0qRZkT8U2tGL/jnTwSblmer6yDyAgPjVgFX2H5vi67/U
	 xKzPeaxhJhPi9q1/ffdeLMPWgilZygbucP+7Hp0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilda Wu <hildawu@realtek.com>,
	Nial Ni <niall_ni@realsil.com.cn>,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 26/60] Bluetooth: btrtl: Avoid loading the config file on security chips
Date: Wed, 10 Dec 2025 16:29:56 +0900
Message-ID: <20251210072948.481641719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



