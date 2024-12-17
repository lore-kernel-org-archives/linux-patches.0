Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CFF140E38;
	Tue, 17 Dec 2024 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456187; cv=none; b=jaJjLnQhx1uUreM8Hq16GS8c8+DtwhKFfVehMmkBBBERRgiKzgLlKPvm3YEKD5LJOT2MyjbkYbWT1c2SF4LFIibzHQ/xhuQHcprifF/NffcegzSbsGf19IsOYMaFXIy2558V2czmewrKPjj9sZgjcMkd+miQC8VmfJjOKqMT1lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456187; c=relaxed/simple;
	bh=gkUOu2q0FcC3nHDqUCG17qEKnvCRxMEAcWn9a9ObNwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai+VZu5HlX9CsVNz/7FyWBJMDTWwqCYZZMSjXXvAwmE3ugb4GiZi/47PgQlPUetIWp74wT3TcwQRWJrrFb6VM0211SbwcYqFWHKRYLedhE3X2RgeYlRr62fdFxqlD+xg6i0nOLjQJmBWF9bvj4N6etX5EPpq4MofvrF40qfsBqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpnUpHiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpnUpHiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE85C4CED7;
	Tue, 17 Dec 2024 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456187;
	bh=gkUOu2q0FcC3nHDqUCG17qEKnvCRxMEAcWn9a9ObNwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpnUpHiK9qRtxQmFlxQFegJkYPptyAnzwYhABkiyVRFOevqqwa/FtWnJpREuGvbFb
	 vfb/MIVlHU0WRhcH+XwTDPLrP2IdXKaVy8krgWo1cKLA+uKZaKL6g4GrVLz17B2L/6
	 5kblTIcFaLzPk4s7516Bbv13mfr6r5JQb+hdOgpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/109] Bluetooth: hci_event: Fix using rcu_read_(un)lock while iterating
Date: Tue, 17 Dec 2024 18:08:11 +0100
Message-ID: <20241217170537.018617980@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

[ Upstream commit 581dd2dc168fe0ed2a7a5534a724f0d3751c93ae ]

The usage of rcu_read_(un)lock while inside list_for_each_entry_rcu is
not safe since for the most part entries fetched this way shall be
treated as rcu_dereference:

	Note that the value returned by rcu_dereference() is valid
	only within the enclosing RCU read-side critical section [1]_.
	For example, the following is **not** legal::

		rcu_read_lock();
		p = rcu_dereference(head.next);
		rcu_read_unlock();
		x = p->address;	/* BUG!!! */
		rcu_read_lock();
		y = p->data;	/* BUG!!! */
		rcu_read_unlock();

Fixes: a0bfde167b50 ("Bluetooth: ISO: Add support for connecting multiple BISes")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 141b4fce55e3..01e51e1dc9b3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6821,38 +6821,27 @@ static void hci_le_create_big_complete_evt(struct hci_dev *hdev, void *data,
 		return;
 
 	hci_dev_lock(hdev);
-	rcu_read_lock();
 
 	/* Connect all BISes that are bound to the BIG */
-	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
-		if (bacmp(&conn->dst, BDADDR_ANY) ||
-		    conn->type != ISO_LINK ||
-		    conn->iso_qos.bcast.big != ev->handle)
+	while ((conn = hci_conn_hash_lookup_big_state(hdev, ev->handle,
+						      BT_BOUND))) {
+		if (ev->status) {
+			hci_connect_cfm(conn, ev->status);
+			hci_conn_del(conn);
 			continue;
+		}
 
 		if (hci_conn_set_handle(conn,
 					__le16_to_cpu(ev->bis_handle[i++])))
 			continue;
 
-		if (!ev->status) {
-			conn->state = BT_CONNECTED;
-			set_bit(HCI_CONN_BIG_CREATED, &conn->flags);
-			rcu_read_unlock();
-			hci_debugfs_create_conn(conn);
-			hci_conn_add_sysfs(conn);
-			hci_iso_setup_path(conn);
-			rcu_read_lock();
-			continue;
-		}
-
-		hci_connect_cfm(conn, ev->status);
-		rcu_read_unlock();
-		hci_conn_del(conn);
-		rcu_read_lock();
+		conn->state = BT_CONNECTED;
+		set_bit(HCI_CONN_BIG_CREATED, &conn->flags);
+		hci_debugfs_create_conn(conn);
+		hci_conn_add_sysfs(conn);
+		hci_iso_setup_path(conn);
 	}
 
-	rcu_read_unlock();
-
 	if (!ev->status && !i)
 		/* If no BISes have been connected for the BIG,
 		 * terminate. This is in case all bound connections
-- 
2.39.5



