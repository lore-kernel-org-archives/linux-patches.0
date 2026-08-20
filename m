Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3973447F2FA;
	Thu, 20 Aug 2026 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248655; cv=none; b=XQAHDFXZvqwyt7+k9W+fLu2VNCq0KYKDwzF5jrziCYyR0EStpUQ2/arZ0fjaSUk9rggM2f46ZDsNuHoMKTf8ZTfzhiliJDcPe48Nk/eQsjPv+HbGk5gzXeHlKytZ3woTAitP42Sqn8zHW0xSZ8BB1WobdCXeYe9Z9PEZURcRj0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248655; c=relaxed/simple;
	bh=ATK/G/F3XHiuoKFHvAWEzGRWeI5qsPG2YeKlzVjLYM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcdNWRzS/w+dOOdpNXbyixyzPnzYaKft2ReVOWa1xWfLiG4cX8+BkscjJTcBv/uscnlmiMiaNrTjzdojKUOB1gf9tFAWM8d6+gPWbvX81CdqR/aw2IabHSgI2nbCbGigwL+7PLlcsv0YLJRToN7p/SjcrXeVMe/pTriY2pL9/Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhH8k39a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhH8k39a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FB91F000E9;
	Thu, 20 Aug 2026 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248654;
	bh=65yMB4zBf/4MJQshHCAaDK+DoeFTAP71pqYvOfYvrtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhH8k39aGMHbHOMR0rgRZvJ7UIw7pnyeaulaGWsJ1HBWKYtb8FN0npJg9eVzxC0NW
	 elLBVkP2HZ8SMVq5xGn9B0sRhnhxS1yo+smlkRZrkRBmUEvUhaxUuEk/ja682ztE2f
	 qLULOLhqot2dV6SFsm/rnSQz4Y+Dy4L/Gh3LVELs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 302/303] Bluetooth: mgmt: fix locking in unpair_device/disconnect_sync
Date: Thu, 20 Aug 2026 16:57:18 +0200
Message-ID: <20260820145302.545757576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

commit 16cd66443957e4ad42155c6fec401012f600c6f8 upstream.

Dereferencing RCU-protected pointers outside critical sections is
invalid and may lead to UAF.

Take hdev->lock for hci_conn lookup and hci_abort_conn().  Don't use RCU
to ensure the conn is fully initialized at this point.

Fixes: 227a0cdf4a028 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2939,6 +2939,8 @@ static int unpair_device_sync(struct hci
 	struct mgmt_cp_unpair_device *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -2946,6 +2948,11 @@ static int unpair_device_sync(struct hci
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return 0;
 
@@ -2953,6 +2960,7 @@ static int unpair_device_sync(struct hci
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
@@ -3100,6 +3108,8 @@ static int disconnect_sync(struct hci_de
 	struct mgmt_cp_disconnect *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3107,6 +3117,11 @@ static int disconnect_sync(struct hci_de
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return -ENOTCONN;
 
@@ -3114,6 +3129,7 @@ static int disconnect_sync(struct hci_de
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }


