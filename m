Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B790F423A85;
	Wed,  9 Sep 2026 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962216; cv=none; b=Sq9DXw9QORIPk87MR3P9yDbvO4D1ufUyr5w1PzMzCpFeFcVQ1gYgEFwzf0jUFKcK187KOuWqBcthAUxwR3SLiajvAbmklRm5AEHuIT4cdjUqvSErhouCxj81gb5tZmrN7RbKIirzw9bkgD54iTyFSSD1K1M2ngGOCYEmDoNDfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962216; c=relaxed/simple;
	bh=EXXHzQcA96A5FIClnQikAE0/vzicEnE5dLsbu6Z3Da8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7QbHnoCWZzYVmtrnSZbdaYE338pFacxfvQl5I6xYl6XoikV27F3EWWJpgJuAzBoxq01pY259VkHbPEN4B5IolkjCB3G19g1hiqQbb4WRX+aPUtdgDhYBLhKaDcZlzyGbagn+q5mVbzzA7l5AJ/aT4mwbibyzoejQquxLfvsW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v27/aRcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v27/aRcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDB71F00A3A;
	Wed,  9 Sep 2026 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962215;
	bh=n57qwtGUVUOFo87lNTpWEygGb3hu4WqZBu74+4Jhcm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v27/aRccCbBvjGPQN4oRHX72IGVjmyuRas3biBpJ/gZAbm0QrMXOkxxvVmbqZEokF
	 LFmQsHOfFV0nRuvSKZkNYVNxmSTfYGHESmsV3nRqS7Jlw1Io4SuwXaI8/xv3VS97TO
	 NAKuCsTTiayWKkD5c4MvvHxJOmTa9UF4qwwAbssY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narek Jilavyan <njilav@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 173/556] mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
Date: Wed,  9 Sep 2026 15:37:33 +0200
Message-ID: <20260909134236.505299924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Narek Jilavyan <njilav@gmail.com>

commit eedc8474d469a2e88f4dc61f8cfe05c147478b43 upstream.

hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
the huge page size and then applies it inside an assertion:

	VM_BUG_ON(page_counter_set_max(fault, limit));
	VM_BUG_ON(page_counter_set_max(rsvd, limit));

With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
i.e.  ((void)(sizeof((__force long)(cond)))), whose operand is never
evaluated.  page_counter_set_max() is not a predicate - it performs
xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
never applied and the counters keep page_counter_init()'s
PAGE_COUNTER_MAX.

That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes the
same rounded value and uses equality as its "unlimited" sentinel.
PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is odd,
so round_down() really does change it and the two sides disagree.  With
CONFIG_DEBUG_VM=n:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	9223372036854771712

and with this patch:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	max

A debug option should not change cgroup output.

Call the function, then assert the result, as v6.12 did.  Use
VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are identical
under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not use BUG()
variants.

Link: https://lore.kernel.org/20260817103433.191266-1-njilav@gmail.com
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Narek Jilavyan <njilav@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -97,6 +97,7 @@ static void hugetlb_cgroup_init(struct h
 		struct page_counter *fault, *fault_parent = NULL;
 		struct page_counter *rsvd, *rsvd_parent = NULL;
 		unsigned long limit;
+		int ret;
 
 		if (parent_h_cgroup) {
 			fault_parent = hugetlb_cgroup_counter_from_cgroup(
@@ -118,8 +119,10 @@ static void hugetlb_cgroup_init(struct h
 		limit = round_down(PAGE_COUNTER_MAX,
 				   pages_per_huge_page(&hstates[idx]));
 
-		VM_BUG_ON(page_counter_set_max(fault, limit));
-		VM_BUG_ON(page_counter_set_max(rsvd, limit));
+		ret = page_counter_set_max(fault, limit);
+		VM_WARN_ON_ONCE(ret);
+		ret = page_counter_set_max(rsvd, limit);
+		VM_WARN_ON_ONCE(ret);
 	}
 }
 


