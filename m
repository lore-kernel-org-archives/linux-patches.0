Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591028;
	b=EETsDjPwhc5GRqiLVaqokM6Xkro4mvSgbgt8o6Hhvl6vOprjwTi6OeGceiEz9UbIZQA0
	 J8guNLYtuUJQ32V62I55x6G1oWBCoixcMWyxDmJ4xQcRRc1bPTOr9eDTUixiLKAmSKIxQ
	 LxZ4aSEwfGvY1NhnDlfXjwoFyljiPHZS17OQVA8/3Hg9I9VSPe0bUNIe579eL96r6EOsl
	 nZORygIUAbTxXsUxp+kP7WN9bnUDpbKgrusYNE/vTOpHjVDjXqyjSSGOvDDZatN6ujkEE
	 JoT8Vr9rrt8NR2xEq58RqLo0MIqcvQP9FXtxoGLXPw5RlJexa5sBRhSwps9aWMxA/DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GfHHhjuH1gYibj0CF19WL3Qnrm09N9b1gHTkWXMmrao=;
	b=K4F8AcAuLkXggN5zOad5rqEBuAj8HJN9KdE2g0Pyfb+It8Cf+LBcL0qdSJtBSXSKZKFy
	 t0tGEMoUO0yoPzPWkAc15svGBz+7snXa+YeyVtfBorI+4ntMshCbbkd5SxyTsioD7lEQI
	 Po2o+esYmXMGFuB5a+yk2CLLD5UVe/VvQrWed+saGbKAqW7iJ7sR2r/Pk6j6JEKhEVPzx
	 AcJDOlKZdi0t6nAranqDs/bhoIAmAo30khLoDr5TPxlVHxbUXwS8INbbx9R8iiqCA03Cb
	 qwgd87LItg1zaSURdj6zEyhLG4qNMX3N7gKd/jB3W0WGLkndMmbaTFPInIoktAZuhWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GY4x0UaG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C6F6084346;
	Fri, 13 Nov 2026 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GY4x0UaG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284A81F000C6;
	Fri, 13 Nov 2026 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591028;
	bh=GfHHhjuH1gYibj0CF19WL3Qnrm09N9b1gHTkWXMmrao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GY4x0UaGeNT/3Lt6owoPfaOxGk524Znke4TVSv5Nbn9zSFGKdn9aTfvMx9+cb/1Ad
	 +9BUTQhY/UK8wO6bKthEZVqyJLE1YpG6LlUnh1s2DKY/ublutfCfRT3hWff3NUVy9z
	 P+FTKP+WDvnHu+9cbVg8vq/nQTAh5xU9edTvTQVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Muchun Song <muchun.song@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Chris Li <chrisl@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/670] mm/memcontrol: fix data-race on reading jiffies_64
Date: Fri, 13 Nov 2026 10:45:14 -0500
Message-ID: <20261113153817.028644518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit c20cf1c3c8cdd98618d6fcc794003a0e003ae858 ]

KCSAN reported a data-race between tick_do_update_jiffies64() updating
jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.

Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
accesses and can even be torn on 32-bit.  Use get_jiffies_64() instead,
and fix the same pattern in mem_cgroup_flush_foreign().

Link: https://lore.kernel.org/20260827025457.116191-1-jiayuan.chen@linux.dev
Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f7dd9bea5196c..74f3a2975e2a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -591,7 +591,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 static void do_flush_stats(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_is_root(memcg))
-		WRITE_ONCE(flush_last_time, jiffies_64);
+		WRITE_ONCE(flush_last_time, get_jiffies_64());
 
 	cgroup_rstat_flush(memcg->css.cgroup);
 }
@@ -620,7 +620,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
+	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
 		mem_cgroup_flush_stats(memcg);
 }
 
@@ -3311,7 +3311,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
-- 
2.53.0



