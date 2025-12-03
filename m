Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000BD327213;
	Wed,  3 Dec 2025 15:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776954; cv=none; b=U9zg/okHKInvm7nrhuwvEfJWoNrK2HM65x6UYfTu4eomTkvf8NXfHM32e3dt3EUTMonwLh67g6HX5Gfuoi6/TOEd0fSkK4sia3SBXHHxZdVcYEegTgC2ZE0odfBNPR0XSMtWlWNtuMW9cnk+FoO4DyuGr/wX41Hpwncagkh/WKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776954; c=relaxed/simple;
	bh=SYaQpDevVexRqBDG7SiK8pKJcNQT4jsJfKNNntPNAnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNVxp1BmwhxDLc4RYFmBQHKj//1Qnbw7hMTurPnzCQU+dy03fN/k/JQIwoY3D3HUx3XTKdld110OTRyJH9MeJ+aV2uMANYgWuTBHJDgjVXKWFSTYrjJIWHZ2a2iotW1wcDeMhTY9OWIYql0wXVcyIQCTnD8bir+Zkrpe8u3YUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INHOefUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INHOefUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B50C4CEF5;
	Wed,  3 Dec 2025 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776953;
	bh=SYaQpDevVexRqBDG7SiK8pKJcNQT4jsJfKNNntPNAnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INHOefUrHqVF5wBuvOSTekmvx2vQ0SAafFCnIj4t3KR+nHIwqsCvY7dvsjMVh+g+U
	 8O9jMcnmsy+3u9otE6SMkok+TugJKj+x9PAbtmcIpIPwvBTpyMlXVjmcjz2B+z/Jtg
	 fxWEttv67DywV833BP9Xmwltw7/eDuwALPqaH4r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 006/146] Bluetooth: hci_core: Fix triggering cmd_timer for HCI_OP_NOP
Date: Wed,  3 Dec 2025 16:26:24 +0100
Message-ID: <20251203152346.697975707@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 275ddfeb3fdc274050c2173ffd985b1e80a9aa37 ]

HCI_OP_NOP means no command was actually sent so there is no point in
triggering cmd_timer which may cause a hdev->reset in the process since
it is assumed that the controller is stuck processing a command.

Fixes: e2d471b7806b ("Bluetooth: ISO: Fix not using SID from adv report")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 55e0722fd0662..72c7607aac209 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4093,7 +4093,7 @@ static void hci_rx_work(struct work_struct *work)
 	}
 }
 
-static void hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
+static int hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	int err;
 
@@ -4105,16 +4105,19 @@ static void hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 	if (!hdev->sent_cmd) {
 		skb_queue_head(&hdev->cmd_q, skb);
 		queue_work(hdev->workqueue, &hdev->cmd_work);
-		return;
+		return -EINVAL;
 	}
 
 	if (hci_skb_opcode(skb) != HCI_OP_NOP) {
 		err = hci_send_frame(hdev, skb);
 		if (err < 0) {
 			hci_cmd_sync_cancel_sync(hdev, -err);
-			return;
+			return err;
 		}
 		atomic_dec(&hdev->cmd_cnt);
+	} else {
+		err = -ENODATA;
+		kfree_skb(skb);
 	}
 
 	if (hdev->req_status == HCI_REQ_PEND &&
@@ -4122,12 +4125,15 @@ static void hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
 	}
+
+	return err;
 }
 
 static void hci_cmd_work(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, cmd_work);
 	struct sk_buff *skb;
+	int err;
 
 	BT_DBG("%s cmd_cnt %d cmd queued %d", hdev->name,
 	       atomic_read(&hdev->cmd_cnt), skb_queue_len(&hdev->cmd_q));
@@ -4138,7 +4144,9 @@ static void hci_cmd_work(struct work_struct *work)
 		if (!skb)
 			return;
 
-		hci_send_cmd_sync(hdev, skb);
+		err = hci_send_cmd_sync(hdev, skb);
+		if (err)
+			return;
 
 		rcu_read_lock();
 		if (test_bit(HCI_RESET, &hdev->flags) ||
-- 
2.51.0



