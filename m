Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047405;
	b=2GG5M0Iz0kuxLXITAt1e6tpgBtxh/ifkI8Q4g/3E9LcEFW2n7u2dPllEFwDuYTpSKyFi
	 7/2twC4XW4gYAskl3U6pNu2/iazQDLvWHIBp5vkgkKcdFk6khdkSAOWeBTifXrsd5Wpga
	 c6s0M/a2Aft1z7Cp1jLC7H5ltoAsKBsDGna0rbFb6w5kGSaDYSvKAm7sAMZxhZPTFh4uH
	 hyszSRelQMwk3NVJzdN9f2yfuNFjD+yx7dFz6stczcu4fZZuvwKGEvoYfyVLo0KZYoacc
	 y9iaa9WpexuhAqPE74kNNn0xZhnTRMH5nHmxP2q3qVy8HSAjYR4PGuuoVCcWUd0dUeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+cH4tb2mcf20FQrxLneIfkfvzTHaCDSoe73LJP5gj/M=;
	b=1rJEut3rDlft13bPXZIcRJOGPzdWIbhejj5xQnXLBlz0sDdsaVGDMkMOnjZ+J6kmQl7Y
	 2TgHwoXhRlTOiCJHW3kNyFzq262IarB3ZeEbwwiFDDDU+x+9laFu/VRtDxyoLwTUESr5p
	 wtbMYjh0XyjkX+9zcC+2gbF92S+awGG34FE4qA7c/yKXPDsnl2cYOL/f3FiSvgefeH6rm
	 4Gy8KJISkrEzDoe2bW1hJkKglK/rXCgdQ1hF7P6y3F3f+W2wxXxWegywkK+MiG5xQdMC4
	 H9Niw2XY2M9voxRMuH6vXF4OXgrsi4OPa7dRGl5oeqAedyzrX9C81AdIU3K+Mx1/PRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbirMC9w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7427A606A31C;
	Thu, 19 Nov 2026 00:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbirMC9w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF77F1F000C4;
	Thu, 19 Nov 2026 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047405;
	bh=+cH4tb2mcf20FQrxLneIfkfvzTHaCDSoe73LJP5gj/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbirMC9wgDb6Bo01PnkVZPaF0Fab3Wosx2d6z6kjRIQx05ECfTB9P4ib+ylYPRq+9
	 DEhbtaZY1I2NzDcdjY++O8piaZcHZn4n4pnJBd6kE6Q3vLDQKoCoCMGMZT43p6c1Mm
	 uzAsdCRlDpD4LqUkGtBfFhh8p1dmRkJxdCRs+o8U=
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
Subject: [PATCH 6.1 1626/2857] mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118150259.891858880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted patch context to retain page_list where upstream uses folio_list. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 2532aee74ae72..77dfca84d27ae 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -399,6 +399,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		spin_unlock(ptl);
 		if (pageout)
 			reclaim_pages(&page_list);
+		cond_resched();
 		return 0;
 	}
 
-- 
2.53.0



