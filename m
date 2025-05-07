Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B592929A0;
	Wed,  7 May 2025 19:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644530; cv=none; b=gLvBfE2fyzMM3uPQWmz9Pw+9YL24B/uQziSa0kiMbFecRmNYxArWIcXnElzA5GP9rgARxozLUApif14m0Vo830/QWoDv/nWLLdymlRZbwjVW8huEAiV7m3i0jOOukzHU2mCS0ekJROJu2wL3n3gzuMoP6a/TPj6blzVY0vooHvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644530; c=relaxed/simple;
	bh=PXLAKOjC1YsmiZPx5ru17r4giawbHnJuu/yTANG8qP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAgVwI1UlICRJxZdp9sug/v+u14LL9ClTPzbzLioBmy7206ZSrdm2U5zCZIzyOKrRpiE5QkQyXDO0s6fUf6hBABK3Uwz9gPXjpIOg+65KzGPvjpANC1STeCqsBlFJHvaXs4/yWnPcfTDeJR//tKrk3jOmVMQIM1KwmsVdw9aAho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdrlVchF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdrlVchF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4706DC4CEE2;
	Wed,  7 May 2025 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644530;
	bh=PXLAKOjC1YsmiZPx5ru17r4giawbHnJuu/yTANG8qP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdrlVchFY+FwEPnDknfznIkju3EjtTO7ji5wbGTqOn4APYJF8+NjNbDqmA/q1Qqow
	 duD7HFLeYv1Lx2iNBeZD/7rBEPg1JuoL5VQgEsu+r3XFAvkwGg1KgjArJm9I1wBd7q
	 cCdvH+feTQFm1jpgNqvzXklLI6h4WkaDtjxarSB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/164] Bluetooth: hci_conn: Remove alloc from critical section
Date: Wed,  7 May 2025 20:39:19 +0200
Message-ID: <20250507183823.960975334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 25ab2db3e60e0e84d7cdc740ea6ae3c10fe61eaa ]

This removes the kzalloc memory allocation inside critical section in
create_pa_sync, fixing the following message that appears when the kernel
is compiled with CONFIG_DEBUG_ATOMIC_SLEEP enabled:

BUG: sleeping function called from invalid context at
include/linux/sched/mm.h:321

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6d0417e4e1cf ("Bluetooth: hci_conn: Fix not setting conn_timeout for Broadcast Receiver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index e6591f487a511..d097e308a7554 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2079,7 +2079,7 @@ static bool hci_conn_check_create_pa_sync(struct hci_conn *conn)
 
 static int create_pa_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_cp_le_pa_create_sync *cp = NULL;
+	struct hci_cp_le_pa_create_sync cp = {0};
 	struct hci_conn *conn;
 	int err = 0;
 
@@ -2108,19 +2108,13 @@ static int create_pa_sync(struct hci_dev *hdev, void *data)
 		if (hci_conn_check_create_pa_sync(conn)) {
 			struct bt_iso_qos *qos = &conn->iso_qos;
 
-			cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-			if (!cp) {
-				err = -ENOMEM;
-				goto unlock;
-			}
-
-			cp->options = qos->bcast.options;
-			cp->sid = conn->sid;
-			cp->addr_type = conn->dst_type;
-			bacpy(&cp->addr, &conn->dst);
-			cp->skip = cpu_to_le16(qos->bcast.skip);
-			cp->sync_timeout = cpu_to_le16(qos->bcast.sync_timeout);
-			cp->sync_cte_type = qos->bcast.sync_cte_type;
+			cp.options = qos->bcast.options;
+			cp.sid = conn->sid;
+			cp.addr_type = conn->dst_type;
+			bacpy(&cp.addr, &conn->dst);
+			cp.skip = cpu_to_le16(qos->bcast.skip);
+			cp.sync_timeout = cpu_to_le16(qos->bcast.sync_timeout);
+			cp.sync_cte_type = qos->bcast.sync_cte_type;
 
 			break;
 		}
@@ -2131,17 +2125,15 @@ static int create_pa_sync(struct hci_dev *hdev, void *data)
 
 	hci_dev_unlock(hdev);
 
-	if (cp) {
+	if (bacmp(&cp.addr, BDADDR_ANY)) {
 		hci_dev_set_flag(hdev, HCI_PA_SYNC);
 		set_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
 
 		err = __hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC,
-					    sizeof(*cp), cp, HCI_CMD_TIMEOUT);
+					    sizeof(cp), &cp, HCI_CMD_TIMEOUT);
 		if (!err)
 			err = hci_update_passive_scan_sync(hdev);
 
-		kfree(cp);
-
 		if (err) {
 			hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 			clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
-- 
2.39.5



