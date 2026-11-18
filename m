Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038798;
	b=Og7p7Vqh3gq5aikRNpG3babXB9lL/pLvT+0+ZmNORYkGp5givBSM9aA6G1xESMEv/Zrs
	 BKgSj1MZu/iCD0V5lL8qwXaNey86UC6ohTXWAqwURbld39ZIx6yWaH4yoYgnBy5y53O1n
	 NPHE7uzR4Ic3GixJ8My+hP9sK0+CHnWopPtYJkZralmYuZ8tguXdnTc9Thp7raA8Jxmky
	 0QB7EeL/QedJb7gNxzy9ZAIXSHxihhYbPC9h0nhm3qmvgN8DufIV+X6K8Jqa2MrAr75Cp
	 zfh4jNqI6WdIt8wUB/JSyFqfI10Y9MQrtJ75DkbVe/Jet0SQ52rIKa8pgn+P157OH8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3YfwN5yQbTyJPt3LucxsCI5lnLYy6QeK/Qp8k5MxVAY=;
	b=fCPn+XmUlwuTWS+N8dQEF8/1RJ8Uq8ckVe4CBSZdhn5YxtPpg2DpHzq/n8FGcXC6paLW
	 okN/5oO/R+ughvAg3uAb8JqJoBRU2QXzgwab2anU2fl75bUJNPgrTJ15OAbD8NKnHRxDl
	 f6SI1e6aclljUgvQ/D5S0UOZJjqO/vBqP1i45UEojdvZtAj7ebDqT1Y+9nMb+SRk+jeBx
	 UZM6YrTH4S46vg63sq+5AyxlafKU5MU1NZjBA9rh2rY7Pur5HYiKzwgdyTPCPVFdTJodB
	 mYJiFFMSphbMlwBwsTmFVwY3N7kPSvD/mRapIPjZIIff6TnQc2dYO0M/ZdPm151L/xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtouqEIb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2F606A320;
	Wed, 18 Nov 2026 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtouqEIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC891F000C4;
	Wed, 18 Nov 2026 21:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038798;
	bh=3YfwN5yQbTyJPt3LucxsCI5lnLYy6QeK/Qp8k5MxVAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtouqEIb60ikDonKGFoPUEhgnyGS0BQud2Y12pdfN4eMk3p6/oYbadcQeiRzBFT0+
	 HM3wjwQvA74H/azxL6vDdpeUgZm/9qPZi8s1nFwftO5DRyRT1f7gcP+9kB0TR7F2BI
	 7uav4A24B8uTQHnjkvBIoUAuBWMKqQX3s6EyhzAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1869/3318] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118150418.014897059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit d2f28a1a652e0a43f6f63de9b4e4d8d5f2716803 ]

When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
isolation, schedule_drain_work() can drop the work in a separate RCU
critical section, and housekeeping_update()'s synchronize_rcu() can race
that second check, leaving the flag set.

drain_local_stock() only clears the bit for work that ran, so the flag
remains set and the stock is never drained again.

Have schedule_drain_work() return whether the work was queued, and clear
FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
isolated, so future drains can retry.

Link: https://lore.kernel.org/20260828135036.7d44361f@fangorn
Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: adapted schedule_drain_work() return handling to a direct flag clear in the existing single-stock isolation branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ff9927140c836..a5fb60f74a10f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2396,6 +2396,8 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 				drain_local_stock(&stock->work);
 			else if (!cpu_is_isolated(cpu))
 				schedule_work_on(cpu, &stock->work);
+			else
+				clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 		}
 	}
 	migrate_enable();
-- 
2.53.0



