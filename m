Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C55631281D;
	Tue,  2 Sep 2025 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819480; cv=none; b=K8NwKgDHlZiis5PBvHOcrIoEcQmC8sBOGu9vx0xBfEKgJxuHDWa5w0Y/td91mqCHdsWdCVJWEgIw/kZ2sUYrWgADU33ZQ2jYwzADagJkttvJOZABnhPGlWuMMNQmZzCV4H8MdgSO7oiBoN4zkEVd3qigkHXurAdUJnFKrS4KLb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819480; c=relaxed/simple;
	bh=LSMIXAqfLl8mIohS9oT0WOzba9dwG1sG9qSbN23U6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs9/tmre+GLg14L0wCC+cYJAY0sOS+oIQsvfvFuoQyffLXC4g6y711WoIw/59CnDFYK6h5bj2VN8ah/TXJLm1Vd6aCZFT2LatmjtxD3ub4EDUhGVKVHtlfj3CBztSUHrH/hP2sNyl2F5uOlB0Yo92GXBMyUt9mXNN04xpp/PUec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIX5aI6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIX5aI6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E1C4CEED;
	Tue,  2 Sep 2025 13:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819480;
	bh=LSMIXAqfLl8mIohS9oT0WOzba9dwG1sG9qSbN23U6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIX5aI6laF04tZPxy6Q/pKLX0J8p8JyW1R7kiYENlYnwdD5Q2Rkovt115SRTr9+Ri
	 MaS2Yx9Da0ko+e+ef4tH+iJ9BBPnz/sKZ0HQB4RrSHZOD4xLnWhoBpb8ykev13J+5b
	 f1EXrWgxj8XhMh/kOF3DVEUBqFFrJbvNj+FazdjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 046/142] Bluetooth: hci_conn: Make unacked packet handling more robust
Date: Tue,  2 Sep 2025 15:19:08 +0200
Message-ID: <20250902131950.019044910@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5d7eba62e5eb68347de59b31b347b24f304cf21c ]

This attempts to make unacked packet handling more robust by detecting
if there are no connections left then restore all buffers of the
respective pool.

Fixes: 5638d9ea9c01 ("Bluetooth: hci_conn: Fix not restoring ISO buffer count on disconnect")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 58 ++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6a064a6b0e431..ad5574e9a93ee 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -149,8 +149,6 @@ static void hci_conn_cleanup(struct hci_conn *conn)
 
 	hci_chan_list_flush(conn);
 
-	hci_conn_hash_del(hdev, conn);
-
 	if (HCI_CONN_HANDLE_UNSET(conn->handle))
 		ida_free(&hdev->unset_handle_ida, conn->handle);
 
@@ -1142,28 +1140,54 @@ void hci_conn_del(struct hci_conn *conn)
 	disable_delayed_work_sync(&conn->auto_accept_work);
 	disable_delayed_work_sync(&conn->idle_work);
 
-	if (conn->type == ACL_LINK) {
-		/* Unacked frames */
-		hdev->acl_cnt += conn->sent;
-	} else if (conn->type == LE_LINK) {
-		cancel_delayed_work(&conn->le_conn_timeout);
+	/* Remove the connection from the list so unacked logic can detect when
+	 * a certain pool is not being utilized.
+	 */
+	hci_conn_hash_del(hdev, conn);
 
-		if (hdev->le_pkts)
-			hdev->le_cnt += conn->sent;
+	/* Handle unacked frames:
+	 *
+	 * - In case there are no connection, or if restoring the buffers
+	 *   considered in transist would overflow, restore all buffers to the
+	 *   pool.
+	 * - Otherwise restore just the buffers considered in transit for the
+	 *   hci_conn
+	 */
+	switch (conn->type) {
+	case ACL_LINK:
+		if (!hci_conn_num(hdev, ACL_LINK) ||
+		    hdev->acl_cnt + conn->sent > hdev->acl_pkts)
+			hdev->acl_cnt = hdev->acl_pkts;
 		else
 			hdev->acl_cnt += conn->sent;
-	} else {
-		/* Unacked ISO frames */
-		if (conn->type == CIS_LINK ||
-		    conn->type == BIS_LINK ||
-		    conn->type == PA_LINK) {
-			if (hdev->iso_pkts)
-				hdev->iso_cnt += conn->sent;
-			else if (hdev->le_pkts)
+		break;
+	case LE_LINK:
+		cancel_delayed_work(&conn->le_conn_timeout);
+
+		if (hdev->le_pkts) {
+			if (!hci_conn_num(hdev, LE_LINK) ||
+			    hdev->le_cnt + conn->sent > hdev->le_pkts)
+				hdev->le_cnt = hdev->le_pkts;
+			else
 				hdev->le_cnt += conn->sent;
+		} else {
+			if ((!hci_conn_num(hdev, LE_LINK) &&
+			     !hci_conn_num(hdev, ACL_LINK)) ||
+			    hdev->acl_cnt + conn->sent > hdev->acl_pkts)
+				hdev->acl_cnt = hdev->acl_pkts;
 			else
 				hdev->acl_cnt += conn->sent;
 		}
+		break;
+	case CIS_LINK:
+	case BIS_LINK:
+	case PA_LINK:
+		if (!hci_iso_count(hdev) ||
+		    hdev->iso_cnt + conn->sent > hdev->iso_pkts)
+			hdev->iso_cnt = hdev->iso_pkts;
+		else
+			hdev->iso_cnt += conn->sent;
+		break;
 	}
 
 	skb_queue_purge(&conn->data_q);
-- 
2.50.1



