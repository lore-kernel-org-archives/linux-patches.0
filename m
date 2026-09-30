Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33073264C2;
	Wed, 30 Sep 2026 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791781; cv=none; b=CqYzJFNa6RU+utURyGWwqaWLbYImLhbFV6B9qSXTnQGjC3pNiM1zrX8wlVVzcvspC/jQTOK8xcikWL8XtDFHWU8yE0b0C2uhtAnxTbPNMaNbRxG5UA1j7lVKATtTQIebxVKPaUjwVFz930BE6AV19Ge5rBadMjwtNw8w7I/5bl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791781; c=relaxed/simple;
	bh=0XB7orkhI2shBMO+RBZmXpnKKuuKnveT9BfFPf3jz3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRJScjRsH0ZLFnErJRlD40WpjUoM91WpkBQ3Y/zpoqQC4CucfVxrHzoyPDvL9ctrw5T7PCx6GOQY9k3hTRQT2V3CGxOkscD3l1nBeSdzlF6pjNsLPROIx40uHd6cgwnrm9qPSxB4wQPuTV6QL9yfDfsiON+WR0xjAd/EHvCtdr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXNd5XaQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXNd5XaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107411F000FF;
	Wed, 30 Sep 2026 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791780;
	bh=Vqd37QiCPVnXbLA/GrGTHobKET1MXW3KgP6Q8ILOxbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXNd5XaQpKx3tgU3TL3++ffzaPwfemUTtyD+4w9FBrxhMnyadw3feLSoJngM+Ehsj
	 CpxEdtjlGvldtc5krhAZp21pRNU8EFCpvzoBb4riL0wqsy+H7xRVZrgAtW3prfUzLT
	 MW7F3YElDfMsBsrGmyurdDmHhJ6MqzH2glG6Yy4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/752] Bluetooth: L2CAP: Fix deadlock
Date: Wed, 30 Sep 2026 17:24:54 +0200
Message-ID: <20260930152407.460687236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
[ Karl Mehltretter: backport only the l2cap_core.c changes. The HCI
  changes are from an unrelated patch accidentally squashed into this
  commit. The l2cap_sock.c change removes locking added by 89e856e124f9,
  which is absent from 5.15.y, so the quoted deadlock cannot occur. The
  core changes are needed because c531e63871c0 was backported without
  the matching lock. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ece7d37339c46..bb514810945ab 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8003,6 +8003,8 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
+	l2cap_chan_lock(chan);
+
 	if (chan->state != BT_BOUND && chan->state != BT_CONNECTED)
 		goto drop;
 
@@ -8020,6 +8022,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	}
 
 drop:
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 free_skb:
 	kfree_skb(skb);
-- 
2.53.0



