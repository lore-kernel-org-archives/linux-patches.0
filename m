Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598923D6465;
	Mon, 17 Aug 2026 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979445; cv=none; b=rutjNoIOsuOJYA4qboQx9G7mq5XwUozdX1hREDDeVAyiMIAheYeew84q8wowJ2GNid/fxYbrFdGYba4iy5wFpc/XekepGNAachpgyAnbSLZErmZIZuJBue8iQSEeRIebjlTxDKlxggGEJ0g5psr2fOGetS6BtlG2gcjcuMaqIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979445; c=relaxed/simple;
	bh=5hLXL8fpZivOVF75mVK66m7X+SCBgtSId4BxNCT+ZfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMXWeyS1kISxSlXQtmI8xKe1XM40oRKiVi0o9qK75KYc62dXzBcMBFzUmhFZWDGQFJuFVXJoi1XER6xDRYPcZrFHqtkqXpBnIWWE9bblv2Yhd2Qox/6K1TVCqKpU0xQj0dhDAubZwDB1YTFh15z4W808S6fwSqg6k9iPiPV6QTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD9XCVnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD9XCVnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472891F000E9;
	Mon, 17 Aug 2026 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979443;
	bh=KeqMo5zqfhWgyityonFcxhsk75bTAgf5hIQ9pz1dbX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD9XCVncamRBW+xHefAdCy/JB9qLunjxbZHTIyndq8Hwrp7a3JLku8/VR52bfEdLJ
	 /5obp14EMDY/AvdlPGKgo/YGW4vymp7xGubNlTcbdRxqQKL1CdyvOuIcaXUDVj35mH
	 ZiRHebCpd7JmCAss+YPA9ym0C4kNrnI1YfbtD630=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 227/609] Bluetooth: hci_sync: Protect UUID list traversal
Date: Mon, 17 Aug 2026 15:28:43 +0200
Message-ID: <20260817132551.684655893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit e9027ffbf5a0f3c12ca8900822e884eae9f0821b upstream.

The hci_sync conversion moved class-of-device and EIR generation from an
HCI request built under hdev->lock to asynchronous command sync work.
The worker holds hdev->req_lock, but that lock does not serialize access
to hdev->uuids against add_uuid() and remove_uuid(), which update the
list under hdev->lock.

The following interleaving can therefore occur:

  CPU0 (command sync work)       CPU1 (management socket)
  fetch uuid from the list
                                list_del(&uuid->list)
                                kfree(uuid)
  read uuid->size

KASAN reports the resulting use-after-free:

  BUG: KASAN: slab-use-after-free in eir_create+0xb8f/0xee0
  Read of size 1 at addr ffff88810dbd8620 by task kworker/u17:0/87
  Workqueue: hci0 hci_cmd_sync_work
  Call Trace:
   eir_create+0xb8f/0xee0
   hci_update_eir_sync+0x1c0/0x330
   hci_cmd_sync_work+0x13c/0x290
   process_one_work+0x63a/0x1070
   worker_thread+0x45b/0xd10

  Allocated by task 86:
   __kasan_kmalloc+0x8f/0xa0
   add_uuid+0x18a/0x4b0
   hci_sock_sendmsg+0x1033/0x1ea0

  Freed by task 92:
   __kasan_slab_free+0x43/0x70
   kfree+0x131/0x3c0
   remove_uuid+0x25e/0x560
   hci_sock_sendmsg+0x1033/0x1ea0

Hold hdev->lock while generating and committing the class-of-device and
EIR snapshots.  Release it before sending an HCI command, so controller
waits do not happen under the device lock.  This protects all UUID list
walks in these paths and restores the serialization lost in the command
sync conversion.

Fixes: 161510ccf91c ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 1")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -903,12 +903,16 @@ int hci_update_eir_sync(struct hci_dev *
 
 	memset(&cp, 0, sizeof(cp));
 
+	hci_dev_lock(hdev);
 	eir_create(hdev, cp.data);
 
-	if (memcmp(cp.data, hdev->eir, sizeof(cp.data)) == 0)
+	if (memcmp(cp.data, hdev->eir, sizeof(cp.data)) == 0) {
+		hci_dev_unlock(hdev);
 		return 0;
+	}
 
 	memcpy(hdev->eir, cp.data, sizeof(cp.data));
+	hci_dev_unlock(hdev);
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_EIR, sizeof(cp), &cp,
 				     HCI_CMD_TIMEOUT);
@@ -940,6 +944,7 @@ int hci_update_class_sync(struct hci_dev
 	if (hci_dev_test_flag(hdev, HCI_SERVICE_CACHE))
 		return 0;
 
+	hci_dev_lock(hdev);
 	cod[0] = hdev->minor_class;
 	cod[1] = hdev->major_class;
 	cod[2] = get_service_classes(hdev);
@@ -947,8 +952,12 @@ int hci_update_class_sync(struct hci_dev
 	if (hci_dev_test_flag(hdev, HCI_LIMITED_DISCOVERABLE))
 		cod[1] |= 0x20;
 
-	if (memcmp(cod, hdev->dev_class, 3) == 0)
+	if (memcmp(cod, hdev->dev_class, 3) == 0) {
+		hci_dev_unlock(hdev);
 		return 0;
+	}
+
+	hci_dev_unlock(hdev);
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_CLASS_OF_DEV,
 				     sizeof(cod), cod, HCI_CMD_TIMEOUT);


