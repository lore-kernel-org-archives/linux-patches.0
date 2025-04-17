Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810BA225787;
	Thu, 17 Apr 2025 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915983; cv=none; b=oXYuW5qRJI968s/VpVpYTVA/WHExVea69FdBHPLtX97I1odcsGpAEPeeQemowp2cbWT9oqUt3qVoh0e6fLqMJlexlFKYWp6zsuj7Ud9GPU9Qn/ps7sooP1rIu7vBK3byT3/B2sdXRVSzLbo6hIJgpEEbviNpj1Nb6l/DsObbOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915983; c=relaxed/simple;
	bh=z6U1NzaYDTS3aTcOj4/EKkQvCvthJ+omQAUqkYIZjKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSJ4ScsYZownVebFcI2gkPQEbTRumOiPimxN1S4mdfZcxDbdaXaQ5zJZYnNAlX16AVmfKXYGj5VR6jMN8e4s1B7MIPyniG55hf0X7o1fknLWk5VCnihvMAQE58Q/gDa72J355mdYJ5J4C/gLA2sDRUP0N8hfp8Z1DWuSXqOXo20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTo6lkAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTo6lkAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F572C4CEE4;
	Thu, 17 Apr 2025 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915983;
	bh=z6U1NzaYDTS3aTcOj4/EKkQvCvthJ+omQAUqkYIZjKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTo6lkAdjkDyzpxGHRV/YH7nAyyfa5FeL88AlME2tK7Qyfe+1rSIfr0RohlsX1J8h
	 CEi4+qDPSLP7MEEjbppPd5UYBDWNLmQsANs1wD4gw0ArXS6WJW1lISqu7F1WHQ2hvA
	 3Aj3QfqOqT5JsD9l2FecIN4CqnmE0DWFPnp8GV58=
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
Subject: [PATCH 6.12 304/393] mm/rmap: reject hugetlb folios in folio_make_device_exclusive()
Date: Thu, 17 Apr 2025 19:51:53 +0200
Message-ID: <20250417175119.838796543@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2488,7 +2488,7 @@ static bool folio_make_device_exclusive(
 	 * Restrict to anonymous folios for now to avoid potential writeback
 	 * issues.
 	 */
-	if (!folio_test_anon(folio))
+	if (!folio_test_anon(folio) || folio_test_hugetlb(folio))
 		return false;
 
 	rmap_walk(folio, &rwc);


