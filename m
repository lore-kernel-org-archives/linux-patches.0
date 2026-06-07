Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030D04071DA;
	Sun,  7 Jun 2026 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827515; cv=none; b=oWz3I0lg4/YPj2wYqL2be67Gu5v/IlDkoNwwcb6p2rQtd5HbkJemOW87EFfddyiMFJBY0SiGtwaUss1NR75aQ3xQH38xd2jpgSRdfQd1x3iZ+UX8odpox3nOcxy/kuyuDCmlH3XpZQ+lxtZrqyMgm0PoAsQ2I/WfRBKcxIinKhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827515; c=relaxed/simple;
	bh=jPOYcR6HCGOPZ4w6YSAtp7q3wE50gLhGcar+PMusTfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gcd/0+MR/mH7WdYufHdzWsLYA4xoXcfpAW80bdTK+pTkxbqNHPjWFt57CO9Xqm6GKJWlYRA0KNZ1P3Y7erchTF02TwjPA2xDqG8ZlKp7eLeZVk8wsjYXlBsQbKbKDY3d7cJ953Mln9rLEg/Z04tSG9k8+PoYbc/9bXU5Q9wVmx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wga5T04j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wga5T04j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594A91F00893;
	Sun,  7 Jun 2026 10:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827514;
	bh=GdkocABn9WhKIDrCwQ/pba8bQStjYrn/P1aTHpTeo7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wga5T04jXqk7GALfW5BsAH2CKPV/hseux/3FdM1AOPT3R5L8qJ8WmQSeu7g8NYDsD
	 Aj2eZQkOEIW2yv5GIoLZh9km8RLnTgY/KoGQbU4wwBNPY291tRa6qqxrfsJcO7Pqq/
	 QIq4PNbPHyF4E6JDHz2ti+0dqXxVQ/iwosl+0rOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 099/332] Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close
Date: Sun,  7 Jun 2026 11:57:48 +0200
Message-ID: <20260607095731.779119801@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

[ Upstream commit 525daaea459fc215f432de1b8debbd9144bf97b0 ]

Since hci_dev_close_sync() can now be called during the reset path, we
should also set HCI_CMD_DRAIN_WORKQUEUE. This avoids queuing timeouts
while the hdev workqueue is being drained.

Fixes: 877afadad2dc ("Bluetooth: When HCI work queue is drained, only queue chained work")
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 426f465be35533..80b71e39656faf 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5301,6 +5301,12 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
+	/* Set HCI_DRAIN_WORKQUEUE flag to prevent queuing work during
+	 * reset/close. See hci_cmd_work() and handle_cmd_cnt_and_timer().
+	 */
+	hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+	synchronize_rcu();
+
 	if (hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
 		disable_delayed_work(&hdev->power_off);
 		disable_delayed_work(&hdev->ncmd_timer);
@@ -5324,6 +5330,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
+		hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
 		return err;
 	}
 
@@ -5423,6 +5430,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	/* Clear flags */
 	hdev->flags &= BIT(HCI_RAW);
 	hci_dev_clear_volatile_flags(hdev);
+	hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
 
 	memset(hdev->eir, 0, sizeof(hdev->eir));
 	memset(hdev->dev_class, 0, sizeof(hdev->dev_class));
-- 
2.53.0



