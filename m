Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5149634F25E;
	Fri, 21 Nov 2025 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732184; cv=none; b=KBRecuhZpg9D7PzodKNFxKe5Nvx48EN1d+vW1AqSold5ORzCmQ1Pxk2i5wKi9dNW1R+RBZOvKjoX1lYInXXQJHzFdwJCoRZEz6bHA0dKbXbbre7UEJvhEDJ0k9kqSG2+qnZ28+zSFEOFSUNU0cSR4E6Y1s4l3eWZ+oxghqwlS1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732184; c=relaxed/simple;
	bh=+2DxrsK3WzuRZqr+VgpVNlTyByAToInE98LRtp4U9hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYu9R41KL2ZP7suWxGtfx2SqMDoHanaImcLf33u87we00lBnJ6fDMNT9TDkp5R76a8yCzuD00p/ZTAutHgL3B8bCrntnHwlR3EDnNz4eWHisRvqinU4XSRZC8UQcSKORCcE2CBrOBFnAPIj0e99zA3zlKwPTWUlReM1orSuVKBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6rZNoyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6rZNoyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D82C4CEFB;
	Fri, 21 Nov 2025 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732184;
	bh=+2DxrsK3WzuRZqr+VgpVNlTyByAToInE98LRtp4U9hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6rZNoyoc4Lglvuff9/piq17RpQElhiPcFQp2gGWN/mX/EpLoloQwklnqrGoZOG8R
	 xxjksLr3e2/SzTRkEb9UZiVE6AmT6D1maWxzpHXkIfpTD523WhErDf8t4XW/qoGuyO
	 Ak2iU9AMnxKhgP17VlNj/jAAiGeK87//fkiOjz/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/529] Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00
Date: Fri, 21 Nov 2025 14:05:32 +0100
Message-ID: <20251121130232.176845132@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 4c084a03d6bb7..b25746b91986c 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -392,6 +392,7 @@ enum {
 	HCI_USER_CHANNEL,
 	HCI_EXT_CONFIGURED,
 	HCI_LE_ADV,
+	HCI_LE_ADV_0,
 	HCI_LE_PER_ADV,
 	HCI_LE_SCAN,
 	HCI_SSP_ENABLED,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7bda00dcb0b2f..064fde4fb70ff 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1598,6 +1598,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		if (adv && !adv->periodic)
 			adv->enabled = true;
+		else if (!set->handle)
+			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
 
 		conn = hci_lookup_le_connect(hdev);
 		if (conn)
@@ -1608,6 +1610,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 		if (cp->num_of_sets) {
 			if (adv)
 				adv->enabled = false;
+			else if (!set->handle)
+				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
 
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 47924f20565d4..f5bbcbbcfbd7b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2651,9 +2651,8 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
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



