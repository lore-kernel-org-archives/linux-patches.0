Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC4A25D525;
	Tue, 25 Mar 2025 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906365; cv=none; b=qmPsObeDh8V+ftAb627Z5yBMMB8iGkALT5Q+WpdqaQ54orBiEGi8pyWz9uanSQEPhrZhHORibDtbrfCtHhoUBSa+WEhSBWntQGPFszHviWZNM5DmG3kyUgGyX4Rs9QgigaI3VYK+wkW6z5I4lWpRjrAs1VyAOxT1PKVNzYVtdnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906365; c=relaxed/simple;
	bh=Nmr/wWMsFqfEfKXU9OrY5uhbIXY51NcGKFARWzCq9QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViFI9w9wtegbP/D2OYeXKupA1BeuSVeDizxZEJrKLxoGDhC8ekMU0HdSRBaj/s/6I+5N2jMFNEzdAbvUT9NHXX5fGT5U1sUD22pAW771Yp5XZtIzaE7JgyR23AUe0TQhvXpENK+vcbMa7PmQ8eUpjK6AQpsI9Ta+bfP4eVCx0ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjvPiwnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjvPiwnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63151C4CEE4;
	Tue, 25 Mar 2025 12:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906365;
	bh=Nmr/wWMsFqfEfKXU9OrY5uhbIXY51NcGKFARWzCq9QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjvPiwnvL7W2qqeaIy1ekKy4PSD54Nl0Oq8j+g6drfBLUUQ0R2ZD8bfvB3Zv5xGy9
	 w3iZGjvjfCgr3MmO00Y1/E1u9mNy3oOfG4g19Rw32EY9W1Pca5FWXtlffatec1Q/Pu
	 l7p8XPIMokMBTfBzSc0KyXuVJ+T94ewayuJn46fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 079/116] memcg: drain obj stock on cpu hotplug teardown
Date: Tue, 25 Mar 2025 08:22:46 -0400
Message-ID: <20250325122151.229353306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit 9f01b4954490d4ccdbcc2b9be34a9921ceee9cbb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1882,9 +1882,18 @@ void drain_all_stock(struct mem_cgroup *
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


