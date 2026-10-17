Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4923B71A7;
	Sat, 17 Oct 2026 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260323; cv=none; b=BdpAvdz8c4yEUP9VBZ4Cemtowq4HqaLWvzcnY9R5mOx5kVC4objgCzFpR+Kn9qG9xnYkGV/oIxc3qQ25IKmp+Tr2HJAYtt59nYENpGgSNw+IvlfGMUz5+DoFzS90EmnkCtCHLZZFOESehDBGL5a9T36q7YnMTIaIIqno/ubWL1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260323; c=relaxed/simple;
	bh=xBGI39P3c5xTBwsSdgMFZacDataCLvuqLYTPzqFn/eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjH4PRTs3pbadqGg+UbgmyeELBSd/+z0FymbYEBzNxuVE20GoH5Kam/gpt3HVPDORieJ+Mrlza7eL5p0/fodNg/VqFAN/uVzZthellVQMNePNY1fOhyANvDHNVTsUZOsLDQnnyOAhGnWvMZhCCfTj9F4zqXYtA3eY5KLhLvYD9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5OvfnLv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5OvfnLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E91F000C4;
	Sat, 17 Oct 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260321;
	bh=K0+DE5x7OwUk7jx0g5uO0wPmWCxZHE5bIjJ0QM+qnE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5OvfnLvj6lMElsHU06Sg8ghID/FApSZqSkwusaiSVCrZlrjNWMVipx9Z2PxHFhZm
	 rfvpU5LDbPuDkpSVBkSqMQS+osXlhQy1YHh61mHEgYy4U1y2QGAM0C8IU517aurDNj
	 ybNGEY16YI+Qq2BGbA6Z4YMw/PnePGu8jRkaVVzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Liu <ye.liu@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1507/1674] mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Sat, 17 Oct 2026 18:02:59 +0200
Message-ID: <20261017160509.813988737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Liu <ye.liu@linux.dev>

[ Upstream commit 90f095b816e25c6a9e4446d299bac5007fdcb3df ]

print_page_owner_memcg() reads page->memcg_data via READ_ONCE() at the
start to guard against tail pages and NULL data.  However, it later
re-reads page->memcg_data locklessly in two places:

1: page_memcg_check(page)

2: PageMemcgKmem(page) (via folio_memcg_kmem(), which includes
   VM_BUG_ON assertions for tail pages and MEMCG_DATA_OBJEXTS)

If the page is concurrently freed and reallocated as a THP tail page or
slab page between these calls, the VM_BUG_ON assertions can trigger on
CONFIG_DEBUG_VM=y builds, crashing the kernel.

Fix both TOCTOU issues by using the memcg_data snapshot throughout.

Link: https://lore.kernel.org/20260714015117.78351-10-ye.liu@linux.dev
Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_owner.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 4e2723e1b300d..3f539928324a3 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -363,6 +363,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 {
 #ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -372,11 +373,18 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	if (!memcg_data)
 		goto out_unlock;
 
-	if (memcg_data & MEMCG_DATA_OBJCGS)
+	if (memcg_data & MEMCG_DATA_OBJCGS) {
 		ret += scnprintf(kbuf + ret, count - ret,
 				"Slab cache page\n");
+		goto out_unlock;
+	}
 
-	memcg = page_memcg_check(page);
+	if (memcg_data & MEMCG_DATA_KMEM) {
+		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		memcg = obj_cgroup_memcg(objcg);
+	} else {
+		memcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	}
 	if (!memcg)
 		goto out_unlock;
 
@@ -384,7 +392,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
-- 
2.53.0



