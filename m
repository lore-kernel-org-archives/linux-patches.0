Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590078;
	b=289NKpIAvCQLErfASxbh8ebDmmHc/0LwgHDHlo5yFI/p+9dTaLpTxTiLUFcuJA1tuETH
	 a73sQCqe5cL1ypOW1JcVTUAt/oMC1bG0u3PazA/Ctvy6OZCHagfBoTWV00l8VQiAk5KCf
	 DUeohkYd8ytS8QHBE6CxqkGRE677bvh+vgbXdndlgF3AcSCKApY/xwR/Kc7Vgi2D3Cmao
	 H6jLvQXp9zOAfNhZdkIvEb0oIU2nlGKDM9koSF2FFnIuFlj1WWj7A8kmKOGLIljgIMUK5
	 q3INgtzAON8y6iyM0dpuwzRUTXlyrNHQei0DD5dcMUAbfuhX+c9vyl5Vu/3CiqychzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SgViqZP7hTGmctKy5R73E+Kk0rIqcVb5UmVA4L+JKY0=;
	b=F0liYTxisU8aWXT5PEaX8ASyVc/XQdGypx0frF4mrzsoiT9CMcpoAyNwHDpkKNruyK8h
	 pzYm+wi2ar5xsuPq5fX6vbmI/oWtrs9c21NUvxhMpG+aQGArJQFhmgwthHynNE8V/81rR
	 CVUqaPEv2l1JUr2nB9ewufQDrNGrUf42doFmfgozdAUOtkWhI6NlX0Q8ftk/RsVebJWd0
	 rvq7I+yCseDnIRyzKaxVodcc88Zzp7us63USL9MJ7TFatdWRxVyN5iEbzsDt8La5Cvvln
	 +Y2RA4QdKd7bc6JfJhqmPsdn4hOKPGMxJ0xHxHtF+Uvna879xTUg1jMLlCMW7Z3ZsXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKmndh6A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC46606C09E;
	Fri, 13 Nov 2026 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKmndh6A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11EA1F000C9;
	Fri, 13 Nov 2026 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590078;
	bh=SgViqZP7hTGmctKy5R73E+Kk0rIqcVb5UmVA4L+JKY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKmndh6A9LwW7DAfNkyfvS5rBNASXSTKmncRg1PDkaPvUGztvtKRmWXVUlt66pRUF
	 KuDp+Y5VZI0981c/L3KTtEFFSBdA9i/SRHANDDwAjN62Tg61cdOx1IJqaQMFuHMruw
	 i5Wo0MlnrmVdCzDUERbtwnoyXvcUgdNuUk/Z5OFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/686] rose: arm the neighbour timers with mod_timer()
Date: Fri, 13 Nov 2026 10:44:01 -0500
Message-ID: <20261113153824.513150491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_start_t0timer() and rose_start_ftimer() restart a neighbour timer
in two steps: timer_delete(), then a rewrite of .function and .expires
followed by add_timer().  Nothing serialises these calls.  Two sockets
using the same neighbour can reach rose_transmit_link() at the same
time on two CPUs, for instance rose_connect() in process context and
rose_route_frame() in softirq context, or a connect racing the
self-rearm at the end of rose_t0timer_expiry().  Both see the timer
idle, both call timer_delete(), and the second add_timer() finds the
timer already pending:

  WARNING: CPU: 1 PID: 11465 at kernel/time/timer.c:1294 add_timer+0x60/0x90
   rose_write_internal+0x3ab/0x15b0 [rose]
   rose_connect+0x60f/0x1320 [rose]

With panic_on_warn this takes the machine down.

Set the expiry functions once, when the neighbour is created, and
start the timers with a single mod_timer() call, which updates a
pending timer or arms an idle one atomically.

This also stops rewriting .function on every start, so a start
that would come after timer_shutdown_sync() in rose_neigh_put() is
ignored, as that function's comment expects, instead of bringing the
timer back.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 41748d2730f1eb6b85fb957581d7ffb6dfe39859)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  1 +
 net/rose/rose_link.c  | 24 ++++++++++--------------
 net/rose/rose_route.c |  6 ++----
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 2fa0331e36f09..83d6b611eb735 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -231,6 +231,7 @@ int rose_rcv_frame(struct sock *sk, struct sk_buff *skb);
 int rose_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 
 /* rose_link.c */
+void rose_neigh_init_timers(struct rose_neigh *neigh);
 void rose_start_ftimer(struct rose_neigh *);
 void rose_stop_ftimer(struct rose_neigh *);
 void rose_stop_t0timer(struct rose_neigh *);
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 1fe48d58726f5..49a45936eb2bd 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -30,26 +30,22 @@ static void rose_t0timer_expiry(struct timer_list *);
 static void rose_transmit_restart_confirmation(struct rose_neigh *neigh);
 static void rose_transmit_restart_request(struct rose_neigh *neigh);
 
-void rose_start_ftimer(struct rose_neigh *neigh)
+void rose_neigh_init_timers(struct rose_neigh *neigh)
 {
-	timer_delete(&neigh->ftimer);
-
-	neigh->ftimer.function = rose_ftimer_expiry;
-	neigh->ftimer.expires  =
-		jiffies + msecs_to_jiffies(sysctl_rose_link_fail_timeout);
+	timer_setup(&neigh->ftimer, rose_ftimer_expiry, 0);
+	timer_setup(&neigh->t0timer, rose_t0timer_expiry, 0);
+}
 
-	add_timer(&neigh->ftimer);
+void rose_start_ftimer(struct rose_neigh *neigh)
+{
+	mod_timer(&neigh->ftimer,
+		  jiffies + msecs_to_jiffies(sysctl_rose_link_fail_timeout));
 }
 
 static void rose_start_t0timer(struct rose_neigh *neigh)
 {
-	timer_delete(&neigh->t0timer);
-
-	neigh->t0timer.function = rose_t0timer_expiry;
-	neigh->t0timer.expires  =
-		jiffies + msecs_to_jiffies(sysctl_rose_restart_request_timeout);
-
-	add_timer(&neigh->t0timer);
+	mod_timer(&neigh->t0timer,
+		  jiffies + msecs_to_jiffies(sysctl_rose_restart_request_timeout));
 }
 
 void rose_stop_ftimer(struct rose_neigh *neigh)
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 6a1de0055e28b..3499f034b83c6 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -102,8 +102,7 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 
 		skb_queue_head_init(&rose_neigh->queue);
 
-		timer_setup(&rose_neigh->ftimer, NULL, 0);
-		timer_setup(&rose_neigh->t0timer, NULL, 0);
+		rose_neigh_init_timers(rose_neigh);
 
 		if (rose_route->ndigis != 0) {
 			rose_neigh->digipeat =
@@ -446,8 +445,7 @@ void rose_add_loopback_neigh(void)
 
 	skb_queue_head_init(&sn->queue);
 
-	timer_setup(&sn->ftimer, NULL, 0);
-	timer_setup(&sn->t0timer, NULL, 0);
+	rose_neigh_init_timers(sn);
 
 	spin_lock_bh(&rose_neigh_list_lock);
 	sn->next = rose_neigh_list;
-- 
2.53.0



