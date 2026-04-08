Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00F2328B75;
	Wed,  8 Apr 2026 18:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673134; cv=none; b=pJQZ+lITaB7llarkzp9RmjyZJ0JWMMScA7dKScGRr1m5PWt4ZBnf9kQ9sYcp9PWid2fnhbkMDSDumMlDl4btZbSBzZEID2iG4RWHg95Xxt7EDl+OWwWkLsDf5QycwMHZAWqNTXmf158Rdvn5gi6eXkxSkytaleacztbWPLaRxSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673134; c=relaxed/simple;
	bh=h1Q0pStPLoWOnMWXb9SVNSMr0xt23wyhvqUp8im3T80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdL3MQkaEIzxS5f7/HTWCv0w5jLZ0qEqXOGb7oFv5QndGQOf0TBxjI4bthnZoQlUVIpQciP4NAfpjUB6TMQ+MNWH7bMDZFeCth9LzYVgrLSB6HFbcwl3yhmdSNwUEfBzPnUAuatMMEybKWvlJw1J5Zsy1chuPisOOHcxghdy4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSYY4kfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSYY4kfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC9DC4AF09;
	Wed,  8 Apr 2026 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673134;
	bh=h1Q0pStPLoWOnMWXb9SVNSMr0xt23wyhvqUp8im3T80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSYY4kfyLU1Oy2vM20gk9wUJUv3yh59qBRFMassIuZ5CDEIumtVOH5xup5Cj5AExt
	 Xg4PTjO+HpVJ963ktSR067Elle2neFvzgszW6RrQWz8+6pX4v28IeHJ4TWjD/tinkD
	 9rcBE3oipul29UtsLj5MuviTMOKAVvXHxKlPUf2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/277] Bluetooth: hci_conn: fix potential UAF in set_cig_params_sync
Date: Wed,  8 Apr 2026 20:01:07 +0200
Message-ID: <20260408175936.926111040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

[ Upstream commit a2639a7f0f5bf7d73f337f8f077c19415c62ed2c ]

hci_conn lookup and field access must be covered by hdev lock in
set_cig_params_sync, otherwise it's possible it is freed concurrently.

Take hdev lock to prevent hci_conn from being deleted or modified
concurrently.  Just RCU lock is not suitable here, as we also want to
avoid "tearing" in the configuration.

Fixes: a091289218202 ("Bluetooth: hci_conn: Fix hci_le_set_cig_params")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 8906526ff32c5..24b71ec8897ff 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1826,9 +1826,13 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 	u8 aux_num_cis = 0;
 	u8 cis_id;
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_cig(hdev, cig_id);
-	if (!conn)
+	if (!conn) {
+		hci_dev_unlock(hdev);
 		return 0;
+	}
 
 	qos = &conn->iso_qos;
 	pdu->cig_id = cig_id;
@@ -1867,6 +1871,8 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 	}
 	pdu->num_cis = aux_num_cis;
 
+	hci_dev_unlock(hdev);
+
 	if (!pdu->num_cis)
 		return 0;
 
-- 
2.53.0



