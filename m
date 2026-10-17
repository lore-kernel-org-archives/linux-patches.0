Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E622DEA61;
	Sat, 17 Oct 2026 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259925; cv=none; b=BNScK2OVrSRSI2xoCwOm5g59kKVtxrtKUrotUso7TPf/cvOf78L+2ItX1u4fjFc1hSndS8zeMveM9WdEfncHLoV136bOUG0/c0f/Bnhy+eLm0H7jvRE5xxVMwBLSZXVajA4dXiiTtui/XuyK1tU0BdcurHBeYeByMlvLh3DM+/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259925; c=relaxed/simple;
	bh=Ycv2sb2TbnDoqzecsYuibHAzpHjKD7S4REDghB7wsZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOKGSKzk2vnjs/OSTCrpqTryq/IvQIDcyhQL8rOz+tDVUTm9x+nxkwARwpPyK09/iFOw9fft/j9dXrph1jb3TlfQgIOYFUE7VVeAGVTt5l6luLzKxWZ0iw/cmo3hiFopMwun816nmaIDvESQz+HJS6ToO4qG72s7NYvDSBN6y+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whojJAoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whojJAoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AD81F000C4;
	Sat, 17 Oct 2026 17:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259924;
	bh=1t0ZJ3MwcaSDRW4t8PngXPqaB3ixVk5ZGPdzCw4QEcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whojJAoHfMOA9bQ0osaP8ThU3jWskqq21v1qXu2LsZBpom/Gk2FPwFaPKH1dVRT9r
	 LU/PpJ/EB3kwaZOtalvudwK2QTfH/jP614Sy7KMfpTrMhGz4es3i6BXvEACBFeWOSx
	 TIjrz6JiqOA21igutu1xNs+i8jPWxANGQbxBAGko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1376/1674] Bluetooth: do not leak an hci_conn when a second LE connect is rejected
Date: Sat, 17 Oct 2026 18:00:48 +0200
Message-ID: <20261017160506.483418254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index d400206d7afec..4c67795758789 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7154,8 +7154,13 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
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



