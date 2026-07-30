Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E281343F8CB;
	Thu, 30 Jul 2026 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427188; cv=none; b=F1UqSzYq8YbU8+LNc+TLacGIhx+1s6NNhliG51gxRAsvUgKCEPjpAKZ+ujZliQta5IgFmxuZfsLR9KgNojdATED7oyH262V/FPs7Klx2C6vDqCtoAaPRoZRR3QAonlxraXmVfACRpzyFJvQx4rv4aB8H0Y77U9lX9QFcYDqWQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427188; c=relaxed/simple;
	bh=WWN5GA9F22j8VwgYmUDRFaJOi0fS2k7TL/a1+uWuHMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh8THE+tYqiJ6ZOBNQbr2B3RuBiT2Gfy6Mq1LAtnP++ivR+VRjUX9NVKqXJYSkaRRRvzj8w6LJfmmSFE7RcZN9+6KmPbkxlIsuVoqYdVwOeCr1vZBBqAQ5PsP4pdnRMMWVnYhUrwiitYedsNygPPx5Hez/LC7C5J2lVFYUT1zmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjp0ROxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjp0ROxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3901F000E9;
	Thu, 30 Jul 2026 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427186;
	bh=4DpirIj4reNuCmnKE0FhiQHGcVkOIom60bxk7rYUtU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjp0ROxO+YfKWlQKyj9vY27tQq2fyulHIB5bkEZuS3lUxwMWhvItpvz+n69Q1GJ3O
	 +ikFLbYQyg2mAwqvOEu45hUlnFMv5DHEAC6rTi3Bhb59Qja3/VWo8Hp16b8dwa2s+q
	 x/6sQ6wq+WUmJUTkJcmVKuf25uksk3jywp1H3j4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/484] Bluetooth: mgmt: fix locking in unpair_device/disconnect_sync
Date: Thu, 30 Jul 2026 16:09:37 +0200
Message-ID: <20260730141425.177980327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 20fe7f011b75c2..2d9781668cb74a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3005,6 +3005,8 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	struct mgmt_cp_unpair_device *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3012,6 +3014,11 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return 0;
 
@@ -3019,6 +3026,7 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
@@ -3166,6 +3174,8 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 	struct mgmt_cp_disconnect *cp = cmd->param;
 	struct hci_conn *conn;
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR)
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
 					       &cp->addr.bdaddr);
@@ -3173,6 +3183,11 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
 					       le_addr_type(cp->addr.type));
 
+	if (conn)
+		hci_conn_get(conn);
+
+	hci_dev_unlock(hdev);
+
 	if (!conn)
 		return -ENOTCONN;
 
@@ -3180,6 +3195,7 @@ static int disconnect_sync(struct hci_dev *hdev, void *data)
 	 * will clean up the connection no matter the error.
 	 */
 	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	hci_conn_put(conn);
 
 	return 0;
 }
-- 
2.53.0



