Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FD5171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6366C433EF;
	Mon, 22 May 2023 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782926;
	bh=DXLP+wOUiBgZm+SUjA0qsNB+QyEVN1tikG3u6WzhJrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suAhi9jBzMvv5Krx/EtVTHcaSkZAlRbg1paxItyAAr9RlyP11nSmRkpiz3c6ieWrn
	 LkxnfJSn5nvaNqtJg19HxIsryrb9RDQgJiXdY0oMjHwyjgq46x0M7XbAAHWgo/ZynR
	 mEWtEajkt6mGo+QSgkFNLQAhTE+GT8/HuJINzD1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/203] Bluetooth: hci_bcm: Fall back to getting bdaddr from EFI if not set
Date: Mon, 22 May 2023 20:08:20 +0100
Message-Id: <20230522190357.091706132@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0d218c3642b9ccf71f44987cd03c19320f3bd918 ]

On some devices the BCM Bluetooth adapter does not have a valid bdaddr set.

btbcm.c currently sets HCI_QUIRK_INVALID_BDADDR to indicate when this is
the case. But this requires users to manual setup a btaddr, by doing e.g.:

btmgmt -i hci0 public-addr 'B0:F1:EC:82:1D:B3'

Which means that Bluetooth will not work out of the box on such devices.
To avoid this (where possible) hci_bcm sets: HCI_QUIRK_USE_BDADDR_PROPERTY
which tries to get the bdaddr from devicetree.

But this only works on devicetree platforms. On UEFI based platforms
there is a special Broadcom UEFI variable which when present contains
the devices bdaddr, just like how there is another UEFI variable which
contains wifi nvram contents including the wifi MAC address.

Add support for getting the bdaddr from this Broadcom UEFI variable,
so that Bluetooth will work OOTB for users on devices where this
UEFI variable is present.

This fixes Bluetooth not working on for example Asus T100HA 2-in-1s.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 47 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index a18f289d73466..f228cdbccaee3 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2015  Intel Corporation
  */
 
+#include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/dmi.h>
@@ -33,6 +34,43 @@
 /* For kmalloc-ing the fw-name array instead of putting it on the stack */
 typedef char bcm_fw_name[BCM_FW_NAME_LEN];
 
+#ifdef CONFIG_EFI
+static int btbcm_set_bdaddr_from_efi(struct hci_dev *hdev)
+{
+	efi_guid_t guid = EFI_GUID(0x74b00bd9, 0x805a, 0x4d61, 0xb5, 0x1f,
+				   0x43, 0x26, 0x81, 0x23, 0xd1, 0x13);
+	bdaddr_t efi_bdaddr, bdaddr;
+	efi_status_t status;
+	unsigned long len;
+	int ret;
+
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
+		return -EOPNOTSUPP;
+
+	len = sizeof(efi_bdaddr);
+	status = efi.get_variable(L"BDADDR", &guid, NULL, &len, &efi_bdaddr);
+	if (status != EFI_SUCCESS)
+		return -ENXIO;
+
+	if (len != sizeof(efi_bdaddr))
+		return -EIO;
+
+	baswap(&bdaddr, &efi_bdaddr);
+
+	ret = btbcm_set_bdaddr(hdev, &bdaddr);
+	if (ret)
+		return ret;
+
+	bt_dev_info(hdev, "BCM: Using EFI device address (%pMR)", &bdaddr);
+	return 0;
+}
+#else
+static int btbcm_set_bdaddr_from_efi(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 int btbcm_check_bdaddr(struct hci_dev *hdev)
 {
 	struct hci_rp_read_bd_addr *bda;
@@ -86,9 +124,12 @@ int btbcm_check_bdaddr(struct hci_dev *hdev)
 	    !bacmp(&bda->bdaddr, BDADDR_BCM4345C5) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM43430A0) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM43341B)) {
-		bt_dev_info(hdev, "BCM: Using default device address (%pMR)",
-			    &bda->bdaddr);
-		set_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
+		/* Try falling back to BDADDR EFI variable */
+		if (btbcm_set_bdaddr_from_efi(hdev) != 0) {
+			bt_dev_info(hdev, "BCM: Using default device address (%pMR)",
+				    &bda->bdaddr);
+			set_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
+		}
 	}
 
 	kfree_skb(skb);
-- 
2.39.2



