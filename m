Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A721C84D0;
	Fri,  7 Aug 2026 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116086; cv=none; b=YuwaKfRQqsgIES7tcSl9zRwlueJN1oN6AnfyBNUQ7pxgkalNHYGE/g+Jah1vF1aZLapUWJUHPlp3A6pwTw2cb700FQStJzOZPHzTQORz9Ox7nA36ogwQC5jc5WD7MltaN/VivJxdPDyv51JGuttq0MtmIyyaOfHqvWJaAxXY5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116086; c=relaxed/simple;
	bh=FSZSASTapPWsxtkS4m6X1mw3ItM/s4Gh1NlgnC86+1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3OoMz3JcBaDkUT0Pk+/F+YfpS01Dv6N42bqBRFjHQrkkpScYwijDMxLke25BzMq0MzBUIobsbQlL0jz3itAeNwL1pAXI0eSLRm1QBagbtdA1KZwWGSWR/QslfdpqeAK7bbT1dAxicXAn0Zr0OHZOoa+gEtHHU1JwO/otNNLVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpWDtsRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpWDtsRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CD71F000E9;
	Fri,  7 Aug 2026 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116085;
	bh=RfNsT8M4PVcNCr6XNLYwC5TWhSfVHnptZoW4i/M/oYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpWDtsRcu56Q0Ii/zd9TAqXQkM2b33WYQnzOYOpVWp+8okSWGUgHFZDm0fX9aJXfS
	 5xGjbF9I/3MwWcS2VaCnsIYeaQFOn27016iymvxji5f5RSpGQAAv/v5qkuzntVc20l
	 6Eqa9T2UvFUaI6rfhthy+nCtAaTNvi+iCg6ouDOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/261] Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync
Date: Fri,  7 Aug 2026 16:37:07 +0200
Message-ID: <20260807143416.894841268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit c0a9dcd2be398eee505d4b254ec3a845aa8ab189 ]

hci_conn_get() without already held reference is data race against
concurrent deletion.

In previous patches, the refcount has been changed to be taken before
starting the hci_sync task, so remove these extra get() + put() as they
are not needed.

Fixes: 12917f591cea ("Bluetooth: hci_conn: Fix null ptr deref in hci_abort_conn()")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6a5ec74eaf25a..9dec36467fead 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6566,11 +6566,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
-	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
-	 * clear_bit() at done.
-	 */
-	hci_conn_get(conn);
-
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 	conn->state = BT_CONNECT;
 
@@ -6585,7 +6580,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 			conn->state = BT_OPEN;
 			hci_abort_conn_sync(hdev, conn,
 					    HCI_ERROR_REJ_LIMITED_RESOURCES);
-			hci_conn_put(conn);
 			return -EBUSY;
 		}
 
@@ -6679,7 +6673,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
-	hci_conn_put(conn);
 	return err;
 }
 
@@ -6958,11 +6951,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 	else
 		cp.role_switch = 0x00;
 
-	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
-	 * clear_bit() below.
-	 */
-	hci_conn_get(conn);
-
 	/* Mark create connection in flight so hci_cancel_connect_sync() can
 	 * cancel it while blocking on the connection complete event.
 	 */
@@ -6974,7 +6962,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 				       conn->conn_timeout, NULL);
 
 	clear_bit(HCI_CONN_CREATE, &conn->flags);
-	hci_conn_put(conn);
 
 	return err;
 }
-- 
2.53.0



