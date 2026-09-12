Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3D73F788A;
	Sat, 12 Sep 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231108; cv=none; b=Sg4rBIcK5e9hHsMn6fcAbhEfPwL1f8dV/GcImo4w1HAdqG7lp3ie8lQqiFI0GqyOEH0cHpYSZYq7iTG6VLuxEYk0JKgxTSXAaLxxBbae6NpFGHv7E95dzPbz5lR9YkxKfL/xHv6YnC4cNYEMTPBnV6v/pu8N62NgLvbifCcsM4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231108; c=relaxed/simple;
	bh=cdkQ98dZCxMHZDKSkOgzqkiQr6N/oARexqrWcSBr7ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htfEVPCzhoAq3xVtTRDxeQNKeAL/gh54bywvk0rBxFU6B6yhnY+5kuse301D7d8trL5vZ6AK0KvO2M9Kw2ZkmY0u2DbTrpJDBe5narfIwXOr4TJbdFms4MTNLtEanPLVqBAe7i59Blkrlqo16/oEi4t5IId1P6qi+MA0QAKeokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlcI1DT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlcI1DT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDB01F000FF;
	Sat, 12 Sep 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231106;
	bh=E1YRmkErWFcO5UNe1bPz1Hc1Ov+jvCOCNS5ZP0mU8LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlcI1DT5GmfN7+pQGCMjiCwIj+mV3i5ndwHnIBkGBToIdOAmKNTojGTb71YbGjHW0
	 OdfJKpKvkaPgn9pADOmINpCc00RXQEHjUdcpxwrPodB/ykByUwKL7fHPUOhPV8ZToC
	 hD2Kb6rN+nbeegbU5cI8UdxdhgkF1/zrKhxpA22g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0932/1191] Bluetooth: MGMT: free the mesh send cancel command when it is cancelled
Date: Sat, 12 Sep 2026 09:01:00 +0200
Message-ID: <20260912065609.161235033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 3c742feda8fcabf741a17bcf668b63c8f606f9c5 ]

mesh_send_cancel() queues the pending command with a NULL destroy
callback, so it is only freed if send_cancel() runs. A cancelled entry is
leaked, as _hci_cmd_sync_cancel_entry() does not release entry->data when
there is no destroy callback, and hci_cmd_sync_clear() cancels every
pending entry when the controller is unregistered. Nothing else reclaims
it either: mgmt_pending_new() does not put the command on
hdev->mgmt_pending.

The leak also pins the socket reference taken by mgmt_pending_new(), so
the mgmt socket is never released.

Free the command from a destroy callback.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fd11dcd354273..00401d6099585 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2338,11 +2338,15 @@ static int send_cancel(struct hci_dev *hdev, void *data)
 
 	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_MESH_SEND_CANCEL,
 			  0, NULL, 0);
-	mgmt_pending_free(cmd);
 
 	return 0;
 }
 
+static void send_cancel_destroy(struct hci_dev *hdev, void *data, int err)
+{
+	mgmt_pending_free(data);
+}
+
 static int mesh_send_cancel(struct sock *sk, struct hci_dev *hdev,
 			    void *data, u16 len)
 {
@@ -2363,7 +2367,8 @@ static int mesh_send_cancel(struct sock *sk, struct hci_dev *hdev,
 	if (!cmd)
 		err = -ENOMEM;
 	else
-		err = hci_cmd_sync_queue(hdev, send_cancel, cmd, NULL);
+		err = hci_cmd_sync_queue(hdev, send_cancel, cmd,
+					 send_cancel_destroy);
 
 	if (err < 0) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_MESH_SEND_CANCEL,
-- 
2.53.0



