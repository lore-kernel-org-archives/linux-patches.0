Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC93B8124;
	Sat, 17 Oct 2026 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255250; cv=none; b=kGy+oCcPi4mCtYyw/wbrfcUvhHHR5HF6VhjClMI6LGgkCzFqevyC7nmOud06Z3eO27QCMV+G30iT4TVaXwIQvoFSFHRCi0PLm8V2kOW4QWFFD6isVWMCvfDnDLuFQ0etdnDeP4BfGCtqmApkZ0NuGuuNp24QFsuXbzfntnUmaV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255250; c=relaxed/simple;
	bh=la6wQiPVnbbnFIcsLwabCdTrtNOPnp+/3ib+3wymmDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3sBU5Cn7XL4szVPofdlqHGv11u0MnTE7nm78G0J/euvVz1vjaJVaMLn5lEklIeLXVJ19kz5V3msvxCSTAkd/ub3AIPWCksSbwdTWfGRxonQ/DPY1g+nBahmR15RdnFFcmoBrx0ZXc+rbquPL3iNl3zRYubtuXIT8/Icpqw0mJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJAmy0z4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJAmy0z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B271F000C4;
	Sat, 17 Oct 2026 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255248;
	bh=eV5BhbjV2vFyXzZYPzBx1eYpBSILXidJcEnvlN5JbWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJAmy0z4Awl5yikXdLW3V5u4uxpoFR48Vn0YS6t+F9h17JraAAx3v3nWXn3T/0eL7
	 d+Ipseki2Z9+rKnO82xlH6i6jGM3oiD0Xh1OozhjAzDpMnsKy8kwPLV+H6lunLZLy9
	 dCcoBu5U2exboZpZLqlTpnzhbkbSV87dSPHynO7c=
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
Subject: [PATCH 6.12 715/869] mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Sat, 17 Oct 2026 17:59:16 +0200
Message-ID: <20261017160055.290607960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 mm/page_owner.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index f92cec789eee5..5d1c946c0008f 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -501,6 +501,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 {
 #ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -510,11 +511,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	if (!memcg_data)
 		goto out_unlock;
 
-	if (memcg_data & MEMCG_DATA_OBJEXTS)
+	if (memcg_data & MEMCG_DATA_OBJEXTS) {
 		ret += scnprintf(kbuf + ret, count - ret,
 				"Slab cache page\n");
+		goto out_unlock;
+	}
 
-	memcg = page_memcg_check(page);
+	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	if (!memcg)
 		goto out_unlock;
 
@@ -522,7 +526,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
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



