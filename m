Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3163B995D;
	Tue, 21 Jul 2026 21:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667960; cv=none; b=P+ZIl/DU8TUGbnZxZZKj92XtbdFXZCe7/Akb4h32gVrS7mtBS4CWU5dnPZfLvtr4fk+BxEWrgKKzf6BZB/9dfck89azbwC/4GUSc9NE13nyuYijownbezLyKrpaJRP8eEKg+3G9PKawrvyH0hmFo5xG/HCVaSfwD6zj8Y+9wngY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667960; c=relaxed/simple;
	bh=lxmi2RnY+kYXadzE5tRevlSF5n6Mbz1YdO1cNRPpnB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht0eG1yu9APgOAAxKFcASHIaOteOmTyn9vnO9Cp/6ciYu/mbMO/XT81m1YrUczfCjD/Zm7S0/VHFji087MwvQfTfm7uqHca9hB2W5+39CitMCyb5Zrga1uc3OaaQdssifX7Bq5vpys4X8Ye3g2bGGBnWSG092DAjmeHJWjZN5cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8390hWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8390hWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8F51F000E9;
	Tue, 21 Jul 2026 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667959;
	bh=YGMxGYLFhTj9tb5V/PY+1kAKKYpD1ZqKIP2KvDyTY/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8390hWnO81Ylqex1Nq5LMf7L8kBK4j4mXzhOUHm4aiJKPKSkYU+/X/L/9CDtKqKf
	 qM+vKKXZVcGo7bI7mvJPDvWoK6KBZ0ZDPQMI2X3ndg+nEGxvgFgCO5Dtq1fjT3Nw89
	 s4HUa9GughseCEM+zKOTYFvS11sSnF6Fu8G/JiDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1259/1266] Bluetooth: btmtk: remove #ifdef around declarations
Date: Tue, 21 Jul 2026 17:28:16 +0200
Message-ID: <20260721152509.997083029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 7a8c6fb21a7c913ddb99785b14914dab2f934fbd upstream.

The caller of these functions in btusb.c is guarded with an
if(IS_ENABLED()) style check, so dead code is left out, but the
declarations are still needed at compile time:

drivers/bluetooth/btusb.c: In function 'btusb_mtk_reset':
drivers/bluetooth/btusb.c:2705:15: error: implicit declaration of function 'btmtk_usb_subsys_reset' [-Wimplicit-function-declaration]
 2705 |         err = btmtk_usb_subsys_reset(hdev, btmtk_data->dev_id);
      |               ^~~~~~~~~~~~~~~~~~~~~~
drivers/bluetooth/btusb.c: In function 'btusb_send_frame_mtk':
drivers/bluetooth/btusb.c:2720:23: error: implicit declaration of function 'alloc_mtk_intr_urb' [-Wimplicit-function-declaration]
 2720 |                 urb = alloc_mtk_intr_urb(hdev, skb, btusb_tx_complete);
      |                       ^~~~~~~~~~~~~~~~~~
drivers/bluetooth/btusb.c:2720:21: error: assignment to 'struct urb *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
 2720 |                 urb = alloc_mtk_intr_urb(hdev, skb, btusb_tx_complete);
      |                     ^

Fixes: f0c83a23fcbb ("Bluetooth: btmtk: Fix btmtk.c undefined reference build error")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.h |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -189,13 +189,11 @@ int btmtk_process_coredump(struct hci_de
 void btmtk_fw_get_filename(char *buf, size_t size, u32 dev_id, u32 fw_ver,
 			   u32 fw_flavor);
 
-#if IS_ENABLED(CONFIG_BT_HCIBTUSB_MTK)
 int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id);
 
 int btmtk_usb_setup(struct hci_dev *hdev);
 
 int btmtk_usb_shutdown(struct hci_dev *hdev);
-#endif
 #else
 
 static inline int btmtk_set_bdaddr(struct hci_dev *hdev,


