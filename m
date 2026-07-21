Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5444AB62;
	Tue, 21 Jul 2026 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670588; cv=none; b=SXQZuWGPttwx8aMe0NOPPq94hP2BemWHFxCcg/2+qxygp9MId5ogAm3FNKIdN1QBPvM4JC2VEEIyLMColvW9qx45isQfYcLhJhHmO54OkTi4uZJJPvB0DT4EroEenw+M/CSMPuPvXuTLq8ijj03DfvAl7J0I1ZGG/T3ulVT31ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670588; c=relaxed/simple;
	bh=TBAEAUtyma/ssTBSAc9dzaNtPQaH+4ICgKPbMWMIT2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojZomrJNKfXUg1o4q2YSN9RVwqPpKFoLTYxWlaqKvTgWnubpCOH7VjDSgoM+j8Auktm8ojSNq1WAQcNldG3ECiBOk2Ua6G5xh9wgNz7R+GBOpUPpolVsIPoz1Niv98/mMxMUgOZOe664GUxK702fdB52jGSUjLVx4NCW0xoKq5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMAzHSDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMAzHSDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968501F000E9;
	Tue, 21 Jul 2026 21:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670587;
	bh=wAf5Nzw0c7x2nkC9vWdR08smEcuvSbbmnZYHYwFvNL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMAzHSDdz9DPYFVPKeZ23u5JB3PDBpO8RvdjU3vHa33zPhl7hFazpZHh4u/p+yK/k
	 daFtcjwKXjPqslrXwYV7quE0Du5n7ITlk+mpYVi7sRin2GqKhwKs/Rf6aLFPRpn10c
	 cjh84AkZWAB/TnaVAue38mh1n0soFnVUncF1nFA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0990/1067] Bluetooth: L2CAP: Fix deadlock in l2cap_conn_del()
Date: Tue, 21 Jul 2026 17:26:31 +0200
Message-ID: <20260721152446.705849713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1782,6 +1782,9 @@ static void l2cap_conn_del(struct hci_co
 
 	BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
 
+	cancel_delayed_work_sync(&conn->info_timer);
+	cancel_work_sync(&conn->id_addr_update_work);
+
 	kfree_skb(conn->rx_skb);
 
 	skb_queue_purge(&conn->pending_rx);
@@ -1795,9 +1798,6 @@ static void l2cap_conn_del(struct hci_co
 
 	ida_destroy(&conn->tx_ida);
 
-	if (work_pending(&conn->id_addr_update_work))
-		cancel_work_sync(&conn->id_addr_update_work);
-
 	l2cap_unregister_all_users(conn);
 
 	/* Force the connection to be immediately dropped */
@@ -1822,9 +1822,6 @@ static void l2cap_conn_del(struct hci_co
 
 	hci_chan_del(conn->hchan);
 
-	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
-		cancel_delayed_work_sync(&conn->info_timer);
-
 	hcon->l2cap_data = NULL;
 	conn->hchan = NULL;
 	l2cap_conn_put(conn);


