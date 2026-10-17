Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C1321445;
	Sat, 17 Oct 2026 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258181; cv=none; b=lr8DTpYbKBfbQgyNLS7qxycZjMXf0W8xpzZB4sCp+hL+HNOGPpbmG1tw0P7eVDirUZVMg+OXIJOCTj3badxJi+E0JJ970vmGoJ7RghtqIQ6uhEGBEaSdAZKg90XoQPG4ZMv4WRqjFqV1XbPtq/PXCQuX/YHR/fbwsZ9lUiqWYAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258181; c=relaxed/simple;
	bh=Q9Zg4/U55iaK23CWhHCYdTtyepoP5h1bBAzMn9PUBZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7/JySj1FgpcK1o7ZESReCbES2vrALUJD6afE9MLOYEx9X8U9SxviQRWH/9eoxbFXvDHsx3hMnoxGn93h8sMOYnHMfMdzQg1MyedgAB4oVjK72L657L0/5O0a3kKRMZ2wtNpgtvRywwBnAr5hhEIhHUCwfEpNMOT0FuyoiJuROg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNHL8ZsJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNHL8ZsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2217E1F000C4;
	Sat, 17 Oct 2026 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258180;
	bh=IPkFL8GErdi1MlMSJAgsLMCNmgyHcNHQBttKC8kIEac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNHL8ZsJhpQ8g4xaZDruSZ77C+54DRpFkxU0L3JYhraqPzYDGs5H5MJP3yXHae22Q
	 vRKNMI6gYoQxV9gEs6n5NYFygMSbx8224h4RUFMxWOwajjhOK913vLoK0fQsL5Zlcc
	 pNT2+V+4WVIJybgV9usM0AtE1mHRKu2+qE/NEqiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0756/1674] Bluetooth: eir: Fix possible crashes on eir_create_adv_data
Date: Sat, 17 Oct 2026 17:50:28 +0200
Message-ID: <20261017160450.507566598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 47c03902269aff377f959dc3fd94a9733aa31d6e ]

eir_create_adv_data may attempt to add EIR_FLAGS and EIR_TX_POWER
without checking if that would fit.

Link: https://github.com/bluez/bluez/issues/1117#issuecomment-2958244066
Fixes: 01ce70b0a274 ("Bluetooth: eir: Move EIR/Adv Data functions to its own file")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/eir.c      | 7 ++++---
 net/bluetooth/eir.h      | 2 +-
 net/bluetooth/hci_sync.c | 5 +++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/eir.c b/net/bluetooth/eir.c
index 7a28baa2b71fe..2f695f1c69b36 100644
--- a/net/bluetooth/eir.c
+++ b/net/bluetooth/eir.c
@@ -242,7 +242,7 @@ u8 eir_create_per_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
 	return ad_len;
 }
 
-u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
+u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr, u8 size)
 {
 	struct adv_info *adv = NULL;
 	u8 ad_len = 0, flags = 0;
@@ -286,7 +286,7 @@ u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
 		/* If flags would still be empty, then there is no need to
 		 * include the "Flags" AD field".
 		 */
-		if (flags) {
+		if (flags && (ad_len + eir_precalc_len(1) <= size)) {
 			ptr[0] = 0x02;
 			ptr[1] = EIR_FLAGS;
 			ptr[2] = flags;
@@ -316,7 +316,8 @@ u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
 		}
 
 		/* Provide Tx Power only if we can provide a valid value for it */
-		if (adv_tx_power != HCI_TX_POWER_INVALID) {
+		if (adv_tx_power != HCI_TX_POWER_INVALID &&
+		    (ad_len + eir_precalc_len(1) <= size)) {
 			ptr[0] = 0x02;
 			ptr[1] = EIR_TX_POWER;
 			ptr[2] = (u8)adv_tx_power;
diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
index 0df19f2f4af94..4497f8fd5fefb 100644
--- a/net/bluetooth/eir.h
+++ b/net/bluetooth/eir.h
@@ -9,7 +9,7 @@
 
 void eir_create(struct hci_dev *hdev, u8 *data);
 
-u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr);
+u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr, u8 size);
 u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 instance, u8 *ptr);
 u8 eir_create_per_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr);
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4781ac734d951..5ad66eb7f6c38 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1336,7 +1336,8 @@ static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
 		}
 	}
 
-	len = eir_create_adv_data(hdev, instance, pdu.data);
+	len = eir_create_adv_data(hdev, instance, pdu.data,
+				  sizeof(pdu.data));
 
 	pdu.cp.length = len;
 	pdu.cp.handle = instance;
@@ -1378,7 +1379,7 @@ static int hci_set_adv_data_sync(struct hci_dev *hdev, u8 instance)
 
 	memset(&cp, 0, sizeof(cp));
 
-	len = eir_create_adv_data(hdev, instance, cp.data);
+	len = eir_create_adv_data(hdev, instance, cp.data, sizeof(cp.data));
 
 	/* There's nothing to do if the data hasn't changed */
 	if (hdev->adv_data_len == len &&
-- 
2.53.0



