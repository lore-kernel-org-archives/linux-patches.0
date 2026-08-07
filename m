Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BD64749FA;
	Fri,  7 Aug 2026 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116944; cv=none; b=Zsae8DoIfZIjhHt3d1kfAJkGoZjW8KRYjqUHvl5MBTLlEHfYGRlb5v/jhtvk3tNeQX1zKZSycim68YqB04d3U8C4tIzVezyfAVdJ+P58UJFFX5Ab59jknX4IMyTBhbw+uCxXddw45Wi6eA+zI7Tjx9fk+omCaURvmdzXCUku1bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116944; c=relaxed/simple;
	bh=0NK9USArL3YNV2qW6oEqWNcBop44Yg7rb3xJauJIjDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLR4C7tkiw5gD+KuoAmr7NtIjKGAAOKlgT69QUnAJWKBtFvzRqdWDv3M2IlLngR+JVuxmQthD89DEEbRhl1g/InBiOiEDwSTQkyfJRRZ5cliQw0lZD55SfUaZJy3aQ9ZlLjMwVdhnFZoIndAgauM+npNSJyrOF585JgiN3fa350=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwGQ/+hF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwGQ/+hF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FFE1F000E9;
	Fri,  7 Aug 2026 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116943;
	bh=f+v0xndrP3VG9roFoKIA6oWY++PR+JZMU+8TmeEEMA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwGQ/+hFnONE1Dv6noFwy0z71ocG3t99Gt68I0hVFhSI6sNkonqOktjskeyeeIZEN
	 zGa/lr/tUbqREUPynE7tf7q5W85NUEss2VPDvWdjTH3iWb2OqCqo2xLhLXImPH9Uwy
	 3/6cP85ae2pFPLtIYB1Wx1hihUXsfMU12hZ3Egj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 144/438] Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback
Date: Fri,  7 Aug 2026 16:35:40 +0200
Message-ID: <20260807143431.075095968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2cac69922353a..2860779e6a791 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7437,10 +7437,12 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
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
@@ -7492,8 +7494,14 @@ int hci_connect_big_sync(struct hci_dev *hdev, struct hci_conn *conn)
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



