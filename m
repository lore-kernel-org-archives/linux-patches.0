Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09BA313267;
	Tue, 13 Oct 2026 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894870; cv=none; b=FW7Qo0LEKI/XWHUMD6jembdGgG3pcfnWZIoh7Sg7Oj62gi4hQm+GPd1yF6jP6S/xrSvS4pFzC1gN7Gm6nWs8d4EcE1JheYlElYWH8oflKTf7fBc78aYsXRCec31BG1pLxlV2P5LvH2A+ojr2mLC5W3AcV12V9+FPNVdIhf/PRSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894870; c=relaxed/simple;
	bh=9xXMIId7CsUEbD4PqX3F/H4irWR5wodZm488ARaKoEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAhYudkx/7ehPnrfsosV0z7tbvb2ii8H+Xj4YgJXS5CSM/7wi2V/SImt5sHm7uErvd+807DdbPH5vsgz9l+VHRxV60u5niu60qRbTHYodCIMCZ5lniI6NyWjH/+kx/RFOUB2+HNJ6krZH0xI79Js5WgnGkQn7J6OLgukzDM7dek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWX4XPFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWX4XPFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA91F000FF;
	Tue, 13 Oct 2026 12:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894869;
	bh=BllV5g3pIfFfLCvykzSNjBJsangbOmhC5B0jy25zSAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWX4XPFg0D03QAetIMNNdtRWwoaNC7FYsQQPjIpagMldEVBag0aNzx+5Gma4SGdjE
	 dYpowQKwiKUlTWmZum8+qG8A7FGsyorJoT7b67fPkM5LZwWi74EbOIRHeD0H5/btgL
	 yiHLoTUZOnX6IeRo9+kQnFwyc2Xon7SD8zOYGawU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/497] memcg: convert memcg->socket_pressure to u64
Date: Tue, 13 Oct 2026 13:34:09 +0200
Message-ID: <20261013112909.832425607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 378bdb97405a00bf03d8d993435c83add1688e36 ]

memcg->socket_pressure is initialised with jiffies when the memcg is
created.

Once vmpressure detects that the cgroup is under memory pressure, the
field is updated with jiffies + HZ to signal the fact to the socket layer
and suppress memory allocation for one second.

Otherwise, the field is not updated.

mem_cgroup_under_socket_pressure() uses time_before() to check if jiffies
is less than memcg->socket_pressure, and this has a bug on 32-bit kernel.

  if (time_before(jiffies, memcg->socket_pressure))
          return true;

As time_before() casts the final result to long, the acceptable delta
between two timestamps is 2 ^ (BITS_PER_LONG - 1).

On 32-bit kernel with CONFIG_HZ=1000, this is about 24 days.

  >>> (2 ** 31) / 1000 / 60 / 60 / 24
  24.855134814814818

Once 24 days have passed since the last update of socket_pressure,
mem_cgroup_under_socket_pressure() starts to lie until the next 24 days
pass.

We don't need to worry about this on 64-bit machines unless they serve for
300 million years.

  >>> (2 ** 63) / 1000 / 60 / 60 / 24 / 365
  292471208.6775361

Let's convert memcg->socket_pressure to u64.

Performance teting:

I don't have a real 32-bit machine so this is a result on QEMU, but
with/without the u64 jiffie patch, the time spent in
mem_cgroup_under_socket_pressure() was 1~5us and I didn't see any
measurable delta.

no patch applied:
iperf3   273 [000]   137.296248:
probe:mem_cgroup_under_socket_pressure: (c13660d0)
                c13660d1 mem_cgroup_under_socket_pressure+0x1
([kernel.kallsyms])
iperf3   273 [000]   137.296249:
probe:mem_cgroup_under_socket_pressure__return: (c13660d0 <- c1d8fd7f)
iperf3   273 [000]   137.296251:
probe:mem_cgroup_under_socket_pressure: (c13660d0)
                c13660d1 mem_cgroup_under_socket_pressure+0x1
([kernel.kallsyms])
iperf3   273 [000]   137.296253:
probe:mem_cgroup_under_socket_pressure__return: (c13660d0 <- c1d8fd7f)

u64 jiffies patch applied:
iperf3   308 [001]   330.669370:
probe:mem_cgroup_under_socket_pressure: (c12ddba0)
                c12ddba1 mem_cgroup_under_socket_pressure+0x1
([kernel.kallsyms])
iperf3   308 [001]   330.669371:
probe:mem_cgroup_under_socket_pressure__return: (c12ddba0 <- c1ce98bf)
iperf3   308 [001]   330.669382:
probe:mem_cgroup_under_socket_pressure: (c12ddba0)
                c12ddba1 mem_cgroup_under_socket_pressure+0x1
([kernel.kallsyms])
iperf3   308 [001]   330.669384:
probe:mem_cgroup_under_socket_pressure__return: (c12ddba0 <- c1ce98bf)

So the u64 approach is good enough.

Link: https://lkml.kernel.org/r/20250717194645.1096500-1-kuniyu@google.com
Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket pressure")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reported-by: Neal Cardwell <ncardwell@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <ncardwell@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 37e02c42a00b ("net: restrict SO_RESERVE_MEM to TCP sockets and cap max value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 44 +++++++++++++++++++++++++++++++++++---
 mm/memcontrol.c            |  5 ++++-
 mm/vmpressure.c            |  2 +-
 3 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e4c24c94b9ef0..659ee811c9c2f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -241,8 +241,10 @@ struct mem_cgroup {
 	 * that this indicator should NOT be used in legacy cgroup mode
 	 * where socket memory is accounted/charged separately.
 	 */
-	unsigned long		socket_pressure;
-
+	u64			socket_pressure;
+#if BITS_PER_LONG < 64
+	seqlock_t		socket_pressure_seqlock;
+#endif
 	int kmemcg_id;
 	/*
 	 * memcg->objcg is wiped out as a part of the objcg repaprenting
@@ -1667,6 +1669,42 @@ extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
+
+#if BITS_PER_LONG < 64
+static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
+{
+	u64 val = get_jiffies_64() + HZ;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&memcg->socket_pressure_seqlock, flags);
+	memcg->socket_pressure = val;
+	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
+}
+
+static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+{
+	unsigned int seq;
+	u64 val;
+
+	do {
+		seq = read_seqbegin(&memcg->socket_pressure_seqlock);
+		val = memcg->socket_pressure;
+	} while (read_seqretry(&memcg->socket_pressure_seqlock, seq));
+
+	return val;
+}
+#else
+static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
+{
+	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
+}
+
+static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+{
+	return READ_ONCE(memcg->socket_pressure);
+}
+#endif
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
@@ -1674,7 +1712,7 @@ static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 		return !!memcg->tcpmem_pressure;
 #endif /* CONFIG_MEMCG_V1 */
 	do {
-		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
+		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
 			return true;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ca5694828c292..6592857d53721 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3542,7 +3542,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
 	spin_lock_init(&memcg->peaks_lock);
-	memcg->socket_pressure = jiffies;
+	memcg->socket_pressure = get_jiffies_64();
+#if BITS_PER_LONG < 64
+	seqlock_init(&memcg->socket_pressure_seqlock);
+#endif
 	memcg1_memcg_init(memcg);
 	memcg->kmemcg_id = -1;
 	INIT_LIST_HEAD(&memcg->objcg_list);
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index bd5183dfd8791..c197ed47bcc45 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -316,7 +316,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 			 * asserted for a second in which subsequent
 			 * pressure events can occur.
 			 */
-			WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
+			mem_cgroup_set_socket_pressure(memcg);
 		}
 	}
 }
-- 
2.53.0



