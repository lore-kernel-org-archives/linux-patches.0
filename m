Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7171E400DE8;
	Fri,  4 Sep 2026 06:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501912; cv=none; b=rTmB8otRgNcVNSBEqn+mEJ3Y7A7/GQrtrD3nU6J17KwFpbgyU7CjPm8j8U0m3PI4MekgM1xRAcw2f+wUFPw4gq8Sr9b4i51ZLd+nQOvDhCO/ghCx0tgyGMqad9AxZjcckqckQbuRH2jjlF2Y52njF0DI3D/2ur7e3LeVfhannno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501912; c=relaxed/simple;
	bh=DenHX2KyfR+5zQLvYj+DaMWuAmpEgCxFFDmg7dWrvrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q18VpMTgSUTJ9rf5WYMdANqCni11/ZJbzKX+CvpptODqIukcKDCrkCTmimLLfur8aHdFO6qVVrkTfTLD5g5so6cZOcNzeeM7eJxpgAEDdQZ647UvX1WZE4rJ+qe1QLzLwn+Ze2MngKGqH90wLwGCmvNLsVLkLhI9UDNbdOC78Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/YdVBn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/YdVBn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85AC1F00A3E;
	Fri,  4 Sep 2026 06:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501911;
	bh=vbr9p2Zdvwc68xyQfAehncGnHNIvw67Y24DgTom/NK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/YdVBn2zA2tRKS6escgtNW5yjlIvgMnuz1smj5dZcdO4z+EMsIf9Omz1L1X1Xded
	 ugz3hYIbj17fTeyrIrW6SXnS9u/6ZRWNhBnkMcfDvah2MFh9KgkufEE0B77t24BjgX
	 qQu+qOoN9KTXcEFNDbdo1axOAt05tlQhkmLl2kz4=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 023/403] mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Fri,  4 Sep 2026 06:57:06 +0200
Message-ID: <20260904045735.340715126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

commit 90f095b816e25c6a9e4446d299bac5007fdcb3df upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_owner.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -501,6 +501,7 @@ static inline int print_page_owner_memcg
 {
 #ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -510,11 +511,14 @@ static inline int print_page_owner_memcg
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
 
@@ -522,7 +526,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:


