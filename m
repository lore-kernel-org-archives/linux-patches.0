Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981F24E4C3;
	Mon, 23 Jun 2025 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684499; cv=none; b=KA+eX1qotU81gfGrYCJ+aEpcxgmyswxuGZZfzlVG1SpRE4qbH1z2OJlpuhm2WO/ibNIbfNcvO1C2c9xDTZfYzEcfk0SFhLFuL23OAdcJEJz6QrvohfMrW0CnRbC8csKyenJ0B+TksIKchiGEEGXfqwaXAcw+Zyisx0vGyc+lcis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684499; c=relaxed/simple;
	bh=0YqWQl8TuXrX3c5HXuytMN5AgJ+Qqy684D9QdWK6GW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfiiqYvt+dgKbA2u79DXShvEqiWTN0SgLchrKwlE9Dclkj1wy/JJSLQcaWtKD4AS0XkjU4GH2lmhU6XBfugqufop9whwqSiclM8yv0QylH7uWJWXD+ETlISZLlvQeyQhp6EcbjIiUISRd0nAT0HkK8FVRGtGbbbHJkBhi1QDDIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dC64Jtc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dC64Jtc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F22DC4CEEA;
	Mon, 23 Jun 2025 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684499;
	bh=0YqWQl8TuXrX3c5HXuytMN5AgJ+Qqy684D9QdWK6GW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dC64Jtc5fzanrcuIHjcyE4jpax/P0KD/f+TP2Xe62xqWqRcmmYiGTRDzEkuDudYc3
	 nIgDU1YNIf185ehASyW1OY+8mlxhjyg+61VOGvGerameA1MQsX7uGXKB17EMWxVs5O
	 Xu6Ym3/momqqHZI677gIWj+lniC72ccujNHRJzvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.15 092/592] arm64/mm: Close theoretical race where stale TLB entry remains valid
Date: Mon, 23 Jun 2025 15:00:50 +0200
Message-ID: <20250623130702.470096890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 4b634918384c0f84c33aeb4dd9fd4c38e7be5ccb upstream.

Commit 3ea277194daa ("mm, mprotect: flush TLB if potentially racing with
a parallel reclaim leaving stale TLB entries") describes a race that,
prior to the commit, could occur between reclaim and operations such as
mprotect() when using reclaim's tlbbatch mechanism. See that commit for
details but the summary is:

"""
Nadav Amit identified a theoritical race between page reclaim and
mprotect due to TLB flushes being batched outside of the PTL being held.

He described the race as follows:

	CPU0				CPU1
	----				----
					user accesses memory using RW PTE
					[PTE now cached in TLB]
	try_to_unmap_one()
	==> ptep_get_and_clear()
	==> set_tlb_ubc_flush_pending()
					mprotect(addr, PROT_READ)
					==> change_pte_range()
					==> [ PTE non-present - no flush ]

					user writes using cached RW PTE
	...

	try_to_unmap_flush()
"""

The solution was to insert flush_tlb_batched_pending() in mprotect() and
friends to explcitly drain any pending reclaim TLB flushes. In the
modern version of this solution, arch_flush_tlb_batched_pending() is
called to do that synchronisation.

arm64's tlbbatch implementation simply issues TLBIs at queue-time
(arch_tlbbatch_add_pending()), eliding the trailing dsb(ish). The
trailing dsb(ish) is finally issued in arch_tlbbatch_flush() at the end
of the batch to wait for all the issued TLBIs to complete.

Now, the Arm ARM states:

"""
The completion of the TLB maintenance instruction is guaranteed only by
the execution of a DSB by the observer that performed the TLB
maintenance instruction. The execution of a DSB by a different observer
does not have this effect, even if the DSB is known to be executed after
the TLB maintenance instruction is observed by that different observer.
"""

arch_tlbbatch_add_pending() and arch_tlbbatch_flush() conform to this
requirement because they are called from the same task (either kswapd or
caller of madvise(MADV_PAGEOUT)), so either they are on the same CPU or
if the task was migrated, __switch_to() contains an extra dsb(ish).

HOWEVER, arm64's arch_flush_tlb_batched_pending() is also implemented as
a dsb(ish). But this may be running on a CPU remote from the one that
issued the outstanding TLBIs. So there is no architectural gurantee of
synchonization. Therefore we are still vulnerable to the theoretical
race described in Commit 3ea277194daa ("mm, mprotect: flush TLB if
potentially racing with a parallel reclaim leaving stale TLB entries").

Fix this by flushing the entire mm in arch_flush_tlb_batched_pending().
This aligns with what the other arches that implement the tlbbatch
feature do.

Cc: <stable@vger.kernel.org>
Fixes: 43b3dfdd0455 ("arm64: support batched/deferred tlb shootdown during page reclamation/migration")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/r/20250530152445.2430295-1-ryan.roberts@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/tlbflush.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -323,13 +323,14 @@ static inline bool arch_tlbbatch_should_
 }
 
 /*
- * If mprotect/munmap/etc occurs during TLB batched flushing, we need to
- * synchronise all the TLBI issued with a DSB to avoid the race mentioned in
- * flush_tlb_batched_pending().
+ * If mprotect/munmap/etc occurs during TLB batched flushing, we need to ensure
+ * all the previously issued TLBIs targeting mm have completed. But since we
+ * can be executing on a remote CPU, a DSB cannot guarantee this like it can
+ * for arch_tlbbatch_flush(). Our only option is to flush the entire mm.
  */
 static inline void arch_flush_tlb_batched_pending(struct mm_struct *mm)
 {
-	dsb(ish);
+	flush_tlb_mm(mm);
 }
 
 /*


