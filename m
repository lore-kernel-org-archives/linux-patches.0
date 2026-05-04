Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909F53DE443;
	Mon,  4 May 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904726; cv=none; b=uqwEq5zpgg9sQE28Bsc6xDb3oBI8kwK6OeIiYrgeOOw6kZeCqdfJ5Mh55EP32OpdO++eXGc1h7uplUmrNkrNMpALQDL06SX21V3EKVD5ZbaSr0y5/wPYHtAz9iYhdhTaxrqNRLGayUx9OVFIFC8O65eHWRumefX+rLHmWVLP328=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904726; c=relaxed/simple;
	bh=mK8wlVE0dlQYoMgL5s99z+uj7Q7Xv6gsCaa0QGacVFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWecUdjCWmOPbnVHViNsFDqJwoNo4dzxCg2vpgCku25nOtxgNQJbszDo3nJ7LRRRRpSlywE/5vURcb1RCSGU/cTAe9dS0An2UJ5Wqzfs+y1UhzZi5Lw9KBHzQrGpjuQPVUWZ3Jr6sEeLiBrlfqcW7/7TR5zj07b2had8LAyFV4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0u5i1KWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0u5i1KWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AC1C2BCB8;
	Mon,  4 May 2026 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904726;
	bh=mK8wlVE0dlQYoMgL5s99z+uj7Q7Xv6gsCaa0QGacVFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0u5i1KWJEG4gctmjYJ/iowaq2jv0F0HdfPb0kW42lSBDnM885nQ+1skVUYd1nDJnn
	 gx1BhvZkPBPL6hHzyJKOoZxSS2OvtNPl3jN6PFQe/pT6VT2u9j+ZU5NPngW2Wt4eOy
	 ZyAW9QmAAerfL845a7HPcvG79tMthq7w9X4oR7Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 151/215] Bluetooth: hci_event: fix potential UAF in SSP passkey handlers
Date: Mon,  4 May 2026 15:52:50 +0200
Message-ID: <20260504135135.684147878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit 85fa3512048793076eef658f66489112dcc91993 upstream.

hci_conn lookup and field access must be covered by hdev lock in
hci_user_passkey_notify_evt() and hci_keypress_notify_evt(), otherwise
the connection can be freed concurrently.

Extend the hci_dev_lock critical section to cover all conn usage in both
handlers.

Keep the existing keypress notification behavior unchanged by routing
the early exits through a common unlock path.

Fixes: 92a25256f142 ("Bluetooth: mgmt: Implement support for passkey notification")
Cc: stable@vger.kernel.org
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5412,9 +5412,11 @@ static void hci_user_passkey_notify_evt(
 
 	bt_dev_dbg(hdev, "");
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	conn->passkey_notify = __le32_to_cpu(ev->passkey);
 	conn->passkey_entered = 0;
@@ -5423,6 +5425,9 @@ static void hci_user_passkey_notify_evt(
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_keypress_notify_evt(struct hci_dev *hdev, void *data,
@@ -5433,14 +5438,16 @@ static void hci_keypress_notify_evt(stru
 
 	bt_dev_dbg(hdev, "");
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	switch (ev->type) {
 	case HCI_KEYPRESS_STARTED:
 		conn->passkey_entered = 0;
-		return;
+		goto unlock;
 
 	case HCI_KEYPRESS_ENTERED:
 		conn->passkey_entered++;
@@ -5455,13 +5462,16 @@ static void hci_keypress_notify_evt(stru
 		break;
 
 	case HCI_KEYPRESS_COMPLETED:
-		return;
+		goto unlock;
 	}
 
 	if (hci_dev_test_flag(hdev, HCI_MGMT))
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_simple_pair_complete_evt(struct hci_dev *hdev, void *data,


