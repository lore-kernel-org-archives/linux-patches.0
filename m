Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63EF23392B;
	Sat, 30 May 2026 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164246; cv=none; b=QGtpw3xuWUyhMeQBqqgQwnV6tc3pNXTEhyctUVvedIwVpYP5j+12LjgKSGbKAdQu+V1WqDQUzWyrn27Fyxh9+PIMX78o4DuKuStvr276hvI0dt2rbjp16IezIqrqVVjEWyzpOxbg7NRG2sPF8iJyasFUZ2h+GzmLwtKLkxyDWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164246; c=relaxed/simple;
	bh=oapsZhSmbtF4y0YNqfVrCZnjNszCujMuFVe0m1FZFPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+SsDBqhiLiUpnfqUBbEh8+6zthHy48GuIFieVMefuip05eCUInuRnQDEmlnLCZJ6jus7ZseuEm6gWSVlJXmnwV63JILVvLxb6Jl4E6mwUvoKiGGgLomufc/bnQ+IyJc4Cl3DnUc5L13Q6+IUQC9ZxdttDI+FC4aowVHtT0AAu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anh4c1jO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anh4c1jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5861F00893;
	Sat, 30 May 2026 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164245;
	bh=3nNDsGeFTNDcAISA82lb6opCg9ArwX3Q+82rDtKYq5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anh4c1jO0Vv1irp7luDI9Yo/pIx9gMqAFdyUb2e5cW8y7J14RqPnnlcrlsQT+nZ+R
	 Z22O8nvkWven0hDVhm4FeukSLdrbc/GITntebddPX/y3SS8S26pmGj3v4FJcLlN0ZQ
	 rIxciegdB8ycPRyKzs8XLS1eqi3frShi/6T8cQBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Chu <jane.chu@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Hillf Danton <hillf.zj@alibaba-inc.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 468/776] Documentation: fix a hugetlbfs reservation statement
Date: Sat, 30 May 2026 18:03:02 +0200
Message-ID: <20260530160252.443547788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit 7a197d346a44384a1a858a98ef03766840e561d4 ]

Documentation/mm/hugetlbfs_reserv.rst has
	if (resv_needed <= (resv_huge_pages - free_huge_pages))
		resv_huge_pages += resv_needed;
which describes this code in gather_surplus_pages()
	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
	if (needed <= 0) {
		h->resv_huge_pages += delta;
		return 0;
	}
which means if there are enough free hugepages to account for the new
reservation, simply update the global reservation count without
further action.

But the description is backwards, it should be
	if (resv_needed <= (free_huge_pages - resv_huge_pages))
instead.

Link: https://lkml.kernel.org/r/20260302201015.1824798-1-jane.chu@oracle.com
Fixes: 70bc0dc578b3 ("Documentation: vm, add hugetlbfs reservation overview")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/vm/hugetlbfs_reserv.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/vm/hugetlbfs_reserv.rst b/Documentation/vm/hugetlbfs_reserv.rst
index f143954e0d056..1c238b10e1772 100644
--- a/Documentation/vm/hugetlbfs_reserv.rst
+++ b/Documentation/vm/hugetlbfs_reserv.rst
@@ -157,7 +157,7 @@ are enough free huge pages to accommodate the reservation.  If there are,
 the global reservation count resv_huge_pages is adjusted something like the
 following::
 
-	if (resv_needed <= (resv_huge_pages - free_huge_pages))
+	if (resv_needed <= (free_huge_pages - resv_huge_pages)
 		resv_huge_pages += resv_needed;
 
 Note that the global lock hugetlb_lock is held when checking and adjusting
-- 
2.53.0



