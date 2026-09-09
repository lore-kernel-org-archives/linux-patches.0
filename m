Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB8595749;
	Wed,  9 Sep 2026 14:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963570; cv=none; b=cCj656sHGl1CTS4c5w2UvWTFyEijB0u91GSwbzT4GPSPX+0ZodupYts7tmpArFPpmc35F1EAmU4jqJYHRB2EiGXUNV2wZ6A0k5xEOMgV5qeB/XfSI0DKqihX3eoGKjyJ4SUTI2sNH7K2TIncj5N+76xYmU9SCFME8t2IQBotxR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963570; c=relaxed/simple;
	bh=Di/Ebab8eYKvavUAV2WL/esZ+erDeFX2DfkPR6qA9ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebazvJT4vq5vGm9vRI1PTwx/Cm1VcptHCbkC86HKNG9K2dHAFkzwALsjdF8Q9BmnuEikS4DTB6UTVAkSMmRVF7oA9R7lLKu2MmAbXS0zSIiiBR9krN4XIzCCduFE4pl0J1fDQfythewStoKQq4FipRoSU1IFosOH1YeNvRUgY7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVoyvpaI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVoyvpaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5551F00A3A;
	Wed,  9 Sep 2026 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963569;
	bh=WLp9YcQGHcgO6q8XmKBQ61FTGXb1B2D86xRN9jdq8Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVoyvpaIjiXCLLsJDD5VXmg+czr5j07cDUrhNlhN7c/fvlUD9kasFlSk3zjTBPd/i
	 nRlrHTjo8VHZoe5eeNOJm+QlPaBcYrDJorpLo1GFl0PM8IYlaGaqMMSqx4aEn0AnJj
	 q72rozaiixItvMrkxlXKkl/qhb/5kVgewcDr6gr0=
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
Subject: [PATCH 6.18 117/583] mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
Date: Wed,  9 Sep 2026 15:36:42 +0200
Message-ID: <20260909134242.182387314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -104,6 +104,7 @@ static void hugetlb_cgroup_init(struct h
 		struct page_counter *fault, *fault_parent = NULL;
 		struct page_counter *rsvd, *rsvd_parent = NULL;
 		unsigned long limit;
+		int ret;
 
 		if (parent_h_cgroup) {
 			fault_parent = hugetlb_cgroup_counter_from_cgroup(
@@ -125,8 +126,10 @@ static void hugetlb_cgroup_init(struct h
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
 


