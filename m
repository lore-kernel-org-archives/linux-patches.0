Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E8526982C;
	Sat, 12 Sep 2026 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202687; cv=none; b=Z5qylUSrc8W+/zriKH+EvscNCGnZ6n+wEj+xQWI0xq7AFMSQ8XZmv88ynTaB/RV5istxGUEWDZvRB3lA1Ahk1a5mqlnXfypODqPekYY+pE/ufmg0ZmlwyPc8kSVOFNoWWSrlWBR4Sm31kjibkB/58CoXkUvhbu6Nmz5551Ih1pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202687; c=relaxed/simple;
	bh=2k6BM/wOIvCSHxTdzltsjW1jW9Vcal895FifapvPafw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aS+fVGS2AY9XTydShB68FZyIENG+BSi4Q8uQfPbISQhBj7tCAJhMgP222VHfHF5m2G9zEW79AMLO5KjLUS6g494jKWYuvC3xwcZCsyVCa5KGwg22I+D3cal98dVBvkn5Vn0NE8HC9oT0z15PX4ybQO2cp/3+T31/I0jeKh2hiRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qR/3VrY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qR/3VrY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7251F000FF;
	Sat, 12 Sep 2026 08:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202686;
	bh=Nq2Ij1AeALL3U8Hw8+4cMRqLmd7oOMpSffhC+1hQ5wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qR/3VrY48za29Z7y6onugO6IotgAnDVYcHIc998uu/Bgr1KinyJ6yRCXoqzTP92kq
	 Oa5pCUrdeN05JuauzHsbNWgvB9hW0/0icWXoHczmpgvYOeBBQPcQf+y7AwMmTnyYy+
	 UoyEkVcu150RLtyj/is1SToWGQ8OohoK8WDcy1fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1254/1815] Bluetooth: MGMT: free the HCI command when it is cancelled
Date: Sat, 12 Sep 2026 08:50:04 +0200
Message-ID: <20260912065718.452237187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 1a62bde2d1d38..aae0330bbc6aa 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2647,7 +2647,7 @@ static int send_hci_cmd_sync(struct hci_dev *hdev, void *data)
 	if (IS_ERR(skb)) {
 		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_HCI_CMD_SYNC,
 				mgmt_status(PTR_ERR(skb)));
-		goto done;
+		return 0;
 	}
 
 	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_HCI_CMD_SYNC, 0,
@@ -2655,12 +2655,14 @@ static int send_hci_cmd_sync(struct hci_dev *hdev, void *data)
 
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
@@ -2686,7 +2688,8 @@ static int mgmt_hci_cmd_sync(struct sock *sk, struct hci_dev *hdev,
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



