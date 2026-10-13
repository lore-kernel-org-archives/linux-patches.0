Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4034F68C4;
	Tue, 13 Oct 2026 12:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893952; cv=none; b=qj/KAPEdFB8s+abxTD4t7Lke4gkmplR+CeXT2nVpF7e7YAf03Qs0pZCJdhgZ72ROvPhrnCmWulW7yC58iJYV69dWa4iEAnTIydQIRcxDuSZK9xKt7LvdIXM3I+K7Xse5avQngJT4cA7AE2AMnoa8buMKN3RvcyHXerStYGoYWis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893952; c=relaxed/simple;
	bh=yF0Zd4T93ZNwxR8TB8TnXB1YvETW2jFaC9/3NfcNneI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhxXWppp7Vx6IUUtr5xjPiODHHiu0CONFZnLTjY/Y844i7aykHhRkoTvz86kVxpfrt5INiOmfwVsWdU16xIXcKOLiGsiNc5J754NYiKRh/dgg8uIfLpvZVLAGHx7x79rcX39nKQiIsh/tL3BQV76zskDd6C1k9/q/KKQmJtmc/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGwYoWAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGwYoWAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240261F00893;
	Tue, 13 Oct 2026 12:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893950;
	bh=Y3YyYN1imxgzJvbKCJOOlA3pnRFyoRbiU1Ha136HkNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGwYoWAeN/KG9AuwHIvuMtYukjZ3L6Aihh8LRNI5NoU1/jh6vQXpQpoXZhkkPHhSs
	 5VROHVlppdOJVbVy/an9wFJnma2F11ZbANlH7Zr+Vn2V7w8XPbPlSuMRoj/62OiDBh
	 kwafhu9PcuQzAKMTE0J+p5P6PY2dKigfdsdDOzKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/621] Bluetooth: do not leak an hci_conn when a second LE connect is rejected
Date: Tue, 13 Oct 2026 13:36:33 +0200
Message-ID: <20261013112930.286766628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Radek Podgorny <radek@podgorny.cz>

[ Upstream commit 7e1e4047200fd7519f9bdfe8a001437715e618b4 ]

create_le_conn_complete() decides whether the failed connection is
still pending by comparing it against hci_lookup_le_connect(), which
returns the first LE connection in BT_CONNECT. That is the same
connection only while at most one is pending.

Two can be pending. Connections created on the passive scan path sit
in BT_CONNECT with HCI_CONN_SCANNING set and are invisible to
hci_lookup_le_connect() until hci_le_create_conn_sync() clears the
flag when their command is issued, so the -EBUSY guard in
hci_connect_le() does not prevent a second connection from being
queued while the first is still on the scan path. Whenever two
connections are in BT_CONNECT at once, the lookup may return one
connection while create_le_conn_complete() is reporting the failure
of the other; the early exit then drops the error and hci_conn_failed()
never runs on the connection that failed.

The controller also rejects a second HCI_OP_LE_CREATE_CONN issued
while another connection creation is still outstanding, per Core Spec
Vol 4, Part E. The spec calls for Command Disallowed there; the
bcm43438 observed here answers with an LMP/LL error code instead,
which bt_to_errno() maps to the -EPROTO (-71) in the log below.

The leaked connection stays in BT_CONNECT forever, and because
hci_connect_le() refuses to dial while hci_lookup_le_connect() finds
anything, every subsequent attempt to reach any peer fails with
-EBUSY and no command reaches the controller at all.

Seen on a bcm43438 with two BLE peers polled on the same interval
(state 5 is BT_CONNECT; both handles are UNSET ones, allocated from
the ida above HCI_CONN_HANDLE_MAX):

  Bluetooth: hci1: Opcode 0x2013 failed: -71

  # hcitool con
          < LE 14:9C:EF:03:68:81 handle 3840 state 5 lm CENTRAL
          < LE C4:D3:6A:8C:B5:38 handle 3841 state 5 lm CENTRAL

A btmon capture across the next ten minutes of connect attempts
contains no HCI_OP_LE_CREATE_CONN at all; outgoing LE connections
do not recover until the adapter is reset. With this change the same
scenario fails the rejected connection cleanly and further connects
to both peers go through.

Ask about the connection itself instead of about the device.

Fixes: c9f73a2178c1 ("Bluetooth: hci_conn: Fix hci_connect_le_sync")
Signed-off-by: Radek Podgorny <radek@podgorny.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index de329178900e8..70fce6811d0a9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7179,8 +7179,13 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 		goto unlock;
 	}
 
-	/* Check if connection is still pending */
-	if (conn != hci_lookup_le_connect(hdev))
+	/* Check if this connection is still pending.
+	 *
+	 * hci_lookup_le_connect() returns only the first LE connection
+	 * in BT_CONNECT, which is not necessarily this one when two are
+	 * pending at once, so ask the connection itself.
+	 */
+	if (conn->state != BT_CONNECT)
 		goto unlock;
 
 	/* Flush to make sure we send create conn cancel command if needed */
-- 
2.53.0



