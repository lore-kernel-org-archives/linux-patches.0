Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774164;
	b=MkDGfTFZmRdosGPsX9Hyx6LCvQeEnpp9FOh7ICBza5eydPXrn1OGoNCf2rW3G5l6wV66
	 4Kr3LlImmWUI97syrd4cNZErernGe3hOyJunPvX645a+1QuNo8EZAgqgTt4wIbg7zJDZG
	 4ZU/+rLMx6e1Dr/iqyKf2RA4Hbrm9MO9eyjPoosA26fBnhO466PCH4RklgW61lmY8WyvX
	 62qE4RnFA0TeRcSyZE/eUuZIMAsgGzMBB72O+Yw6bn7RoN9/z4bslTq35Ub+tpPOacREs
	 2cIJwDigq4SMRmeDshsLq8OukjK8x1pSqFIh+Rwz+HVRKd8OoLwLfyV1wfEjjGIQZwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G78xlgO29ZLOUg8WCMelaBwIEPTA4EDNMNq1YJYrEbM=;
	b=Xv9HZSugxD9gf5bmYr21uUq/QvCqKDjTWa9dHlk91arfPozYs8sFYuQZDTUQNHK48yFx
	 J274rrEY4WXo3PVibcv1F5lmlvMk8day8kcKqPWTjaVVYBbqN3MmyRdLXmc8skZ6Jp1Fj
	 RTZUr/T5nPR9JRlAuY9kdBrgI6YViKh7BoaXCVd2cQceEcmKTvovUV/Nzy7+9+w7LjVpg
	 Bk7jXMMhvCkBnBaRhXxz0pQMy3A1UsfjfZ8lBe+2n9Gv6aiIEC9d66SIASW4UguSJizXB
	 BNyqcHpex4MrYJB9XihhG5713HlgsQ/HMYHs6X9+m9WikRCtfo8TlW6F92g75h3DDFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoUF58Xh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05214606A31B;
	Fri, 23 Oct 2026 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoUF58Xh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B051F01825;
	Fri, 23 Oct 2026 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774163;
	bh=G78xlgO29ZLOUg8WCMelaBwIEPTA4EDNMNq1YJYrEbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoUF58XhCNT0iHncKlL/fiM4nTv6HTwGgXAl2NQZF4yRj1erxpt+m2WHyer785b9e
	 zXtnY2Pbg/t4+d1WWjRffJwduuditFVEgh2c9Ewiec3oSqVc+kV+rT4eOqGj3vvlGB
	 QXMttCd2NxU5bLjNw+cFC8ZnEI4bMl/EmS7K4Clo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	syzbot+1bd20115328f8254ed62@syzkaller.appspotmail.com
Subject: [PATCH 6.18 135/193] workqueue: Annotate cb_lock nesting when draining a dead BH pool
Date: Fri, 23 Oct 2026 18:36:52 +0200
Message-ID: <20261023163717.403806873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit 6eca8f94d84106d3754b9df27f46a14572af9e7f upstream.

On PREEMPT_RT, bh_worker() wraps work item execution in pool->cb_lock to
provide a handshake for canceling BH work items. When a CPU goes down,
drain_dead_softirq_workfn() runs the dead pool's bh_worker() nested inside
the local pool's bh_worker(), acquiring the cb_locks of two different pools
without a nesting annotation. lockdep reports possible recursive locking:

  ============================================
  WARNING: possible recursive locking detected
  --------------------------------------------
  ktimers/0/16 is trying to acquire lock:
  ffff8880b873a990 (&pool->cb_lock){+...}-{3:3}, at: bh_worker+0x7d/0x880

  but task is already holding lock:
  ffff8880b863a990 (&pool->cb_lock){+...}-{3:3}, at: bh_worker+0x7d/0x880

  Call Trace:
   bh_worker+0x7d/0x880 kernel/workqueue.c:3688
   drain_dead_softirq_workfn+0x95/0x220 kernel/workqueue.c:3763
   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
   bh_worker+0x46a/0x880 kernel/workqueue.c:3708
   tasklet_action+0xc/0x70 kernel/softirq.c:965

The nesting can't deadlock. A pool's bh_worker() runs nested only while the
pool's CPU is dead, entered from a live pool's bh_worker() on the draining
CPU, so the ordering is always live to dead. CPU hotplug operations are
serialized and the drain is synchronous, so the nesting depth never exceeds
two. Annotate the inner acquisition with SINGLE_DEPTH_NESTING.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: syzbot+1bd20115328f8254ed62@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1bd20115328f8254ed62
Fixes: ad7c7f4b9c6c ("workqueue: Provide a handshake for canceling BH workers")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3115,7 +3115,16 @@ restart:
 #ifdef CONFIG_PREEMPT_RT
 static void worker_lock_callback(struct worker_pool *pool)
 {
-	spin_lock(&pool->cb_lock);
+	/*
+	 * SINGLE_DEPTH_NESTING is for a dead pool's bh_worker() running from
+	 * drain_dead_softirq_workfn() inside a live pool's bh_worker(). The
+	 * unlocked read is stable: the flag is only set while @pool's CPU is
+	 * dead, inside a serialized hotplug operation. data_race() as the value
+	 * only affects the lockdep annotation and the read can be elided when
+	 * lockdep is disabled.
+	 */
+	spin_lock_nested(&pool->cb_lock,
+			 data_race(pool->flags) & POOL_BH_DRAINING ? SINGLE_DEPTH_NESTING : 0);
 }
 
 static void worker_unlock_callback(struct worker_pool *pool)


