Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E20E36212F;
	Tue, 21 Jul 2026 22:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672956; cv=none; b=U7kssraadyRp9YxEXCpXb1UvKpojuGf7aRrtjlOetFKCwgymmB08FKithH8lPq1+/c1dfjr3rTqEjkCHQWBFZsx33dHvZYUszUMrkTZI+aWIigaQOXopQrMjUwPmD9t3xCS34BdpuhJOErGOeDWbj+n4enQCSSnhy8T5U64HYN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672956; c=relaxed/simple;
	bh=pPoC8YYXdAjV8JWZQZDFlX576mk98zdNUnaBVyBvVV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5YHHP7iv2eQt4xcc9dod10tjqP109A15yJEktOuMwmD37uyWLAFVJEpx3q99qVTknH7Hx5/HlEddY41FRpGh56oJV6O467inKKMDj0r00LcX0OnOnAYbVb/3by4bsWnjtW55Om8rhggfUvhtlx1VTBmHjiZNBiVEt5FueXYpqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COynMcQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COynMcQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8C31F000E9;
	Tue, 21 Jul 2026 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672954;
	bh=gi2G08J1NqQKlpxPCVSrCjnRVeFo33kaZ8hjCUqFr/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COynMcQ7qpohBdHvRM7jEOOMK/GoKFtSih+qNSvtmQm4fK/pJM2voogI33bPxuV/a
	 AkivAOh9/3+YuN13fs8SZSxZ26Qc8DVdi2CYV2oYwFMM9avvTmat+LPTP0fu9MBDzu
	 IY/xJYzRHK8aTcarSeHa2+TwYmE+qCpCv7fHaBsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 777/843] Bluetooth: L2CAP: Fix deadlock in l2cap_conn_del()
Date: Tue, 21 Jul 2026 17:26:52 +0200
Message-ID: <20260721152423.534218037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 00fdebbbc557a2fc21321ff2eaa22fd70c078608 ]

l2cap_conn_del() calls cancel_delayed_work_sync() for both info_timer
and id_addr_timer while holding conn->lock. However, the work functions
l2cap_info_timeout() and l2cap_conn_update_id_addr() both acquire
conn->lock, creating a potential AB-BA deadlock if the work is already
executing when l2cap_conn_del() takes the lock.

Move the work cancellations before acquiring conn->lock and use
disable_delayed_work_sync() to additionally prevent the works from
being rearmed after cancellation, consistent with the pattern used in
hci_conn_del().

Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2641a9e0a1dd ("Bluetooth: L2CAP: cancel pending_rx_work before taking conn->lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1896,6 +1896,9 @@ static void l2cap_conn_del(struct hci_co
 
 	BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
 
+	cancel_delayed_work_sync(&conn->info_timer);
+	cancel_work_sync(&conn->id_addr_update_work);
+
 	kfree_skb(conn->rx_skb);
 
 	skb_queue_purge(&conn->pending_rx);
@@ -1909,9 +1912,6 @@ static void l2cap_conn_del(struct hci_co
 
 	ida_destroy(&conn->tx_ida);
 
-	if (work_pending(&conn->id_addr_update_work))
-		cancel_work_sync(&conn->id_addr_update_work);
-
 	l2cap_unregister_all_users(conn);
 
 	/* Force the connection to be immediately dropped */
@@ -1936,9 +1936,6 @@ static void l2cap_conn_del(struct hci_co
 
 	hci_chan_del(conn->hchan);
 
-	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
-		cancel_delayed_work_sync(&conn->info_timer);
-
 	hcon->l2cap_data = NULL;
 	conn->hchan = NULL;
 	l2cap_conn_put(conn);


