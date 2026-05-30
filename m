Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B9A32D42B;
	Sat, 30 May 2026 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160131; cv=none; b=j7GJ9Tri9njCluXpLZXhrwxpnTJRNgYtoWUK1BTViMxCELNPxgif6k7ZO5EAwrD0vC/YbRjwVTOe827Z2nbIWSXoNyHWv5F1lQB8q0vfo/LLJQTDm1dXVbyPLLU89XLeKNaZA80OT9ylfW2fEVjO5pnOCQJTKdiLtDTo4CYQ9eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160131; c=relaxed/simple;
	bh=BObBBbDiRFMegG0dLRJeSWOPEY/PesFGHYhjTLqZ7o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/2urNh82q2jEdcKIL5Ls4rh9oIZAxy5uEMp+v4ryJsxABE4WhNBACHE6muKcJzTn/3Zjzv6/XpGCJiywwDmhHGXIDyQL+kZRBGp0OWN9UomyQjE/NIbaN/C1mIW+xxiQd9L04m5wEc5mvtfSrt3B1JHPlFvliDmdcSSD4yaX5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1F/j7QMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1F/j7QMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390071F00893;
	Sat, 30 May 2026 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160130;
	bh=oaB9t/4jSZ8V4jzXD17VnpaoIm7L25Ejr4Yb+8aK38I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1F/j7QMMyjWotSrA2+HhXp74CTaEVdQZzooD9PFnOMKCl2jtUUxCDWRhbmS62fOvF
	 7UR5m23p3ZTeigNKl7Hg4YPflNrNIy3eMxPAdwT+dt9Ggol3fUQkb/I6hMZORWPLBR
	 934bejNDTbxsZLBLOFbYjtVZYAqnxVPhS0d3YpEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 253/969] Bluetooth: hci_event: fix potential UAF in SSP passkey handlers
Date: Sat, 30 May 2026 17:56:17 +0200
Message-ID: <20260530160307.459209519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -5497,9 +5497,11 @@ static void hci_user_passkey_notify_evt(
 
 	bt_dev_dbg(hdev, "");
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	conn->passkey_notify = __le32_to_cpu(ev->passkey);
 	conn->passkey_entered = 0;
@@ -5508,6 +5510,9 @@ static void hci_user_passkey_notify_evt(
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_keypress_notify_evt(struct hci_dev *hdev, void *data,
@@ -5518,14 +5523,16 @@ static void hci_keypress_notify_evt(stru
 
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
@@ -5540,13 +5547,16 @@ static void hci_keypress_notify_evt(stru
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


