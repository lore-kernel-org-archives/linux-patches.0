Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40041F5E6;
	Thu, 30 Jul 2026 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425613; cv=none; b=WObWe0vR15pcrguZcaieXvbPMNHfO2cdp+CqvodfGckm+6bSm398d5I9JNZDoGlS3Rb6lKz6DLbiNLOG1LmYMladyHOwtOEEURwh4aHe6l8/wxWeB5WtosD3YLErAVzH6gvufXhDu0d4TlKDW8Z0q6UNGNGBq6ugVgcBovVQj9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425613; c=relaxed/simple;
	bh=uqznGd4i0tkFJjnJE7nxF1+39r5WY+vYsrahlaV4DXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUrCAdM3Rn4dEnQBX/1zaSEzG0xh3hxUGSo1dcZxKnU26zko5oA5bfkm6FS2aXR6Ec5ESXtNavfncRsvbJZrY05sAERfFC425HWqUDTLoalqLY4r86WNw0wCBQ03vJYZdxXKFPhO85UOqL+R6vNEVU+IbYPdGB0tY8oiDfxTHqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrOeOShf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrOeOShf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD541F000E9;
	Thu, 30 Jul 2026 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425611;
	bh=zopsbkOqP4Xq6ihlOBR4amQO+wdfMkKTX7lVaQBYGj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrOeOShf3HNVXy9qIR4qn7rtfluvvoVH8DilKwNfC7Ae2iTkgumG2/RTC4FEcc4h9
	 EMjLZXlqGmM4JaZ7Ag84CG6SrQYl7YvF4GMOLOQ8tZEb8qJ/yVAkdDOglME40bKqwe
	 9m7fMMkHdSSno+6NxiEQRfJfF5BfRuW5Nys0Q3w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/602] Bluetooth: mgmt: fix locking in unpair_device/disconnect_sync
Date: Thu, 30 Jul 2026 16:08:05 +0200
Message-ID: <20260730141437.948758298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 0c09cb5a78e028..a5945cfd71c5a5 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3012,6 +3012,8 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	struct mgmt_cp_unpair_device *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3019,6 +3021,11 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return 0;
 
@@ -3026,6 +3033,7 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
@@ -3173,6 +3181,8 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 	struct mgmt_cp_disconnect *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3180,6 +3190,11 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return -ENOTCONN;
 
@@ -3187,6 +3202,7 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
-- 
2.53.0



