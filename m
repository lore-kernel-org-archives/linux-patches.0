Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081544189B9;
	Sat, 12 Sep 2026 09:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205109; cv=none; b=c+shrCLhfS9CPQAslA/ICuqBK7GPKgB9I5mN3KlKA8odqVDbK7PrECGwFrn8k33wCdy5XGeXLkIUzBRrgJsYBMuDK6OeicTaBP78cZuEZx/rvBKDKUBH4HS7b9RYJuhGSX24PwCzdITn8soWu5eSYGSRmH7u7cvOn7fokAAIcOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205109; c=relaxed/simple;
	bh=shgqGZBEjq3wtQmcwIo3CLuI6MMwOZ+hgtVjCpca5AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipdSqBJwRe4VZhCmjCYxlK3pFov9qG5oOByaaw5kSlYNtzzWyrNF35qI+n8UHUfJiAocR1UqQZFZT77OydZxi42cwo6sJuf2ee801UKFEzAh5V5H+3gYmRK3/7N1XvCTKbJKMga5YuZIdNZq6lzriIzCWLYfhoJgNvEGPkF58Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCbo4+tz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCbo4+tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52211F000FF;
	Sat, 12 Sep 2026 09:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205107;
	bh=dYYcHcozJTn+DuU4rdhhSPhSZ9wGVr+kCgDsJ41RWIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCbo4+tzjDtgWxOO3rshynqgRsBxpmLN2/ELX+oC0Cjyo6h8ILhKlbyS96JaLaxzu
	 IDfjLgQFhFDnNTAsIwLBCXxyzcE7PIroN5LsU4M6/PsgfoZYA7gbvrDn0t1bDngdnN
	 +HPH0qmOSrZh8uj8zzB+ZCsGMaJrr8A2YSN37YNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	kernel test robot <yi1.lai@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1751/1815] mm/memcontrol: avoid false sharing between vmstats and events
Date: Sat, 12 Sep 2026 08:58:21 +0200
Message-ID: <20260912065730.091720025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit c1afbd5de131f5e3c4fc7559acf055f8d9d86868 ]

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank struct
vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.  This
moved memory_events_local[MEMCG_SWAP_FAIL] and the hot vmstats_percpu
pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap disabled,
generating about 20 million MEMCG_SWAP_FAIL updates per 60-second run on a
176-CPU test system.  Those writes bounce the line while memcg statistics
paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the test
system with one socket.  The patched kernel brings the performance to
within 0.5% of the parent which is within the observed boot-to-boot spread
(up to 1.2%).

Link: https://lore.kernel.org/20260817103835.2937733-1-usama.arif@linux.dev
Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Tested-by: kernel test robot <yi1.lai@intel.com>
  Link: http://lore.kernel.org/aoAABX59IzUXz/Rv@ly-workstation
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8170bb8066a22..32621fa690ac7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -270,10 +270,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
-- 
2.53.0



