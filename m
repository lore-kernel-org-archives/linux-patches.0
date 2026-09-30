Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587EE46EF77;
	Wed, 30 Sep 2026 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783258; cv=none; b=rasKLFV39eJwr9pvn0I/Tmse81mC8BWu8sLDe2BRdE8BO3fO/eG4hdbiYsBzrL47IMrDui0zIBeFhjCqElswk2yPFhdDxYP8gy4oleh/awJUq39fQFM3CE2jk9o/wYkAiGRpykUnYKlFSphi30YlQMFeLxomxiuSYeT/Et57Nkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783258; c=relaxed/simple;
	bh=j4V/+7CtQndtb9sjiqn+T8QIXE4ErnlAPW6ba2nUP5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skSAp4q7P1QxJcUZFidux78gyeUrxDtSHxfMJF6N7/PyRnvAotQHNStJuFlyMRrPRvvIcNUeTBFIuErB/YZieXprKdrVhD4dwkMBe3MijjrROhLiEfLeAHBtdWfc3qUDwZ3OCqGXAaYu+5y/FJ/lpO0B2+Nsz3aEaU+Ylb6pp7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7ZRU+R3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7ZRU+R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E81F000FF;
	Wed, 30 Sep 2026 15:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783254;
	bh=zx16DvXGRmgTSXwrjtVpx6TurAiK4KRzGWBFaIZWdlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7ZRU+R3nChdwFiHjTN3iOLRlU+Di02RI8+9Z5aqppmpUztEcanfjCKNSUrYcIrr5
	 /LaGuRju2wqw8XpeZmOJ9fUo9t6r7EZ7EeKh/7GyPSAMoDhRheRaRAsWdrVka3U5gh
	 wJ9AqaNTCrRd577Ixcz9y5OQQxjNC9MZdTjcNBmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/595] Bluetooth: L2CAP: Fix deadlock
Date: Wed, 30 Sep 2026 17:23:46 +0200
Message-ID: <20260930152354.844673481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f1a8f402f13f94263cf349216c257b2985100927 ]

This fixes the following deadlock introduced by 39a92a55be13
("bluetooth/l2cap: sync sock recv cb and release")

============================================
WARNING: possible recursive locking detected
6.10.0-rc3-g4029dba6b6f1 #6823 Not tainted
--------------------------------------------
kworker/u5:0/35 is trying to acquire lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_sock_recv_cb+0x44/0x1e0

but task is already holding lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&chan->lock#2/1);
  lock(&chan->lock#2/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u5:0/35:
 #0: ffff888002b8a940 ((wq_completion)hci0#2){+.+.}-{0:0}, at:
process_one_work+0x750/0x930
 #1: ffff888002c67dd0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0},
at: process_one_work+0x44e/0x930
 #2: ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

To fix the original problem this introduces l2cap_chan_lock at
l2cap_conless_channel to ensure that l2cap_sock_recv_cb is called with
chan->lock held.

Fixes: 89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Karl Mehltretter: only the l2cap_core.c and l2cap_sock.c hunks apply
  to this tree. hci_sync.c and hci_sync.h do not exist here, and the
  hci_core.c change is an unrelated conversion of hci_dev_cmd() off
  the old hci_request API. The changes to both L2CAP files apply
  unmodified.

  The lock this adds to l2cap_conless_channel() is also the one that
  commit c531e63871c0 ("Bluetooth: l2cap: always unlock channel in
  l2cap_conless_channel()") was backported without, so it additionally
  pairs the l2cap_chan_unlock() that function currently calls on a
  mutex it never acquired. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c |  3 +++
 net/bluetooth/l2cap_sock.c | 13 +------------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e974d8038dec8..cb883bd13286a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8055,6 +8055,8 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
+	l2cap_chan_lock(chan);
+
 	if (chan->state != BT_BOUND && chan->state != BT_CONNECTED)
 		goto drop;
 
@@ -8072,6 +8074,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	}
 
 drop:
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 free_skb:
 	kfree_skb(skb);
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 9d834f2254626..018b5a0c87ce9 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1548,18 +1548,9 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 	struct l2cap_pinfo *pi;
 	int err;
 
-	/* To avoid race with sock_release, a chan lock needs to be added here
-	 * to synchronize the sock.
-	 */
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
 	sk = chan->data;
-
-	if (!sk) {
-		l2cap_chan_unlock(chan);
-		l2cap_chan_put(chan);
+	if (!sk)
 		return -ENXIO;
-	}
 
 	pi = l2cap_pi(sk);
 	lock_sock(sk);
@@ -1611,8 +1602,6 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 
 done:
 	release_sock(sk);
-	l2cap_chan_unlock(chan);
-	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



