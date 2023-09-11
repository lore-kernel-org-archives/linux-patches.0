Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68C7F9F4
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C41C433C7;
	Mon, 11 Sep 2023 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440757;
	bh=JV/esFEVJXJfEIQs6VvwwNuFwA8ODePOtnsknUGsbdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhVnoa/q2uZZbiqnsg3CKWRRjGtlt4bx3ZiDqjyEwWeEJREA586beYHrRT5Dch3A2
	 As3MSkC9Rw2gEABnA6qxI6FdC27edaAZZTXVaPyiK9RqY42SfW/ER+5+Po9ZMXU8UB
	 FchVwsvz8SmwFCK+vbKRZ/AlwRJUri6ZyyaWhoow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf54c1da6574b6c1b049@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 175/739] Bluetooth: hci_conn: fail SCO/ISO via hci_conn_failed if ACL gone early
Date: Mon, 11 Sep 2023 15:39:34 +0200
Message-ID: <20230911134656.084465097@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

[ Upstream commit 3344d318337d9dca928fd448e966557ec5063f85 ]

Not calling hci_(dis)connect_cfm before deleting conn referred to by a
socket generally results to use-after-free.

When cleaning up SCO connections when the parent ACL is deleted too
early, use hci_conn_failed to do the connection cleanup properly.

We also need to clean up ISO connections in a similar situation when
connecting has started but LE Create CIS is not yet sent, so do it too
here.

Fixes: ca1fd42e7dbf ("Bluetooth: Fix potential double free caused by hci_conn_unlink")
Reported-by: syzbot+cf54c1da6574b6c1b049@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-bluetooth/00000000000013b93805fbbadc50@google.com/
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7f2e3a2d2768d..ce76931d11d86 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1040,6 +1040,29 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 	return conn;
 }
 
+static void hci_conn_cleanup_child(struct hci_conn *conn, u8 reason)
+{
+	if (!reason)
+		reason = HCI_ERROR_REMOTE_USER_TERM;
+
+	/* Due to race, SCO/ISO conn might be not established yet at this point,
+	 * and nothing else will clean it up. In other cases it is done via HCI
+	 * events.
+	 */
+	switch (conn->type) {
+	case SCO_LINK:
+	case ESCO_LINK:
+		if (HCI_CONN_HANDLE_UNSET(conn->handle))
+			hci_conn_failed(conn, reason);
+		break;
+	case ISO_LINK:
+		if (conn->state != BT_CONNECTED &&
+		    !test_bit(HCI_CONN_CREATE_CIS, &conn->flags))
+			hci_conn_failed(conn, reason);
+		break;
+	}
+}
+
 static void hci_conn_unlink(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -1062,14 +1085,7 @@ static void hci_conn_unlink(struct hci_conn *conn)
 			if (!test_bit(HCI_UP, &hdev->flags))
 				continue;
 
-			/* Due to race, SCO connection might be not established
-			 * yet at this point. Delete it now, otherwise it is
-			 * possible for it to be stuck and can't be deleted.
-			 */
-			if ((child->type == SCO_LINK ||
-			     child->type == ESCO_LINK) &&
-			    HCI_CONN_HANDLE_UNSET(child->handle))
-				hci_conn_del(child);
+			hci_conn_cleanup_child(child, conn->abort_reason);
 		}
 
 		return;
-- 
2.40.1



