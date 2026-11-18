Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021699;
	b=dgBhdaWk4Kez+9sK13Q+Ku+NAJfLYroduXkXErysr7V0gRCzoDzI9HetRZU8Kf0PKrr9
	 Hte8naWZadaYAkWFtD4G42AC4b/RTVk5Gl4U9jH+QaAaMoBrrEulOPezBAuJU3hAwybG3
	 aC40WbaurbM3GoUxdFB4dyMtmI+gR7fx9U+Nk8AqtPcDRZlzFTmSayTEDArnnSj3AtCgN
	 P+Tj9JgtAAsuvDahTWisf2U/bjb+keJ2coys7bKop3eDxLRwrVf36wwIXri4yQvZ1lcOJ
	 en1bEG0zJQ4x1pfGeYdonkKtoSDx1t8OLkmjP1FGvsyRWHIepXU7oi5xzxR3HkFJb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilR33ORc5Ve0LzlbePRqeI+ndEBwQ42byWaUgZna5Zg=;
	b=ByB5OvpuBVsavmPPvaS59G2qRvucLz1ZaPi+uqq9imsfGiwudPkb45fbZw0XuwQcxUJS
	 yC4J2fsLmTUIsx+tnviIOwwRk+U7PcSqdHhtI/nzXASE0/tqFGFr6j0Bq/5SnfWvDynhS
	 cFKRA7K83Ml2316vwo/P6y7Ylf4vQeFJyOriraYYuagBN9Z2BbJp7SfTmMiIXsvnHalLy
	 L9ErppumAvBD9uErD0iYDkrLzUgwyMHZoYGipplcNfDL2l3IG+TYGhxPdM3YYr9VIjcVl
	 ZVKB1AKf8gqTMAC69L9h5IGzZgq0Kgp3YhgygYa3sL/xu+ANFBtvhoHZ//vfVCPGxWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJEOpsg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243D9606A325;
	Wed, 18 Nov 2026 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJEOpsg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D8E1F000C4;
	Wed, 18 Nov 2026 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021699;
	bh=ilR33ORc5Ve0LzlbePRqeI+ndEBwQ42byWaUgZna5Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJEOpsg6RgGRZDaqZp1EPgivh0n5TCZhXa5Ru6OmrwovM9XZXpf9Iah691m4aBACf
	 oQIAEXjQ5k0w6+nti23GQmwmwGh/HjpRf8xvpIouNLtzbeidiveecEjl++9ndzC0zt
	 TngGyPA0g8Kcax4HzhmT8vklSZV3bmMgweTgYHJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <mkofdwu@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2363/2651] perf: Fix UAF in attach_task_ctx_data()
Date: Wed, 18 Nov 2026 16:00:03 +0100
Message-ID: <20261118150410.615066622@linuxfoundation.org>
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
index 9b90b6831de7c..e8293a0e7945c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5434,6 +5434,9 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
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



