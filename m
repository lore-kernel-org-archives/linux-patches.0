Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428E93FEB20;
	Tue, 31 Mar 2026 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974387; cv=none; b=tRj5Cdqn2qQuJIiJkIWjfn0ct+XZjrVx7ima8roTlKAd4py6yzErilv0FIVNF7uAFN7/IPYL38cOmgkmHZ064xB4iXqo4hPEck6JEQAdPLtmmapVnJPiOnBaqjeV57ZOtiPn3Ji31gDVslZzPNjG3OoGD88Y3YL4PplndGjNgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974387; c=relaxed/simple;
	bh=hXEpCyDpZ6OHbLnZu8fYQlxfqelx6fjZpfUqB99054A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1NWML1DkrdJYjcQYSspVxFTKml91NWkL4hX2ewE46zFf53buVuUgAk3SUkYYpPeOTR7bHMBD8IYwCPeC+6fjy7NtY49JiiAkAzDzMN9Vk4777jL9lJmJUzYWN/bM9ghzYkNwU5ZEKhi1OfvTvhHglShyku/2uwdMHtHg6R3DoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1jNBa6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1jNBa6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14FEC19423;
	Tue, 31 Mar 2026 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974387;
	bh=hXEpCyDpZ6OHbLnZu8fYQlxfqelx6fjZpfUqB99054A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1jNBa6M4tG/1eMv8UalQxD3Pn+1pWgOksnBhoYGCua3Ph8/8EluIMMNLGqavQpdZ
	 BNw5xEHBKuU9jWUzVzc8w34izlmt9OuZDizQp+xxa01UtKR8FdIOHdKsB+46OkOWBP
	 C01AnmZkKwiDdTyigqDtgJNB4zlN6O4BpTiHXS9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/175] Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock
Date: Tue, 31 Mar 2026 18:20:49 +0200
Message-ID: <20260331161732.170706201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index 3773cd9d998d5..25fcd00c6a174 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -242,11 +242,13 @@ static void btintel_hw_error(struct hci_dev *hdev, u8 code)
 
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
 
@@ -254,18 +256,21 @@ static void btintel_hw_error(struct hci_dev *hdev, u8 code)
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
 
 int btintel_version_info(struct hci_dev *hdev, struct intel_version *ver)
-- 
2.51.0



