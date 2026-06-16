Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48234534AE;
	Tue, 16 Jun 2026 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625909; cv=none; b=XOGfx29HPRSborMNx/P8t0wQZ6vL+EU8IHJA45Nml0sgplLwVEZYnza8ONhobcKIxzz8wAdikDllB7CuFNwF5nK9ZG/mLRcNIJruVYrI313NMqDhbfL3odAVzW18qcDqHDZV3YmaEfTZkJ3w4h/uUl+QGSdgV4gArX1dvVXr/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625909; c=relaxed/simple;
	bh=7kI2m5/3K1Dhe2cdOR+bsfl2XDz15SHxvDnmU3q4gy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7YLl/gyL14nEPeLdmSHvvoilh5/hRQAkwYiAg/RqVo3fQd4lfVk8Iur7PlMMNqSCkGmibIGuawNiwVy3grcoVZ5InKx7GVqzM7rDL5y+cxTgK3F4CBXlkPOqT/ASJK2AgW1xUQpEmhyOIVk+FU2hU2o/yitAzske47Ls6IVTHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kyncqown; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kyncqown"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D1A1F000E9;
	Tue, 16 Jun 2026 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625908;
	bh=p0i9lTnut6wmW6RCNkeM7j2ovFHZPFhGATLgzjKW4Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kyncqown2whGdhir872W14cljtUGLfLaAK7+ijTPMUKosHG7Z96Va/sZfpxgVfkzN
	 Bp/cLxlcOgj9shHPlJQ8UUqoRi59JY7JK6W52MrhE1XMVcKx2bnLVGA1o0l21lcPSf
	 5HSiMQIVa2aXvxcNSXb5SMk0PSGfpSA6CLFT3P70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 230/325] memcg: use round-robin victim selection in refill_stock
Date: Tue, 16 Jun 2026 20:30:26 +0530
Message-ID: <20260616145109.861740375@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit c0cafe24d3f6534294c4b2bc2d47734ff7cbd313 upstream.

Harry Yoo reported that get_random_u32_below() is not safe to call in the
nmi context and memcg charge draining can happen in nmi context.

More specifically get_random_u32_below() is neither reentrant- nor
NMI-safe: it acquires a per-cpu local_lock via local_lock_irqsave() on the
batched_entropy_u32 state.  An NMI that lands on a CPU mid-update of the
ChaCha batch state and recurses into the random subsystem would corrupt
that state.  The memcg_stock local_trylock prevents re-entry on the percpu
stock itself, but cannot protect an unrelated subsystem's per-cpu lock.

Replace the random pick with a per-cpu round-robin counter stored in
memcg_stock_pcp and serialized by the same local_trylock that already
guards cached[] and nr_pages[].  No atomics, no random calls, no extra
locks needed.

Link: https://lore.kernel.org/20260521223751.3794625-1-shakeel.butt@linux.dev
Fixes: f735eebe55f8f ("memcg: multi-memcg percpu charge cache")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Harry Yoo <harry@kernel.org>
Closes: https://lore.kernel.org/4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org/
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1754,6 +1754,7 @@ struct memcg_stock_pcp {
 
 	struct work_struct work;
 	unsigned long flags;
+	uint8_t drain_idx;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
@@ -1937,7 +1938,9 @@ static void refill_stock(struct mem_cgro
 	if (!success) {
 		i = empty_slot;
 		if (i == -1) {
-			i = get_random_u32_below(NR_MEMCG_STOCK);
+			i = stock->drain_idx++;
+			if (stock->drain_idx == NR_MEMCG_STOCK)
+				stock->drain_idx = 0;
 			drain_stock(stock, i);
 		}
 		css_get(&memcg->css);


