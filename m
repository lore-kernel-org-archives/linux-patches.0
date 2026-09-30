Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC83357D11;
	Wed, 30 Sep 2026 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786948; cv=none; b=ZgK1HrkD52DKqActBJcyj2lq5rWeXoLqBiiDlsJrWoDvqG0yI6gHLuyLB/DIzdEKpnGf3xxPHxwdDLdSk2psgA3t30sJ3Ly276bV9EhK0p9BQBJnKK2xnKuo/7aDyVosY6NDnbkSippZiFRFdMtDt9D+aiVomfQkZUXjGlnR/Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786948; c=relaxed/simple;
	bh=9orYnatfFa5MtnLOU2Q8eNG98V98AGjwxNq50vEegrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfXybSnDlI1FpwSWwd+3Kv3ftX8LCpIzfUa4+NU0mjFxgr6dU9rPtB86mYXo7pGJ3fJ93GOgHP41ZSf99sl62HPnQEiZ/DrxtAZrqYbSkZ3MGeu4d1W8++TYVvyKQpEMe5XC63c3KDxDKzqJeqNCMP34SsYI+kJGCtmJBqUmZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlP2zE/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlP2zE/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72C21F000FF;
	Wed, 30 Sep 2026 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786947;
	bh=CR3XAQxkNAO1unBpi7apvn6Bgohs45PLCDiJfqeLyGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlP2zE/gJ+1T4TJO2aexMEbuj+a3bdvy50jT0KQtWI5XVP3joeU4TzUQW6cVZSwGX
	 nMDNcTK/cEGsLs0pvk0Li8JSLbZ7CjKKFCt+x8rTNSkEGwBcj5q7IwGfhYtgCHxtSO
	 kJa6SHJO2MBeyAJ+YQ0ltnUk13s7+8rTA7hGC5YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 056/457] Bluetooth: mgmt: Dequeue pending mesh_send_sync entries on cancel
Date: Wed, 30 Sep 2026 17:22:41 +0200
Message-ID: <20260930152347.247523125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index deced8a5bc2d6..9bcc35de08899 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2310,6 +2310,8 @@ static void mesh_send_start_complete(struct hci_dev *hdev, void *data, int err)
 		hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
 		/* Send Complete Error Code for handle */
 		mesh_send_complete(hdev, mesh_tx, false);
+		if (err != -ECANCELED)
+			mesh_next(hdev, NULL, 0);
 		return;
 	}
 
@@ -2419,19 +2421,28 @@ static int send_cancel(struct hci_dev *hdev, void *data)
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



