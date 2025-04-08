Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCFB2192F2;
	Tue,  8 Apr 2025 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110967; cv=none; b=ZetZvHvaLsyygfaDkILPB1aYvc6MLFS+zEXhZzoZZw33sh+7Wjj1+uO7+rNvDEPAQ3RiUmrhy55xNyQ8hwbEnE2pnU+Z9Y6YqmDbNzohhIBrqXD11QvSx8bqtprboMFT763eThYTaCh84lQ72KTeeG0x1+W53p5ODKZK22wD8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110967; c=relaxed/simple;
	bh=bv68yh5WS8XLjel2TNBlvmSH26ojUv604AAOJ6nSzxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSDmtsulexuj2sQCW85VKxSxqoAnC3HelWPQi7tQnwQAKpFFDBOrJgNHIk2HmcXDq5ROXcUYjFVmBG39umZIp6B1xqPifYmKgxeoQEtaV1qd1IGmaRSfVO05cF08OkhEGr5a5Rf5Cb8A+dtrifIA3xN+acwVxY8Dh1fKnk2qfko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/JndbLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/JndbLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9792C4CEE5;
	Tue,  8 Apr 2025 11:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110967;
	bh=bv68yh5WS8XLjel2TNBlvmSH26ojUv604AAOJ6nSzxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/JndbLV0nXOh76Ytj46uXbYEYDJilFz89MaLS9BWYILHXAwoKmZJrxh/wD247G39
	 F/1LYd0pc7HYjuVv37UvkAQuYdD7W9gEOukH4lKLuienqzavJ2LVYYMN4v0lxgA9nl
	 IOTzQIkooPOUm64hoORAMDcEB6l/MZeGLnddTcHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Nishiyama <nishiyama.pedro@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 253/731] Bluetooth: Add quirk for broken READ_VOICE_SETTING
Date: Tue,  8 Apr 2025 12:42:30 +0200
Message-ID: <20250408104920.169297433@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Pedro Nishiyama <nishiyama.pedro@gmail.com>

[ Upstream commit ff26b2dd6568392f60fa67a4e58279938025c3af ]

Some fake controllers cannot be initialized because they return a smaller
report than expected for READ_VOICE_SETTING.

Signed-off-by: Pedro Nishiyama <nishiyama.pedro@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 1f04b0e5e3b9 ("Bluetooth: btusb: Fix regression in the initialization of fake Bluetooth controllers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 8 ++++++++
 include/net/bluetooth/hci_core.h | 4 ++++
 net/bluetooth/hci_sync.c         | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 3ec915738112b..295d97e312e1d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -354,6 +354,14 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_PHY,
+
+	/* When this quirk is set, the HCI_OP_READ_VOICE_SETTING command is
+	 * skipped. This is required for a subset of the CSR controller clones
+	 * which erroneously claim to support it.
+	 *
+	 * This quirk must be set before hci_register_dev is called.
+	 */
+	HCI_QUIRK_BROKEN_READ_VOICE_SETTING,
 };
 
 /* HCI device flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 6281063cbd8e4..8649ad17408bb 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1925,6 +1925,10 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 	((dev)->commands[20] & 0x10 && \
 	 !test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks))
 
+#define read_voice_setting_capable(dev) \
+	((dev)->commands[9] & 0x04 && \
+	 !test_bit(HCI_QUIRK_BROKEN_READ_VOICE_SETTING, &(dev)->quirks))
+
 /* Use enhanced synchronous connection if command is supported and its quirk
  * has not been set.
  */
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index dd770ef5ec368..0c6a85abba2c5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3696,6 +3696,9 @@ static int hci_read_local_name_sync(struct hci_dev *hdev)
 /* Read Voice Setting */
 static int hci_read_voice_setting_sync(struct hci_dev *hdev)
 {
+	if (!read_voice_setting_capable(hdev))
+		return 0;
+
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_VOICE_SETTING,
 				     0, NULL, HCI_CMD_TIMEOUT);
 }
-- 
2.39.5



