Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585543;
	b=gFg7+bWxianhl0T4QcN05iC5GQEkSkfqXv21wwwO+2ABQItSm2oeos6aDfhJbdAdF6h4
	 vCnZC+mqU1393N4ZuHe7ndFRzRizu9/CkDW4rYnxU7s1GVQBuxlswQocPU/avwwbGN+Dt
	 bNECH4dM86o1QVsXHnN7BQz0noW1aGXnfenRo6vVjm2XkNYrapXVF19KcGmri7bFA1ab2
	 mUnWtIde68BfEAf+zyXJD18nxaBgOaODwHoYBYrSObL4N2eJpCTAdkn07utGvEn93niGw
	 smIScZBa5C9myiPC/dzMEi9APhELyW3WhNjy+cm4Yod84j1gn1nOXghlZnsbBuI8Yhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yAvkyDb/qVlextLvZBgrEg4F6McJuaHfgbLmPG0y5tE=;
	b=1Fw5QaFcPt07AAzAQt+fP7f513oKAXqVrktUcouNVfQFoQQ2bHuZNe5abf8eqQqh75Uk
	 6GNbdymhuwL6vD1csSBWfpj81Cz878RQsketaaGmVtrtPBr95WKclVrWe7VoXLZy4K5vU
	 797zwmRvjB5WeXOFUjWoZ8D4JcITBo/ei7RFdDJkgrA1oe3j5DnpxLLKqGgYHquC8cZuN
	 daM9ON+82C41P+C4yQvOKBIayim2iGlPRIT1D5pyxxdPbzGG3STjlHYhcxUezawRSsYZ9
	 oDlrDtiERgnVop8InMEhZ9sovqCXokcjN5AYxcrTDIkIkhPnSYle18zYdY1d18ObLIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mel+AffR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5684606A883;
	Fri, 13 Nov 2026 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mel+AffR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37111F000C6;
	Fri, 13 Nov 2026 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585543;
	bh=yAvkyDb/qVlextLvZBgrEg4F6McJuaHfgbLmPG0y5tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mel+AffRu3OzJB5QfwMNBaz+Acf5mA+WW7X4Qz76tGq1X8aIOO574VkdF/5qeOfCu
	 ZNIi9RL2Zo9rJZU4B+MwydpFPiU/R2tI+MExtRPwsehyCpGt8sdvXn//v0A0kzIeYP
	 /SV70+WbaHWBp+KqH+a6KrsNqWDK4vR9VzXmjS74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Rik van Riel <riel@surriel.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	SJ Park <sj@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 145/507] mm/mglru: dont use stack pointers when walking PUD and PMD tables
Date: Fri, 13 Nov 2026 10:47:29 -0500
Message-ID: <20261113153759.349146284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 65a9bf08a3e4d6e58df211ed900c16bafb79b267 ]

MGLRU passes stack copies of page-table entries in walk_pud_range() and
walk_pmd_range() when walking to the next level. These copies can become
stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
table concurrently.

This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
support page table walks"). Likely, earlier locking masked the latent
bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
retract_page_tables() without mmap or vma lock") allowed concurrent
retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
for MGLRU") dropped the walker's outer RCU protection.

The fix is simple, so just fix the original commit so we don't have to
speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
RCU-protected lookup and validation against the live PMD. Note that the PUD
handling is required as well to handle folded page tables correctly in all
cases.

Fix generated by an LLM and sent by Josef Bacik in private.

[ david: handle walk_pud_range() as well, clarify+simplify description,
         adjust Fixes: ]

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Link: https://patch.msgid.link/20261031-fixes_core-v3-1-d6437171ecc3@kernel.org
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a53762d55447..963cdd67039d1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3771,7 +3771,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -3807,7 +3807,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
-- 
2.53.0



