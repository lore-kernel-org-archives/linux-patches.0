Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F79436BF8;
	Thu, 30 Jul 2026 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421429; cv=none; b=FjLpCwouGvwqnvXECdtRkxHnyXDos+cYqKIoHmE1WzAmARJat7svTpK7ugNnpCVR2gyg5pt8TWXLVd0+CNquH3GtyMYA7jsQUVq/Q8v8NEiMDwxy+3eN2ti+bbrGOkCLwzHcf2Iz1vrYs4o0yqkB4mHFbMXzJUu1xnoWGz+Pq94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421429; c=relaxed/simple;
	bh=6BfIiV+nzxHB3tb0+JcIeBRpRBtmNfzFDVml/ewWkg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOnNXy6YQe3Tacikf+dRvPVoINU/ezoMpvuwFELsJXXHEElYBRBE54SYOCtQBaYdsS9HqD6OIiY4+a5c4ZUZ+TPvIFnr0/GnBtl0LSyC61Gf1XkEo/emOklkUcWzrX46ZX1AGI76J8Hgk2qvCg9F9DZKa/SmOQIRThMZ5UbgHZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbufUkfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbufUkfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEF71F000E9;
	Thu, 30 Jul 2026 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421427;
	bh=2WUPyPFkj2K7NgUtotQZZoOtnFvQzwK2IeIpvmI7sqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbufUkfeU3lf9/xsJjjs0wiH3Hf7CigTsjqhg/3pnbEulX75brAMXqhEe6zMyrng1
	 06KjvQpPeZLpuOD78Nhyg4ikcRmpqwaJ7+Aa+RWOsmtlb/9MSfW+rjzf0Q+XIVq6je
	 RKccOyHUpsRiK8jr6+6A/feFBj7VL/1tKCdVNE4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 100/744] Bluetooth: MGMT: revalidate LOAD_CONN_PARAM queued update
Date: Thu, 30 Jul 2026 16:06:13 +0200
Message-ID: <20260730141446.396330280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 2bf282f8f715f5d05d6f4c49ffb3bd241c5e667e ]

MGMT_OP_LOAD_CONN_PARAM queues conn_update_sync() when a single parameter
update changes an existing LE central connection. The queued work currently
stores a borrowed hci_conn_params entry from hdev->le_conn_params. A later
LOAD_CONN_PARAM request can clear disabled parameters and free that entry
before hci_cmd_sync_work() runs the queued callback.

Do not keep the borrowed hci_conn_params pointer in queued work. Queue the
hci_conn instead and hold a reference until the queued callback completes.
When the work runs, revalidate that the connection is still present, look
up the current hci_conn_params entry, and cancel the update if userspace
removed that entry while the work was pending.

Copy the interval values from the current params entry under hdev->lock,
then drop the lock and keep using hci_le_conn_update_sync() to issue the
update.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in conn_update_sync+0x2a/0xf0 [bluetooth]
Read of size 1 at addr ffff88810c697126 by task kworker/u17:0/377
Workqueue: hci0 hci_cmd_sync_work [bluetooth]

Call Trace:
 <TASK>
 dump_stack_lvl+0x66/0xa0
 print_report+0xce/0x5f0
 kasan_report+0xe0/0x110
 conn_update_sync+0x2a/0xf0 [bluetooth]
 hci_cmd_sync_work+0x187/0x210 [bluetooth]
 process_one_work+0x4fd/0xbc0
 worker_thread+0x2d8/0x570
 kthread+0x1ad/0x1f0
 ret_from_fork+0x3c9/0x540
 ret_from_fork_asm+0x1a/0x30

Allocated by task 466:
 hci_conn_params_add+0xa6/0x240 [bluetooth]
 load_conn_param+0x4e1/0x850 [bluetooth]
 hci_sock_sendmsg+0x96b/0xf80 [bluetooth]

Freed by task 474:
 kfree+0x313/0x590
 hci_conn_params_clear_disabled+0x9b/0xc0 [bluetooth]
 load_conn_param+0x4bf/0x850 [bluetooth]
 hci_sock_sendmsg+0x96b/0xf80 [bluetooth]

Fixes: 0ece498c27d8c ("Bluetooth: MGMT: Make MGMT_OP_LOAD_CONN_PARAM update existing connection")
Suggested-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index e8544194a52424..f24b7bbfcb5b6f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7940,14 +7940,36 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
 
 static int conn_update_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_conn_params *params = data;
-	struct hci_conn *conn;
+	struct hci_conn *conn = data;
+	struct hci_conn_params *params;
+	struct hci_conn_params local = {};
 
-	conn = hci_conn_hash_lookup_le(hdev, &params->addr, params->addr_type);
-	if (!conn)
-		return -ECANCELED;
+	hci_dev_lock(hdev);
+
+	if (!hci_conn_valid(hdev, conn) || conn->role != HCI_ROLE_MASTER)
+		goto cancel;
+
+	params = hci_conn_params_lookup(hdev, &conn->dst, conn->dst_type);
+	if (!params)
+		goto cancel;
+
+	local.conn_min_interval = params->conn_min_interval;
+	local.conn_max_interval = params->conn_max_interval;
+	local.conn_latency = params->conn_latency;
+	local.supervision_timeout = params->supervision_timeout;
 
-	return hci_le_conn_update_sync(hdev, conn, params);
+	hci_dev_unlock(hdev);
+
+	return hci_le_conn_update_sync(hdev, conn, &local);
+
+cancel:
+	hci_dev_unlock(hdev);
+	return -ECANCELED;
+}
+
+static void conn_update_sync_destroy(struct hci_dev *hdev, void *data, int err)
+{
+	hci_conn_put(data);
 }
 
 static int load_conn_param(struct sock *sk, struct hci_dev *hdev, void *data,
@@ -8057,9 +8079,13 @@ static int load_conn_param(struct sock *sk, struct hci_dev *hdev, void *data,
 			    (conn->le_conn_min_interval != min ||
 			     conn->le_conn_max_interval != max ||
 			     conn->le_conn_latency != latency ||
-			     conn->le_supv_timeout != timeout))
-				hci_cmd_sync_queue(hdev, conn_update_sync,
-						   hci_param, NULL);
+			     conn->le_supv_timeout != timeout)) {
+				hci_conn_get(conn);
+				if (hci_cmd_sync_queue(hdev, conn_update_sync,
+						       conn,
+						       conn_update_sync_destroy) < 0)
+					hci_conn_put(conn);
+			}
 		}
 	}
 
-- 
2.53.0



