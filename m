Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C39143870;
	Thu, 13 Jun 2024 12:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280400; cv=none; b=G6OCnau5FN26J1AdxEkjc20AhL/uTMCPZtsgtO+6YcnNl031CekVS3ankRsR6pKVD4PCK1F4AlY5ehWimPP4nF8F1AHs6NLZnv5Ke1L9Zpou2hwm42h2QDfkijNBEo9DD9KAuiY4iBB5YvU/bRODaW7WxjaIballFxAhdtGyA5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280400; c=relaxed/simple;
	bh=1yN2LBIEfMM7qKBIaMjL0T/XI+dICbYRGXQlP2JWkQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNY1eHrZIfToR7WnjjFC/h6UToyjvbVwS42Rhqps6elNgyURKlrQ0/praX7oQXgFq7/KTY0rLNsdwJ87VwnrpBuzhInEIVrq1qSqMKdYx000BqhtxYORjQHMSXV/IQ+7CDxuC/B/Pwfe8f3D+0liM3aB/6AF/ClY4+EgRJIIh68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tNVmkj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tNVmkj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5357C2BBFC;
	Thu, 13 Jun 2024 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280400;
	bh=1yN2LBIEfMM7qKBIaMjL0T/XI+dICbYRGXQlP2JWkQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tNVmkj+/dvdiwhjyjQqDy55AHPxMiFvsFw2GQaHZbKxdPrb/+k2rG/QeSQO5dXb9
	 6uIbzLzUFp9qI4rHx6JvNB093e9Ij6n/2QHDBJcNBn8+Mb7vp1emKGfYV+qI5Zf+yv
	 z/Sc1X+nsPBf6ndOHbSc9ptW599G2FlKOOep+Lns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 6.6 010/137] mm: ratelimit stat flush from workingset shrinker
Date: Thu, 13 Jun 2024 13:33:10 +0200
Message-ID: <20240613113223.689615373@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeelb@google.com>

commit d4a5b369ad6d8aae552752ff438dddde653a72ec upstream.

One of our workloads (Postgres 14 + sysbench OLTP) regressed on newer
upstream kernel and on further investigation, it seems like the cause is
the always synchronous rstat flush in the count_shadow_nodes() added by
the commit f82e6bf9bb9b ("mm: memcg: use rstat for non-hierarchical
stats").  On further inspection it seems like we don't really need
accurate stats in this function as it was already approximating the amount
of appropriate shadow entries to keep for maintaining the refault
information.  Since there is already 2 sec periodic rstat flush, we don't
need exact stats here.  Let's ratelimit the rstat flush in this code path.

Link: https://lkml.kernel.org/r/20231228073055.4046430-1-shakeelb@google.com
Fixes: f82e6bf9bb9b ("mm: memcg: use rstat for non-hierarchical stats")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -664,7 +664,7 @@ static unsigned long count_shadow_nodes(
 		struct lruvec *lruvec;
 		int i;
 
-		mem_cgroup_flush_stats();
+		mem_cgroup_flush_stats_ratelimited();
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,


