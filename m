Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06144D014;
	Tue, 16 Jun 2026 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622552; cv=none; b=qtdUVZ+Z3lajSByAiwYvRvBuAzYZP+N5/gbVqaVG8/lHOXaAHaFJuqr/OV5OUfip9jqybkSQaIscwc/stkBubRwF1vBXH1NwDF/rDkSJlXuGU3Rfw+u+nOzmClVASg0q8LDAgeEKp0JUKTARUWSv2JtiT4WEMKrmmXlrHyDsTbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622552; c=relaxed/simple;
	bh=YlM1jrTjR9PMWKx2wwnZag7MXyX+oiGX+OkdeZOYUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JR5iZb6cN4T8hR9AI56FaauygoK4hHw1pG4XKd+Yfmkk3UOFyru9ZyqxkenJ7+mRAmIQCbL8+wkKELVkmI66XRyAxAZ/GV6R85pLCo3Y0Fd6jF7C0xwlhx9hLiL05qj151ainosZWe251TnVME2Cuyo5eu3/x408OqSxA84xThg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8dFpkmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8dFpkmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6954D1F000E9;
	Tue, 16 Jun 2026 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622551;
	bh=ZLZh8/Y3nKwlRwpTE7164ftoOJbuoAU6Bl2cPbCI3t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8dFpkmJnaqNvAFyq6HtWohpD/TY7lTKXCIwyCWplPJahRk1ue7BqjBvG+4haTKq+
	 LPbRTixVKmg5reVfTNQUNepWw+mBb+CGZ6MSGJ102lIojfTBoDvbLNSMRb9p/2BwEo
	 tc0q+QfmmxlUuJtAIYTNW/lboQy/gRpMShhtchvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueria <victor@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/342] net/sched: sch_sfb: Replace direct dequeue call with peek and qdisc_dequeue_peeked
Date: Tue, 16 Jun 2026 20:25:01 +0530
Message-ID: <20260616145048.586961390@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Victor Nogueria <victor@mojatatu.com>

[ Upstream commit 1b9bc71153b01dbde8045b9edede4240f4f5520e ]

When sfb has children (eg qfq qdisc) whose peek() callback is
qdisc_peek_dequeued(), we could get a kernel panic. When the parent of such
qdiscs (eg illustrated in patch #3 as tbf) wants to retrieve an skb from
its child (sfb in this case), it will do the following:
 1a. do a peek() - and when sensing there's an skb the child can offer, then
     - the child in this case(sfb) calls its child's (qfq) peek.
        qfq does the right thing and will return the gso_skb queue packet.
        Note: if there wasnt a gso_skb entry then qfq will store it there.
 1b. invoke a dequeue() on the child (sfb). And herein lies the problem.
     - sfb will call the child's dequeue() which will essentially just
       try to grab something of qfq's queue.

[  127.594489][  T453] KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
[  127.594741][  T453] CPU: 2 UID: 0 PID: 453 Comm: ping Not tainted 7.1.0-rc1-00035-gac961974495b-dirty #793 PREEMPT(full)
[  127.595059][  T453] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  127.595254][  T453] RIP: 0010:qfq_dequeue+0x35c/0x1650 [sch_qfq]
[  127.595461][  T453] Code: 00 fc ff df 80 3c 02 00 0f 85 17 0e 00 00 4c 8d 73 48 48 89 9d b8 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 76 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
[  127.596081][  T453] RSP: 0018:ffff88810e5af440 EFLAGS: 00010216
[  127.596337][  T453] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: dffffc0000000000
[  127.596623][  T453] RDX: 0000000000000009 RSI: 0000001880000000 RDI: ffff888104fd82b0
[  127.596917][  T453] RBP: ffff888104fd8000 R08: ffff888104fd8280 R09: 1ffff110211893a3
[  127.597165][  T453] R10: 1ffff110211893a6 R11: 1ffff110211893a7 R12: 0000001880000000
[  127.597404][  T453] R13: ffff888104fd82b8 R14: 0000000000000048 R15: 0000000040000000
[  127.597644][  T453] FS:  00007fc380cbfc40(0000) GS:ffff88816f2a8000(0000) knlGS:0000000000000000
[  127.597956][  T453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  127.598160][  T453] CR2: 00005610aa9890a8 CR3: 000000010369e000 CR4: 0000000000750ef0
[  127.598390][  T453] PKRU: 55555554
[  127.598509][  T453] Call Trace:
[  127.598629][  T453]  <TASK>
[  127.598718][  T453]  ? mark_held_locks+0x40/0x70
[  127.598890][  T453]  ? srso_alias_return_thunk+0x5/0xfbef5
[  127.599053][  T453]  sfb_dequeue+0x88/0x4d0
[  127.599174][  T453]  ? ktime_get+0x137/0x230
[  127.599328][  T453]  ? srso_alias_return_thunk+0x5/0xfbef5
[  127.599480][  T453]  ? qdisc_peek_dequeued+0x7b/0x350 [sch_qfq]
[  127.599670][  T453]  ? srso_alias_return_thunk+0x5/0xfbef5
[  127.599831][  T453]  tbf_dequeue+0x6b1/0x1098 [sch_tbf]
[  127.599988][  T453]  __qdisc_run+0x169/0x1900

The right thing to do in #1b is to grab the skb off gso_skb queue.
This patchset fixes that issue by changing #1b to use qdisc_dequeue_peeked()
method instead.

Fixes: e13e02a3c68d ("net_sched: SFB flow scheduler")
Signed-off-by: Victor Nogueria <victor@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260430152957.194015-3-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1b04e760e47d6c..ce6c7e34e3c470 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -439,7 +439,7 @@ static struct sk_buff *sfb_dequeue(struct Qdisc *sch)
 	struct Qdisc *child = q->qdisc;
 	struct sk_buff *skb;
 
-	skb = child->dequeue(q->qdisc);
+	skb = qdisc_dequeue_peeked(child);
 
 	if (skb) {
 		qdisc_bstats_update(sch, skb);
-- 
2.53.0



