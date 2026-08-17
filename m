Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919B3F1662;
	Mon, 17 Aug 2026 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974410; cv=none; b=UtLWfQKma3jtS0cq4S/UrleG/XylHDLfk/edo3Vi63SznBdE9D0KJVORXgcyj1JAjl7s/fe3JwbkzgxYbhCSYADLGGw9nwNFvKWlXlZ8c5WvYCOSRwZaEGPygyhdSd0kLU4yiYnSB3j6+i0njrWO2sK1/iay1ouCZ6LLexpH88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974410; c=relaxed/simple;
	bh=i6LkfkjJcMbWBAMJw2dvK2TMT9DecgmP26FuOQ7kOUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Crr76tQnSELgRutjXZx99cXjd4sE3XUOYTMjLx8f38ohf/EvsOcQkMV0DAyoUXIM8xZrck1zqyw+FNCV2kKB/jI0lvV9HBzD68yv0woWzNWwb5Z2fxOok7WbT4fAMPejNUPekxLUNtqD0cEuRBAVnPlBMV3h5A2M3SJeLenU69c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFZHBVc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFZHBVc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052CE1F00A3E;
	Mon, 17 Aug 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974405;
	bh=Z4OJcnK5fF3vpMI9h3PROQSuBFd+pC6yd6AW9Nh77h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFZHBVc2/60TAghOjCFVGjf9OExLMXaoshEtYJ7xNY+puKJG9OFTXOF9Y66tIO206
	 nbRlTkWmJba/OXp+HXikB4nK5WZYNkX7YdN5Q4j4M+u7Ytv8dATlYEygBKE2F/zDzc
	 3gDnbVOWBysSH89gWFLnyESEraZjTtJvz/P3+2pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexej Sidorenko <alexej@sidorenko.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 167/271] Bluetooth: btrtl: fix RTL8761B/BU broken LE extended scan
Date: Mon, 17 Aug 2026 15:31:32 +0200
Message-ID: <20260817132543.754082100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 03fa9409e3ee4..7f54d2d2d13a0 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1343,6 +1343,19 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
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



