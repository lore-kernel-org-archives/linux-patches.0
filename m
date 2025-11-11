Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8484C97;
	Tue, 11 Nov 2025 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822411; cv=none; b=KBvfXFX4xEQZoPF+uT63bImoHxQ4NxT9NaDGLaMBKsb7xAgaTArJSsHRvpZxFTZCGeTvm4HN/W8tVVZNCVPGOW+Ieq3VOTUiQApzKMTA/dBaxaSSNAwV1UXYF7ls+V1plVlXYKAhzovIKF3qxn9D+rmswpKVd+r6EoRg5PwNQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822411; c=relaxed/simple;
	bh=M6fID+/ndcVzLAgMza0olKG5Q/HGbAz8gK61NNigda0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8nIXsAJE3Y/P1AdtM8Q3ANvertvyoT1aFqzLVvqx6pFz541Mu+hnMFEyMOY0V5TvYrD1caUslMITXXCi4057R04GD9TPiMvrlj2O7cmIIu31xAamcC0ZMkXGKqlkHgbpnbmY46pmP7HxkVftbxmo4W5pCYAfu3q6Nb1xVI+C8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM74FXSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM74FXSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCAAC4CEFB;
	Tue, 11 Nov 2025 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822411;
	bh=M6fID+/ndcVzLAgMza0olKG5Q/HGbAz8gK61NNigda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM74FXSYhRDS0gDS6xwoLFrcj4ydDbaMKFTudT+kGDAcSXdsRYpPdzwYFbbpxI+o9
	 2mXPko7HchZ/kcSKQF/9AGhz6eQRObY/uM4wBFOnD2rHVTyPKbXR13ZxfVpvLs45cF
	 QbHz5Alt1ybTqIqQsdQRmvJaedvjbke2EBVti6/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/565] Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00
Date: Tue, 11 Nov 2025 09:38:21 +0900
Message-ID: <20251111004527.919095035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b3200542fe66..999ac27050993 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -424,6 +424,7 @@ enum {
 	HCI_USER_CHANNEL,
 	HCI_EXT_CONFIGURED,
 	HCI_LE_ADV,
+	HCI_LE_ADV_0,
 	HCI_LE_PER_ADV,
 	HCI_LE_SCAN,
 	HCI_SSP_ENABLED,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index debe9cc2f72d9..176565ef47c63 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1600,6 +1600,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		if (adv && !adv->periodic)
 			adv->enabled = true;
+		else if (!set->handle)
+			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
 
 		conn = hci_lookup_le_connect(hdev);
 		if (conn)
@@ -1610,6 +1612,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 		if (cp->num_of_sets) {
 			if (adv)
 				adv->enabled = false;
+			else if (!set->handle)
+				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
 
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c08e46ee70b24..06d8ab997bd85 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2616,9 +2616,8 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
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



