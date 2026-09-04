Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7CF3DAAB7;
	Fri,  4 Sep 2026 05:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498436; cv=none; b=RmEKe0A8J8s7iBo4QMwoCQU7DHi7Mj+CrxTZaFarAE0OWqN/kr1ijoxq2D2KEutMbau5M5WY1fwhSzIm93mV8m4Hi+InHPDHhqHR2KRd7bxzioztInZ7HMaKY80NapINBOApha3NfIDREFNR6m56nc4mBiOgetcxJf3/HgwFNoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498436; c=relaxed/simple;
	bh=ruxHvggCYUzrOgNWhB1GV/iSbaHsCapVzCPWDWL7kkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shdsb8zC4RLLSOcN6y4cCIHiJPKEWRlkD3U4P4PrYGA4TN9RFVa/54D6E7TYfx5/OdDQpfdEb3tpTH6JPMZu5kVRr0JNSYdJdm9telfcwVzLPETLr2EiCRlI7xvqQS5qXhVrNL1i46jp+090fsaY+TOEZbQzPLFA4CL5M/PM3R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dK6aJQ3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dK6aJQ3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1441F00A3D;
	Fri,  4 Sep 2026 05:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498433;
	bh=UwhV80x/vJwhO++AVyLRP0PCw54N0UUyfePTQWE1NLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dK6aJQ3TbH14SnNMgA2SWAIUJ1rxYBIXbsikKIS0ufxUs27WjrTvVGo4nLVwMjC0U
	 PKJ3beTmMgEy6jeRrVxdjhTTgoOIwaf++1p/4nZ0AgBPK8JLSWguVw1/moJk4uEyL+
	 OlBAOkcy5DXtVyue7fJj6zKJPOFINRawjknkWkPw=
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
Subject: [PATCH 7.2 061/713] mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Fri,  4 Sep 2026 06:50:29 +0200
Message-ID: <20260904045805.204324545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -513,6 +513,7 @@ static inline int print_page_owner_memcg
 {
 #ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -522,11 +523,14 @@ static inline int print_page_owner_memcg
 	if (!memcg_data || PageTail(page))
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
 
@@ -534,7 +538,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:


