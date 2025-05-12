Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0808B298CD1;
	Mon, 12 May 2025 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073328; cv=none; b=lg2jWHRRRdUVIIXFikRPfMyskVxEfojFg2fwHXbkbsSLYnz4M8ZEMglMDrnim3X+zYB4IwIr+G4kiyYBcc5p/e72TI3qeNeLqTOBGkrbQ74OLiQiBMlSCp6P+AZbzV0Hfj117/eKyLnoq4hULdPAa8eAw3ZV4YL1Eee06Gp3opg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073328; c=relaxed/simple;
	bh=i6rIAK4yZ6Ozj/Sez6GjUQTFdaLBalPUIhQk6qm73hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcR+sQle2fYUrKILsCkHfWqOEtNeX/Ii+DO2bZIBK5Nn9wi14YqyQtzrMOoUVucKxpF6ho8jQpIplOyUHxZuhyOZ7l87plqRvruzkUdpjyac6afVVE7uoTQb8+4FNKOuC4qLUqKlkBotBnot8iALPormR7GCk5MWjItDVite1Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwZoOYOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwZoOYOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3277CC4CEEF;
	Mon, 12 May 2025 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073327;
	bh=i6rIAK4yZ6Ozj/Sez6GjUQTFdaLBalPUIhQk6qm73hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwZoOYOfKvxSaXrIaUBcW4sWZ3CvXUrnfFmuLgbkUEjUqrW9MMjlTudI8GSBTAydz
	 XPPSfILT2tQ6YarOpocD8jmN2f4MAQa28ASQjrNHdyOhkjsqAMJfo3gcLBJmigxMe+
	 f9WQdmKrq9Q2o6wapt+4esXcAyJBgWUB35+LSpmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rik van Riel <riel@surriel.com>,
	Stephen Dolan <sdolan@janestreet.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 040/113] x86/mm: Eliminate window where TLB flushes may be inadvertently skipped
Date: Mon, 12 May 2025 19:45:29 +0200
Message-ID: <20250512172029.302756097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

commit fea4e317f9e7e1f449ce90dedc27a2d2a95bee5a upstream.

tl;dr: There is a window in the mm switching code where the new CR3 is
set and the CPU should be getting TLB flushes for the new mm.  But
should_flush_tlb() has a bug and suppresses the flush.  Fix it by
widening the window where should_flush_tlb() sends an IPI.

Long Version:

=== History ===

There were a few things leading up to this.

First, updating mm_cpumask() was observed to be too expensive, so it was
made lazier.  But being lazy caused too many unnecessary IPIs to CPUs
due to the now-lazy mm_cpumask().  So code was added to cull
mm_cpumask() periodically[2].  But that culling was a bit too aggressive
and skipped sending TLB flushes to CPUs that need them.  So here we are
again.

=== Problem ===

The too-aggressive code in should_flush_tlb() strikes in this window:

	// Turn on IPIs for this CPU/mm combination, but only
	// if should_flush_tlb() agrees:
	cpumask_set_cpu(cpu, mm_cpumask(next));

	next_tlb_gen = atomic64_read(&next->context.tlb_gen);
	choose_new_asid(next, next_tlb_gen, &new_asid, &need_flush);
	load_new_mm_cr3(need_flush);
	// ^ After 'need_flush' is set to false, IPIs *MUST*
	// be sent to this CPU and not be ignored.

        this_cpu_write(cpu_tlbstate.loaded_mm, next);
	// ^ Not until this point does should_flush_tlb()
	// become true!

should_flush_tlb() will suppress TLB flushes between load_new_mm_cr3()
and writing to 'loaded_mm', which is a window where they should not be
suppressed.  Whoops.

=== Solution ===

Thankfully, the fuzzy "just about to write CR3" window is already marked
with loaded_mm==LOADED_MM_SWITCHING.  Simply checking for that state in
should_flush_tlb() is sufficient to ensure that the CPU is targeted with
an IPI.

This will cause more TLB flush IPIs.  But the window is relatively small
and I do not expect this to cause any kind of measurable performance
impact.

Update the comment where LOADED_MM_SWITCHING is written since it grew
yet another user.

Peter Z also raised a concern that should_flush_tlb() might not observe
'loaded_mm' and 'is_lazy' in the same order that switch_mm_irqs_off()
writes them.  Add a barrier to ensure that they are observed in the
order they are written.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/oe-lkp/202411282207.6bd28eae-lkp@intel.com/ [1]
Fixes: 6db2526c1d69 ("x86/mm/tlb: Only trim the mm_cpumask once a second") [2]
Reported-by: Stephen Dolan <sdolan@janestreet.com>
Cc: stable@vger.kernel.org
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/tlb.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -630,7 +630,11 @@ void switch_mm_irqs_off(struct mm_struct
 
 		choose_new_asid(next, next_tlb_gen, &new_asid, &need_flush);
 
-		/* Let nmi_uaccess_okay() know that we're changing CR3. */
+		/*
+		 * Indicate that CR3 is about to change. nmi_uaccess_okay()
+		 * and others are sensitive to the window where mm_cpumask(),
+		 * CR3 and cpu_tlbstate.loaded_mm are not all in sync.
+ 		 */
 		this_cpu_write(cpu_tlbstate.loaded_mm, LOADED_MM_SWITCHING);
 		barrier();
 	}
@@ -900,8 +904,16 @@ done:
 
 static bool should_flush_tlb(int cpu, void *data)
 {
+	struct mm_struct *loaded_mm = per_cpu(cpu_tlbstate.loaded_mm, cpu);
 	struct flush_tlb_info *info = data;
 
+	/*
+	 * Order the 'loaded_mm' and 'is_lazy' against their
+	 * write ordering in switch_mm_irqs_off(). Ensure
+	 * 'is_lazy' is at least as new as 'loaded_mm'.
+	 */
+	smp_rmb();
+
 	/* Lazy TLB will get flushed at the next context switch. */
 	if (per_cpu(cpu_tlbstate_shared.is_lazy, cpu))
 		return false;
@@ -910,8 +922,15 @@ static bool should_flush_tlb(int cpu, vo
 	if (!info->mm)
 		return true;
 
+	/*
+	 * While switching, the remote CPU could have state from
+	 * either the prev or next mm. Assume the worst and flush.
+	 */
+	if (loaded_mm == LOADED_MM_SWITCHING)
+		return true;
+
 	/* The target mm is loaded, and the CPU is not lazy. */
-	if (per_cpu(cpu_tlbstate.loaded_mm, cpu) == info->mm)
+	if (loaded_mm == info->mm)
 		return true;
 
 	/* In cpumask, but not the loaded mm? Periodically remove by flushing. */


