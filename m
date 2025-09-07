Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF697D528;
	Sun,  7 Sep 2025 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276699; cv=none; b=YXsfBHeeGe1JKMVD0nZEPmIrp6o9eD38LTNuS2sE3+EY20LQUl/TlqB0tMyg2Nv9SjrRRwg+ZvZYIGoBiFsP3PAfMwBeh5Agwlc3N0ACm1PBr2PTRdf4OpgQi/4Zww++dr2IU+hy1JmcOZzfn8uUks4s+t5epC85021HMPifA24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276699; c=relaxed/simple;
	bh=UMSmyIRqCohQZyOI6fG6GNHvQr4QEjKuXOMTmnOD29Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwLZ10rfzBhEe6I+1KffgxkdckENXL5TDUWhGDIjg+uUF0n+ZKqsywD0OiHRuAP5J9jaURGmu7jgxtRkOFhGlBX8JkRX7tat0tim2eHnnTEg8mFgrsfFAWdZnYqvBubtAIPCX9RsHqjk1EvlUosg7wf5fLGWpsUS5OmYOtRgmOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eifVOTTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eifVOTTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657B2C4CEF9;
	Sun,  7 Sep 2025 20:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276698;
	bh=UMSmyIRqCohQZyOI6fG6GNHvQr4QEjKuXOMTmnOD29Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eifVOTTvYFtXzjig9JbSzW/go1HvXsRD+dH0oEXFEPilH3GHHU35dwxDuZSbOSOmb
	 9THnxH0yjTie0nzMUG+S174O4pva0IQ+Yr9bYw0c13hF1eC6n6U9rGeaRp0KeKVEfi
	 4qKwNEshOI8Evw7bCgRYHPe5olU6EHE2y8bIBPWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/121] memcg: drain obj stock on cpu hotplug teardown
Date: Sun,  7 Sep 2025 21:58:37 +0200
Message-ID: <20250907195611.916719134@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 9f01b4954490d4ccdbcc2b9be34a9921ceee9cbb ]

Currently on cpu hotplug teardown, only memcg stock is drained but we
need to drain the obj stock as well otherwise we will miss the stats
accumulated on the target cpu as well as the nr_bytes cached. The stats
include MEMCG_KMEM, NR_SLAB_RECLAIMABLE_B & NR_SLAB_UNRECLAIMABLE_B. In
addition we are leaking reference to struct obj_cgroup object.

Link: https://lkml.kernel.org/r/20250310230934.2913113-1-shakeel.butt@linux.dev
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2376,9 +2376,18 @@ static void drain_all_stock(struct mem_c
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old;
+	unsigned long flags;
 
 	stock = &per_cpu(memcg_stock, cpu);
+
+	/* drain_obj_stock requires stock_lock */
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	old = drain_obj_stock(stock);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+
 	drain_stock(stock);
+	obj_cgroup_put(old);
 
 	return 0;
 }


