Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9B711705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A5EC433C8;
	Mon, 11 Sep 2023 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443062;
	bh=W0nqTaMHlmwwXpa5Y3y7ljzUIu7/FlR1kuRPtZ6TU2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4cy+QTvskK/v+x/9YlWSrOxc8LQQe+UlIQxGc4UBJDwNLmklfM9mUt/65wk+JZH5
	 7jJ6XcFdcyF0eHo8DzSiDk2Xw1nq9y1I05qiJMWYr8utD5VM9w0esXnQz8Opq4cQdG
	 BQcHPtSl7/qJHoQ+Uj1y0ItqM7bUnPSRtB25dUWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Shakeel Butt <shakeelb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 215/737] net-memcg: Fix scope of sockmem pressure indicators
Date: Mon, 11 Sep 2023 15:41:14 +0200
Message-ID: <20230911134656.596497945@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Wu <wuyun.abel@bytedance.com>

[ Upstream commit ac8a52962164a50e693fa021d3564d7745b83a7f ]

Now there are two indicators of socket memory pressure sit inside
struct mem_cgroup, socket_pressure and tcpmem_pressure, indicating
memory reclaim pressure in memcg->memory and ->tcpmem respectively.

When in legacy mode (cgroupv1), the socket memory is charged into
->tcpmem which is independent of ->memory, so socket_pressure has
nothing to do with socket's pressure at all. Things could be worse
by taking socket_pressure into consideration in legacy mode, as a
pressure in ->memory can lead to premature reclamation/throttling
in socket.

While for the default mode (cgroupv2), the socket memory is charged
into ->memory, and ->tcpmem/->tcpmem_pressure are simply not used.

So {socket,tcpmem}_pressure are only used in default/legacy mode
respectively for indicating socket memory pressure. This patch fixes
the pieces of code that make mixed use of both.

Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket pressure")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 9 +++++++--
 mm/vmpressure.c            | 8 ++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 222d7370134c7..7f2921217f50b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -284,6 +284,11 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
+	/*
+	 * Hint of reclaim pressure for socket memroy management. Note
+	 * that this indicator should NOT be used in legacy cgroup mode
+	 * where socket memory is accounted/charged separately.
+	 */
 	unsigned long		socket_pressure;
 
 	/* Legacy tcp memory accounting */
@@ -1743,8 +1748,8 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
-		return true;
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return !!memcg->tcpmem_pressure;
 	do {
 		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index b52644771cc43..22c6689d93027 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -244,6 +244,14 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 	if (mem_cgroup_disabled())
 		return;
 
+	/*
+	 * The in-kernel users only care about the reclaim efficiency
+	 * for this @memcg rather than the whole subtree, and there
+	 * isn't and won't be any in-kernel user in a legacy cgroup.
+	 */
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
+		return;
+
 	vmpr = memcg_to_vmpressure(memcg);
 
 	/*
-- 
2.40.1



