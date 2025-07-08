Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161AF2D9790;
	Tue,  8 Jul 2025 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991963; cv=none; b=gCxLbMcRiC23hAzx21oYyR5K37T2wJzv94jMFiVjLBYILJZlfxzyr89OxrpXxeUsAz+aEtJGz3AzF0oufpRnsW4YwHyrcyDd+rNVH7hnDXlqh4BrlD+ToPfynLuiltSiVzv+BrJU1DWLm95xR9rToDLSNqX3KuRinGggiKpqlQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991963; c=relaxed/simple;
	bh=j9Cxl2Z1TX+3G6WT1xMDEpSqmz/ByIpf37dKDUcThNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jijp37+R+ld6ArsrtgtiEKPTsu2yXfCM6HB635cg592z1Yt/vZeZl9Q5fQitSPjv8Ya3drmKPx1gaHdrlhvx0CCy6nbEUXbKCGGT8YtwUjZ2BnCcn7inHoKbxWpRwdajYGXzw9hj+5xEd75WdkhsccmnCETNWQP8k44asHD+1T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d78bcCf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d78bcCf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46109C4CEED;
	Tue,  8 Jul 2025 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991962;
	bh=j9Cxl2Z1TX+3G6WT1xMDEpSqmz/ByIpf37dKDUcThNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d78bcCf2oxvWlAwLxFtQ/tVlHwIqgl8Yi4AVIYR5YB2b4c6j/lqyQvaMp/ckdABw3
	 zWpRl8yqVD9uQefoX5YAE7g0zuAMHgCI86PmwRXYgRK+9tbpDyUbBt0jh+n0PtWi18
	 UW4QPl/Uyii5NVH/EYRPoBU3R4Hk9HduDMXUb7R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 07/81] Bluetooth: hci_sync: revert some mesh modifications
Date: Tue,  8 Jul 2025 18:22:59 +0200
Message-ID: <20250708162225.080329164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

commit 46c0d947b64ac8efcf89dd754213dab5d1bd00aa upstream.

This reverts minor parts of the changes made in commit b338d91703fa
("Bluetooth: Implement support for Mesh"). It looks like these changes
were only made for development purposes but shouldn't have been part of
the commit.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1966,13 +1966,10 @@ static int hci_clear_adv_sets_sync(struc
 static int hci_clear_adv_sync(struct hci_dev *hdev, struct sock *sk, bool force)
 {
 	struct adv_info *adv, *n;
-	int err = 0;
 
 	if (ext_adv_capable(hdev))
 		/* Remove all existing sets */
-		err = hci_clear_adv_sets_sync(hdev, sk);
-	if (ext_adv_capable(hdev))
-		return err;
+		return hci_clear_adv_sets_sync(hdev, sk);
 
 	/* This is safe as long as there is no command send while the lock is
 	 * held.
@@ -2000,13 +1997,11 @@ static int hci_clear_adv_sync(struct hci
 static int hci_remove_adv_sync(struct hci_dev *hdev, u8 instance,
 			       struct sock *sk)
 {
-	int err = 0;
+	int err;
 
 	/* If we use extended advertising, instance has to be removed first. */
 	if (ext_adv_capable(hdev))
-		err = hci_remove_ext_adv_instance_sync(hdev, instance, sk);
-	if (ext_adv_capable(hdev))
-		return err;
+		return hci_remove_ext_adv_instance_sync(hdev, instance, sk);
 
 	/* This is safe as long as there is no command send while the lock is
 	 * held.
@@ -2105,16 +2100,13 @@ int hci_read_tx_power_sync(struct hci_de
 int hci_disable_advertising_sync(struct hci_dev *hdev)
 {
 	u8 enable = 0x00;
-	int err = 0;
 
 	/* If controller is not advertising we are done. */
 	if (!hci_dev_test_flag(hdev, HCI_LE_ADV))
 		return 0;
 
 	if (ext_adv_capable(hdev))
-		err = hci_disable_ext_adv_instance_sync(hdev, 0x00);
-	if (ext_adv_capable(hdev))
-		return err;
+		return hci_disable_ext_adv_instance_sync(hdev, 0x00);
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_ADV_ENABLE,
 				     sizeof(enable), &enable, HCI_CMD_TIMEOUT);


