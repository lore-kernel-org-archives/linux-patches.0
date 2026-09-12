Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D6B202F71;
	Sat, 12 Sep 2026 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217677; cv=none; b=WAfkfFXhRshm/ghU5f5vR8eTfGdTveyLutNXNC6JyB+u3VjzVkxX/lfj0q4R48SVrPGqFAofBk9f7woMLRNyd1iGBHWIIidE0o+eoVoza3vXSLdXklPzL4rzTr25m5rOx19UG/3D0Ze0P+hGAqK31unCeAiUUR3hiT/a015H2zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217677; c=relaxed/simple;
	bh=ix3OVpOX+ZcHVr4lmygY0qDME3MDmoDM2oSD/UGDnKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJYFz3e2NnCn/zLdDwWrxWZ6KmoiYvvc4TikYYZw548I0MLPvdG4KL8a+RVZL5Cnt7FQCB4WI9aGZRfIYS8M/BZVKL1miPWE0HImOOStwWtASDkfcic6R/VI36/4AMkoqU5a/2nb8uGzcxkx4bWRZ/kHavlhQZvf747bb/zXJCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIOHyjUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIOHyjUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B01F000FF;
	Sat, 12 Sep 2026 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217675;
	bh=OKUFb22v9/ve4e7zzDCNAirNDK5YwK4sJqdZWAksZJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIOHyjUAPi4XSQx1zoDEo+m9fkZr2OO0NvhTfGkr0Nz2peG8EXJDt64tVW/hpuoaQ
	 6vf42mpGC/uPMOJZcpss/e3LELdWYfnrToM4xaQ1S2dPe4GQrZ+pVUNlfLDFrhRRwg
	 YdUuNXpXMi05Tv5z9wQtjxUVdoVSJ7aHBo/6rWyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0989/1376] Bluetooth: MGMT: free the mesh send cancel command when it is cancelled
Date: Sat, 12 Sep 2026 08:56:55 +0200
Message-ID: <20260912065629.608892102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 13b1ecb83e0e3..d92eb0d4c54da 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2411,11 +2411,15 @@ static int send_cancel(struct hci_dev *hdev, void *data)
 
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
@@ -2436,7 +2440,8 @@ static int mesh_send_cancel(struct sock *sk, struct hci_dev *hdev,
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



