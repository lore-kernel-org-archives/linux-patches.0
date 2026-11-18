Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021927;
	b=NJPIKa43qOJDvoiKiTfzeqaJ7GJJ7kk22JWPCX6lg6PZPVjF87haG7N1uJxdRQfh0uCQ
	 l8A5ttd5HM3VZTLZVDpMUxZ4eeidwFjjxpEYCN2TWgA2QWQL5V4UCmOQ4Ttgzxj6LIfX7
	 PD8bufhMdcicsJZVaqtYYQG6ScPtIzvz+V4mkhMQ/OU4VWRcUzB8XuSGHWnCRJ0x7u00Z
	 i/Dg4DFEXpJRU6jqoAGCBVzUusKdIKiypWTk9IzMcF/A/b6npOy4/QVnf5/KBOxm6T6Ug
	 F8piDggDaTi+PcCIcSSSwi8b8BXcjZ1xBiQvLXrZCSTFIowB6tafYwONG/mZchyQxZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JA1bJ9scwIIgS87onS3ag0epklH4/j6lzOyVB34ZT5s=;
	b=TeMhp6ft/0TYR6BXUY6vIyEFdsfUWv1phbP+mWC0+iV1ZnFh9kDDBceq2Whpk6BJ4Ynw
	 CEegqUjNAuoSbMusEkZoVZ4XhvL6vGlc0dVfvHwZRwZ5j869Tx55TiGOqhGkCplOMLiVP
	 bxSdwCUwnks9ogAiNHHXYCK6HnyBZ0yLgx0BjsFLtb6MWvEWE+9INC08O0vYwqr5arBnX
	 HNVuIzIVJEktK/I6ltMyP9dTqLWYjgJb9QPI3QXEp5dzF70Z7ejwLjfGXYp/jodeFk5mN
	 V84c5lnsGFCuajmHpido0QLMFQx6ZeNMlNyiMmuY20kO7nw2J8Fm+oftuBdAh6/jFvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUxgto4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84F2606A320;
	Wed, 18 Nov 2026 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUxgto4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4111F000C4;
	Wed, 18 Nov 2026 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021927;
	bh=JA1bJ9scwIIgS87onS3ag0epklH4/j6lzOyVB34ZT5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUxgto4i0NXyXY9SvqWTnNgSWFifk3PD+NC+xk9lWmMJzY2Qkv8tXZ0TpYbikplhz
	 yoaQSJAYmi4MWTTAuWRaJmaVIlI2a321FPkzu8pPC/aFajKsasvLFMlNt/n5lRqyy0
	 iJ5jwjxoTvPkfWZTC5lacnGz4CjBtsMgX/Kz3lmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2480/2651] bpf: Fix bpf_timer callback running on a freed map
Date: Wed, 18 Nov 2026 16:02:00 +0100
Message-ID: <20261118150414.209989228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mani Tofigh <mt4022@columbia.edu>

[ Upstream commit 815a0a2a40d6c5985a153041231731651bc4024b ]

A bpf_timer in an inner map can fire after the map has been freed, and
bpf_timer_cb() then reads the freed map:

  [   50.709520] BUG: KASAN: slab-use-after-free in bpf_timer_cb+0x249/0x290
  [   50.709540] Read of size 4 at addr ff11000003bc1030 by task bpftimer/72
  ...
  [   50.710783] Freed by task 12:
  ...
  [   50.710826]  bpf_map_free+0x1a2/0x380

When user space closes the map, its timers are cancelled and their
callbacks are cleared.  Since commit 1bfbc267ec91 ("bpf: Enable
bpf_timer and bpf_wq in any context"), bpf_timer_set_callback() and
bpf_timer_start() run without a lock, so a program that found the timer
just before the close can still use it afterwards:

  Task A                  Task B                  Task C
  ------                  ------                  ------
  bpf_timer_start()
    finds the timer
                          bpf_timer_set_callback()
                            finds the timer
                                                  close(map_fd)
                                                    clears the callback
                                                    cancels the timer
                            sets the callback
    arms the timer
                                                  deletes the map from
                                                  the outer map
                                                    map is freed
  the timer fires
    bpf_timer_cb() reads the freed map

The timer is cancelled once more when it is finally freed, but that
happens well after the inner map is freed, so a timer started this way
can still fire on the freed map.

Clear the timer's map pointer in bpf_async_cancel_and_free() before the
map can be freed, and make the bpf_timer and bpf_wq callbacks return
early when it is NULL.  The map is not freed until callbacks that are
already running have finished, so a callback either sees the map while
it is still valid or sees NULL.

The reproducer below calls the two helpers in a loop on two CPUs while a
third CPU keeps creating an inner map with a timer, closing it and
removing it from the outer map.  This bug was identified and confirmed
with the help of a deterministic hypervisor currently under development,
but the non-deterministic C reproducer can typically trigger it in the
1-50s time range.  With the fix, nothing is triggered after 600 seconds.

Fixes: 1bfbc267ec91 ("bpf: Enable bpf_timer and bpf_wq in any context")
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Mahe Tardy <mahe.tardy@gmail.com>
Link: https://patch.msgid.link/20261027-bpf-timer-freed-map-v1-1-30402b0ee99b@columbia.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 44dce0730476d..7c2e6f0e74091 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1183,7 +1183,7 @@ static void bpf_async_refcount_put(struct bpf_async_cb *cb);
 static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 {
 	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
-	struct bpf_map *map = t->cb.map;
+	struct bpf_map *map = READ_ONCE(t->cb.map);
 	void *value = t->cb.value;
 	bpf_callback_t callback_fn;
 	void *key;
@@ -1191,7 +1191,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 
 	BTF_TYPE_EMIT(struct bpf_timer);
 	callback_fn = rcu_dereference_check(t->cb.callback_fn, rcu_read_lock_bh_held());
-	if (!callback_fn)
+	if (!callback_fn || !map)
 		goto out;
 
 	/* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't migrate and
@@ -1216,7 +1216,7 @@ static void bpf_wq_work(struct work_struct *work)
 {
 	struct bpf_work *w = container_of(work, struct bpf_work, work);
 	struct bpf_async_cb *cb = &w->cb;
-	struct bpf_map *map = cb->map;
+	struct bpf_map *map;
 	bpf_callback_t callback_fn;
 	void *value = cb->value;
 	void *key;
@@ -1227,8 +1227,9 @@ static void bpf_wq_work(struct work_struct *work)
 	/* keeps the program that callback_fn belongs to */
 	rcu_read_lock_trace();
 
+	map = READ_ONCE(cb->map);
 	callback_fn = READ_ONCE(cb->callback_fn);
-	if (!callback_fn)
+	if (!callback_fn || !map)
 		goto out;
 
 	key = map_key_from_value(map, value, &idx);
@@ -1694,6 +1695,8 @@ static void bpf_async_cancel_and_free(struct bpf_async_kern *async)
 	if (!cb)
 		return;
 
+	/* Callbacks that run after this see NULL and return. */
+	WRITE_ONCE(cb->map, NULL);
 	bpf_async_update_prog_callback(cb, NULL, NULL);
 	/*
 	 * No refcount_inc_not_zero(&cb->refcnt) here. Dropping the last
-- 
2.53.0



