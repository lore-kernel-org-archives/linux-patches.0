Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89934CFA1;
	Wed,  3 Dec 2025 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778749; cv=none; b=o84O1X/GKLZXpS0Ge6mG07iBrWQXVNTkYegfUR16JWUkG3akbYxeT13R6B/AzndBRrpGG2zMAxj5zxFjocTkQqpdBRswJQ9b05oISdhSopktppB7tkdOcSlxNsCfcyr5NpwDxzYOOnLhVRZatdJQ7eFbjos8GTvN37VAh3+jfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778749; c=relaxed/simple;
	bh=YnoFc1NoatUx8xkbzUFRibng3n1DQuI/4vBU7JsV2Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4zhj00PW6xKXBk2cycE0TYAIb4t0sjMEm5FrUZXaojqTnBGCeGmNj6c5BlueHo80ffbQy6qGaSK9ZNPOZ2FctFOPh4bn/YCNquCfzKu0IO/alVyuyBTeDyQKJUAUPs7FF04OUam7wvMXlLCKtUL9fJGvSDkuU0wLiMC+T6Ze7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWXv3Y2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWXv3Y2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE861C4CEF5;
	Wed,  3 Dec 2025 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778749;
	bh=YnoFc1NoatUx8xkbzUFRibng3n1DQuI/4vBU7JsV2Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWXv3Y2SWGisSEVe1biIGyYvk4OjcRzHPEHbKdwJ6S+6iaB2FZZzzDIMwJomNaPh4
	 03u0DQEO3dtAP+0QoqI0WtMcnsO2puhFGfHnnyOLuQFn5za7MMSuNYxchKE7auvV1l
	 V+b5+2a8gTBaE1XhH/zgDkfUv51JX1+RfHGQjbxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/568] Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00
Date: Wed,  3 Dec 2025 16:20:50 +0100
Message-ID: <20251203152442.450236485@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0d92808024b4e9868cef68d16f121d509843e80e ]

This fixes the state tracking of advertisement set/instance 0x00 which
is considered a legacy instance and is not tracked individually by
adv_instances list, previously it was assumed that hci_dev itself would
track it via HCI_LE_ADV but that is a global state not specifc to
instance 0x00, so to fix it a new flag is introduced that only tracks the
state of instance 0x00.

Fixes: 1488af7b8b5f ("Bluetooth: hci_sync: Fix hci_resume_advertising_sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_event.c   | 4 ++++
 net/bluetooth/hci_sync.c    | 5 ++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 09bc4bf805c62..1a20fb1fa157b 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -372,6 +372,7 @@ enum {
 	HCI_USER_CHANNEL,
 	HCI_EXT_CONFIGURED,
 	HCI_LE_ADV,
+	HCI_LE_ADV_0,
 	HCI_LE_PER_ADV,
 	HCI_LE_SCAN,
 	HCI_SSP_ENABLED,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a0ce0a1e3258e..e1f1be4dfe97a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1655,6 +1655,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		if (adv)
 			adv->enabled = true;
+		else if (!set->handle)
+			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
 
 		conn = hci_lookup_le_connect(hdev);
 		if (conn)
@@ -1665,6 +1667,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 		if (cp->num_of_sets) {
 			if (adv)
 				adv->enabled = false;
+			else if (!set->handle)
+				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
 
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 2937e7a37bcba..5ad09900f8ff1 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2607,9 +2607,8 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 		/* If current advertising instance is set to instance 0x00
 		 * then we need to re-enable it.
 		 */
-		if (!hdev->cur_adv_instance)
-			err = hci_enable_ext_advertising_sync(hdev,
-							      hdev->cur_adv_instance);
+		if (hci_dev_test_and_clear_flag(hdev, HCI_LE_ADV_0))
+			err = hci_enable_ext_advertising_sync(hdev, 0x00);
 	} else {
 		/* Schedule for most recent instance to be restarted and begin
 		 * the software rotation loop
-- 
2.51.0



