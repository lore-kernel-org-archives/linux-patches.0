Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A06F13B2BA;
	Tue, 27 Feb 2024 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041336; cv=none; b=gdygDy5QQcxype/FOtfixTM0lUtoSUVNuvzMS+J810cN4kJ3RII1OzBte+GpmWt0sisWGapSk+2wCRbkf7fcl68GASor30JtKxhNZow3juSkdmthkKwQI2syU18oQlWBJNAHL+767nMWNG2n4htCd0ScPQxX8EY8i6DyxlV6hYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041336; c=relaxed/simple;
	bh=/Xoq692CG7KYWXnX84T36bzfYjqbA+gHGT/qziGtPdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orjtfm9o7OJTmbprpqqa9hgBTtzag0dwQYw0Y4Qz2OdjuelgVTydbWO5KQE3ZJ91iHBcvxUj2sygA5mTIBQcK8Afg0I/HozetdfEsDujoK6h/e9Lp3nrMqB6Z5SejE1rmtoO450XOmU9DnbGTbceh50EmlrOV7eIKAwX7K8HIuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i29fhQHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i29fhQHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CF6C433C7;
	Tue, 27 Feb 2024 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041336;
	bh=/Xoq692CG7KYWXnX84T36bzfYjqbA+gHGT/qziGtPdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i29fhQHpVRZQus4sSsyaSInBaAUEUBCossP27/4MaPhibRVefA2+ZwXRksKcYBAm+
	 shD65iYXj4kaB6nWI3pW/PE2WFDhGXGRmUH00Jd5JnF2CskGmzbRgNv9E7Sa8miqBe
	 EeWD1hTZFa8UClnNVZNfgolm98SWwyImIJ1C5OpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 276/334] bpf: Fix racing between bpf_timer_cancel_and_free and bpf_timer_cancel
Date: Tue, 27 Feb 2024 14:22:14 +0100
Message-ID: <20240227131639.901359058@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b3053af6427d2..ce4729ef1ad2d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1101,6 +1101,7 @@ struct bpf_hrtimer {
 	struct bpf_prog *prog;
 	void __rcu *callback_fn;
 	void *value;
+	struct rcu_head rcu;
 };
 
 /* the actual struct hidden inside uapi struct bpf_timer */
@@ -1332,6 +1333,7 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 
 	if (in_nmi())
 		return -EOPNOTSUPP;
+	rcu_read_lock();
 	__bpf_spin_lock_irqsave(&timer->lock);
 	t = timer->timer;
 	if (!t) {
@@ -1353,6 +1355,7 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 	 * if it was running.
 	 */
 	ret = ret ?: hrtimer_cancel(&t->timer);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1407,7 +1410,7 @@ void bpf_timer_cancel_and_free(void *val)
 	 */
 	if (this_cpu_read(hrtimer_running) != t)
 		hrtimer_cancel(&t->timer);
-	kfree(t);
+	kfree_rcu(t, rcu);
 }
 
 BPF_CALL_2(bpf_kptr_xchg, void *, map_value, void *, ptr)
-- 
2.43.0



