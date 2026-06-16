Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34D349CF0;
	Tue, 16 Jun 2026 19:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636468; cv=none; b=TzudmwrDfyknecDC+0pwhDv7jAsrjy400cDyrKGBH9cnExC607w/0VAIXtcmxvV7zII6JhulJMCa9+HKDPCLo5o6N4mLSDq3/eiXu9/nTe2RMBOGyESQ1LM9qgja+u0ftstpuaw+z3N12DIFZHAe/6+df/Tb1f3h1Uxq3eto5Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636468; c=relaxed/simple;
	bh=OUBSuenhVX3Tmb7+hSoi9yUKcZhabuyUkcCBLg+WUtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N13P2UGb1d9H02yeU3o7LdvH8x66wxTRiA65UUD549FXhzWinKgVefqWcfmGKYEJqB+8HIcj/ud5mRY3r27dVAFFtzJDMrKh2whM6Vc2cEXlOjjjOVA7OlrUqZ49rYNTXcUzSXmsSAQDvfeSE9548vckaPYHlUvj7XwIMxTNZrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL1myVX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL1myVX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E31E1F000E9;
	Tue, 16 Jun 2026 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636467;
	bh=Yllhu6vPvMe4/azqmps06OdcNIpnfdMd2/pcr2y/1m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tL1myVX3m/Cqd/2h3frkjOQWtPHhTNZah/lTBIyEHUM9qf+UQzGGSeBAO9rnumFRk
	 rtoOa7C54511m0Vt8jfAiCy4nXkR5NqjWfCBVMxzZvMNrxM3unFZbHnt+lELjs5pnH
	 iGjtsBqqrM/wcOFeL3JjALJaV/rVAsO+etb9M9eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/342] Bluetooth: hci_event: fix potential UAF in SSP passkey handlers
Date: Tue, 16 Jun 2026 20:28:59 +0530
Message-ID: <20260616145059.533735001@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit 85fa3512048793076eef658f66489112dcc91993 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4842,9 +4842,11 @@ static void hci_user_passkey_notify_evt(
 
 	BT_DBG("%s", hdev->name);
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	conn->passkey_notify = __le32_to_cpu(ev->passkey);
 	conn->passkey_entered = 0;
@@ -4853,6 +4855,9 @@ static void hci_user_passkey_notify_evt(
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_keypress_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
@@ -4862,14 +4867,16 @@ static void hci_keypress_notify_evt(stru
 
 	BT_DBG("%s", hdev->name);
 
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
@@ -4884,13 +4891,16 @@ static void hci_keypress_notify_evt(stru
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
 
 static void hci_simple_pair_complete_evt(struct hci_dev *hdev,


