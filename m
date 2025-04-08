Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB7264614;
	Tue,  8 Apr 2025 11:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110996; cv=none; b=VHP5RZ/x2NuH+ZCE4iee0/VmT5MyvWg0PHAlCD2M/Bm6YzR9tnpUXpvPpzLBdw6TzxGOWEwMtVrdANdEfsW1yrt0OAsR76+YXq93Wyix8vD8nxag668DYTBDrpB9H9mfNhLcJYgaCxrRirUvKx0TWgnW7dyIdrGhQb+Kme95+Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110996; c=relaxed/simple;
	bh=Gciai5NwaK8u0c1cZPbYOaRBz46E7baWz66mt+5gGHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnxkfUgtr6AhobgthfniEyBITauMILb4hImBPuXZzoslyyqkICc+rHPVMizYIUmrjzVD+0uVOrdjmLrj/NOFpiMsyjFrAH8se+25TkxXwjG/yLmF85kLsWwORvLrMNVEyT1WWWJ+awCwqChVU/9+l+NuSQ0NUNr5/fphC8ATNno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiXPrqid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiXPrqid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC6AC4CEE5;
	Tue,  8 Apr 2025 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110996;
	bh=Gciai5NwaK8u0c1cZPbYOaRBz46E7baWz66mt+5gGHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiXPrqidbhr/SBImhUgN24dvj+uoTpKl2CRlfSwFGRAx3b0W/4rJAPyLy5o7Vjx3j
	 UFWsEcyt1RuyUNYYAu+M4C+iZOqXpyQj+V1zTKI2JI6ivtJAAvNQiUi5t29lw/XzOt
	 yoQFsffVltSmRSJj/6a0+pmmY9fK0zT3W1NcTUi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Nishiyama <nishiyama.pedro@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 254/731] Bluetooth: Add quirk for broken READ_PAGE_SCAN_TYPE
Date: Tue,  8 Apr 2025 12:42:31 +0200
Message-ID: <20250408104920.191407863@linuxfoundation.org>
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

[ Upstream commit 127881334eaad639e0a19a399ee8c91d6c9dc982 ]

Some fake controllers cannot be initialized because they return a smaller
report than expected for READ_PAGE_SCAN_TYPE.

Signed-off-by: Pedro Nishiyama <nishiyama.pedro@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 1f04b0e5e3b9 ("Bluetooth: btusb: Fix regression in the initialization of fake Bluetooth controllers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 8 ++++++++
 net/bluetooth/hci_sync.c    | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 295d97e312e1d..aa684d2b079fa 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -362,6 +362,14 @@ enum {
 	 * This quirk must be set before hci_register_dev is called.
 	 */
 	HCI_QUIRK_BROKEN_READ_VOICE_SETTING,
+
+	/* When this quirk is set, the HCI_OP_READ_PAGE_SCAN_TYPE command is
+	 * skipped. This is required for a subset of the CSR controller clones
+	 * which erroneously claim to support it.
+	 *
+	 * This quirk must be set before hci_register_dev is called.
+	 */
+	HCI_QUIRK_BROKEN_READ_PAGE_SCAN_TYPE,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 0c6a85abba2c5..cf60a8da943a5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4132,7 +4132,8 @@ static int hci_read_page_scan_type_sync(struct hci_dev *hdev)
 	 * support the Read Page Scan Type command. Check support for
 	 * this command in the bit mask of supported commands.
 	 */
-	if (!(hdev->commands[13] & 0x01))
+	if (!(hdev->commands[13] & 0x01) ||
+	    test_bit(HCI_QUIRK_BROKEN_READ_PAGE_SCAN_TYPE, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_PAGE_SCAN_TYPE,
-- 
2.39.5



