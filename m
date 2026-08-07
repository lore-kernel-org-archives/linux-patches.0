Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEEC47A898;
	Fri,  7 Aug 2026 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116951; cv=none; b=SwCUcnoWlWeEmNy4waZ+CRshpikjusLLHd6AIiU9Z4XHwfZ10q8n7fs5+Dk6+BJdpVM4+icL3B9h9bNrOrWRX21YEArHs7caR1cAGgl8iBLAruRrelZmZu3ggtC4aIICpZKKa04cNJD8F/bZwEWhSq+5/ep7NOsIkUI7MmZ023o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116951; c=relaxed/simple;
	bh=FHzWCNUod3T8dLqdKYcUxcZ+xZfACLj4uNe1YDzLq/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urv4A/D5dHc5HQRLDFYbe1BZScK8BS9wr3weaA0orzDXhIKC4x/WJhKPQ+TNHCNa/ufea20srgYYzYv7P2f6SUHMP1qmWVBAs/Cj6wj0ZM8EJ+FqkT76aK+2KKqNa3EBuxnN6RUTvJKwsOcSrE/V1zWp8QfHBrHfKEDrBPBxl+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPbbAagz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPbbAagz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317561F000E9;
	Fri,  7 Aug 2026 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116948;
	bh=VL//PQA8u7QMcyCoXWSn8yOP/ruKN58sEh1+/oYn9pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPbbAagzQL/z0bftZV3qF9PnAA536VVQNKtWpJclCfvMTocbhi1ysZZ84Xzix7SWI
	 HpvRax78DpeMKqAvbg/kPef+PXj5mAEN8t9iJYtBNvcKLwkQvunkyKuIiWLMDv2rf4
	 +0DRNc54pEEBDuMn3Yf+oIh7R5C2G9LU8v4IzQP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 146/438] Bluetooth: hci_sync: hold conn in hci_past_sync() callback
Date: Fri,  7 Aug 2026 16:35:42 +0200
Message-ID: <20260807143431.119308867@linuxfoundation.org>
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

[ Upstream commit abf9753edf3f88282c44a605f3945d8d4f8dd86c ]

Avoids giving freed pointers to hci_conn_valid(), which kmalloc may have
reused.

Hold refcount to avoid that.

Fixes: d3413703d5f8 ("Bluetooth: ISO: Add support to bind to trigger PAST")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6c3dc910fdeba..70ac18fe74448 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7521,6 +7521,8 @@ static void past_complete(struct hci_dev *hdev, void *data, int err)
 
 	bt_dev_dbg(hdev, "err %d", err);
 
+	hci_conn_put(past->conn);
+	hci_conn_put(past->le);
 	kfree(past);
 }
 
@@ -7585,8 +7587,8 @@ int hci_past_sync(struct hci_conn *conn, struct hci_conn *le)
 	if (!data)
 		return -ENOMEM;
 
-	data->conn = conn;
-	data->le = le;
+	data->conn = hci_conn_get(conn);
+	data->le = hci_conn_get(le);
 
 	if (conn->role == HCI_ROLE_MASTER)
 		err = hci_cmd_sync_queue_once(conn->hdev,
@@ -7596,8 +7598,11 @@ int hci_past_sync(struct hci_conn *conn, struct hci_conn *le)
 		err = hci_cmd_sync_queue_once(conn->hdev, hci_le_past_sync,
 					      data, past_complete);
 
-	if (err)
+	if (err) {
+		hci_conn_put(data->conn);
+		hci_conn_put(data->le);
 		kfree(data);
+	}
 
 	return (err == -EEXIST) ? 0 : err;
 }
-- 
2.53.0



