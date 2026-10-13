Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987814F93CD;
	Tue, 13 Oct 2026 12:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894583; cv=none; b=RE3olUywR3sqQkolErY7WxlHPv71V8ZhJGWeUuTW6jkTxiIWzCidPk/oQ+fyQ9nccX/DUVaiOI0pE0w+kQkWBV3Y4DrhF94aUT7W3L1NeOgENBEZIqEncm1shFN1UPLOeK7wkw0Nl2skbQCCxSwBATPG3nHpH2ksmmkXwp7eC4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894583; c=relaxed/simple;
	bh=UywKhRX0pcA0JSOwnCa8YSbtLJgouhQzjzwTzKNAR7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOiEQmPhPNhXqZN8y9twmcuIqqqCrjsbt/dRU4nZunIB0WEeGkqERomlf60qKxrixErXuU5SuJ7wCDgMcZLmruVNyhVNl2aNezSaDO2AJ90nK2jFE9h4AqB0YouCP+Hh3fGNtA/Ftaf/X8apA1rv51NObjFwtl3+m9l8Y3xdgzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh+I0hKf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh+I0hKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10811F000FF;
	Tue, 13 Oct 2026 12:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894582;
	bh=h9a+Ce5uhRM6KRkLWzkmX4QVN3LL2L//1zzO4UQl6XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh+I0hKfr6xNzdloFkWBQKVUNoHBSVvjvUU/6tO8xCP0Z9tqusZoCjILteBHSRgSF
	 9V12Urg9gv8e+vjSMGE1OlNknOXwokY0hZbbSgnauUe2WXTZagstdcYWrFfxCmy8PJ
	 nJW+OoJ10GnR6uO5micn/CULfbj4bOd/n8QQ+m/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 608/621] net: fix backlog_unlock_irq_restore() vs CONFIG_PREEMPT_RT
Date: Tue, 13 Oct 2026 13:40:03 +0200
Message-ID: <20261013112935.227109897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 26f29b14916964043bc25b55ad1b9f5e9a12ca53 upstream.

CONFIG_PREEMPT_RT is special, make this clear in backlog_lock_irq_save()
and backlog_unlock_irq_restore().

The issue shows up with CONFIG_DEBUG_IRQFLAGS=y

raw_local_irq_restore() called with IRQs enabled
 WARNING: kernel/locking/irqflag-debug.c:10 at warn_bogus_irq_restore+0xc/0x20 kernel/locking/irqflag-debug.c:10, CPU#1: aoe_tx0/1321
Modules linked in:
CPU: 1 UID: 0 PID: 1321 Comm: aoe_tx0 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
 RIP: 0010:warn_bogus_irq_restore+0xc/0x20 kernel/locking/irqflag-debug.c:10
Call Trace:
 <TASK>
  backlog_unlock_irq_restore net/core/dev.c:253 [inline]
  enqueue_to_backlog+0x525/0xcf0 net/core/dev.c:5347
  netif_rx_internal+0x120/0x550 net/core/dev.c:5659
  __netif_rx+0xa9/0x110 net/core/dev.c:5679
  loopback_xmit+0x43a/0x660 drivers/net/loopback.c:90
  __netdev_start_xmit include/linux/netdevice.h:5275 [inline]
  netdev_start_xmit include/linux/netdevice.h:5284 [inline]
  xmit_one net/core/dev.c:3864 [inline]
  dev_hard_start_xmit+0x2df/0x830 net/core/dev.c:3880
  __dev_queue_xmit+0x16f4/0x3990 net/core/dev.c:4829
  dev_queue_xmit include/linux/netdevice.h:3384 [inline]

Fixes: 27a01c1969a5 ("net: fully inline backlog_unlock_irq_restore()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260213120427.2914544-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -231,10 +231,13 @@ static bool use_backlog_threads(void)
 static inline void backlog_lock_irq_save(struct softnet_data *sd,
 					 unsigned long *flags)
 {
-	if (IS_ENABLED(CONFIG_RPS) || use_backlog_threads())
+	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 		spin_lock_irqsave(&sd->input_pkt_queue.lock, *flags);
-	else
+	} else {
 		local_irq_save(*flags);
+		if (IS_ENABLED(CONFIG_RPS) || use_backlog_threads())
+			spin_lock(&sd->input_pkt_queue.lock);
+	}
 }
 
 static inline void backlog_lock_irq_disable(struct softnet_data *sd)
@@ -248,9 +251,13 @@ static inline void backlog_lock_irq_disa
 static inline void backlog_unlock_irq_restore(struct softnet_data *sd,
 					      unsigned long flags)
 {
-	if (IS_ENABLED(CONFIG_RPS) || use_backlog_threads())
-		spin_unlock(&sd->input_pkt_queue.lock);
-	local_irq_restore(flags);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		spin_unlock_irqrestore(&sd->input_pkt_queue.lock, flags);
+	} else {
+		if (IS_ENABLED(CONFIG_RPS) || use_backlog_threads())
+			spin_unlock(&sd->input_pkt_queue.lock);
+		local_irq_restore(flags);
+	}
 }
 
 static inline void backlog_unlock_irq_enable(struct softnet_data *sd)


