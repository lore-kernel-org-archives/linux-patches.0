Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E822C15B2;
	Tue, 31 Mar 2026 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975811; cv=none; b=IqN0pf4pv+yc1v68ArfdaYfi7xXa91r+CQS+i9V3Xs65kk6sR2/RxCFsQe/UokrZAMiAnAScwxEuaIyi0m9QJ+VWwY8bawt9jHMX8mZ4a0JIX0dSJssHaoFI+Tp8lQGThzZwngU+gsZ23YjggJHIMkQshjeI/rH8bDxgVuXr788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975811; c=relaxed/simple;
	bh=cakKbTh4hdXXiddk9mBx+hbJWa0oEhiUTgH8PYoLBa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK74xBAF0VxggZhTSOVwnaJefzkOCUtNsOIRq6ulOB3kVvyT1tLV0XxjJtgnuZpDG1k/H8HZzQ8fqqFJXXyEmZF3o5RvUsUOtXoJ/pvmR6H9xv7olr2r1v246K9/U5gV5TEPfGyJ8mbUDAgwE/rXqgBpiVtodiE/ijvUhI5FPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIBqB2Kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIBqB2Kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990B0C19423;
	Tue, 31 Mar 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975810;
	bh=cakKbTh4hdXXiddk9mBx+hbJWa0oEhiUTgH8PYoLBa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIBqB2KvZjFVkHnXdCFYcPmvhJYusCpdbwUSxsUnEppxySiZKHr6ujdMRwrh8g4qt
	 5fiDo/XgIUkczkL5tETCkzGx5KdGgnWQc5JnL5d8L8fKxa8u8+LeZZn1UU1ng17Sf+
	 qwuhyzZeorB2mB5yXpyatBI9I5Qu1WTv7oYJgnj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/244] Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock
Date: Tue, 31 Mar 2026 18:20:45 +0200
Message-ID: <20260331161745.184776659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 94d8e6fe5d0818e9300e514e095a200bd5ff93ae ]

btintel_hw_error() issues two __hci_cmd_sync() calls (HCI_OP_RESET
and Intel exception-info retrieval) without holding
hci_req_sync_lock().  This lets it race against
hci_dev_do_close() -> btintel_shutdown_combined(), which also runs
__hci_cmd_sync() under the same lock.  When both paths manipulate
hdev->req_status/req_rsp concurrently, the close path may free the
response skb first, and the still-running hw_error path hits a
slab-use-after-free in kfree_skb().

Wrap the whole recovery sequence in hci_req_sync_lock/unlock so it
is serialized with every other synchronous HCI command issuer.

Below is the data race report and the kasan report:

  BUG: data-race in __hci_cmd_sync_sk / btintel_shutdown_combined

  read of hdev->req_rsp at net/bluetooth/hci_sync.c:199
  by task kworker/u17:1/83:
   __hci_cmd_sync_sk+0x12f2/0x1c30 net/bluetooth/hci_sync.c:200
   __hci_cmd_sync+0x55/0x80 net/bluetooth/hci_sync.c:223
   btintel_hw_error+0x114/0x670 drivers/bluetooth/btintel.c:254
   hci_error_reset+0x348/0xa30 net/bluetooth/hci_core.c:1030

  write/free by task ioctl/22580:
   btintel_shutdown_combined+0xd0/0x360
    drivers/bluetooth/btintel.c:3648
   hci_dev_close_sync+0x9ae/0x2c10 net/bluetooth/hci_sync.c:5246
   hci_dev_do_close+0x232/0x460 net/bluetooth/hci_core.c:526

  BUG: KASAN: slab-use-after-free in
   sk_skb_reason_drop+0x43/0x380 net/core/skbuff.c:1202
  Read of size 4 at addr ffff888144a738dc
  by task kworker/u17:1/83:
   __hci_cmd_sync_sk+0x12f2/0x1c30 net/bluetooth/hci_sync.c:200
   __hci_cmd_sync+0x55/0x80 net/bluetooth/hci_sync.c:223
   btintel_hw_error+0x186/0x670 drivers/bluetooth/btintel.c:260

Fixes: 973bb97e5aee ("Bluetooth: btintel: Add generic function for handling hardware errors")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 3a4db68fc2e63..6e3e4a817e727 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -245,11 +245,13 @@ void btintel_hw_error(struct hci_dev *hdev, u8 code)
 
 	bt_dev_err(hdev, "Hardware error 0x%2.2x", code);
 
+	hci_req_sync_lock(hdev);
+
 	skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reset after hardware error failed (%ld)",
 			   PTR_ERR(skb));
-		return;
+		goto unlock;
 	}
 	kfree_skb(skb);
 
@@ -257,18 +259,21 @@ void btintel_hw_error(struct hci_dev *hdev, u8 code)
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Retrieving Intel exception info failed (%ld)",
 			   PTR_ERR(skb));
-		return;
+		goto unlock;
 	}
 
 	if (skb->len != 13) {
 		bt_dev_err(hdev, "Exception info size mismatch");
 		kfree_skb(skb);
-		return;
+		goto unlock;
 	}
 
 	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
 
 	kfree_skb(skb);
+
+unlock:
+	hci_req_sync_unlock(hdev);
 }
 EXPORT_SYMBOL_GPL(btintel_hw_error);
 
-- 
2.51.0



