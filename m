Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125C643C7B4;
	Mon, 17 Aug 2026 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975223; cv=none; b=IW3rCVQvrhlkaXvKygSbxNYxwPxUzqMNnyyuX54Eic2LLHfENwhFn5UlExoUmlUlmfpmiUE57GH3kTbUOSen7pbgU/Y3SojkGpusmnQrd1AlFQwVSRTEIpXAbrxiCm1Ogocg4616iYjTAVoerPL1PzeVqz2fsrDAzkUUfUmGMJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975223; c=relaxed/simple;
	bh=E5GR4WBkw2SDncTe4w/11Ws8GJFbLkuBGa9qNiOGXBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q45+UW6hXUP969cpx3EWfOTZ0YXvyCAoAV3f39QlbYsvvD3dugJ0VnBBPfZ/IbYVGyG5rEu2IKdIsIjIkUe4oxEqQCR5mvTLD+qGQD8N2Bpxgl17HerBTh6Lungn5r2xD++ycJ2l7OrSLgQAqYoDAmHp1KB/cmIghs+hOIktX48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8FyUg33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8FyUg33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4541F000E9;
	Mon, 17 Aug 2026 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975221;
	bh=ZQ6eGZZEcS4oQL2ylVyGOwdSm6lL1mMoC8QtlhAAuFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8FyUg33aB7eubGpRyH7D4UHbSQdWdA+xYcEDS2o/7mkV3U1z4A95TDHSM0o/GrpR
	 n+9fOUNJu3IofqyuU96K891CHYSAi6WuGNyhZOTAbKgK/bYsLLJATqqoc85O96VZLH
	 2FZD4dkCBh6IrUecs6bkrQXmxtY/7+eUBe3neL2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexej Sidorenko <alexej@sidorenko.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/250] Bluetooth: btrtl: fix RTL8761B/BU broken LE extended scan
Date: Mon, 17 Aug 2026 15:31:55 +0200
Message-ID: <20260817132542.850180052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexej Sidorenko <alexej@sidorenko.cz>

[ Upstream commit 5ead2063611ae56809b1b113ac44cef9547c81d7 ]

RTL8761B and RTL8761BU devices report HCI version 5.1 but do not
support the LE Extended Scan commands. This causes repeated failures
with Opcode 0x2042 (LE Set Extended Scan Parameters) returning -EBUSY
when BlueZ attempts extended scanning while a connection is active.

Set HCI_QUIRK_BROKEN_EXT_SCAN for CHIP_ID_8761B to make BlueZ fall
back to legacy LE scan commands which the firmware supports correctly.

Tested with RTL8761BU (USB ID 0bda:a728) where the issue manifested
as continuous 'Opcode 0x2042 failed: -16' errors in dmesg whenever
a BLE connection was active.

Signed-off-by: Alexej Sidorenko <alexej@sidorenko.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index a62eae7276d64..cb1c321910e2a 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1331,6 +1331,19 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 	if (!btrtl_dev->ic_info)
 		return;
 
+	switch (btrtl_dev->project_id) {
+	case CHIP_ID_8761B:
+		/* RTL8761B/BU reports HCI version 5.1 but does not support
+		 * the LE Extended Scan commands (Opcode 0x2042), causing
+		 * repeated -EBUSY failures when BlueZ attempts extended
+		 * scanning while a connection is active.
+		 */
+		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_EXT_SCAN);
+		break;
+	default:
+		break;
+	}
+
 	switch (btrtl_dev->ic_info->lmp_subver) {
 	case RTL_ROM_LMP_8703B:
 		/* 8723CS reports two pages for local ext features,
-- 
2.53.0



