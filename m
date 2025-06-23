Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE62E224B01;
	Mon, 23 Jun 2025 21:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713948; cv=none; b=MbTLiWC7o6BmGHZYOYIIpxvi+4rGqzEr1kAoGmxNPZhEKWX/bKiOISDFj89pMEEfp4cIgVENHZIhqGPE0WoEYWWvyCWBqiN4SVfy3CTqL9ruRrq820VOwNz3NL1lDzVgYChI+DuWRFXRV/AaHZze5BhiIXgbubPWx9lUyLvs2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713948; c=relaxed/simple;
	bh=0nEFvdJrHjla68baqkebCUaoNtwuCCH2it+0FJslXpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X89ehy+I1ujYL8TLS4B43+H3n+l+uBINircyt+ok1LHu0iYwPUJeAPIRku5PwSvvo21UZnA19sxTDeri+43Xykek0V3OWIlUVj7nth3hRVwAkITKirWv9nbZUSzSjPUNnJb/yiO5FzCnOC4cTNFeV+MM46L0V8lmQAC3BVoSaes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfPE4huN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfPE4huN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2576BC4CEF6;
	Mon, 23 Jun 2025 21:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713947;
	bh=0nEFvdJrHjla68baqkebCUaoNtwuCCH2it+0FJslXpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfPE4huNPdCpfbEEitefZGfBMmoLpP+NLMYVvuSuofgm2XKHY1DmIhH/+MssXAQVW
	 cs0SpnhZGkwn3MxHLetG9953kGeZi304jdgZQA60CDrBxjLqAfB55D1fblB1Kf+a95
	 /icb+zu+PGnIPZ5UoZfxurbH3/wteYg6irSznPXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 072/414] arm64/mm: Close theoretical race where stale TLB entry remains valid
Date: Mon, 23 Jun 2025 15:03:29 +0200
Message-ID: <20250623130643.873591658@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
@@ -330,13 +330,14 @@ static inline void arch_tlbbatch_add_pen
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


