Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03C24756BB;
	Fri,  7 Aug 2026 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116956; cv=none; b=FL7tauvc9o2qhKUwgFzOyBSGYpf/s4QXLPwNukfo/aJ+RiG1VqBwCi8skzF97EvldKwewgbQN8SvROkDJ7Rr0i+UTnIj2dMci5RHG5LEIZp3LACLB7BHmYut28WBgLV2zBYAu+Vm/I7tfgxbzUAScCNMlkTglvPTHzh7hTbfSdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116956; c=relaxed/simple;
	bh=UwbND3odkHN416tJ5yYBSQMjKmMhvW8Hhr1CH7lUURE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfKmpkNWvbjrtiqphDOLJq2LJmYjwkJfd3i+SwSfRbBtaGke1bwHeAvm1iKBoFML6acagnqq8qnaMJxl0FIK0ae1QDt3bbETr6l8Rl4XT8CToqmGFsThhcwUzUNQi7RCz7ucr2aYWXkVZy59H/yLVUL9JMTkcErOMkd/JmFoElU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD6D1FGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD6D1FGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0CE1F000E9;
	Fri,  7 Aug 2026 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116954;
	bh=fPkbdzTao6QhQDd6Qr1+u9M5QzOJxBI+hWx8YCGaS7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD6D1FGOpFRR0k1NUMOAZ8RExHyIr6p+TEuVrJIBP9XpLZk9NnQtk1G0+JgN93Mol
	 vQvsFKSFZpe+35jkqNke8X6eJKrnD4dd+mnpKI5lYdMD7PJLaewSki8mapfDE6ul50
	 QaBOvvQWWUaVWL0VmuHktAnNC3q6O+3Whw9DN+Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 148/438] Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync
Date: Fri,  7 Aug 2026 16:35:44 +0200
Message-ID: <20260807143431.162640313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
index 0bb015da6f88c..540da127ecea6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6656,11 +6656,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
-	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
-	 * clear_bit() at done.
-	 */
-	hci_conn_get(conn);
-
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 	conn->state = BT_CONNECT;
 
@@ -6675,7 +6670,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 			conn->state = BT_OPEN;
 			hci_abort_conn_sync(hdev, conn,
 					    HCI_ERROR_REJ_LIMITED_RESOURCES);
-			hci_conn_put(conn);
 			return -EBUSY;
 		}
 
@@ -6773,7 +6767,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
-	hci_conn_put(conn);
 	return err;
 }
 
@@ -7048,11 +7041,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
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
@@ -7064,7 +7052,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 				       conn->conn_timeout, NULL);
 
 	clear_bit(HCI_CONN_CREATE, &conn->flags);
-	hci_conn_put(conn);
 
 	return err;
 }
-- 
2.53.0



