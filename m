Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2096E1A3029;
	Tue, 21 Oct 2025 20:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077466; cv=none; b=isZk/VR8H4/iCCP3KNP9kvOASbVA/XNMntQZi7RatcykCxoPFr9RUyttpeymFa4LQhQREgMluhyeNJh/YJlfcxk7yMsJpQcYrzx2xp9b+YdG+J4IcJmBK8hHLRjm0Y41tuAzmyXFWXTn0iaRvCll2HvHaRw0Fg7UVYvCDlDf8ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077466; c=relaxed/simple;
	bh=ygQJTd/pgYKCcrsFKhjc2Ls45jlGSmxLa7OsR0yUcgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ij2F+2ka8yYx1jJEkjJa70zDi8aNjbX8cCIiWR/DrVXSbqrxnOzawr5nQKAVn0hucCx1ifjWSNr13NAhnsg4l2TKyybkuchaFiLl14lKQaLHiemKMYEJrOhXk2Uo5AkOvmTMVfiF6OqCA92UacpLUYTbsrOrVtHbvuM1IK44IdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvEivlB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvEivlB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DE0C4CEF1;
	Tue, 21 Oct 2025 20:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077466;
	bh=ygQJTd/pgYKCcrsFKhjc2Ls45jlGSmxLa7OsR0yUcgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvEivlB/RgpRwA8B1G9hgTwdIjPZexbsayrcszxs30q6pjxxFdTgV2TIqjb2V/r4d
	 CPEW+4+ZEOr9rbruEBNPXh9yz3pnj+tkW7+jpBKaGmzuBohIXR3qlLNk1p7LfY2xKF
	 BH7lQBOx/9mvHnp4oPLI1qIc9KD67d7Tt3mQZEBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Dolan <sdolan@janestreet.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/159] x86/mm: Fix SMP ordering in switch_mm_irqs_off()
Date: Tue, 21 Oct 2025 21:51:31 +0200
Message-ID: <20251021195045.906577011@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 83b0177a6c4889b3a6e865da5e21b2c9d97d0551 ]

Stephen noted that it is possible to not have an smp_mb() between
the loaded_mm store and the tlb_gen load in switch_mm(), meaning the
ordering against flush_tlb_mm_range() goes out the window, and it
becomes possible for switch_mm() to not observe a recent tlb_gen
update and fail to flush the TLBs.

[ dhansen: merge conflict fixed by Ingo ]

Fixes: 209954cbc7d0 ("x86/mm/tlb: Update mm_cpumask lazily")
Reported-by: Stephen Dolan <sdolan@janestreet.com>
Closes: https://lore.kernel.org/all/CAHDw0oGd0B4=uuv8NGqbUQ_ZVmSheU2bN70e4QhFXWvuAZdt2w@mail.gmail.com/
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/tlb.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 39f80111e6f17..5d221709353e0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -911,11 +911,31 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 		 * CR3 and cpu_tlbstate.loaded_mm are not all in sync.
 		 */
 		this_cpu_write(cpu_tlbstate.loaded_mm, LOADED_MM_SWITCHING);
-		barrier();
 
-		/* Start receiving IPIs and then read tlb_gen (and LAM below) */
+		/*
+		 * Make sure this CPU is set in mm_cpumask() such that we'll
+		 * receive invalidation IPIs.
+		 *
+		 * Rely on the smp_mb() implied by cpumask_set_cpu()'s atomic
+		 * operation, or explicitly provide one. Such that:
+		 *
+		 * switch_mm_irqs_off()				flush_tlb_mm_range()
+		 *   smp_store_release(loaded_mm, SWITCHING);     atomic64_inc_return(tlb_gen)
+		 *   smp_mb(); // here                            // smp_mb() implied
+		 *   atomic64_read(tlb_gen);                      this_cpu_read(loaded_mm);
+		 *
+		 * we properly order against flush_tlb_mm_range(), where the
+		 * loaded_mm load can happen in mative_flush_tlb_multi() ->
+		 * should_flush_tlb().
+		 *
+		 * This way switch_mm() must see the new tlb_gen or
+		 * flush_tlb_mm_range() must see the new loaded_mm, or both.
+		 */
 		if (next != &init_mm && !cpumask_test_cpu(cpu, mm_cpumask(next)))
 			cpumask_set_cpu(cpu, mm_cpumask(next));
+		else
+			smp_mb();
+
 		next_tlb_gen = atomic64_read(&next->context.tlb_gen);
 
 		ns = choose_new_asid(next, next_tlb_gen);
-- 
2.51.0



