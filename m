Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064552;
	b=iHR+eNSoYraWe11KTh+qIvNKlRydL7HYLfnL1sixe8iANx1aDBPmr59wuHN54Re/tTNf
	 8HAqcJTOmqBjpLHL+0iHXcDas4cd2L4w65TaOC/vQMTfjqwu6o2j+pzepcquRNVKfgzhX
	 EV6+Pbc8HAF+Mqcj+ee17GWQdrdlKtkyJPLhrUOBdSeCDeT8gsQuvQ6RvcPqO2n/5CO4a
	 dzSNBwxV1QDtTFcw40kSS3CeXBdfoCe3S+AQDvOOdEC9ZRWArZIQaHU01LIThAWYAAcwY
	 Hv1vZEvDCNYbNGXU/LidLlavelBCXRTQkOGVr7IogBfJazg7EdNTXSVNLY8OLF2kEbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ArbTuywoVtQUQaSRCqIVL8KGuFMm0QoZGvMcnxxT+W0=;
	b=wb7vjTywa9n1dMGYoV6b3PZO9PIEWo6cgeGL4O9ApbOHlDL45E2t7c2DbYjzSWm4tonj
	 phn60Nyy8geNWNcByF3DbgVlyI2qn432B4c7lwOL4X7CeqvrsRGCZl89eid+ObJDLwVhr
	 d2AAlSivGoGO1Z0lQ/xBCyjaQlG2SqRkUnYt+95iSQOp2ukegli1OdWRFM4padL/vmt55
	 p9Sj/mDWN83BGPe8bc+AigxKzX/ZjiUw4L4qb+vMuwG7qJaVVT9URcZUZgBlYlclVsXqf
	 AS4emCbCPj1GeDw1zo8haOadSnIFgibAPIaDsEOjtD/GD74orq0+eW3Csk2ct5jGNYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=was7BImc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC46A606B8A6;
	Sat,  7 Nov 2026 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=was7BImc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE761F0089F;
	Sat,  7 Nov 2026 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064551;
	bh=ArbTuywoVtQUQaSRCqIVL8KGuFMm0QoZGvMcnxxT+W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=was7BImcmocdQsZNBB3OMe+HMJvcxaiXnhyZmPTarl7+DdrftovEycTY9hVR0b0ec
	 SAmY3H/WjWAQx6JXJiVUtz7lxZZuzE8/9V5OhCF//A2Ogx4FWkEl2eW6YMUxhGRCOS
	 Byw+Cn9m9VH+bdyMNKadQKVnAtnHh2OwaqZr1des=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0575/1257] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Sat,  7 Nov 2026 08:47:51 -0500
Message-ID: <20261107134955.228823290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hui Zhu <zhuhui@kylinos.cn>

[ Upstream commit 7c0a645068deaf4c3a8c619ddbb8b84c477f9a9a ]

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update,
but the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Link: https://lore.kernel.org/9ffdbdfc96312e3e13cb8f056bfe26649492d949.1789096175.git.zhuhui@kylinos.cn
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index af61dacf0d180..ed371b1ddab87 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -853,6 +853,17 @@ static long memcg_state_val_in_pages(int idx, long val)
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -864,6 +875,9 @@ get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
-- 
2.53.0



