Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AACD257855;
	Sun,  7 Jun 2026 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828566; cv=none; b=gXu2XCzjlcuDYBiGpr9w91bOlIu/mEBkqxZ76ErTt6pyrjNQDFafloWEIjfA/+urSKecYbuNnFuMyX4ca35G+WGhgIBNVLqh1k++iAIDMw+noeLt+1DyTUwsoah7XgLRfZZiMMAMuUAGA75ArH5EupNsVNYMCR20O0jbo5iJjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828566; c=relaxed/simple;
	bh=LzQYmfzcpFQOREB+wJwd4DJecvcV2G1LZs+bYPfZ708=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoNexvdS0tSisOWnc3T0GFMJkw3grPSSRDsWcWS3ZTyFIJbo/sIk5ai+/kg5E0ySLoknaptrh3f1nzk9jRhB1Lj9+4NYJ142ek9Sm3edDOxgd3IOl/POvjHBXj8bV8JDBC0Q26c8NXxvAtJfh+6U7u68GR7S1A76Kmqi0zeOpTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2u5wzeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2u5wzeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183D31F00893;
	Sun,  7 Jun 2026 10:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828565;
	bh=d5isgzkup+7Tvob8MY0TDm5RXTTRWhNzOc2npVtVnPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2u5wzeogWe2oZ4uUxEqKB0Mpz3qY8sCEOZ+Zw6AZM+t4yuN+lKZqA1fXfhFOxgId
	 n5IfbtgdrTCsLN7jUqPjNbxsG5e8bx3GIy1wKdpAt3k/HunMy7GQ2eJWROxWbN8PUV
	 l8qR39qMdV+QUfnqyuV7tUBx/EzNMmaUF2lXNsvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 148/307] Bluetooth: hci_sync: fix UAF in hci_le_create_cis_sync
Date: Sun,  7 Jun 2026 11:59:05 +0200
Message-ID: <20260607095733.162649272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -6626,6 +6626,7 @@ int hci_le_create_cis_sync(struct hci_de
 	DEFINE_FLEX(struct hci_cp_le_create_cis, cmd, cis, num_cis, 0x1f);
 	size_t aux_num_cis = 0;
 	struct hci_conn *conn;
+	u16 timeout = 0;
 	u8 cig = BT_ISO_QOS_CIG_UNSET;
 
 	/* The spec allows only one pending LE Create CIS command at a time. If
@@ -6696,6 +6697,7 @@ int hci_le_create_cis_sync(struct hci_de
 		set_bit(HCI_CONN_CREATE_CIS, &conn->flags);
 		cis->acl_handle = cpu_to_le16(conn->parent->handle);
 		cis->cis_handle = cpu_to_le16(conn->handle);
+		timeout = conn->conn_timeout;
 		aux_num_cis++;
 
 		if (aux_num_cis >= cmd->num_cis)
@@ -6715,7 +6717,7 @@ done:
 	return __hci_cmd_sync_status_sk(hdev, HCI_OP_LE_CREATE_CIS,
 					struct_size(cmd, cis, cmd->num_cis),
 					cmd, HCI_EVT_LE_CIS_ESTABLISHED,
-					conn->conn_timeout, NULL);
+					timeout, NULL);
 }
 
 int hci_le_remove_cig_sync(struct hci_dev *hdev, u8 handle)


