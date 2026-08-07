Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE6277CA5;
	Fri,  7 Aug 2026 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113995; cv=none; b=KFPiH7P4+UnW2LrlY3D2j++LFnuLKFk7kbMNSuqdGGETHv0fg1TNfnhjwfuu3UtCYXompvn4kLGmE3EdZDLy6oVWqSxEzXwPKY5nQ8lpj3Y29CxhYGcI4Ilwf/ytWeVzmKebww0tif2ITVG/touSHKnwh6RVFKmPxhYwA+2pteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113995; c=relaxed/simple;
	bh=bUBuA3jcl4LocyYbEpttTs87gacvQmKH8cbTn0Ma23M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfjmCyqRrUf56CniNQacd1hUEhUJTPNcsMmw0hMgZ81Cgcgm+tP8mB9+SbLKLhzwHXvW5Bi9kls16TfPHj9HiX+VHuqGVw21A+rflrml7ufLlg7ti59tT9I7pcIIoXVQayR5W4xARt1PAsPePUs1BWWEFefevSdGcYZg0TvIhFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiEd4YVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiEd4YVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5071F000E9;
	Fri,  7 Aug 2026 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113994;
	bh=cN5lyX5Ma5pBcSGktZ9jgU91EBjgZwqAehqWihwUI5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiEd4YVppKVI7tUAJqLop8EdZF/27vnGiuxbcCNvFXg/IY9VdFST8Gfeog1vakv4/
	 ZhmgDeF365R2BkXA2Q4I6h0DPRMK6bnXNnsw1Ae4DqCjiigNQEUUkaV/QbpVChJ/q+
	 gvoXx3MF0kO6dmZF9aL6At7D4r9t+lh8/kAcbSz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/337] Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync
Date: Fri,  7 Aug 2026 16:35:09 +0200
Message-ID: <20260807143420.836222269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 8c48d459a5415..03bbf4c1d6e5a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6577,11 +6577,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
-	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
-	 * clear_bit() at done.
-	 */
-	hci_conn_get(conn);
-
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 	conn->state = BT_CONNECT;
 
@@ -6596,7 +6591,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 			conn->state = BT_OPEN;
 			hci_abort_conn_sync(hdev, conn,
 					    HCI_ERROR_REJ_LIMITED_RESOURCES);
-			hci_conn_put(conn);
 			return -EBUSY;
 		}
 
@@ -6690,7 +6684,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
-	hci_conn_put(conn);
 	return err;
 }
 
@@ -6965,11 +6958,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
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
@@ -6981,7 +6969,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 				       conn->conn_timeout, NULL);
 
 	clear_bit(HCI_CONN_CREATE, &conn->flags);
-	hci_conn_put(conn);
 
 	return err;
 }
-- 
2.53.0



