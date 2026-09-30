Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A98B513551;
	Wed, 30 Sep 2026 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786323; cv=none; b=ufxrNSto6FFUYdSLl4cQd5jXMJChbykc1dy8qBRaHYQLedOsfchuuxoIxGP3G23oDzWZ7Xu28aXXPBnLovGqa/kdq7nU497nQX+mPztukNO8wz++fxipF9ni/0rLluWcqe7uU3fWofpPGqQKfWeaSB86b2HCSjsuOunjTpAYvww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786323; c=relaxed/simple;
	bh=OsDIlG/5lrl8X2dBx31/TrKwCfKAmzy+ijlygh5yXcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qoi4Ufkx9Jyi09HW6M5ZfQEbcMZb3oMNClTmYhA1RZP6T9RnregO33/Ii7JsLwV8xDFg3T11PvHC6bWo52/j/MziYU4TXGj1NZ9v0lm19yrC98RyrXSVUm6pqY8BjBGcW0XYCV0yJhllNv95BgtVpR+T0Nw1pNA2P40roT7t6kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4R605FA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4R605FA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643F01F000FF;
	Wed, 30 Sep 2026 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786321;
	bh=6Gklqe4OuX/5ljlx8jno8kDu/oa5m9xq9C6MHYEi0lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4R605FAzSyaSmeRp5EjPAbZLSWit8lij+t3aINdKy8U3xq2PwHqhLlLtu+ft4jts
	 NoRipBpF0GT8jExz1ywt6r8AyFpH6qaO8KFiVe63HqWYq0jSJMDI/SxPgSQIFr4UJk
	 UJXl3hpYeWFmSiZzDtoQ3Ar5O2uAoSLGnNvlSOF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 820/982] Bluetooth: mgmt: Dequeue pending mesh_send_sync entries on cancel
Date: Wed, 30 Sep 2026 17:25:56 +0200
Message-ID: <20260930152434.371932330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit 71af682ba4692c2ed9ace4c3d4ca462ae368c029 ]

In send_cancel(), pending mesh_tx objects are removed from the
hdev->mesh_pending list and freed via mesh_send_complete().  However, if
a mesh transmission was already queued onto hdev->cmd_sync_work_list via
mesh_next(), the queued entry retains a raw pointer to mesh_tx.

When hci_cmd_sync_work later processes the entry, it attempts to execute
mesh_send_sync and its destroy callback mesh_send_start_complete using
the already freed mesh_tx pointer, leading to a use-after-free.

Fix this by invoking hci_cmd_sync_dequeue() for mesh_send_sync on the
target mesh_tx before completing it.  If the entry is found and dequeued,
its destroy callback will complete and free the object; otherwise,
mesh_send_complete() is called directly.

Additionally, ensure the transmission queue advances after cancellation
or errors.  In mesh_send_start_complete(), call mesh_next() on error
unless err is -ECANCELED, because hci_cmd_sync_dequeue() holds
hdev->cmd_sync_work_lock and calling mesh_next() synchronously would
deadlock.  Instead, advance the queue in send_cancel() once the lock is
released and if no transmission is in progress.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 6a3f4afc9760a..251e0c0a062a7 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2217,6 +2217,8 @@ static void mesh_send_start_complete(struct hci_dev *hdev, void *data, int err)
 		hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
 		/* Send Complete Error Code for handle */
 		mesh_send_complete(hdev, mesh_tx, false);
+		if (err != -ECANCELED)
+			mesh_next(hdev, NULL, 0);
 		return;
 	}
 
@@ -2326,19 +2328,28 @@ static int send_cancel(struct hci_dev *hdev, void *data)
 		do {
 			mesh_tx = mgmt_mesh_next(hdev, cmd->sk);
 
-			if (mesh_tx)
-				mesh_send_complete(hdev, mesh_tx, false);
+			if (mesh_tx) {
+				if (!hci_cmd_sync_dequeue(hdev, mesh_send_sync,
+							  mesh_tx, NULL))
+					mesh_send_complete(hdev, mesh_tx, false);
+			}
 		} while (mesh_tx);
 	} else {
 		mesh_tx = mgmt_mesh_find(hdev, cancel->handle);
 
-		if (mesh_tx && mesh_tx->sk == cmd->sk)
-			mesh_send_complete(hdev, mesh_tx, false);
+		if (mesh_tx && mesh_tx->sk == cmd->sk) {
+			if (!hci_cmd_sync_dequeue(hdev, mesh_send_sync,
+						  mesh_tx, NULL))
+				mesh_send_complete(hdev, mesh_tx, false);
+		}
 	}
 
 	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_MESH_SEND_CANCEL,
 			  0, NULL, 0);
 
+	if (!hci_dev_test_flag(hdev, HCI_MESH_SENDING))
+		mesh_next(hdev, NULL, 0);
+
 	return 0;
 }
 
-- 
2.53.0



