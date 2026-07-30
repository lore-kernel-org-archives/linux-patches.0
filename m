Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297794052DC;
	Thu, 30 Jul 2026 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423633; cv=none; b=psI8ii+YvJBKazsdv4y/YMeDNETkco9WkZYv2n6hu9bUWofHwXSrRUM9VZ3CaUr4PG94w0kO4eWMBkrRD66tf93HmaiCNFdz1YQQpUOj/2RZR92hrwKWS4TaYO8kxUHUsybslQ8uGX973AytRlg5HJYXfUFF/Mx8eMmeCjPfHKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423633; c=relaxed/simple;
	bh=0gWjaA7AjeyyttzyMjywitZGtx5Bihr8PgmRPodaeGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwCMBiQdw8ykZLQVKFczUV0MHBtxmn0HHe4VCLvcFSUfkmjsAO3Y1O5z6sj8G8mzinQVCzbnZur13tgcqEB/mRD7YmKEi4eLYTAgcpxnYIr6yUx2LOC5X5MfUdc9z+87n6Xx7EW5TNVOFbUWd2jQE7JGZG8CtYrqVTANLAqU9CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuX/Ln1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuX/Ln1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858F61F000E9;
	Thu, 30 Jul 2026 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423632;
	bh=FJaINxXUy84QiKvBVWKnsRGGqd6Oem4nshdRFT2au80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuX/Ln1QxASF1fh/rgPwsbqkgh6IWaecRyd1pc37DxodwuKMfigAaobjWdW0MrmjH
	 bFvceubykqlJpCTwYNaoJ6lzbLydEfhrBdc7eTyvtCw8MNtYbOfc2zA7l9AapqT4RD
	 Bj3DHGKICx5liNahS7AHU4zIpRcKlgBYoe2n7J4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/675] Bluetooth: mgmt: hold reference for hci_conn in mgmt_pending_cmds
Date: Thu, 30 Jul 2026 16:07:21 +0200
Message-ID: <20260730141447.500338084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit da55f570191d5d72f10c607a7043b947eb05ea46 ]

Dereferencing RCU-protected pointers outside critical sections is
invalid and may lead to UAF.  Use of hci_conn in hci_sync callbacks also
needs to hold refcount to avoid UAF.

Take appropriate locks for hci_conn lookups, and take refcount for
hci_conn pointers stored in mgmt_pending_cmd so that the pointer stays
valid.

When accessing conn->state, ensure hdev->lock is held to avoid data
race.

Fixes: 7b445e220db9 ("Bluetooth: MGMT: Fix holding hci_conn reference while command is queued")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0ef1192e5e452e..79eb605be2804c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7325,6 +7325,9 @@ static void get_conn_info_complete(struct hci_dev *hdev, void *data, int err)
 		rp.max_tx_power = HCI_TX_POWER_INVALID;
 	}
 
+	if (conn)
+		hci_conn_put(conn);
+
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, MGMT_OP_GET_CONN_INFO, status,
 			  &rp, sizeof(rp));
 
@@ -7339,6 +7342,8 @@ static int get_conn_info_sync(struct hci_dev *hdev, void *data)
 	int err;
 	__le16   handle;
 
+	hci_dev_lock(hdev);
+
 	/* Make sure we are still connected */
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
@@ -7346,12 +7351,16 @@ static int get_conn_info_sync(struct hci_dev *hdev, void *data)
 	else
 		conn = hci_conn_hash_lookup_ba(hdev, LE_LINK, &cp->addr.bdaddr);
 
-	if (!conn || conn->state != BT_CONNECTED)
+	if (!conn || conn->state != BT_CONNECTED) {
+		hci_dev_unlock(hdev);
 		return MGMT_STATUS_NOT_CONNECTED;
+	}
 
-	cmd->user_data = conn;
+	cmd->user_data = hci_conn_get(conn);
 	handle = cpu_to_le16(conn->handle);
 
+	hci_dev_unlock(hdev);
+
 	/* Refresh RSSI each time */
 	err = hci_read_rssi_sync(hdev, handle);
 
@@ -7485,6 +7494,9 @@ static void get_clock_info_complete(struct hci_dev *hdev, void *data, int err)
 	}
 
 complete:
+	if (conn)
+		hci_conn_put(conn);
+
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode, status, &rp,
 			  sizeof(rp));
 
@@ -7501,15 +7513,21 @@ static int get_clock_info_sync(struct hci_dev *hdev, void *data)
 	memset(&hci_cp, 0, sizeof(hci_cp));
 	hci_read_clock_sync(hdev, &hci_cp);
 
+	hci_dev_lock(hdev);
+
 	/* Make sure connection still exists */
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &cp->addr.bdaddr);
-	if (!conn || conn->state != BT_CONNECTED)
+	if (!conn || conn->state != BT_CONNECTED) {
+		hci_dev_unlock(hdev);
 		return MGMT_STATUS_NOT_CONNECTED;
+	}
 
-	cmd->user_data = conn;
+	cmd->user_data = hci_conn_get(conn);
 	hci_cp.handle = cpu_to_le16(conn->handle);
 	hci_cp.which = 0x01; /* Piconet clock */
 
+	hci_dev_unlock(hdev);
+
 	return hci_read_clock_sync(hdev, &hci_cp);
 }
 
-- 
2.53.0



