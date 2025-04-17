Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89C2638A6;
	Thu, 17 Apr 2025 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914775; cv=none; b=OWsFpyTKU1LOu1xTWLYgaWqISsE6v6CYbVQpGQa4j32WoWlTppNSqZhU/c34vvDobHL87BA59fE8I7AwPFDfCrRemGA56GXbZJK4RAz7BE8ne7KT5EiZs4fWug7aOJAUj6lPdX9mx05ugKQ02hLZTCyV0bVIpwJhQgIV2GqxZxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914775; c=relaxed/simple;
	bh=ajPFpkFAuhzwMTDbRnq1cYt5mCF7wSa5sD7pbhO4rbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/koR8eAxEoMUFDfdFi8tG5MlOAWML5KBBPrmlIgmYLn0aTTFLZmYFoDJKt0RgA0GIkZdschEHmKIf+szeYQf08NPBq+Mwcw/IFP0j7Ank6Ci+F358qyrzXDBMt25QztS1ZBVQJsUnsZCz8IXVAZ42h7hYgzzNtt1hKwjfRpRXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvQcW1FV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvQcW1FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0628C4CEE4;
	Thu, 17 Apr 2025 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914773;
	bh=ajPFpkFAuhzwMTDbRnq1cYt5mCF7wSa5sD7pbhO4rbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvQcW1FVl5xrGZl5RwfFhFoRRikfd5+gTACyvxu5VNMgumdH6/OHspDF76NJM+kWH
	 iGTdPMvrHzK4anicfnTtRMqQaUeE7bhh5jXF6AN3v0JmJKVKqQvxrleiwPDeSR/XkU
	 8sEq109qmrvioeQUuOfQd++BLvAPirmK8Uj+yNTE=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 326/414] mm/rmap: reject hugetlb folios in folio_make_device_exclusive()
Date: Thu, 17 Apr 2025 19:51:24 +0200
Message-ID: <20250417175124.544995866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit bc3fe6805cf09a25a086573a17d40e525208c5d8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2499,7 +2499,7 @@ static bool folio_make_device_exclusive(
 	 * Restrict to anonymous folios for now to avoid potential writeback
 	 * issues.
 	 */
-	if (!folio_test_anon(folio))
+	if (!folio_test_anon(folio) || folio_test_hugetlb(folio))
 		return false;
 
 	rmap_walk(folio, &rwc);


