Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590139;
	b=0PsDNxWvhGK98YVBz2/1z4PWyrtut4ULuDVDJZCH/4R9eHH7h1HvZ7Aj4e7lalqGTmnh
	 4iKJ7hM07CFQJdntyobgyc/szJgVplzxPtcHG3VOqqlRzBdwk7kLJHubLxCqdW8pfetES
	 xoUmA/klQZqJcqfiaj1I+1mv0kEuk1Xky2v4Hz5y8FROseVU1CUEAMPYENg8Df6y68AHh
	 xXYU6zcwZhPDpfB8chV72PzvGRTk140SqgqDfl6KYMXA7tnI/UEd19/stJAYr/uK6QjAJ
	 YONiaEB7hejQZMJXGDEjJxq6pKCZQdbz1cJK16SfYW7lhalmvlMV92v/VbMNTud0jwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xn/8M+rtWplWl8Huhpv3bMuKqKcS5wsbpvpQm5ZgzDM=;
	b=fRQKoeJgwE5J9Ss3PA63GJIWXtZiy1B2aO0jgabdCrDO2+yIa2e/tPB81VRpLbIpiGVg
	 88T5wiJPPvODmLnP/MukpZTfEayRpe32AMqd2Ggn6Mnl8TrEZdmE+SAMoP1xUYaQBc28U
	 NBk8yRGBcw0Uy51LoRn9fz3gK0nZJQ115iT4wT2yUvSBFf2trk9AeQkHMbLTvY8hXTrDY
	 pj3puzRqsLUIVEszcW9XKT/XdLwIo44gdDBFt1UN3p0hHoCPB9REZZ9oUbUkAjqasgLR9
	 7onmVGgH2qlxpllaPsK3VLPZzVe5IQ3lKopl2iNOsRyuRnF/D7K1+eGEpJ8oBw7vUZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1NlEOFw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F2F606E20D;
	Fri, 13 Nov 2026 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1NlEOFw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0458E1F000C5;
	Fri, 13 Nov 2026 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590139;
	bh=Xn/8M+rtWplWl8Huhpv3bMuKqKcS5wsbpvpQm5ZgzDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1NlEOFwYB98C9HYVLhsQsjCjOf1KnnxKmVmwTfP2DDN7nSeJV6mcXk2ElhIVwQ/J
	 aXENaDknGpERuWQLzLPf9yEQAx5X5ITRDsYY1YiLqDZHWe2eXL9Ta3H3YaSi2hdYxa
	 2V3ojjgIOa1E9vvtFIxzp6LLyCXBqGw97P/yvt58=
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
Subject: [PATCH 6.18 156/686] mm/memcontrol: fix data-race on reading jiffies_64
Date: Fri, 13 Nov 2026 10:44:49 -0500
Message-ID: <20261113153826.078368387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 2aa741316b49f..eec89dcb7801b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -604,7 +604,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 		return;
 
 	if (mem_cgroup_is_root(memcg))
-		WRITE_ONCE(flush_last_time, jiffies_64);
+		WRITE_ONCE(flush_last_time, get_jiffies_64());
 
 	css_rstat_flush(&memcg->css);
 }
@@ -632,7 +632,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
+	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
 		mem_cgroup_flush_stats(memcg);
 }
 
@@ -3512,7 +3512,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
-- 
2.53.0



