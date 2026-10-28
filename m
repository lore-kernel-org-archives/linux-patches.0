Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207196;
	b=PpRZNFueQ9BkVpIjpkZd1XE9p3T1wEsC/MTEswZBuIcQP1WzvNAoq5bbT59RfrVy0uBI
	 EQOE9AVA/TiWOqwLmjtvEHUQgybZUmuvQteF6MBCKnF7muUF8K0S1ZPQ/e6tgxFhQx57s
	 H2IGfiw64k/XhLLhFMYFwvDz/sIBc1hudxScUnnporeiXyPyO4AzpUWjr6fEgpZR2eXok
	 zNVvnG607haAa9wWTspWpUrmN2+YBU87EFg8JpS9fuyCraVTDSgrNGhl12FKJWsLCiQqe
	 XIpRkvTuHFracgj9we37wTXfsAO5NALc0cehMonZ8o2/SOyOPS/eTLOX+Qktq54o7dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQqVQZGy3++6ahUmbEpxneyL5Hlu6kdF1ZECc7cYd9k=;
	b=Z2LlLy5IZ/2sBZonvm5NlrIyZmtjFR95vSQyZhHlRrIOLkVvF+i06s/Ueb28GiN6ogOm
	 jnA/uhLOR45JdpFjyWBKKQHGhqi708x++cqHBzJM8AP71GLRfP8XP9G9F3EHIKSfILHSs
	 Ab1DQkT8wVXKi1eAe4VFeLHOhhs6Uau5tm6B6jEoiKogTMy13xtdsrEShv1HmhO4qZkev
	 yhsdhAK1qHAS8tet8ILTyRvFFGpXFYu51gd2CGgKvsnBhhEgBNh3V9zKhNojhZihRaR3C
	 N+O30QkDmZPdTwrPy13zxtc1Pq4ymxv3pGUyCBaj3hjY8EPxQdkZBIpq9Gt3bmZ0GxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kl1u0uxH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2564606A31C;
	Wed, 28 Oct 2026 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kl1u0uxH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCE01F01825;
	Wed, 28 Oct 2026 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207195;
	bh=IQqVQZGy3++6ahUmbEpxneyL5Hlu6kdF1ZECc7cYd9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kl1u0uxH9V0KAqR5uePa9JvJeNcvVD/bqhjgMDpkgcCWAfEsPXVO/pjxcJ5MEoXui
	 UK+qLQa+J/5PY/0S3fzTHCFMVhjtl1myq2EYiydOUwFjZLSLiR2pDx030ZeblpFdF8
	 o+6u2ZiRUoUiiggvo/ih1C/84aJmaWNdQNqH5/sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 05/88] sched/fair: Avoid overflow in place_entity()
Date: Wed, 28 Oct 2026 17:59:13 +0100
Message-ID: <20261028165942.239576640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 2f93bcb3f9aaf6ceee1aec0a97d4fe386d48e781 ]

place_entity() inflates an entity's virtual lag with

    lag * (load + weight) / load

Commit 4823725d9d1d ("sched/fair: Increase weight bits for avg_vruntime")
replaced the scaled-down weights used in this calculation with
avg_vruntime_weight(), removing the arithmetic headroom provided by
scale_load_down().

The multiplication can overflow s64 before the division even when the
final quotient is representable. A task's hierarchical effective weight
can be as small as 2 after avg_vruntime_weight() scaling under group
scheduling, while entity_lag() bounds |vlag| by

    calc_delta_fair(cfs_rq_max_slice(cfs_rq) + TICK_NSEC, se)

For example, with HZ=1000, NICE_0_LOAD=1048576, and the minimum scaled
hierarchical weight scale_load(2)=2048, this bound is 891289600. With 114
maximum-weight entities, the runqueue load is 10361604096. The
intermediate product is:

    891289600 * (10361604096 + 2)
        = 9235189971864780800
        > S64_MAX

The signed overflow corrupts the entity's placement.

Rewrite

    lag * (load + weight) / load

as

    lag + lag * weight / load

The two expressions are equivalent, but the latter avoids multiplying the
virtual lag by the total runqueue weight. entity_lag() bounds vlag against
the entity's effective weight, so the remaining lag * weight product stays
bounded. rescale_entity() preserves this scale across h_load changes and
already relies on the same product when rescaling vlag.

Keep the original zero-load warning semantics by multiplying lag by weight
after replacing the divisor with one.

Fixes: 4823725d9d1d ("sched/fair: Increase weight bits for avg_vruntime")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260928124754.1692077-1-sh_def@163.com
[ Backport to v7.2 which doesn't have flat hierarchy ]
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b6cace1d0e322..9e1a28a158da2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6250,12 +6250,20 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		load = cfs_rq->sum_weight;
 		if (curr && curr->on_rq)
 			load += avg_vruntime_weight(cfs_rq, curr->load.weight);
-
-		weight = avg_vruntime_weight(cfs_rq, se->load.weight);
-		lag *= load + weight;
 		if (WARN_ON_ONCE(!load))
 			load = 1;
-		lag = div64_long(lag, load);
+
+		weight = avg_vruntime_weight(cfs_rq, se->load.weight);
+
+		/*
+		 * Rewrite, because the product (W + w_i)*vl'_i might
+		 * overflow s64:
+		 *
+		 *   vl_i = (W + w_i)*vl'_i / W
+		 *        = (W*vl'_i + w_i*vl'_i) / W
+		 *        = vl'_i + w_i*vl'_i/W
+		 */
+		lag += div64_long(lag * weight, load);
 
 		/*
 		 * A heavy entity (relative to the tree) will pull the
-- 
2.53.0



