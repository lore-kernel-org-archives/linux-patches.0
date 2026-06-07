Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB6A1FE47B;
	Sun,  7 Jun 2026 10:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828335; cv=none; b=mLaTpRa65rUAJhWMW28eBvwTIp62va94ZpNOenanKcKlDW4DT5hW1M1gZm9tMkf2VUPkXoG+6q0GD2wTCuVWUnGQ/gt/Ey50QcsJlOFeJoUVJ9Tvk0iAdUtPMHtL2PG5/2683pyjx4BFUNPe7c1xXXgKjc0O5jeWeIq2BG7MHUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828335; c=relaxed/simple;
	bh=1qIjaoSXE1EXN0+XmK1R+rqXxNDz7FUyyio36L/oGsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXQ69qh12aCmdOb5SG1Mh/F+5iNMkoBzfylXSKsfiJoxkzlcb+zzcmQESyi889OYmWFhu2z/0zy/j6yCvH3HzBVE2W212GaxjlVr3YSDQMXVlUzfOseX+kfoWwn8AO3R6v2RvZF67ok6r258JP/5Os4PUyCUvo4brJm322lJVzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzP7DTdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzP7DTdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251031F00893;
	Sun,  7 Jun 2026 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828334;
	bh=2XzJtx20YVW7dUOmBFT7SO9yWLaSLbFEKKksY7YTEGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzP7DTdvvqukzAzDll71Mr/1SXf+PgQEPT77zpFQmo5INUEzrJBxgJNX8h0x3AhpK
	 C7fbdp40esjMhoxAkLRoZPg0+p8fuqY2s+kqUDAv0yvcooZVeADEi3Tp1Ktxmm1I+s
	 73qMYbAiDgSkS80XgxeDwxIsYEiJ5TvbpdFYn6Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 135/315] Bluetooth: hci_sync: fix UAF in hci_le_create_cis_sync
Date: Sun,  7 Jun 2026 11:58:42 +0200
Message-ID: <20260607095732.568853552@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit bfea6091e0fffb270c20e74384b660910277eb6c upstream.

hci_le_create_cis_sync() dereferences conn->conn_timeout after releasing
both rcu_read_lock() and hci_dev_lock(hdev).  The conn pointer was
obtained from an RCU-protected iteration over hdev->conn_hash.list and
is not valid once these locks are dropped.  A concurrent disconnect can
free the hci_conn between the unlock and the dereference, causing a
use-after-free read.

The cancellation mechanism in hci_conn_del() cannot prevent this because
hci_le_create_cis_pending() queues hci_create_cis_sync with data=NULL:

    hci_cmd_sync_queue(hdev, hci_create_cis_sync, NULL, NULL);

While hci_conn_del() dequeues with data=conn:

    hci_cmd_sync_dequeue(hdev, NULL, conn, NULL);

Since NULL != conn, the lookup in _hci_cmd_sync_lookup_entry() never
matches, and the pending work item is not cancelled.

Fix this by saving conn->conn_timeout into a local variable while the
locks are still held, so the stale conn pointer is never dereferenced
after unlock.

This is the same class of bug as the one fixed by commit 035c25007c9e
("Bluetooth: hci_sync: Fix UAF on le_read_features_complete") which
addressed the identical pattern in a different function.

This vulnerability was identified using 0sec.ai, an open-source
automated security auditing platform (https://github.com/0sec-labs).

Fixes: c09b80be6ffc ("Bluetooth: hci_conn: Fix not waiting for HCI_EVT_LE_CIS_ESTABLISHED")
Cc: stable@vger.kernel.org
Reported-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6656,6 +6656,7 @@ int hci_le_create_cis_sync(struct hci_de
 	DEFINE_FLEX(struct hci_cp_le_create_cis, cmd, cis, num_cis, 0x1f);
 	size_t aux_num_cis = 0;
 	struct hci_conn *conn;
+	u16 timeout = 0;
 	u8 cig = BT_ISO_QOS_CIG_UNSET;
 
 	/* The spec allows only one pending LE Create CIS command at a time. If
@@ -6726,6 +6727,7 @@ int hci_le_create_cis_sync(struct hci_de
 		set_bit(HCI_CONN_CREATE_CIS, &conn->flags);
 		cis->acl_handle = cpu_to_le16(conn->parent->handle);
 		cis->cis_handle = cpu_to_le16(conn->handle);
+		timeout = conn->conn_timeout;
 		aux_num_cis++;
 
 		if (aux_num_cis >= cmd->num_cis)
@@ -6745,7 +6747,7 @@ done:
 	return __hci_cmd_sync_status_sk(hdev, HCI_OP_LE_CREATE_CIS,
 					struct_size(cmd, cis, cmd->num_cis),
 					cmd, HCI_EVT_LE_CIS_ESTABLISHED,
-					conn->conn_timeout, NULL);
+					timeout, NULL);
 }
 
 int hci_le_remove_cig_sync(struct hci_dev *hdev, u8 handle)


