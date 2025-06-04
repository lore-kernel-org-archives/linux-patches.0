Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A80A6AA7;
	Wed,  4 Jun 2025 00:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998607; cv=none; b=cJ6himhU4DfD+octt+SLGSQiKEXPPRavkvqlURdk49SmLLSGc9VL9nA1HDe1VJtiD1Ns54B/0d9Q00T/mlglemkDtSD6Ms1Wzn6q/imbm7caqMTcqqWQ4IQ/SgDdG9dHO33naB6HBRSr2fUKrIYpNlNOZCaciZdEbumiVXY4W+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998607; c=relaxed/simple;
	bh=1/z1j1K+t4TayPa4Fv3uiAcfd7KJmwb4XAdnqs4m4ks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kj/bH6Ma3UtanZH4Rt4uAhoG9WfN3Em0d7C/8qdwyokxp+3HHxXHfwqLKhT/gJSvAaJJnlSLWjCyrRGmGTd9svkjOOiZ+v59L+5pELIABblyX3xCkHB6EYMYRCdTmHavraImWbvIKZyvHhKS0OlUMATpaD33U4DrWLFK6C/4h6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0Gtvzhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0Gtvzhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F13C4CEEF;
	Wed,  4 Jun 2025 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998606;
	bh=1/z1j1K+t4TayPa4Fv3uiAcfd7KJmwb4XAdnqs4m4ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0GtvzhhsWSjWV0Z9h5wAaARaE1r+q+63l24/BAwCzj/lyRG83AZcGg4580YNbhQK
	 4eNvnWn6g9uVxxNSemcpjUfx/CdeSGPYfIML/jP+2HF2XSW+OHMjwWkuVoaTeR5OkC
	 s51W8EUyom5JjTUZCiEZigqidDUmnk1L6QKiFoHCi11I/dh0s3lf2rNwu9Di08II/e
	 LAscn/vKXAChs79TPRb9j9Metegup/LS0Q4YowpHXxUA8fl+gbZAoLA7pqpyICZlBe
	 mUy5oDrS175FERPvoy8AXqhN01x+IyyXQXDnhRv64Scr8plTMlsHygrFw+Y5dOUvme
	 gwKocGJIDLLjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	netdev@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 038/108] net: page_pool: Don't recycle into cache on PREEMPT_RT
Date: Tue,  3 Jun 2025 20:54:21 -0400
Message-Id: <20250604005531.4178547-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 32471b2f481dea8624f27669d36ffd131d24b732 ]

With preemptible softirq and no per-CPU locking in local_bh_disable() on
PREEMPT_RT the consumer can be preempted while a skb is returned.

Avoid the race by disabling the recycle into the cache on PREEMPT_RT.

Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250512092736.229935-2-bigeasy@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Bug Fix Classification This is a **race
condition fix** for PREEMPT_RT kernels that prevents potential memory
corruption and system instability. The commit addresses a fundamental
concurrency issue in the page_pool subsystem that only manifests on
real-time kernels. ## Technical Analysis of the Race Condition The issue
occurs in the `page_pool_napi_local()` function, which determines
whether pages can be recycled directly into the page pool's fast cache
(`pool->alloc.cache[]`). This lockless cache provides optimal
performance by avoiding spinlock overhead. **On regular kernels:** -
Softirqs are non-preemptible - Direct cache access is safe because
producer and consumer cannot run concurrently **On PREEMPT_RT kernels:**
- Softirqs can be preempted by higher priority tasks - A softirq
returning pages can be interrupted while another context allocates from
the same cache - This creates a classic race condition on the shared
cache data structure ## Code Change Analysis The fix is minimal and
surgical: ```c /bin /bin.usr-is-merged /boot /dev /etc /home /init /lib
/lib.usr-is-merged /lib64 /lost+found /media /mnt /opt /proc /root /run
/sbin /sbin.usr-is-merged /snap /srv /sys /tmp /usr /var On PREEMPT_RT
the softirq can be preempted by the consumer linux/ if
(IS_ENABLED(CONFIG_PREEMPT_RT)) return false; ``` This forces all page
recycling on PREEMPT_RT to use the ring buffer path (`ptr_ring`) which
has proper locking, instead of the lockless direct cache. ## Impact
Assessment **Functional Impact:** Zero - pages are still recycled
correctly, just through a different path **Performance Impact:** Minimal
- ring buffer operations are slightly slower than direct cache access,
but only affects PREEMPT_RT systems **Risk:** Very low - the change is
isolated, well-understood, and follows established kernel patterns ##
Backporting Suitability 1. **Clear bug fix:** Addresses a real race
condition that could cause memory corruption 2. **Minimal and
contained:** Single 4-line change with no dependencies 3. **High
importance for affected systems:** Critical for PREEMPT_RT system
stability 4. **Low regression risk:** Fallback to existing, proven ring
buffer mechanism 5. **Follows established patterns:** Similar PREEMPT_RT
guards exist throughout the networking stack ## Historical Context Based
on my analysis of the kernel repository, the page_pool infrastructure
has evolved significantly, with the direct caching mechanism being added
for performance optimization. The `page_pool_napi_local()` function was
introduced in commit 4a96a4e807c3 (Linux 6.9+) as part of the lockless
caching optimization. This fix addresses an oversight in that
optimization where PREEMPT_RT preemption semantics weren't considered.
## Conclusion This commit represents exactly the type of fix that stable
kernels should include: a focused, low-risk correction of a race
condition that could cause system instability on specific
configurations. While it only affects PREEMPT_RT systems, the potential
consequences (memory corruption, crashes) are severe enough to warrant
backporting to any stable tree that supports PREEMPT_RT and contains the
page_pool caching infrastructure.

 net/core/page_pool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index cca51aa2e876f..68e7962daa08f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -801,6 +801,10 @@ static bool page_pool_napi_local(const struct page_pool *pool)
 	const struct napi_struct *napi;
 	u32 cpuid;
 
+	/* On PREEMPT_RT the softirq can be preempted by the consumer */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		return false;
+
 	if (unlikely(!in_softirq()))
 		return false;
 
-- 
2.39.5

