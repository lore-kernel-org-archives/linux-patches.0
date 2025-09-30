Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A90D1487F4;
	Tue, 30 Sep 2025 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244961; cv=none; b=A25fD58gdpca2UtGMwMXIRIqJ0qjtu/NcY8rEFrtqOP4sY0zdx52zkmjHm0oJwr7THE4InkisaCeD7dFkWMwbcdRnYxrq3vV9Eo6uRIUppAHWwuJtEU3W9W1t46eooRrjqS7QO3wuSzzYTRiP5WQPWCCG9nmRti5pGWv4LB0qaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244961; c=relaxed/simple;
	bh=NWXOkMZ1SNVSSNj9qhvZh9VOwkGj4Ndpvlk3YJTJYYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1vK8uMzg12fcXPcCY7wJNQgYsc6F4IM2tcMp25UzOaVzyigS+pj1lnDEEUi6tiPADXDiIEEnb9SVjxV2xkmMq9sepTmMgZEOfh5Hk4oGnGf5KvGItZf/apTKfO+WYj4YJBIToEWpq0ZMDzOab3zix6mgx6u3Y+8WlVk3EUjs9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhhWmbF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhhWmbF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7020EC4CEF0;
	Tue, 30 Sep 2025 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244961;
	bh=NWXOkMZ1SNVSSNj9qhvZh9VOwkGj4Ndpvlk3YJTJYYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhhWmbF8EB3gawCeHGLZXUv+XyQ5Uojn1vHDR8A9/bIYbd5OS3+G5yg5vqf+JyzXt
	 7TvOxfLSoZc9hFWD0rZPVW24WbXdYh9fMyNZOYk/kcuU0jIf4JdSEPfSLMAzpGIdol
	 AcaeJNWF7JPCnDeCkYPLoNexUDAXyj0osW5Hg8H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Alex Shi <alexs@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Airlie <airlied@gmail.com>,
	Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jerome Glisse <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Karol Herbst <kherbst@redhat.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Lyude <lyude@redhat.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yanteng Si <si.yanteng@linux.dev>,
	Barry Song <v-songbaohua@oppo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/151] mm/rmap: reject hugetlb folios in folio_make_device_exclusive()
Date: Tue, 30 Sep 2025 16:45:39 +0200
Message-ID: <20250930143827.968202761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit bc3fe6805cf09a25a086573a17d40e525208c5d8 ]

Even though FOLL_SPLIT_PMD on hugetlb now always fails with -EOPNOTSUPP,
let's add a safety net in case FOLL_SPLIT_PMD usage would ever be
reworked.

In particular, before commit 9cb28da54643 ("mm/gup: handle hugetlb in the
generic follow_page_mask code"), GUP(FOLL_SPLIT_PMD) would just have
returned a page.  In particular, hugetlb folios that are not PMD-sized
would never have been prone to FOLL_SPLIT_PMD.

hugetlb folios can be anonymous, and page_make_device_exclusive_one() is
not really prepared for handling them at all.  So let's spell that out.

Link: https://lkml.kernel.org/r/20250210193801.781278-3-david@redhat.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ folio_test_hugetlb() => PageHuge() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2184,7 +2184,7 @@ static bool page_make_device_exclusive(s
 	 * issues. Also tail pages shouldn't be passed to rmap_walk so skip
 	 * those.
 	 */
-	if (!PageAnon(page) || PageTail(page))
+	if (!PageAnon(page) || PageTail(page) || PageHuge(page))
 		return false;
 
 	rmap_walk(page, &rwc);


