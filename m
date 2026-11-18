Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027798;
	b=CGVhLmbhxfboGAIqr+eGWQXkHu1K1sCe0HQR+3nTGhDjSUsWWuvRVeLb+1SGZ3VWow5D
	 F7reKozXyQ2ecPJP56j03RZKH0A7S0oc1X23jGpR8TWJVSzfUCCJOeFnxWyVnXvINXPAN
	 GuMfSjrtnvJkhHAZPRbpesUBVl7JffLDIGiVj1q/CMpwrXUNEKMISAXvzI97E99zb/s0p
	 fOuH8vnguzrKa/ssYRR+sezVcmdgXgbq1Cng3RAJDHKWSU1kd4cHhXzc4LxyYET8LNGbp
	 NhRG2A7G1DFcrTLJjsMFT4ydtMk2FlEQ2DQCqT71U1BDqO7NDxpZrrThtv+xLIRW0Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uk+6FOgi7yuE/b51a3xLvcmD/Lfdl0RLnT8h0JzjlbU=;
	b=rDIgrhY4PA8rjHgDknMUoVgF9AV8zhz4AQBoAKuYTYVkmG9Lboe52CwxAmJoALXIaHk6
	 LqxpzyWV2l3YfvQbwAiclBfjH+Si9/bknMVd0jNXN7UcEukG2sokkTHYL4o6KOz8LJioQ
	 9P2B2ulWt8FQfVbCODfU5x+uddOydfPIRe3ANhlaDFHJsk2yVXODkH4MOzqc4IjnFwZ9u
	 XgAhrjxwXdsQUrqW9x78marpfRNiRt1P7gLJPWA2kzG95Pow6RJGdBnyCdXIvXJ6vTaSq
	 diD30uSj3kbqmPPJhIqkI57BEnnMPxoh+iStcgdzM5noAGG42mQdgg7ea+RoGZ9qhpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGaJknAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC6E606A31C;
	Wed, 18 Nov 2026 18:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGaJknAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7B71F000C6;
	Wed, 18 Nov 2026 18:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027797;
	bh=uk+6FOgi7yuE/b51a3xLvcmD/Lfdl0RLnT8h0JzjlbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGaJknAuuj1vWpL9eTFGDt6HQfvXaIYyJgO7w23X+hbvzo+SKAAbAQKMg5Qc09dpN
	 IXRD0AGKTHAqa79mM6HdxZ7JCBOlsefHhZ52XI6E0fJPCdlO2S5cNFflfqpQ5RIEJd
	 64BkcuB81lXtg8a8dBq0YkNAohleneva0G1JyyRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <mkofdwu@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1910/2151] perf: Fix UAF in attach_task_ctx_data()
Date: Wed, 18 Nov 2026 16:00:45 +0100
Message-ID: <20261118150231.366232815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Lee Jia Jie <mkofdwu@gmail.com>

[ Upstream commit 64ea0e8226ed98d14e0231af1beae10c3d5c043a ]

struct perf_ctx_data is RCU protected. In attach_task_ctx_data(),
the cmpxchg retry loop runs without holding rcu_read_lock(). If
task->perf_ctx_data already holds a pointer (call it `cd1`), then
try_cmpxchg(&task->perf_ctx_data, &old, cd) fails and loads old = cd1.
A concurrent thread running detach_task_ctx_data() could free cd1
leading to UAF and further memory corruption when cd1 is reclaimed by
another thread.

  CPU 0: attach_task_ctx_data()     CPU 1: detach_task_ctx_data()
  -----------------------------     -----------------------------
  try_cmpxchg(&task->perf_ctx_data,
              &old, cd2)
    -> fails; loads old = cd1

                                    refcount_dec_and_test(&cd1->refcount)
                                    try_cmpxchg(&task->perf_ctx_data,
                                                &cd1, NULL)
                                    perf_free_ctx_data_rcu(cd1)
                                    [ RCU grace period -> kfree(cd1) ]

  refcount_inc_not_zero(&old->refcount)
    -> UAF on freed cd1

Fix this by taking rcu_read_lock across the race window.

Fixes: 506e64e710ff ("perf: attach/detach PMU specific data")
Signed-off-by: Lee Jia Jie <mkofdwu@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ec2d21af68f63..f6045a7f83283 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5291,6 +5291,9 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
 		return -ENOMEM;
 
 	for (;;) {
+		/* Protect @old until inc_not_zero(&old->refcount) */
+		guard(rcu)();
+
 		if (try_cmpxchg(&task->perf_ctx_data, &old, cd)) {
 			if (old)
 				perf_free_ctx_data_rcu(old);
-- 
2.53.0



