Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42DF43D504;
	Tue, 16 Jun 2026 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623876; cv=none; b=ArX/rkCMl37eVukRp+FEGg2XsvzfA5D2krvLOXhSGr90hZolcdbpIGqFShVsVEcMtIm8hGLXwjz4tbGU+hDYiw4/TjMECaNq3qvDwHAilqb4xXKIZHA6Q2+YSNdvc6mSDefhcxvUC8+Whi6/6FLS51xg8PAARA/N7WGWrqM6QzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623876; c=relaxed/simple;
	bh=xuutsi/O0niwvHQzV5iUnRd4XvJOfk+GFqrO08xWNv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u17nTuc0y/txMA6k1nKpAT3OnOriAxhVq8IUOYy2Y7kCiiJuM9wg7LikOV51GBkqAcOw1iD5dqshku57IfRjvTbGEoXcnTtFA+hNgWx72sUQw5e63DTGxji46Hjch4QSIKn2xGd+YiJ0sogArIGuN8M4xnQv8nt+y/WwLryVGbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDoT1jgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDoT1jgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A251F000E9;
	Tue, 16 Jun 2026 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623875;
	bh=KXbxqmMdGbDYeLkWGhi1c4Xp0luCqNGlMagcS8XqYTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDoT1jgsXaiK9CwcXzKyciN9GWwTbIUab2NO5WoLVrAPMSfE15DUUp2VBLTA1Efiy
	 OogH0hcM0BbwQmguG1E1W/vaMfGQYtoHHb3xyVeW8oAHS+9sH90/rXPtd7XJPQW+H5
	 +ZezGOmdT0jisyTHc6DmPRsi02CG22CZvUmHx5aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Tirui <yintirui@huawei.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Chen Jun <chenjun102@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yang Shi <yang.shi@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 218/378] mm/huge_memory: update file PMD counter before folio_put()
Date: Tue, 16 Jun 2026 20:27:29 +0530
Message-ID: <20260616145121.800766982@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yin Tirui <yintirui@huawei.com>

commit 8d878059924f12c1bc24556a92ec56add74de3c8 upstream.

__split_huge_pmd_locked() updates the file/shmem RSS counter after
dropping the PMD mapping's folio reference.  If folio_put() drops the last
reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Link: https://lore.kernel.org/20260526101337.1984081-1-yintirui@huawei.com
Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3031,7 +3031,9 @@ static void __split_huge_pmd_locked(stru
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
 				folio_set_referenced(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
+			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);
+			return;
 		}
 		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 		return;


