Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCA414B086;
	Wed,  4 Jun 2025 00:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998333; cv=none; b=mT1MjqNF5Hl6A86zmHdOiLJePvhvIzLr8itdPkFjB8xsD28phtDHxBtzQK7KZBlQ0nUPNU2QktAXXljj3gy4YIAdlgTCBPUv8aWf2kUNW+zcYvJjbUQZ+xG/LrZp3DEtlwlJtLZWWRADGVZXbCf62pAP2rcH156lkXOCm3wU8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998333; c=relaxed/simple;
	bh=l++nGnrPMLKJQrWzMrVrWOaGkuAWOaeqoUzFK19eB4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZWXmiUXXYkSM7elRmWbAaNipxEjvv7PW2iXiW8o/Jcm5a/If+nMxHGSOrdo+cqcGDDRSTkRXkVFptIWsJ7YW0DpF7apT36gvLlV35cBPcDLYvevthmfKl99gI2eFyXIWoZaeoWwuyjFIidknmurg+syYGlz7vyADNVGr5h99+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qxf+drFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qxf+drFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC41C4CEF1;
	Wed,  4 Jun 2025 00:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998332;
	bh=l++nGnrPMLKJQrWzMrVrWOaGkuAWOaeqoUzFK19eB4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qxf+drFYI6mrAzSI/w83OAZmFPkMK6OC2cjC9Rn26oJJdKt2piZb3kO43CNjHBQyB
	 mLIdSYUIIM+FzmcyHRgKBnWBgCPuLGRwWWw5zbt3zrIJhQxjC+n+DmliIkgtY3NAAi
	 CDwI0NkEdvdoXVKxJLuVdHOH2yYjgkv4s0btWIWq1whAhIFhLH96CWu27dqMfcteN/
	 2I1egB0ZwNtlMXlInu428vY85dv5j2U94qsNGhmrcJWjYsjb9e2kxuob03v4KSPwq3
	 RK+vDtSGa3yo5fRnICueIX+tfmN/Dsn53htkvs52v4ryFmRDHTAAH74uZs0Ew6XNQ7
	 aXqOfapWxgy1w==
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
Subject: [PATCH AUTOSEL 6.15 041/118] net: page_pool: Don't recycle into cache on PREEMPT_RT
Date: Tue,  3 Jun 2025 20:49:32 -0400
Message-Id: <20250604005049.4147522-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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
index 7745ad924ae2d..ba8803c2c0b20 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -805,6 +805,10 @@ static bool page_pool_napi_local(const struct page_pool *pool)
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

