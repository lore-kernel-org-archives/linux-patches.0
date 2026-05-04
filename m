Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2E529E116;
	Mon,  4 May 2026 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904514; cv=none; b=eTuG1dhZl8vXkwEwqYv3jEGFOBm4aqvfU+CuxN3rzi9PajVmh7mldFfOvQD6QH4l3zifMozchAbkha/Y2bELgut5YYSzDo4CXRrox3lVCN97W9K/GLQDHaSMjLXvf3gon3vArNNYTyHRDn+Lqvgw9kKjZXOjmCVOe0bkOlZFvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904514; c=relaxed/simple;
	bh=3lSvyk/ezsF2m/sYUOVHlGEhr7WwGs8cU3ZPB5rN8R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6WBf1hWdZGm3rEzZj6RjMECbuK/e+sIEe0U1iJUoiQf4/hUnZaqamn/3oriTVXYOpAlKOJRKNk++T8Nqk8JnO49Xk07Kna/X6993lgYwEKP/0Lgz25I7vXJD+ayPign+/p5Z5g3YXWmYvSysdEJMOsk302aGm7o9w5+2gUCZYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PnR5zK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PnR5zK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A853C2BCB8;
	Mon,  4 May 2026 14:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904514;
	bh=3lSvyk/ezsF2m/sYUOVHlGEhr7WwGs8cU3ZPB5rN8R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PnR5zK2CPl+jSPTZ1S431ic+LiZiaT5BwXT6KDhZILf8INWg30l3O3wuFWm1N+sf
	 B58g01/n4bfCqpdU9d4d03Zzqq1JDO0M7n5nfiU1kgvBe0+sQL2kMefxEwUAgZupRi
	 54h9jnLlWZYstn1vlT3sIpPG5ysy7bEKOMSVtioA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Raghav <kernel@pankajraghav.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/215] mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Mon,  4 May 2026 15:50:54 +0200
Message-ID: <20260504135131.460056540@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 397f6d14f9c370e4910e6885294c340f39dedbf5 upstream.

In do_migrate_range(), the hwpoisoned folio may be large folio, which
can't be handled by unmap_poisoned_folio().

I can reproduce this issue in qemu after adding delay in memory_failure()

BUG: kernel NULL pointer dereference, address: 0000000000000000
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
RIP: 0010:try_to_unmap_one+0x16a/0xfc0
  <TASK>
  rmap_walk_anon+0xda/0x1f0
  try_to_unmap+0x78/0x80
  ? __pfx_try_to_unmap_one+0x10/0x10
  ? __pfx_folio_not_mapped+0x10/0x10
  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
  unmap_poisoned_folio+0x60/0x140
  do_migrate_range+0x4d1/0x600
  ? slab_memory_callback+0x6a/0x190
  ? notifier_call_chain+0x56/0xb0
  offline_pages+0x3e6/0x460
  memory_subsys_offline+0x130/0x1f0
  device_offline+0xba/0x110
  acpi_bus_offline+0xb7/0x130
  acpi_scan_hot_remove+0x77/0x290
  acpi_device_hotplug+0x1e0/0x240
  acpi_hotplug_work_fn+0x1a/0x30
  process_one_work+0x186/0x340

Besides, do_migrate_range() may be called between memory_failure set
hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In other
places, unmap_poisoned_folio() is called when the folio is isolated, obey
it in do_migrate_range() too.

[david@redhat.com: don't abort offlining, fixed typo, add comment]
Link: https://lkml.kernel.org/r/3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com
Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0a42e9a8caba2..16d788547b9b6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1802,8 +1802,14 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
-			if (WARN_ON(folio_test_lru(folio)))
-				folio_isolate_lru(folio);
+			/*
+			 * unmap_poisoned_folio() cannot handle large folios
+			 * in all cases yet.
+			 */
+			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+				goto put_folio;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				goto put_folio;
 			if (folio_mapped(folio)) {
 				folio_lock(folio);
 				unmap_poisoned_folio(folio, pfn, false);
-- 
2.53.0



