Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA93B1029;
	Fri, 15 May 2026 16:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860999; cv=none; b=NoV4QmPqjTHPSoGH2b58M7dlYwJVbSFc9xkPHyQ1Bm6SR1yUTFxl5gC57b36ct/X+dPZ3qLdFbyTVO7bKDOgRovwHfxFdmteeBhZU3kdcW7dmhpI5cOrKyz38ibDEM6JYlo4Ff8r9eXA9y4HHdbhxJNz1yzdSaFQ5KLr6Jpk4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860999; c=relaxed/simple;
	bh=i6etVC8eWBnNDI7h+MO/KcTIwPvZKAKGIC+HYnaTi0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqT73ScWOy7mWpmaDj2GL69lYG00cnzDAEePDI5d7GzKSGcLKzTce2etJREcSkm16B+IQE2bJp71ojxbpnl/ijefbfrRbycKYyIUTU8MkgG14gqir5h/I/O2hQ+2DuZLdZt3A2WUyL+B+tA8T4HWQ5Zm7HbjJyq+pq0XyiSpsfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qbjt2dzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qbjt2dzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D04C2BCB0;
	Fri, 15 May 2026 16:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860999;
	bh=i6etVC8eWBnNDI7h+MO/KcTIwPvZKAKGIC+HYnaTi0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qbjt2dzzkRkVLSH+efKbCjOCzCZGCIZjPCwZp3bzsu7u2LbnHQRUz35TYqr0P9jTH
	 b9lnM14qUzOq2vriGa6llumG4DWPEPqCV1wCEB1Iej19rqVKOy83pzGtN2Y00pcCQz
	 fQJmJkPHRdACQiwQ2IjYg/84UzxwHvOeGAlbHKhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 118/474] Bluetooth: hci_event: fix potential UAF in SSP passkey handlers
Date: Fri, 15 May 2026 17:43:47 +0200
Message-ID: <20260515154717.591881242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -5409,9 +5409,11 @@ static void hci_user_passkey_notify_evt(
 
 	bt_dev_dbg(hdev, "");
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	conn->passkey_notify = __le32_to_cpu(ev->passkey);
 	conn->passkey_entered = 0;
@@ -5420,6 +5422,9 @@ static void hci_user_passkey_notify_evt(
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_keypress_notify_evt(struct hci_dev *hdev, void *data,
@@ -5430,14 +5435,16 @@ static void hci_keypress_notify_evt(stru
 
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
@@ -5452,13 +5459,16 @@ static void hci_keypress_notify_evt(stru
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


