Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3543316905;
	Thu, 28 May 2026 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001561; cv=none; b=SWXO6/o6jQi8FN8F3s41lsi8WYsGRBX2cG0Fn+DX2dLYltv/D9ua3WOyR9NxXJqAil6yBdxDPEyd+GlDI/fnmhmum8r5fDwEYH/J7yp+tQbjTxdviV9fxiZY0vyfJaBZekYb26XJTc3eJXAvUuaB8ccUSoWA+CTHO3OAvoj0QXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001561; c=relaxed/simple;
	bh=FJO0m5I++vAlLeJU4wWmQ9sjBzIFLpZvZKPcYombaoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StegpNVq2B4l/w1s22/csnt5h4hMlR+TBu8RmYDVW/jbCSjYxVrOhDOrPeLMwmIZwDY1gVShpPI8neUiPk8eYVgLRgtAgR19KLBC0sGkP+WMw/catlAVa4HPnrn2HAJPEBVEw+LlXxgMDfgH0Tso93kQjeHH5GHKSWpXQoAzCDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=votvJrck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="votvJrck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2601F000E9;
	Thu, 28 May 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001559;
	bh=2svI8gq98kMbOVkvk3xBzdJM0n4ETG8RuLBNWXVHsg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=votvJrckz7XyYpcXaawVMl8gssqJDBnX1JP1Nuovnc180S0XdSDehsIgQ9rHxn29k
	 1Xo6nFFttI7jdxaN5GTnXqMKo5j51cspTZvMy0F2SAZ+7rIP/kX95cwpzc2lyi636W
	 n2coeh1TJ09siAWsBGlffUPbphOG7lXVsIfaKwSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/186] Bluetooth: btmtk: add the function to get the fw name
Date: Thu, 28 May 2026 21:50:51 +0200
Message-ID: <20260528194933.587132725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 00f993fdec06c8f036a1b9c8ee6b004c17143bd1 ]

Include a shared function to get the firmware name, to prevent repeating
code for similar chipsets.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: dd1dda6b8d6e ("Bluetooth: btmtk: fix urb->setup_packet leak in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 18 ++++++++++++++++++
 drivers/bluetooth/btmtk.h |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 4c53ab22d09b0..31fca4529b5ad 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -103,6 +103,24 @@ static void btmtk_coredump_notify(struct hci_dev *hdev, int state)
 	}
 }
 
+void btmtk_fw_get_filename(char *buf, size_t size, u32 dev_id, u32 fw_ver,
+			   u32 fw_flavor)
+{
+	if (dev_id == 0x7925)
+		snprintf(buf, size,
+			 "mediatek/mt%04x/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
+			 dev_id & 0xffff, dev_id & 0xffff, (fw_ver & 0xff) + 1);
+	else if (dev_id == 0x7961 && fw_flavor)
+		snprintf(buf, size,
+			 "mediatek/BT_RAM_CODE_MT%04x_1a_%x_hdr.bin",
+			 dev_id & 0xffff, (fw_ver & 0xff) + 1);
+	else
+		snprintf(buf, size,
+			 "mediatek/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
+			 dev_id & 0xffff, (fw_ver & 0xff) + 1);
+}
+EXPORT_SYMBOL_GPL(btmtk_fw_get_filename);
+
 int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 			      wmt_cmd_sync_func_t wmt_cmd_sync)
 {
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index cbcdb99a22e6d..e76b8a358be88 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -160,6 +160,9 @@ int btmtk_register_coredump(struct hci_dev *hdev, const char *name,
 			    u32 fw_version);
 
 int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb);
+
+void btmtk_fw_get_filename(char *buf, size_t size, u32 dev_id, u32 fw_ver,
+			   u32 fw_flavor);
 #else
 
 static inline int btmtk_set_bdaddr(struct hci_dev *hdev,
@@ -194,4 +197,9 @@ static int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	return -EOPNOTSUPP;
 }
+
+static void btmtk_fw_get_filename(char *buf, size_t size, u32 dev_id,
+				  u32 fw_ver, u32 fw_flavor)
+{
+}
 #endif
-- 
2.53.0



