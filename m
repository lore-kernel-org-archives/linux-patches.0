Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EF11BE23C;
	Wed, 20 Nov 2024 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107573; cv=none; b=Kw5v8SOIVmh/iFxepABZi3LTNEZiib7F1TMKKs98YybPQJzzqPOmAAbLVCmd3NdUs5cq5mhRDwCnx1sD2l2bdpSXhKwQGw99KMIVxwkERGJJJSA0K1G9uWimQBkub7qRu4ZFZ/Y/pODI95yoZlxvSqERkHpCo45UUM/zCDJfcxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107573; c=relaxed/simple;
	bh=YkFW8YpZ2N2XokKmzgPi7REMtxNoRU4dftIfahxldwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJH7rGVv/KD8ncrWPAsjQ/YM/IsP0bZmYONcn4prqLOU3HHQWiwmI3WD9+aHc/7YDXz1gxCu2bsmakaIiC/gTxQjTvAVXbWT5qCYUyTgsEkGxf0noum9g5L9Ke7hm0vQQHstpmvKyCGQC8yNtOYs/ZVNvYxg/TnACvFcMJLh2lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bosnklTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bosnklTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282AAC4CECD;
	Wed, 20 Nov 2024 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107573;
	bh=YkFW8YpZ2N2XokKmzgPi7REMtxNoRU4dftIfahxldwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bosnklTg8wSIckiZlcsDMFNju8P2X9FpS/nkzwxmiCsX7wQbFY2GrqhK3arE++zsO
	 wQHmYldZaXFTPNfm1TD/zliWPiUtfcORUWszklNcNbVWjHchWdLvlfSM3mb9V9cdqB
	 YhyRBCxXFhnK4Al6H4drAK/Ays7MQT6WM7F8tZFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/82] Bluetooth: hci_core: Fix calling mgmt_device_connected
Date: Wed, 20 Nov 2024 13:56:23 +0100
Message-ID: <20241120125629.915239243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7967dc8f797f454d4f4acec15c7df0cdf4801617 ]

Since 61a939c68ee0 ("Bluetooth: Queue incoming ACL data until
BT_CONNECTED state is reached") there is no long the need to call
mgmt_device_connected as ACL data will be queued until BT_CONNECTED
state.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219458
Link: https://github.com/bluez/bluez/issues/1014
Fixes: 333b4fd11e89 ("Bluetooth: L2CAP: Fix uaf in l2cap_connect")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d4e607bf35baf..3cf4dd9cad8a3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3752,8 +3752,6 @@ static void hci_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hci_dev_lock(hdev);
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (conn && hci_dev_test_flag(hdev, HCI_MGMT))
-		mgmt_device_connected(hdev, conn, NULL, 0);
 	hci_dev_unlock(hdev);
 
 	if (conn) {
-- 
2.43.0



