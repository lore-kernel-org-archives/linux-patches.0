Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B288838654F;
	Sat, 17 Oct 2026 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254580; cv=none; b=foSfCm8c93wd9+Y2jn6K1iRl8fBQkevEcFLDWkkjbWABqrebTIKIozyNYBHU0DuTXHSlWjfz8j7B7gXI3CJxYV91LJ4d0fJ4fiha+q9PZFZlSrQrMOFabgZ11eBTG27J1IFLs9GqVRKKe6veW9h15O2Rgwn42PYl80OvMbaM3FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254580; c=relaxed/simple;
	bh=TK8+AMQPp2zFSnDArK52e00b67Iw1uXiDQAHo+3AnSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3caoBw1ptYtHow/fi8r3bj9QsNu23qrtB/8u/VbF+oIEWRXSJlzyK1q68F1twJLyGFz0thZZel27O/2vu+HKQLFdjMtJutEE3E4pdj1glLJmQx6VTlpGfieWNlvOYcGvr+7cdLgymwqgDojTuGdwvLx94aCWNkoYYlJd6L2dH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qc+nTTIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qc+nTTIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154F61F000C4;
	Sat, 17 Oct 2026 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254579;
	bh=uVZRx4AgnHzHvIfPPfhvU220c4iXZXZsIgxFzkpXjCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qc+nTTIOY7LgYWkcL/KdewwxwI/vxeLGiFPZRzz+hBbDN3gkP1Ht6tEJrcGuiChc0
	 CKYwLei56GGyzXgccU4mji5j0Ni2gkM5sLZz0uLDMpqPJ5XDiMhGl/nJ3vwFscHC7v
	 ldOjy50RS1/czUfBIWQet+CDPnH4f8dMt9sXZvt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 494/869] Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback
Date: Sat, 17 Oct 2026 17:55:35 +0200
Message-ID: <20261017160049.778393384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 56e78b670356caab0b607e8aad4cf819a1909d07 ]

There is theoretical UAF if the conn is freed while the hci_sync task is
running.

Hold refcount to avoid that. Handle NULL hcon, return 0 + do nothing to
match the previous behavior.

Fixes: 024421cf3992 ("Bluetooth: hci_conn: Fix not setting timeout for BIG Create Sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 2d28a649f33b0..92ef7d88f8e3c 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7447,10 +7447,12 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
-	if (hci_conn_valid(hdev, conn))
-		clear_bit(HCI_CONN_CREATE_BIG_SYNC, &conn->flags);
+	clear_bit(HCI_CONN_CREATE_BIG_SYNC, &conn->flags);
+
+done:
+	hci_conn_put(conn);
 }
 
 static int hci_le_big_create_sync(struct hci_dev *hdev, void *data)
@@ -7502,7 +7504,13 @@ int hci_connect_big_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_le_big_create_sync, conn,
+	if (!conn)
+		return 0;
+
+	err = hci_cmd_sync_queue_once(hdev, hci_le_big_create_sync,
+				      hci_conn_get(conn),
 				      create_big_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
-- 
2.53.0



