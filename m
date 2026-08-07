Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31828377A93;
	Fri,  7 Aug 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115012; cv=none; b=n6+RPql1IjhePEO7KN7lc6ILHAcpYoH7IPKKsHZ/rAIjqX2AjA5OUxOzs4RhIzMRiv+I9laUCuUspVk3OM7XI6WM0s9BTWACqKftLucR6/NcK3312sntSzwS096J3anWVNYv4J0+F/MSThqa2VYNVNK/CidyoYCId2MsyuyLpfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115012; c=relaxed/simple;
	bh=TllLHmWHR8BACUqEpDtVXIu3o0pvBAoiERa/CQ7BwzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT1Jj358ILsSzMvW3OlhBRC9S90L1sSHj8Vx0s4tzNBJ4hC6lvKDvm6msAJY7O+226IVKa7Yd3NhhDOd/VEf859CwdQejmvyxFRYVVV1xFLczf37Hx7EZu9ka1ClFDn4gpDdY0Sx98FBIoA74uyFM9knjl/XD3jNSos3vmjiwAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCj7n4ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCj7n4ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839B11F000E9;
	Fri,  7 Aug 2026 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115011;
	bh=OJxK6Z2qdwoac2AcEnrlut8j8YyPtvzFnUWdw6GcT3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCj7n4ss0TFA2yB32UBFnJI9HCcjwRskAh65F+BFZbKSGnuqHypx4e4MYhbh0k3yv
	 mIeFtUOShhzPotle+GeBzROw8xQLXMgrPjsWLXEQABgd2RKSRjKQqPZN5vYC5F1yRx
	 ik7d6zezOHPtJVbzmVcxLc+K4YhWE3/4/6oDY88A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/396] Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync
Date: Fri,  7 Aug 2026 16:34:45 +0200
Message-ID: <20260807143427.004875582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index 27c5cc1457e65..1ba41e82c406e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6604,11 +6604,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
-	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
-	 * clear_bit() at done.
-	 */
-	hci_conn_get(conn);
-
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 	conn->state = BT_CONNECT;
 
@@ -6623,7 +6618,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 			conn->state = BT_OPEN;
 			hci_abort_conn_sync(hdev, conn,
 					    HCI_ERROR_REJ_LIMITED_RESOURCES);
-			hci_conn_put(conn);
 			return -EBUSY;
 		}
 
@@ -6717,7 +6711,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
-	hci_conn_put(conn);
 	return err;
 }
 
@@ -6992,11 +6985,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
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
@@ -7008,7 +6996,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 				       conn->conn_timeout, NULL);
 
 	clear_bit(HCI_CONN_CREATE, &conn->flags);
-	hci_conn_put(conn);
 
 	return err;
 }
-- 
2.53.0



