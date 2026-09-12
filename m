Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFEA455181;
	Sat, 12 Sep 2026 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210444; cv=none; b=craGCoMjRjjh1U2o2Hk1gXZVAQZ6HHv9OHsA2gTwrZbFIwY84VK1ERTeiyfu+58d32z6Hwa/2Epxc7Ix6OPrJIaDJFnnDq25WkhaSCarzeboI5VKEyNmrk6I5BbnLrwlZBm8xPS/lF4He9zBYyI03XZzY1e4NZCXnhKnPfL3Xew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210444; c=relaxed/simple;
	bh=Y9893PataQ8AWr4TOqFf+HB6QCjl5m4IBDl57TVoJ/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCoNONZGQonwfIimTtW1aGKAiA5ncM/VFvc/qbSYL8YuuX+ezyRwoIF8ET+JISlD3TL2quJYTUm/ZivCQQcsA3jVXni3kVuh3s+aan2IlfMaIAADwiIflJEF+X+bMN4DXd+1EEcI/Ub/NQx94STHFTB4kkAxz7JzV9cT8rUUb5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmmJxjkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmmJxjkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901F21F000FF;
	Sat, 12 Sep 2026 10:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210443;
	bh=5gEDuvPx4/LWt00Dam7aOUm3gHkwxs1KuP4m65xVZOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmmJxjkOooVtgiGD1idaAh9CRs3caVYe+nUb+arF+JMPhRFnAH20deRgZeE+Vz8P6
	 zh7aKYGiVgfnbAt8RLfhSpjMUVwQ0MDalHjHyqaE7bqNrIHfQ2eUB38KRZ05B37MHH
	 7HszXUgpXwsANvsNv9Tx5UnVWMe2SDSswnB0s3Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1028/1518] Bluetooth: MGMT: free the HCI command when it is cancelled
Date: Sat, 12 Sep 2026 08:53:17 +0200
Message-ID: <20260912065646.704926710@linuxfoundation.org>
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

[ Upstream commit 414b365ecea6c30357adee6b8a7c5edc03a03575 ]

mgmt_hci_cmd_sync() queues the pending command with a NULL destroy
callback, so it is only freed if send_hci_cmd_sync() runs. A cancelled
entry is leaked, as _hci_cmd_sync_cancel_entry() does not release
entry->data when there is no destroy callback, and hci_cmd_sync_clear()
cancels every pending entry when the controller is unregistered. Nothing
else reclaims it either: mgmt_pending_new() does not put the command on
hdev->mgmt_pending.

The leak also pins the socket reference taken by mgmt_pending_new(), so
the mgmt socket is never released.

Free the command from a destroy callback. The now-empty done label is
replaced by a direct return.

Fixes: 827af4787e74 ("Bluetooth: MGMT: Add initial implementation of MGMT_OP_HCI_CMD_SYNC")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5fac2ce4340dd..62f496b446e7a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2650,7 +2650,7 @@ static int send_hci_cmd_sync(struct hci_dev *hdev, void *data)
 	if (IS_ERR(skb)) {
 		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_HCI_CMD_SYNC,
 				mgmt_status(PTR_ERR(skb)));
-		goto done;
+		return 0;
 	}
 
 	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_HCI_CMD_SYNC, 0,
@@ -2658,12 +2658,14 @@ static int send_hci_cmd_sync(struct hci_dev *hdev, void *data)
 
 	kfree_skb(skb);
 
-done:
-	mgmt_pending_free(cmd);
-
 	return 0;
 }
 
+static void send_hci_cmd_sync_destroy(struct hci_dev *hdev, void *data, int err)
+{
+	mgmt_pending_free(data);
+}
+
 static int mgmt_hci_cmd_sync(struct sock *sk, struct hci_dev *hdev,
 			     void *data, u16 len)
 {
@@ -2689,7 +2691,8 @@ static int mgmt_hci_cmd_sync(struct sock *sk, struct hci_dev *hdev,
 	if (!cmd)
 		err = -ENOMEM;
 	else
-		err = hci_cmd_sync_queue(hdev, send_hci_cmd_sync, cmd, NULL);
+		err = hci_cmd_sync_queue(hdev, send_hci_cmd_sync, cmd,
+					 send_hci_cmd_sync_destroy);
 
 	if (err < 0) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_HCI_CMD_SYNC,
-- 
2.53.0



