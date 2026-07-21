Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A718219049B;
	Tue, 21 Jul 2026 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654505; cv=none; b=g/9jHa2TqAwxciSIhyXRXWLRGoEQ+tKGjbgknLGLMmAQ21kbJwZ5G91qo3w0dhqt/4zC6a0OT1cTDqLGZisPtvjuPxlXeksAJ9W+dcFfo80OPvwTgYWO0q7WaWkrntCYrmPcpaabmGYskSWN9ZydpRKupuhsnOzyW3oZkbJBMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654505; c=relaxed/simple;
	bh=6xkO+7BKkeMRmDvqwSCnsNh+pje1NoyqL4YV5sWcDYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6+QbZXgdCx6FHOCeE9r/O3fFj67kmUl0qs0Rg//ze8OoEmsdB2n8pxZqk0J3NXw4oZ7uR90BnltW4SLjSYoUbhpLeUVbVk3TZ6Jjtpy309hdjlnX6u3vLmtwNKVMNou7NmQ9Njp1K6/kVjtbURgGdU5FMYRgV+DjHAc3BFcQu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWlsLc/v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWlsLc/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B7B1F000E9;
	Tue, 21 Jul 2026 17:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654504;
	bh=lcW2ve7LgVqzoOheFBBUfeKN6xPR9rYo55rxTLOS5WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWlsLc/vSOcF1TQxi625En2rBaFhD/8zI0PIoA5fbET7ZwDKWFxHK0/vowker7jKz
	 Ny11h9aJ2yepBvsxTDxHVwM3AGVAOwJoVE6Va2DxXzIi83PiiEeg22KPjpe/PtqxkX
	 rjAuwktUOVSjtlGDY3CVm9fogiUuNrVkyGSO6R5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1730/2077] fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
Date: Tue, 21 Jul 2026 17:23:23 +0200
Message-ID: <20260721152633.553920272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 1b074e3270e1c061c829150c742eb83bad4dddd1 upstream.

The partial-page check compares against HPAGE_SIZE (PMD_SIZE), which is
wrong for gigantic hugetlb hstates (e.g.  1G).  The walker hands the
callback a huge_page_size()-sized range, never start + HPAGE_SIZE, so the
comparison always declares it partial and aborts the WP.  Compare against
the actual hstate's page size.

Link: https://lore.kernel.org/20260529172331.356655-3-kas@kernel.org
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2873,7 +2873,7 @@ static int pagemap_scan_hugetlb_entry(pt
 	if (~categories & PAGE_IS_WRITTEN)
 		goto out_unlock;
 
-	if (end != start + HPAGE_SIZE) {
+	if (end != start + huge_page_size(hstate_vma(vma))) {
 		/* Partial HugeTLB page WP isn't possible. */
 		pagemap_scan_backout_range(p, start, end);
 		p->arg.walk_end = start;


