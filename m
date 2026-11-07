Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063627;
	b=UDa3FhZDfU5kWVVYe9f4JzfuN08ge9VlgdI4BE51LGAs03Rt8gkjYn4BEKrmwtexxNCl
	 cnDt0RBkYfNDKwxPoUxri1ODU2fklVKwOJa95IlY6hjg1O+FhDe7K3mVvLgWl81Se8sCs
	 mlP6as5BrEv/BrXX0A9xQDiJrxf4AXOfDbIUuBqp0X7GPFzds+/fJI8Vy8pexMSMrM6ul
	 EQUDniZaqBoA444/8JQrW8Ysj41WoYXOAHiMPqFPQBfst/O05AgBOZVDo7WYFI1Tqz6uJ
	 pTP0LfRo1BMvb7oDfKb90LpzHo3k6vU53fOz9w0kNvYx8UakFk+TQroVlfSVKbnIh9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O74PPJk14VcsnIRu6kW/HfV1cpTiQVBi1NBlnHnflX0=;
	b=Mrqux2n1NhmFFepmsB8ZoTs6H1f5tmWmzgaFOOCEi3sqy0uBRBkiqHpqr9spxpUb0Eld
	 aXR9Ct7/QhLYACB4pIZEHVt1ETBmE3TZoeUVD1UfXPLObDIjTrSVpRYhUTA0hmUXLzlBb
	 L66SRucPRG/MGGvtyKIYxakrXaOVHiWHnvxw2NSrVIHS9EsQqyhCCDcKy+gx0IXCS6UST
	 JzXuZM24cKfkla2KweZ0aMlNBadRLoJPb5wmOjc/HzRs9yY6w0PatGvuMLAmtGULGO6Xx
	 KGrfV+SYTijA6FnG06yAPsIm9VYHWC+FSGwPSnLdIkVKjSH9/zik0ntXX4LHERmS46g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8agJfui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F98606A333;
	Sat,  7 Nov 2026 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8agJfui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C849C1F0089F;
	Sat,  7 Nov 2026 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063627;
	bh=O74PPJk14VcsnIRu6kW/HfV1cpTiQVBi1NBlnHnflX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8agJfuiG3ww7rzqZfkshObPYQw44dMpa6Jwzq6ZL4OMKMyZZsMXSPuo9GjE9BnYX
	 hBoaAyq41AVYYmFxR2s6Zr42HUHxzdVDfq6/BnJ7ojHUJyNli/8w9BeU6/KgwR2mjV
	 FP0HuLjFhcKIBumX+vLRj1nETL+qywuaAyK0H/ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <albinwyang@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 745/869] mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
Date: Sat,  7 Nov 2026 08:57:07 -0500
Message-ID: <20261107134918.050137834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <albinwyang@tencent.com>

[ Upstream commit f5cfc8e3b20ad71949a1e5623ff45882c063a71b ]

During stress testing with stress-ng on a 256-CPU system, a softlockup was
observed when madvise(MADV_COLD) was called on a 31GB memory region backed
by transparent hugepages.  The region contains 15935 THP PMD entries, and
the softlockup was triggered after 14485 of them had been processed.

The THP branch of madvise_cold_or_pageout_pte_range() has no scheduling
point.  walk_pmd_range() invokes it once per 2MB PMD entry with no
cond_resched() anywhere in the loop.  Each iteration calls
pmdp_invalidate() which issues a synchronous TLB shootdown (dsb ish)
waiting for all CPUs to acknowledge.  This operation can be time-consuming
under heavy system load, causing the accumulated time across all PMD
entries to exceed the softlockup threshold (20s) and panic when
softlockup_panic=1.  On a CONFIG_PREEMPT_NONE=y kernel, there is no other
opportunity to reschedule during this entire traversal.

The regular PTE path already has an unconditional cond_resched() at the
function tail (introduced by commit 9c276cc65a58 ("mm: introduce
MADV_COLD") and commit 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") when
MADV_COLD and MADV_PAGEOUT were first introduced) and a conditional one
inside the loop (commit b2f557a21bc8 ("mm/madvise: add cond_resched() in
madvise_cold_or_pageout_pte_range()")).  The THP branch never received
equivalent treatment.

Fix by adding cond_resched() at the huge_unlock exit path after
spin_unlock(ptl) and reclaim_pages(), which is the single exit point for
all goto paths in the THP branch.

Crash log:
  watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
  ...
  Call trace:
  pmdp_invalidate+0x48/0x68
  madvise_cold_or_pageout_pte_range+0x84c/0xb00
  walk_pmd_range.isra.0+0x1ac/0x3b0
  walk_pud_range+0x120/0x190
  walk_pgd_range+0x170/0x1b8
  __walk_page_range+0x184/0x198
  walk_page_range_vma+0x94/0x128
  madvise_cold+0xd8/0x198
  madvise_vma_behavior+0x234/0x638
  madvise_walk_vmas.constprop.0+0xdc/0x210
  madvise_do_behavior+0xa8/0x328
  do_madvise+0xd8/0x140
  __arm64_sys_madvise+0x2c/0xe0

Link: https://lore.kernel.org/20261010024042.4070048-1-albin_yang@163.com
Signed-off-by: Wei Yang <albinwyang@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 505a580cd9c4c..bb02220e1959b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -452,6 +452,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		spin_unlock(ptl);
 		if (pageout)
 			reclaim_pages(&folio_list);
+		cond_resched();
 		return 0;
 	}
 
-- 
2.53.0



