Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18A9471266;
	Sat, 12 Sep 2026 10:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210439; cv=none; b=M4KvrjgkbtF0XOHSnybGXm/EF852jYBdodg0Tgvqm00bxRyfgDskG5/F8GXbT/SYOt8zieQsdVJd0PUfu9a1Y4w14p5nrObEu/wiKBYbVHxOTzF0hf3Uaq0BqL6xTU1+2BxdM/P1kobPAOgDeovZWhBLKMaH4l8V6WwvUkuMMdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210439; c=relaxed/simple;
	bh=0b7OgxP09yuIucrDBJ/wkvMVB5Fab0kEO7mMwybt38M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxSwrwbqBSwv9oGOv8cQJ4bVRYnPMf0a6FaMNXIczn3idt04TTFXoAUsYYREcHzRgMFdMTViHdZzD36Sd0zXB4RTbuD/FIoPju/rK4BGRakE53OxVnfL67dj/uVYC/Qv8C95kvLgBCaFtHY+Woakk1/cJ3etGyUYVm33Ztzvv/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPdv2prV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPdv2prV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5973D1F000FF;
	Sat, 12 Sep 2026 10:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210438;
	bh=OiQqMJbegrIzC/x1ToZlCQe7WeakgFuRMFmMcRablcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPdv2prVHaJrdeKOfF1z7nR/ZL17/w+1gIN/z7Rn3FJ/0fxBH4/xIJI8/1m4cJjN0
	 yKSTVlms7fuAXKvcXTHj/2kN6C5bArnft/5VeAr+noNsBYgFccG6m0pNq05KBYVBfC
	 mk8gcJZKrQffnUMutJN9KcifQSiU4EVBWzWA7YUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1027/1518] Bluetooth: MGMT: free the mesh send cancel command when it is cancelled
Date: Sat, 12 Sep 2026 08:53:16 +0200
Message-ID: <20260912065646.682353588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 0ef601dbb2e28..5fac2ce4340dd 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2434,11 +2434,15 @@ static int send_cancel(struct hci_dev *hdev, void *data)
 
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
@@ -2459,7 +2463,8 @@ static int mesh_send_cancel(struct sock *sk, struct hci_dev *hdev,
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



