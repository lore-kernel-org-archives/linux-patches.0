Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7818742E8FF;
	Thu, 30 Jul 2026 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421434; cv=none; b=A54QuDlg5PwfhzV+8gtn6eZAKmI4Hgag19yD0k0/FnQhoYmNBFv5KHxEoreTpN4Q/+dUU7tMwGKBZd+ii06u9VIvnCHSFW0D+Y0q6WqIVetQk7nQG2g04n3xo8yo9/bSj+HiCWh3ykZHkODOwgSQv3CE/VBxf5HjGEweGb3ZEyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421434; c=relaxed/simple;
	bh=kOgenngjBH6cUwIxPC1ooJ9BnWBrF9nA15uQ5tAT/d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRy/fNEOPyUsEA74xPppfpQuw6xPCJo+2o17NIwvjmBXxlAGpZZsFolLkENWO7o20mNMNdt0K8CNhB+FEypsvld/BvtJ9gfeHqOkL8RufUx52esXf+TY5m3Q2aHqNpmKzea9irocEZKF+4IcSsACLc4q7WGkPuB/AOiCPx9GYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Isg7Ph/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Isg7Ph/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98F31F000E9;
	Thu, 30 Jul 2026 14:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421433;
	bh=4w8x//q5ZIq/yW9fqrNnOSLom8UpWyHY1jztvMR5eIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Isg7Ph/mYLYgtOs8dUStXHmqINLqxIrenxlovGJySrr+F1/uTrAijQBCpm9S/1prU
	 MRcZ7NiZcLHgBeFr31Uq7+LNUEMftvl2jtTiSgt/lPlSGR/EWLTp5hp2VOSN3UVy62
	 AuSl7+vrI0LhHqyVy6ZU2fqM9yG6HfaXEQkyb5m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 102/744] Bluetooth: mgmt: fix locking in unpair_device/disconnect_sync
Date: Thu, 30 Jul 2026 16:06:15 +0200
Message-ID: <20260730141446.438721275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

[ Upstream commit 16cd66443957e4ad42155c6fec401012f600c6f8 ]

Dereferencing RCU-protected pointers outside critical sections is
invalid and may lead to UAF.

Take hdev->lock for hci_conn lookup and hci_abort_conn().  Don't use RCU
to ensure the conn is fully initialized at this point.

Fixes: 227a0cdf4a028 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index f24b7bbfcb5b6f..186850538a8bb5 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3094,6 +3094,8 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	struct mgmt_cp_unpair_device *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3101,6 +3103,11 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return 0;
 
@@ -3108,6 +3115,7 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
@@ -3255,6 +3263,8 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 	struct mgmt_cp_disconnect *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3262,6 +3272,11 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return -ENOTCONN;
 
@@ -3269,6 +3284,7 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
-- 
2.53.0



