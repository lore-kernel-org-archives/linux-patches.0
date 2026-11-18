Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028518;
	b=gpdQLdniWdhVGgjbIN31WpXlurx9OMDSxyhUHSSsR+XOKVK2/fl7IqCfoVteqMmOGUTf
	 2MDvJdklsZBLdurHvl/0ptrR8BpNLAJ1uhZAJENQqxGTV3siVydqweSb+oO4Gybd9FM6x
	 g1w7jT2Q+Ng4z2p2L3kMZhEsUm4a6DgbY4DMIh1H9OnnUy+gLk+DjWvBBKDl4n3WsridL
	 Pk9muLZIhtEOdKIpSu3N0v2oMN4Dw45GJWb7t4gV05K1OsxlHLt2KQmyTt2zz8Qkp5XwN
	 db5xW/qvFHgE/Cu/PsLGaVT5FK8L3xuwjPQ7Cl2dQvQ64L0Y0n/knNxUmvGolDS02yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1xfIPc4Migo4ve67S1VXU2opA5k6PCyx7Exj6zf95o=;
	b=ipk27q0WauPgcmvx3C8FHAlaavQA21ewCrOUoUP1AfW/MGbKDkCkpjN9IKteJAShrGXn
	 hDn+ddfrg0629uP2gpVnR5r2CMokUQTZRSq/ktZsXBKcU6eUOyX4zmJnWU7qCRMgCQ3dG
	 haFTBDj+Q1r0wimapF6hvzCYM9ku4MB88he1gbaXqlaXn2f9tj7Odi5KcjdUYoJsbcL0f
	 1nC7XHYp66wdBlU5xHPCuBYi2Y27WMAAjMe6pN6YKEZkzNSXhUktL0deLOyLk9hSaMa8R
	 T2+LoeENZqfKDMafbdQELicms1NnX8/fXprOlR8SzFnylMWoGddVFfYoX9+kCvwUDew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKGnA4fv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53A4606A32C;
	Wed, 18 Nov 2026 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKGnA4fv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B38B1F000C4;
	Wed, 18 Nov 2026 19:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028518;
	bh=L1xfIPc4Migo4ve67S1VXU2opA5k6PCyx7Exj6zf95o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKGnA4fvFs3U0Rq5ar7FzBMxKaNWFfmbOIxVchguAeeGrpvigqVIDADo+FOgs1qEq
	 GgM3hpte4TjvohRpxFE4sCir0bQ2FpbCQjSr9gvRW0VoBhAY63R8grBx7lQgRyWeCd
	 kEwhE6QorWR52qyfx3f8rQARp1QJAxCwtbApUk2o=
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
Subject: [PATCH 6.12 0011/1756] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Wed, 18 Nov 2026 15:35:38 +0100
Message-ID: <20261118150008.411907418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: Adapted schedule_drain_work() result handling to an inline branch in drain_all_stock() for the combined charge cache. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2aae088c86082..de7bd67619533 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1871,6 +1871,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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



