Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8051C067;
	Wed, 30 Sep 2026 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792850; cv=none; b=pvN+n2ULfs1vxJPia6O7pluP1kqphBrZWw5qWMPkEYz9cjPWfEKkivWZ+1nwPXV2GdTTbk2jUPBMwC+YNWB3Wx3NZrN4gC9xJjHZyvNkph/u7z5eBJORFV0K1HD2f6enOZwptgELMv1BFvE6eWDQ9l1iuPkIr182NOyvzV+BGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792850; c=relaxed/simple;
	bh=J+yOBZRNsxUFd159m7Gh/fPWl5PqgYYC22QOq2e+XX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzcrElBwsWNlJxJG/qOUxSHSE4yNz0eiNbugcbfGGwa1yMarrcPCPWzEHKDz14VEVki+xify1utJeQk0wVVMwf4P+tOpVF9i9dsOrnbeK/JHWNmKFMViRJEoHx1SQKjJu2NIQ/mEKKgzk0SzF8MWCUQSvljdp3XLNWE7c1egCns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoIgQIUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoIgQIUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FD31F000FF;
	Wed, 30 Sep 2026 18:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792849;
	bh=pLxot6NOHEF1VUB6EYQ9IiGfm8L8IStB9ElNX5xpudU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoIgQIUH+K2ZrDC7744QqCsF98dErMJ3S/dm4e210ITQ4XKmePOTBTDa+1NpCGms7
	 TWrrQBXtbgxmmHk0/Rqbw0TwGyagYYQbLz9kC939tkj8pclQJEFshrTx2WHQ1dlP17
	 E3KK1TJYSwpV4k5MUDG1j5ma0TXTEnGiVcSOZ3tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/395] Bluetooth: mgmt: Dequeue pending mesh_send_sync entries on cancel
Date: Wed, 30 Sep 2026 17:25:09 +0200
Message-ID: <20260930152341.653943247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 01f46a985e2b3..3ab39becb07cb 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2313,6 +2313,8 @@ static void mesh_send_start_complete(struct hci_dev *hdev, void *data, int err)
 		hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
 		/* Send Complete Error Code for handle */
 		mesh_send_complete(hdev, mesh_tx, false);
+		if (err != -ECANCELED)
+			mesh_next(hdev, NULL, 0);
 		return;
 	}
 
@@ -2422,19 +2424,28 @@ static int send_cancel(struct hci_dev *hdev, void *data)
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



