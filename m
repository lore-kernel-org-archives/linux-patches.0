Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956D336EC5;
	Tue, 31 Mar 2026 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974385; cv=none; b=CFqunkl9jsfTUAo2PlVc+AAc9WJWr3YmYuR7YHtr3cJORkYirgHALTSMVmAfo2kBBMmUlAXZ+ipS9IAhGhQNGLju4kPKsB4hsAtpgVBXDpQNZ+GOumMHkR3Uk/OMRxXdysZAomhG1R0ALoiUbgfwXQ40h7mT0VM3bnu+R49qxC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974385; c=relaxed/simple;
	bh=R9tD341VAzPIGznTgxJdzEvxA5LH8JM7j69fdXxHzFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD6WTy3+0GZd+490NUa4fGIEbWIjCiTpMp82OQObhaWtAd9VMcWfdzugDm5LvvCfGXwkq1PBDQecEfc95/p4uIdt0TOnb6vbW9Fy7qKWoQCbPLFBi/K21PtQ+ZVvyLD6m4WJm5Ggs8qYuhtgMOw4dpidpjgq2dkbDTWbKbVFvhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCSvHdc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCSvHdc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F37C19423;
	Tue, 31 Mar 2026 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974384;
	bh=R9tD341VAzPIGznTgxJdzEvxA5LH8JM7j69fdXxHzFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCSvHdc4v5tXSMKKLw2w/ipSgNn6QTuQyCmUssYrQxRQDRvWJBot/A9qj6O1ZH47s
	 2Lml0IuBqrctALKwE9upcJjLuQyXIS40ghq/yAETkM++YNQNNpd8M/1V8C49OVxSb9
	 P+zClvaHEiVX400shIDbIB31OCU2DiuZ5xmXzVsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/175] Bluetooth: hci_sync: Remove remaining dependencies of hci_request
Date: Tue, 31 Mar 2026 18:20:48 +0200
Message-ID: <20260331161732.134102495@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f2d89775358606c7ab6b6b6c4a02fe1e8cd270b1 ]

This removes the dependencies of hci_req_init and hci_request_cancel_all
from hci_sync.c.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 94d8e6fe5d08 ("Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h | 17 +++++++++++++++++
 net/bluetooth/hci_request.h      | 17 -----------------
 net/bluetooth/hci_sync.c         | 14 +++++++++++---
 3 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index e2e588b08fe90..e155ab5aa9b4f 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -8,6 +8,23 @@
 #define UINT_PTR(_handle)		((void *)((uintptr_t)_handle))
 #define PTR_UINT(_ptr)			((uintptr_t)((void *)_ptr))
 
+#define HCI_REQ_DONE	  0
+#define HCI_REQ_PEND	  1
+#define HCI_REQ_CANCELED  2
+
+#define hci_req_sync_lock(hdev)   mutex_lock(&hdev->req_lock)
+#define hci_req_sync_unlock(hdev) mutex_unlock(&hdev->req_lock)
+
+struct hci_request {
+	struct hci_dev		*hdev;
+	struct sk_buff_head	cmd_q;
+
+	/* If something goes wrong when building the HCI request, the error
+	 * value is stored in this field.
+	 */
+	int			err;
+};
+
 typedef int (*hci_cmd_sync_work_func_t)(struct hci_dev *hdev, void *data);
 typedef void (*hci_cmd_sync_work_destroy_t)(struct hci_dev *hdev, void *data,
 					    int err);
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index c91f2838f5424..b730da4a8b476 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -22,23 +22,6 @@
 
 #include <asm/unaligned.h>
 
-#define HCI_REQ_DONE	  0
-#define HCI_REQ_PEND	  1
-#define HCI_REQ_CANCELED  2
-
-#define hci_req_sync_lock(hdev)   mutex_lock(&hdev->req_lock)
-#define hci_req_sync_unlock(hdev) mutex_unlock(&hdev->req_lock)
-
-struct hci_request {
-	struct hci_dev		*hdev;
-	struct sk_buff_head	cmd_q;
-
-	/* If something goes wrong when building the HCI request, the error
-	 * value is stored in this field.
-	 */
-	int			err;
-};
-
 void hci_req_init(struct hci_request *req, struct hci_dev *hdev);
 void hci_req_purge(struct hci_request *req);
 bool hci_req_status_pend(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6192f70e4d393..c1c9d82faa658 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -12,7 +12,6 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/mgmt.h>
 
-#include "hci_request.h"
 #include "hci_codec.h"
 #include "hci_debugfs.h"
 #include "smp.h"
@@ -147,6 +146,13 @@ static int hci_req_sync_run(struct hci_request *req)
 	return 0;
 }
 
+static void hci_request_init(struct hci_request *req, struct hci_dev *hdev)
+{
+	skb_queue_head_init(&req->cmd_q);
+	req->hdev = hdev;
+	req->err = 0;
+}
+
 /* This function requires the caller holds hdev->req_lock. */
 struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 				  const void *param, u8 event, u32 timeout,
@@ -158,7 +164,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	bt_dev_dbg(hdev, "Opcode 0x%4.4x", opcode);
 
-	hci_req_init(&req, hdev);
+	hci_request_init(&req, hdev);
 
 	hci_cmd_sync_add(&req, opcode, plen, param, event, sk);
 
@@ -5227,7 +5233,9 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	cancel_delayed_work(&hdev->le_scan_disable);
 	cancel_delayed_work(&hdev->le_scan_restart);
 
-	hci_request_cancel_all(hdev);
+	hci_cmd_sync_cancel_sync(hdev, ENODEV);
+
+	cancel_interleave_scan(hdev);
 
 	if (hdev->adv_instance_timeout) {
 		cancel_delayed_work_sync(&hdev->adv_instance_expire);
-- 
2.51.0



