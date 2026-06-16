Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864744D014;
	Tue, 16 Jun 2026 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628944; cv=none; b=IgT36PYUcJX5dxWLT1P9plw5jSm4/F/XjIlcM7yAEY7WH2mKLg9D6gbDr4vlU4JIojEXLXo0jsO9LSjeLlgkesSbDPqDpphrSRWNbvJXuIU5FZ+eWgwKeJiGcYaCvEC7qghqhUKE1RuEOdehTW0KHTeygMAq8ePrPlmH++vXR7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628944; c=relaxed/simple;
	bh=GDB3qCIHel6Mc2vbHqm3lXvBcCQ0jcvU1frqL7r3Bnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLmTGjdOtQhkK0iID5zDx8ScKEBfmq59G1RNvNvS+bsYowmW1f0ICBrDv/uJnQXpbWcGgz23Qy8Ak0WvXavfm4tbRzuH1cbVMVJrzKnEg4k6fowLxRqC2sOPFa3GYy4UwSLM7ymdMBuAkf+PEeuWMjmo/lacmq+fulz5HMsJh7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiPAp7sL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiPAp7sL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4E81F00A3A;
	Tue, 16 Jun 2026 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628943;
	bh=0KbO73aQBToGIfs295ZxncHv/fyuR0qYrAy5JTty8WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiPAp7sLvW0dn9jjoHvh1PVQFuFLO+4hoh3iKR4N/Emv7gb8jwBfdMDBe+dd7/gWY
	 b2pxC+4xlb91UnEfS1Z7brfDsqt73oLL0yaVBvL9TPJtNkhah1QJRzJmyp6y91g5mg
	 Kkc4w4KTWSwJua4GzTLatOSP4AZAoRq8G3/PC2IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/452] Bluetooth: hci_sync: fix UAF in hci_le_create_cis_sync
Date: Tue, 16 Jun 2026 20:26:59 +0530
Message-ID: <20260616145127.921707561@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit bfea6091e0fffb270c20e74384b660910277eb6c ]

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
[doruk: adjust context for 6.6 \u2014 open-coded cmd struct instead of
 DEFINE_FLEX, num_cis tracked via cmd.cp.num_cis]
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a41cfc76e98bf1..7cba461b21de4f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6631,6 +6631,7 @@ int hci_le_create_cis_sync(struct hci_dev *hdev)
 		struct hci_cis cis[0x1f];
 	} cmd;
 	struct hci_conn *conn;
+	u16 timeout = 0;
 	u8 cig = BT_ISO_QOS_CIG_UNSET;
 
 	/* The spec allows only one pending LE Create CIS command at a time. If
@@ -6703,6 +6704,7 @@ int hci_le_create_cis_sync(struct hci_dev *hdev)
 		set_bit(HCI_CONN_CREATE_CIS, &conn->flags);
 		cis->acl_handle = cpu_to_le16(conn->parent->handle);
 		cis->cis_handle = cpu_to_le16(conn->handle);
+		timeout = conn->conn_timeout;
 		cmd.cp.num_cis++;
 
 		if (cmd.cp.num_cis >= ARRAY_SIZE(cmd.cis))
@@ -6722,7 +6724,7 @@ int hci_le_create_cis_sync(struct hci_dev *hdev)
 					sizeof(cmd.cp) + sizeof(cmd.cis[0]) *
 					cmd.cp.num_cis, &cmd,
 					HCI_EVT_LE_CIS_ESTABLISHED,
-					conn->conn_timeout, NULL);
+					timeout, NULL);
 }
 
 int hci_le_remove_cig_sync(struct hci_dev *hdev, u8 handle)
-- 
2.53.0



