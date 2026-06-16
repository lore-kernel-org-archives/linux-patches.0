Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EB3DC4D9;
	Tue, 16 Jun 2026 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635111; cv=none; b=b21zEXTSlmlxnpyPPV+Zyyk9KQS33mycJQClkAFPlPZLh50qi+mBHv8UShct0ImOzHF/41ag+GFs66Q9VxAIvQnORQeR21K4nKQHD56gbiEIib1fVR48L9NE0zadm3HjQc7zi8lOmz79MSOy+WNOHNrAYkh1I0p3HxSgLTtkX6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635111; c=relaxed/simple;
	bh=NBNhSuJ6oKPUQ7fm9ISoNpp78M5G7N4mf1OZ/i20Mt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFSinRtYXDOVWUtXmZB9Jl8xbH516eYqfvvcDtWfnd5FW/lv7rjkkGxBnSsmkTpiqU6JQbFCxP2PS2TGlrOqpUGrTvtqjFyCa+fsZCRth0J285dr9IBV4b2LTKe+exKVSqfnBV1OjkdGpMFtzyJWhqr9z5cSUue6hTpQlxbTY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM+aKmO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM+aKmO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AEA1F000E9;
	Tue, 16 Jun 2026 18:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635110;
	bh=ANZisJGzyxShD/+bsxZ9eeaHR0oJfCo9/Y3TJU4lPI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JM+aKmO0p2YPX5l9ae9p5P24Q7UQBPQxcHILOC22yH+t2AmXsxeG/JBORlUFOAg4M
	 SykQvQGZ7AKr5S1atkImRvjfgQQ9gyI0P5hetczSUOEORSi71fUXw9B86kqayodhOz
	 np0Z534W0/T36WlWbB8DduoBq5qGKFbMrnb3aAg8=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/411] mm/huge_memory: update file PMD counter before folio_put()
Date: Tue, 16 Jun 2026 20:30:30 +0530
Message-ID: <20260616145122.064997421@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Yin Tirui <yintirui@huawei.com>

[ Upstream commit 8d878059924f12c1bc24556a92ec56add74de3c8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1994,7 +1994,9 @@ static void __split_huge_pmd_locked(stru
 			if (!PageReferenced(page) && pmd_young(old_pmd))
 				SetPageReferenced(page);
 			page_remove_rmap(page, true);
+			add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 			put_page(page);
+			return;
 		}
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;


