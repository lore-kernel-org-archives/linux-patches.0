Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0545F14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PxJn/7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F0BC433C8;
	Mon, 23 Oct 2023 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059426;
	bh=XxiFUZWroY6+KyMuiG+hxsVcI8JBDlkyuVgt3TkxPa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PxJn/7bQha05kxmkNhOE3uM8Je5urahFfg7LZ6pTc7DasqUSmfCHi3XIePq9YRJa
	 LO1oaU7Ffkffuy3TgbM2vI6I74UPKpMHi5C//JKTTJzPREyGEjRWzcCkY34PYyHAAV
	 gPlC8s1znpI439XI4mpbKW0gFd65dyJbQ7uDuIE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 147/241] Bluetooth: hci_sync: delete CIS in BT_OPEN/CONNECT/BOUND when aborting
Date: Mon, 23 Oct 2023 12:55:33 +0200
Message-ID: <20231023104837.453264085@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 2889bdd0a9a195533c2103e7b39ab0de844d72f6 ]

Dropped CIS that are in state BT_OPEN/BT_BOUND, and in state BT_CONNECT
with HCI_CONN_CREATE_CIS unset, should be cleaned up immediately.
Closing CIS ISO sockets should result to the hci_conn be deleted, so
that potentially pending CIG removal can run.

hci_abort_conn cannot refer to them by handle, since their handle is
still unset if Set CIG Parameters has not yet completed.

This fixes CIS not being terminated if the socket is shut down
immediately after connection, so that the hci_abort_conn runs before Set
CIG Parameters completes. See new BlueZ test "ISO Connect Close - Success"

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a239110ee8e0 ("Bluetooth: hci_sync: always check if connection is alive before deleting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 73cdd051dd464..d21127e992c0f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5302,6 +5302,10 @@ static int hci_connect_cancel_sync(struct hci_dev *hdev, struct hci_conn *conn,
 		if (test_bit(HCI_CONN_CREATE_CIS, &conn->flags))
 			return hci_disconnect_sync(hdev, conn, reason);
 
+		/* CIS with no Create CIS sent have nothing to cancel */
+		if (bacmp(&conn->dst, BDADDR_ANY))
+			return HCI_ERROR_LOCAL_HOST_TERM;
+
 		/* There is no way to cancel a BIS without terminating the BIG
 		 * which is done later on connection cleanup.
 		 */
@@ -5384,13 +5388,11 @@ int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 		err = hci_reject_conn_sync(hdev, conn, reason);
 		break;
 	case BT_OPEN:
-		/* Cleanup bises that failed to be established */
-		if (test_and_clear_bit(HCI_CONN_BIG_SYNC_FAILED, &conn->flags)) {
-			hci_dev_lock(hdev);
-			hci_conn_failed(conn, reason);
-			hci_dev_unlock(hdev);
-		}
-		break;
+	case BT_BOUND:
+		hci_dev_lock(hdev);
+		hci_conn_failed(conn, reason);
+		hci_dev_unlock(hdev);
+		return 0;
 	default:
 		hci_dev_lock(hdev);
 		conn->state = BT_CLOSED;
-- 
2.40.1



