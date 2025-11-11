Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7E51D6DB5;
	Tue, 11 Nov 2025 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822397; cv=none; b=RY/naDzKJTx84Nls1S616cVYIWTtOR6SXAe7JPPk0CCaXAlmsGWLxq5bGSuQ85UkLRdMerKWIchyFqK3+QTEsgF02ls0IEYyRKxh97vMcxTS6LJaSzwWXf2i/XrLts7g6PKlAUNASXtt+0PBA/wg6i2fkrUhBpidR2fy/fNXCtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822397; c=relaxed/simple;
	bh=U0Sf+E9NxpgzNiwf813ZPZyujrP612geHkrJubaBjAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQOqdBchCXQdeQ6QJuU8pgsgnEtEKCoGJz4g4xEU7VlNCf/xe6s0wN1hxAVUZEoeyXgKnFqjRUWnvO5hxOBDf1YcIrzTA2t6eCNTsVhMOiZ49ktdN3p6TuFhkzmk8UWfkF5zy8bUQHJPFpvuManBJ0DqkxhLr560eDB5RInGlZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJSvMVZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJSvMVZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06140C116B1;
	Tue, 11 Nov 2025 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822397;
	bh=U0Sf+E9NxpgzNiwf813ZPZyujrP612geHkrJubaBjAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJSvMVZ+/iVdMPCIcOb8WslX/WzbLxrDGaEwnbm50MB72EmWnBe0QonphED13t/RZ
	 0QaK1yAs/ZBjypyo8/pAmWLjtKdErPx2igC1CpphAsLF9p99IgtcVUilDpxJ43epeC
	 nhMdAVNouYFUX0XH5IuYXkNCwSp+yafSMv0HI1Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/565] Bluetooth: ISO: Update hci_conn_hash_lookup_big for Broadcast slave
Date: Tue, 11 Nov 2025 09:38:18 +0900
Message-ID: <20251111004527.846089865@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 83d328a72eff3268ea4c19deb0a6cf4c7da15746 ]

Currently, hci_conn_hash_lookup_big only checks for BIS master connections,
by filtering out connections with the destination address set. This commit
updates this function to also consider BIS slave connections, since it is
also used for a Broadcast Receiver to set an available BIG handle before
issuing the LE BIG Create Sync command.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: f0c200a4a537 ("Bluetooth: ISO: Fix BIS connection dst_type handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 12 +++++++++++-
 net/bluetooth/hci_event.c        |  1 +
 net/bluetooth/iso.c              |  1 -
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 69a1d8b12beff..ca75c71b58588 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1315,7 +1315,17 @@ static inline struct hci_conn *hci_conn_hash_lookup_big(struct hci_dev *hdev,
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (bacmp(&c->dst, BDADDR_ANY) || c->type != ISO_LINK)
+		if (c->type != ISO_LINK)
+			continue;
+
+		/* An ISO_LINK hcon with BDADDR_ANY as destination
+		 * address is a Broadcast connection. A Broadcast
+		 * slave connection is associated with a PA train,
+		 * so the sync_handle can be used to differentiate
+		 * from unicast.
+		 */
+		if (bacmp(&c->dst, BDADDR_ANY) &&
+		    c->sync_handle == HCI_SYNC_HANDLE_INVALID)
 			continue;
 
 		if (handle == c->iso_qos.bcast.big) {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1e537ed83ba4b..debe9cc2f72d9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6976,6 +6976,7 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 			/* Mark PA sync as established */
 			set_bit(HCI_CONN_PA_SYNC, &bis->flags);
 
+		bis->sync_handle = conn->sync_handle;
 		bis->iso_qos.bcast.big = ev->handle;
 		memset(&interval, 0, sizeof(interval));
 		memcpy(&interval, ev->latency, sizeof(ev->latency));
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 2cd0b963c96bd..f48a694b004ab 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1928,7 +1928,6 @@ static void iso_conn_ready(struct iso_conn *conn)
 		if (!bacmp(&hcon->dst, BDADDR_ANY)) {
 			bacpy(&hcon->dst, &iso_pi(parent)->dst);
 			hcon->dst_type = iso_pi(parent)->dst_type;
-			hcon->sync_handle = iso_pi(parent)->sync_handle;
 		}
 
 		if (ev3) {
-- 
2.51.0



