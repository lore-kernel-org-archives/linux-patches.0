Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4F34E9C2C;
	Fri,  9 Oct 2026 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556912; cv=none; b=frg32cOQJrDrPsdC8yryusbL3Wm8vyrsDkzJG4eFxUGKRTmFGo8qO8MCwpx6FZoeBP55Cs5xcJj7EwXybA5YER0baXEephHi+hJXmZQuNBj4y/ksuIhXY4oR17LwGbr6qYxhlAY6y5qrPTkoVJ4wdnBcreupf/K1ztzYIIuLkdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556912; c=relaxed/simple;
	bh=+MLh7oXDE+DBrmDG6OBP6t6PQL6n23sgJv/knSnazjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZtD1qXUrYs0x8c4n8vlTj9pf8yxyOkt5+hb47mANUrQay1nASV2IV3WuEHPcqrAiDnE16TVoDkVEhbqO9lApfe2b0CWHSocawpwa+TmjUgLnnirVj2A6/1LEzv34q/L1jV327qHul6aGA3JzSmHd1FZb/uedqltZvyQGJ5/H4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vn0jnZnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vn0jnZnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907911F00893;
	Fri,  9 Oct 2026 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556911;
	bh=9HAMbDmg7GkXNUGwpNOcqCxr/qK7+zUbOtyab8cw5u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vn0jnZnVNJ4D9DRB3BaDMP2CRdZAKxufpK0HZE8NAcEHNyGcBZw74+a/ht+XmYghr
	 YsWvwFBsHf3jcCyE9qXm65ZqzRwvQIyRfigAc4HJnZc4tbEIATIzn3Ui22KVO9/Tdj
	 SmKX4lweHhr0tgo3AZJRAF0DzWS/U5U1myN1+I/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 262/428] arm64: mm: Fix the break-before-make flush range for erratum 2645198
Date: Fri,  9 Oct 2026 16:09:59 +0200
Message-ID: <20261009140951.854822123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 1fef81669147d63eb8c5d3627d54eadc21173a0b upstream.

modify_prot_start_ptes() performs the break-before-make TLB invalidation
required by erratum 2645198 with __flush_tlb_range(), whose third
argument is the end address of the range.  It passes nr * PAGE_SIZE
instead of addr + nr * PAGE_SIZE, so __do_flush_tlb_range() computes the
page count as (nr * PAGE_SIZE - addr) >> PAGE_SHIFT.

For addr > nr * PAGE_SIZE that subtraction underflows, the page count
exceeds the batching limit and the flush degenerates to flush_tlb_mm(),
so a single-page mprotect broadcasts an ASID-wide invalidation and a
full-range mmu notifier call.

For addr <= nr * PAGE_SIZE only [addr, nr * PAGE_SIZE) is invalidated,
and when the cleared batch starts below nr * PAGE_SIZE the tail is left
in the TLB.  The workaround then no longer covers the whole batch, and
for addr == nr * PAGE_SIZE the flush is empty.

On affected Cortex-A715 CPUs, this can corrupt ESR_ELx and FAR_ELx on the
next instruction abort caused by a permission fault.

Pass addr + nr * PAGE_SIZE as the end address.

Fixes: 7efa1cd5f89b5 ("arm64: add batched versions of ptep_modify_prot_start/commit")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2245,7 +2245,7 @@ pte_t modify_prot_start_ptes(struct vm_a
 		 * in cases where cpu is affected with errata #2645198.
 		 */
 		if (pte_accessible(vma->vm_mm, pte) && pte_user_exec(pte))
-			__flush_tlb_range(vma, addr, nr * PAGE_SIZE,
+			__flush_tlb_range(vma, addr, addr + nr * PAGE_SIZE,
 					  PAGE_SIZE, 3, TLBF_NOWALKCACHE);
 	}
 


