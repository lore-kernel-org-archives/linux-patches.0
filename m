Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DB16FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F12C433C9;
	Sun, 17 Sep 2023 20:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981747;
	bh=F2m1EVKy1K9iSC7HylGIBeFybQxx8lgcnXVWGZl6mNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvMDVwkdB8/DE7iADaRZ4npq2dV8dyQwPlr69wtc2JV4HOVqjFGRvC5LJSD4xjbPR
	 Vv5P4LZUgFjUHN1Fks4r69RabNQverW0lG5EbDjHNWeFsFXRkDFLK2rSKAsYWHJtgV
	 FAE2tph10McwalaZW61tgPhaY6Vl8Exh6cSO1cN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Shakeel Butt <shakeelb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/511] net-memcg: Fix scope of sockmem pressure indicators
Date: Sun, 17 Sep 2023 21:08:48 +0200
Message-ID: <20230917191116.304320785@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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
index 4f189b17dafcc..94df87cb69c3b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -310,6 +310,11 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
+	/*
+	 * Hint of reclaim pressure for socket memroy management. Note
+	 * that this indicator should NOT be used in legacy cgroup mode
+	 * where socket memory is accounted/charged separately.
+	 */
 	unsigned long		socket_pressure;
 
 	/* Legacy tcp memory accounting */
@@ -1627,8 +1632,8 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
-		return true;
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return !!memcg->tcpmem_pressure;
 	do {
 		if (time_before(jiffies, memcg->socket_pressure))
 			return true;
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 76518e4166dc9..383e0463c0258 100644
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



