Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3064582DB;
	Tue, 21 Jul 2026 21:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667793; cv=none; b=gcGNdqqNrM9NtjkECdt9VHxIApauiHcrDUlCGA/NLWzTp6XFROvx0w4VTvg0EU/NweTN+MF6p1qyWn4Zvpf/QYsNgBPgPQvS2+u1A79czpHREpW4OWd1A6Ipcrgtvl7MHN94vTGBt/VkRmzK4shtSmxHnpnPCCIB7X/E27Mqxn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667793; c=relaxed/simple;
	bh=jOesk/5Y5ZO41W+3/eSTrFZ/USlttyZEWrY4XQIDBss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz+1hnWNsdbl2sMXtRZG1w1eEuirmGw2T/xBqLM7cC2Pa3hgKeZpyNq+/1d/UoTi7YmyqerYOqPQg4qnW9SgHPo5z8u5OITBZnMV4mY886LcNu+kPUopPLjBC1Xs3qYKRYS4o5AOo/lUTYEtECgZ3gTA0j3ImhxtTo4R9WaNKqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cblu90t2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cblu90t2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB6B1F000E9;
	Tue, 21 Jul 2026 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667790;
	bh=zpG4uyyUBuRHaT92X1ie9u5hcj7Tw3c5l7K3tzJR6tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cblu90t2gWbrEHpgQM/vD9C8c5KKXulhUKGeGOqSCmbe6pT6K/dj7vSaKTywmP9cb
	 BBJ2ab3md4Q2MLdEPG6Jl86Tgcs0kiG3+1HL5YPOf9CKAzxqIuIa1gP2UKWQpUtvTp
	 ZcxoQgkdoqjD0QumucR3P82PeR6eEBUhoz/p3lPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1192/1266] Bluetooth: L2CAP: cancel pending_rx_work before taking conn->lock
Date: Tue, 21 Jul 2026 17:27:09 +0200
Message-ID: <20260721152508.469503849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 2641a9e0a1dd4af2e21995470a21d55dd35e5203 ]

l2cap_conn_del() takes conn->lock and then calls cancel_work_sync() for
pending_rx_work.  process_pending_rx() takes the same mutex, so teardown
can deadlock against the worker it is flushing.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the l2cap_conn_ready() -> queue_work(...,
&conn->pending_rx_work) submit path, the l2cap_conn_del() ->
cancel_work_sync(&conn->pending_rx_work) teardown path, and the
process_pending_rx() -> mutex_lock(&conn->lock) worker edge.  Lockdep
reported:

  WARNING: possible circular locking dependency detected
  process_pending_rx+0x21/0x2a [vuln_msv]
  l2cap_conn_del.constprop.0+0x3f/0x4e [vuln_msv]
  *** DEADLOCK ***

Cancel pending_rx_work before taking conn->lock, matching the existing
lock-before-drain ordering used for the two delayed works in the same
teardown path.  The pending_rx queue is still purged after the work has
been cancelled and conn->lock has been acquired.

Fixes: 7ab56c3a6ecc ("Bluetooth: Fix deadlock in l2cap_conn_del()")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ adjusted context for 6.6 lacking the disable_delayed_work_sync() conversion and the ida_destroy(&conn->tx_ida) line from the tx_ident IDA dependency ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1760,19 +1760,13 @@ static void l2cap_conn_del(struct hci_co
 
 	BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
 
+	cancel_work_sync(&conn->pending_rx_work);
+
 	mutex_lock(&conn->lock);
 
 	kfree_skb(conn->rx_skb);
 
 	skb_queue_purge(&conn->pending_rx);
-
-	/* We can not call flush_work(&conn->pending_rx_work) here since we
-	 * might block if we are running on a worker from the same workqueue
-	 * pending_rx_work is waiting on.
-	 */
-	if (work_pending(&conn->pending_rx_work))
-		cancel_work_sync(&conn->pending_rx_work);
-
 	cancel_delayed_work_sync(&conn->id_addr_timer);
 
 	l2cap_unregister_all_users(conn);


