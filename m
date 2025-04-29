Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A521ADC7;
	Tue, 29 Apr 2025 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947493; cv=none; b=Ea/tS0VfqxWJCkVJqjuJsRN0otCFQfJa3lHYuVjkXA0fl+jMd4GcOHunEb4ljaNf9spfVbW99lXlpYpNnzuQzK96H9Y4PnHyiym0eej8F5WLWl1uUn1GPaDctl2ciP7/17qEcgXKMEJt1hkBJhhHf/4w7KTHpb7Oty9v+eRJx6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947493; c=relaxed/simple;
	bh=tUTamObTEO3Czi1Ov3ANQMbcPjuPOdJliYFv944WcCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyLgy0vvCdx8Cda7Hu5tHNuXE2Gk+oki5ws109eXNszwQa7SptztYY+Gmg24YwBVFzVvaNBRqmNuoQPkJV7XmHO9dIvoU4+dwkOfPBTdJofuNAdmmiPJ4BJJTH6bsyblyZIfe0lHJE7Cohj0vj0GbBrfbhomkHhwK1GKthiLysQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/64X9Lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/64X9Lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B71C4CEE3;
	Tue, 29 Apr 2025 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947492;
	bh=tUTamObTEO3Czi1Ov3ANQMbcPjuPOdJliYFv944WcCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/64X9Lh4xPUrbF5U+CvfXSQ+cggfPVVZPZqE0GWjOFKVq085ojIYe2Fg98lRu4k/
	 55CbJpYjAtkB0dbXKGeFu9G9zdDyAGJG/s+cfQYcfcKjsXckRfkfRQUpZggutoDkac
	 7XGt0Qn6qCcQXYctnzKZPBb+0qXQ+OqlKP3GltU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	kernel.org
Subject: [PATCH 6.12 004/280] mm/vmscan: dont try to reclaim hwpoison folio
Date: Tue, 29 Apr 2025 18:39:05 +0200
Message-ID: <20250429161115.193296895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit 1b0449544c6482179ac84530b61fc192a6527bfd ]

Syzkaller reports a bug as follows:

Injecting memory failure for pfn 0x18b00e at process virtual address 0x20ffd000
Memory failure: 0x18b00e: dirty swapcache page still referenced by 2 users
Memory failure: 0x18b00e: recovery action for dirty swapcache page: Failed
page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x20ffd pfn:0x18b00e
memcg:ffff0000dd6d9000
anon flags: 0x5ffffe00482011(locked|dirty|arch_1|swapbacked|hwpoison|node=0|zone=2|lastcpupid=0xfffff)
raw: 005ffffe00482011 dead000000000100 dead000000000122 ffff0000e232a7c9
raw: 0000000000020ffd 0000000000000000 00000002ffffffff ffff0000dd6d9000
page dumped because: VM_BUG_ON_FOLIO(!folio_test_uptodate(folio))
------------[ cut here ]------------
kernel BUG at mm/swap_state.c:184!
Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
Modules linked in:
CPU: 0 PID: 60 Comm: kswapd0 Not tainted 6.6.0-gcb097e7de84e #3
Hardware name: linux,dummy-virt (DT)
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : add_to_swap+0xbc/0x158
lr : add_to_swap+0xbc/0x158
sp : ffff800087f37340
x29: ffff800087f37340 x28: fffffc00052c0380 x27: ffff800087f37780
x26: ffff800087f37490 x25: ffff800087f37c78 x24: ffff800087f377a0
x23: ffff800087f37c50 x22: 0000000000000000 x21: fffffc00052c03b4
x20: 0000000000000000 x19: fffffc00052c0380 x18: 0000000000000000
x17: 296f696c6f662865 x16: 7461646f7470755f x15: 747365745f6f696c
x14: 6f6621284f494c4f x13: 0000000000000001 x12: ffff600036d8b97b
x11: 1fffe00036d8b97a x10: ffff600036d8b97a x9 : dfff800000000000
x8 : 00009fffc9274686 x7 : ffff0001b6c5cbd3 x6 : 0000000000000001
x5 : ffff0000c25896c0 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : ffff0000c25896c0 x0 : 0000000000000000
Call trace:
 add_to_swap+0xbc/0x158
 shrink_folio_list+0x12ac/0x2648
 shrink_inactive_list+0x318/0x948
 shrink_lruvec+0x450/0x720
 shrink_node_memcgs+0x280/0x4a8
 shrink_node+0x128/0x978
 balance_pgdat+0x4f0/0xb20
 kswapd+0x228/0x438
 kthread+0x214/0x230
 ret_from_fork+0x10/0x20

I can reproduce this issue with the following steps:

1) When a dirty swapcache page is isolated by reclaim process and the
   page isn't locked, inject memory failure for the page.
   me_swapcache_dirty() clears uptodate flag and tries to delete from lru,
   but fails.  Reclaim process will put the hwpoisoned page back to lru.

2) The process that maps the hwpoisoned page exits, the page is deleted
   the page will never be freed and will be in the lru forever.

3) If we trigger a reclaim again and tries to reclaim the page,
   add_to_swap() will trigger VM_BUG_ON_FOLIO due to the uptodate flag is
   cleared.

To fix it, skip the hwpoisoned page in shrink_folio_list().  Besides, the
hwpoison folio may not be unmapped by hwpoison_user_mappings() yet, unmap
it in shrink_folio_list(), otherwise the folio will fail to be unmaped by
hwpoison_user_mappings() since the folio isn't in lru list.

Link: https://lkml.kernel.org/r/20250318083939.987651-3-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger,kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 39b3c7f35ea85..0eb5d510d4f6b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1079,6 +1079,13 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!folio_trylock(folio))
 			goto keep;
 
+		if (folio_contain_hwpoisoned_page(folio)) {
+			unmap_poisoned_folio(folio, folio_pfn(folio), false);
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 
 		nr_pages = folio_nr_pages(folio);
-- 
2.39.5



