Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1DE2AD00;
	Sun,  7 Jun 2026 10:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827324; cv=none; b=u0gJONNA0HMZ143o4PMoZPq7Uoo3NGcjopTzIA3iVbVMv+NfCKUwQvem3WeCqum8ZMelvQx0ST4b6IDHT2euAjuEukYed1EpKwe9ATgUNXGMjg7X5xG7QNFaaElPiUItTN2zXFOw4fxgAb+JULr3YV15DjCawCRmWOrFZ5ReEtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827324; c=relaxed/simple;
	bh=Xh5HvUd+3u4M2hjYp7Te5H/fkjeFz4ta0gvZFSKlei0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH6ZUIT36t3ZPo3CXJJEdrn+tN5+Fe2dA+twDi5xQLI+lHL8VBSEy0/sHsx1C8bMS5pyfVOzLEsasjL/o2p03H9P7FRyDvxZLSUSobqYGzgK9bSx22itDUjZhwF+gfAajOctcToGWzzHeYssPqOYZTz0XwEEHt5TneZNv18D88o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAtlyu+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAtlyu+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935B21F00893;
	Sun,  7 Jun 2026 10:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827323;
	bh=AY3s2pJ9x0s8gfGJNs1s6S92I8RRzCjKa9I0c3AGGyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAtlyu+lNhj2EMG55CFbBcfgyARUN1T6r8cMzJz/m29jVn8jRBYTN7Yxd/ZYsGHUx
	 41oLyDcCZAvzaqIs6uB9RzfEZonvzG6CSGiEM9esO9LMWBGuavjOJrH0fkkGEPHpU6
	 twRFWBk0yP4jG88vjrbU7Vpx0sxE6oTE/LnRWpQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 083/332] net/sched: act_mirred: Fix blockcast recursion bypass leading to stack overflow
Date: Sun,  7 Jun 2026 11:57:32 +0200
Message-ID: <20260607095731.193550895@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kito Xu (veritas501) <hxzene@gmail.com>

[ Upstream commit a005fa5d7502eefec7ee6e1c01adadc06de2f9ad ]

tcf_mirred_act() checks sched_mirred_nest against MIRRED_NEST_LIMIT (4)
to prevent deep recursion.  However, when the action uses blockcast
(tcfm_blockid != 0), the function returns at the tcf_blockcast() call
BEFORE reaching the counter increment.  As a result, the recursion
counter never advances and the limit check is entirely bypassed.

When two devices share a TC egress block with a mirred blockcast rule,
a packet egressing on device A is mirrored to device B via blockcast;
device B's egress TC re-enters tcf_mirred_act() via blockcast and
mirrors back to A, creating an unbounded recursion loop:

  tcf_mirred_act -> tcf_blockcast -> tcf_mirred_to_dev -> dev_queue_xmit
  -> sch_handle_egress -> tcf_classify -> tcf_mirred_act -> (repeat)

This recursion continues until the kernel stack overflows.

The bug is reachable from an unprivileged user via
unshare(CLONE_NEWUSER | CLONE_NEWNET): user namespaces grant
CAP_NET_ADMIN in the new network namespace, which is sufficient to
create dummy devices, attach clsact qdiscs with shared blocks, and
install mirred blockcast filters.

 BUG: TASK stack guard page was hit at ffffc90000b7fff8
 Oops: stack guard page: 0000 [#1] SMP KASAN NOPTI
 CPU: 2 UID: 1000 PID: 169 Comm: poc Not tainted 7.0.0-rc7-next-20260410
 RIP: 0010:xas_find+0x17/0x480
 Call Trace:
  xa_find+0x17b/0x1d0
  tcf_mirred_act+0x640/0x1060
  tcf_action_exec+0x400/0x530
  basic_classify+0x128/0x1d0
  tcf_classify+0xd83/0x1150
  tc_run+0x328/0x620
  __dev_queue_xmit+0x797/0x3100
  tcf_mirred_to_dev+0x7b1/0xf70
  tcf_mirred_act+0x68a/0x1060
  [repeating ~30+ times until stack overflow]
 Kernel panic - not syncing: Fatal exception in interrupt

Fix this by incrementing sched_mirred_nest before calling
tcf_blockcast() and decrementing it on return, mirroring the
non-blockcast path.  This ensures subsequent recursive entries see the
updated counter and are correctly limited by MIRRED_NEST_LIMIT.

Fixes: fe946a751d9b ("net/sched: act_mirred: add loop detection")
Signed-off-by: Kito Xu (veritas501) <hxzene@gmail.com>
Link: https://patch.msgid.link/20260525122556.973584-7-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index dd5e7ea7ef2652..dbe4a4ff3e08b8 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -396,14 +396,12 @@ static int tcf_blockcast_mirror(struct sk_buff *skb, struct tcf_mirred *m,
 
 static int tcf_blockcast(struct sk_buff *skb, struct tcf_mirred *m,
 			 const u32 blockid, struct tcf_result *res,
-			 int retval)
+			 int m_eaction, int retval)
 {
 	const u32 exception_ifindex = skb->dev->ifindex;
 	struct tcf_block *block;
 	bool is_redirect;
-	int m_eaction;
 
-	m_eaction = READ_ONCE(m->tcfm_eaction);
 	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
 
 	/* we are already under rcu protection, so can call block lookup
@@ -453,8 +451,16 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	tcf_action_update_bstats(&m->common, skb);
 
 	blockid = READ_ONCE(m->tcfm_blockid);
-	if (blockid)
-		return tcf_blockcast(skb, m, blockid, res, retval);
+	m_eaction = READ_ONCE(m->tcfm_eaction);
+	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+	if (blockid) {
+		if (!want_ingress)
+			xmit->sched_mirred_dev[xmit->sched_mirred_nest++] = NULL;
+		retval = tcf_blockcast(skb, m, blockid, res, m_eaction, retval);
+		if (!want_ingress)
+			xmit->sched_mirred_nest--;
+		return retval;
+	}
 
 	dev = rcu_dereference_bh(m->tcfm_dev);
 	if (unlikely(!dev)) {
@@ -463,8 +469,6 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		return retval;
 	}
 
-	m_eaction = READ_ONCE(m->tcfm_eaction);
-	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
 	if (!want_ingress) {
 		for (i = 0; i < xmit->sched_mirred_nest; i++) {
 			if (xmit->sched_mirred_dev[i] != dev)
-- 
2.53.0



