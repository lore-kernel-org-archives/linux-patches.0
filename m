Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48B078B61;
	Tue, 27 Feb 2024 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043137; cv=none; b=rwcVJn7D0vVli3wKWcYONzrTObz5fK+IZOrvCJ/5pJBdIBLfoWg9V/Wfn+Jh/1tN+NvoUBoG5QMrFw40k+0qOOg5ypLWDSbjvGg43v3ujE/ihEpko5pD5xXIIlG9uhgJ/I8u/ModEBMkCXfZYv8CIVzApjMvZaegvDaw9jA3XpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043137; c=relaxed/simple;
	bh=z2/7Gj13yedvBLUL5VKnq+tLvRWcW9gdTZQ1nOOiQx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRVkfUOl4eD3Klur5jZLno8jnnt/UKOhTA/n5yw7tj680zoFuWHqOrBXTu1f4JBfvEnRteHAt5shc1hXxyJoeheQIdcgK0dkoWHnv+y6BFtah1f6FQ8zY0yxKCK36hCfE1XWAMR4rq5k7FKCJTBxLXNhdoCrIHTkYW+uYzQ11rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twOSoksK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twOSoksK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AABC433F1;
	Tue, 27 Feb 2024 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043137;
	bh=z2/7Gj13yedvBLUL5VKnq+tLvRWcW9gdTZQ1nOOiQx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twOSoksKtEkZohBu9y3/fJmafaQvB7X/AVvz2j8tRR8d7ht8ivVvdIupUZ61WNZCo
	 2SDktmQ2vy/3ir3Pg6YYnTGuAEPfxopAh77ZYEU800+B3fAZq994EGVYo2RPYp4fWw
	 rLUNgFsHgi8z97VY7LGQUiIH925uuYw6+ABPcggI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/245] bpf: Fix racing between bpf_timer_cancel_and_free and bpf_timer_cancel
Date: Tue, 27 Feb 2024 14:26:48 +0100
Message-ID: <20240227131622.348191075@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 0281b919e175bb9c3128bd3872ac2903e9436e3f ]

The following race is possible between bpf_timer_cancel_and_free
and bpf_timer_cancel. It will lead a UAF on the timer->timer.

bpf_timer_cancel();
	spin_lock();
	t = timer->time;
	spin_unlock();

					bpf_timer_cancel_and_free();
						spin_lock();
						t = timer->timer;
						timer->timer = NULL;
						spin_unlock();
						hrtimer_cancel(&t->timer);
						kfree(t);

	/* UAF on t */
	hrtimer_cancel(&t->timer);

In bpf_timer_cancel_and_free, this patch frees the timer->timer
after a rcu grace period. This requires a rcu_head addition
to the "struct bpf_hrtimer". Another kfree(t) happens in bpf_timer_init,
this does not need a kfree_rcu because it is still under the
spin_lock and timer->timer has not been visible by others yet.

In bpf_timer_cancel, rcu_read_lock() is added because this helper
can be used in a non rcu critical section context (e.g. from
a sleepable bpf prog). Other timer->timer usages in helpers.c
have been audited, bpf_timer_cancel() is the only place where
timer->timer is used outside of the spin_lock.

Another solution considered is to mark a t->flag in bpf_timer_cancel
and clear it after hrtimer_cancel() is done.  In bpf_timer_cancel_and_free,
it busy waits for the flag to be cleared before kfree(t). This patch
goes with a straight forward solution and frees timer->timer after
a rcu grace period.

Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/bpf/20240215211218.990808-1-martin.lau@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index c8827d1ff3c59..870127c895c49 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1048,6 +1048,7 @@ struct bpf_hrtimer {
 	struct bpf_prog *prog;
 	void __rcu *callback_fn;
 	void *value;
+	struct rcu_head rcu;
 };
 
 /* the actual struct hidden inside uapi struct bpf_timer */
@@ -1269,6 +1270,7 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 
 	if (in_nmi())
 		return -EOPNOTSUPP;
+	rcu_read_lock();
 	__bpf_spin_lock_irqsave(&timer->lock);
 	t = timer->timer;
 	if (!t) {
@@ -1290,6 +1292,7 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 	 * if it was running.
 	 */
 	ret = ret ?: hrtimer_cancel(&t->timer);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1344,7 +1347,7 @@ void bpf_timer_cancel_and_free(void *val)
 	 */
 	if (this_cpu_read(hrtimer_running) != t)
 		hrtimer_cancel(&t->timer);
-	kfree(t);
+	kfree_rcu(t, rcu);
 }
 
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
-- 
2.43.0



