Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334DE430CE3;
	Tue, 21 Jul 2026 23:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674816; cv=none; b=LV4rQG1QfV4HGFrM//pJUvZsbUZ4xiWOffXfTQk+2aCqR0qBsdPn7CUxQp0pqf5PL6wgdWQeIutw772WNc2YUbsmcplsdUyxa6s8kCaeWMmGVkLchvfaiI1zCQZKwEiLlFfwQHmg+GQuNiy29BSNiOwnUdBa/5VrFhGirxpaQLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674816; c=relaxed/simple;
	bh=nr8wMa7g4eoBhY4+GBFySnnz4D9RVuEQMo85fLqgBrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5rVuIzfajuC1ELKZraqJEpNqLeSTQfTA6vWeNf815ATI05ZkWq/26ugiWgtIXeW7+ijCWFSN+RztVF8UVRSFnSeN94pLEuqfZhWdFdwAILmYTypicnVyv/RGDLNMe8zj5KhSnLMDBqdPIEqNHO8AJhAxyzqLHj1HmuSNiSrFhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7neMOsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7neMOsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9302C1F00A3A;
	Tue, 21 Jul 2026 23:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674815;
	bh=dJhbfctXLoKkNiopAlT/CD7lu+Tk0fOCNhlE6jBKMps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7neMOsPRwIDeFWUOYHjWfgXVvQLqBcR23XQvNELb+lcH//gN4NP4wh+sWeiRYs8G
	 DmZzzNqUrJqKJpBKWacRoMoPxpmAxX8AGWwT/XuxWQSLnhlnr+5z6NpJrT3YCIHSHT
	 LbkZgkvwmYLIcN6QLPfZjgX/bb5KCNEVTYznZEyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 640/699] Bluetooth: L2CAP: Fix deadlock in l2cap_conn_del()
Date: Tue, 21 Jul 2026 17:26:39 +0200
Message-ID: <20260721152410.188933811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1898,6 +1898,9 @@ static void l2cap_conn_del(struct hci_co
 
 	BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
 
+	cancel_delayed_work_sync(&conn->info_timer);
+	cancel_work_sync(&conn->id_addr_update_work);
+
 	kfree_skb(conn->rx_skb);
 
 	skb_queue_purge(&conn->pending_rx);
@@ -1911,9 +1914,6 @@ static void l2cap_conn_del(struct hci_co
 
 	ida_destroy(&conn->tx_ida);
 
-	if (work_pending(&conn->id_addr_update_work))
-		cancel_work_sync(&conn->id_addr_update_work);
-
 	l2cap_unregister_all_users(conn);
 
 	/* Force the connection to be immediately dropped */
@@ -1938,9 +1938,6 @@ static void l2cap_conn_del(struct hci_co
 
 	hci_chan_del(conn->hchan);
 
-	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
-		cancel_delayed_work_sync(&conn->info_timer);
-
 	hcon->l2cap_data = NULL;
 	conn->hchan = NULL;
 	l2cap_conn_put(conn);


