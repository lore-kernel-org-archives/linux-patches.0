Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D7337E5CB;
	Thu, 16 Jul 2026 13:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209649; cv=none; b=Akr3aLnu20zE26WfnkH1r3WAH/0rER4YG07FxChzQzIHOxri70q+ClDZuBSgRxZWDKp3WX3oF1ejuLK4VDeJiJwY9mfwyUyLaOuJtM2oBWbGugaP14MbRiVNLpG1WjVgUD9MjIkbIMBQ2ZMANLG9aBdTaPSi8q86OPAHQYFTAds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209649; c=relaxed/simple;
	bh=pf2uPuv8dPPolCnmdTgzID4CDstckEkhFf2tjf+ZwmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6oS5zniBaNkbsB3Pa0L/iqKykCK2zLpWcwKSxMG21gT5hAKk0gin/VPgysRlrpn77diYIkCsGypHCu5IcZToGIG6/QkKq/ATgbh7kNH87RX5xpBEBrkJedCHAkwrXG19YyIT7T8dhzerO2MPul8HjA1DKO9LpF4Dx1qYqpU5rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPnefy4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPnefy4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C1D1F00AC4;
	Thu, 16 Jul 2026 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209644;
	bh=CFjDCVx8Plmuh8cFCMbs6QG6/VHfv87WAoq+f2mMu/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPnefy4IAG9/jQQu0muafsR2apWAiEgEVdvsyGUpyS6nbesY9BhRBjsyp8lqXZETx
	 sOWLfQih2N/3mRipX4+Uq6kKXGIGCVE/WE4pwfF681EP868Pd5rxIIubuvWbUfY/bg
	 grrCzK+orZjMrY5VzLNSvDWaZAKdhPJ7pNGtJOr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 211/518] Bluetooth: L2CAP: cancel pending_rx_work before taking conn->lock
Date: Thu, 16 Jul 2026 15:27:59 +0200
Message-ID: <20260716133052.434118516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 2641a9e0a1dd4af2e21995470a21d55dd35e5203 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1778,19 +1778,13 @@ static void l2cap_conn_del(struct hci_co
 	disable_delayed_work_sync(&conn->info_timer);
 	disable_delayed_work_sync(&conn->id_addr_timer);
 
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
 	ida_destroy(&conn->tx_ida);
 
 	l2cap_unregister_all_users(conn);


