Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D58C258CEB;
	Thu, 17 Apr 2025 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914761; cv=none; b=XLgqFkdcYSyWrG/k6e0yhPazZZa2utTg17d1l6fl0PeP/jFlu9q92Eiv4sVvpfyJHldKnG75h5QeLuet2pvH9aYAoh5Az+iBFVBT43liS+DedYmmGxZMkfTD4KleYIAMJ38dZd/6Oxp+wrS0NBmTOz0dsXUzkCT4WvcNtbiRdKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914761; c=relaxed/simple;
	bh=mCZxR591USSgVdQt90E6VTtMA44NES1wNyo3aHE4lsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW+SH8ZC0p0hZvNlcmfNch33r/Fx2uDUjh8ndF2LCwExrhrRJIQW3QbM6kJgyDv8JBGtFT0w8SydkvXRodVGYcLzrEv+8wOkR2f4EPLVeOEojFHgG6+BCphA3/oMBkZ4AklB0fU+ZuBqvdnECzdBcnPp3E/51phsbt70lIadmhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7slyDax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7slyDax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87075C4CEE4;
	Thu, 17 Apr 2025 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914761;
	bh=mCZxR591USSgVdQt90E6VTtMA44NES1wNyo3aHE4lsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7slyDaxNax2xcx5TRsQjvAYWgZsHsBMnv3I5/bD08JhgQC+4lWicODcnnuHt32uN
	 Ew27rwTswCln9Y8eUD636Zi8ufI3s9g+aAbaIGSv5bCWp0Tv0Ij44dQlCMVT0anyFJ
	 iVMCWfedEWfZwo46fdWHZATHHyXCc9NV24cnulBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Juergen Gross <jgross@suse.com>,
	Borislav Betkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 322/414] sparc/mm: disable preemption in lazy mmu mode
Date: Thu, 17 Apr 2025 19:51:20 +0200
Message-ID: <20250417175124.384633667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit a1d416bf9faf4f4871cb5a943614a07f80a7d70f upstream.

Since commit 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy
updates") it's been possible for arch_[enter|leave]_lazy_mmu_mode() to be
called without holding a page table lock (for the kernel mappings case),
and therefore it is possible that preemption may occur while in the lazy
mmu mode.  The Sparc lazy mmu implementation is not robust to preemption
since it stores the lazy mode state in a per-cpu structure and does not
attempt to manage that state on task switch.

Powerpc had the same issue and fixed it by explicitly disabling preemption
in arch_enter_lazy_mmu_mode() and re-enabling in
arch_leave_lazy_mmu_mode().  See commit b9ef323ea168 ("powerpc/64s:
Disable preemption in hash lazy mmu mode").

Given Sparc's lazy mmu mode is based on powerpc's, let's fix it in the
same way here.

Link: https://lkml.kernel.org/r/20250303141542.3371656-4-ryan.roberts@arm.com
Fixes: 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy updates")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/tlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -52,8 +52,10 @@ out:
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+	struct tlb_batch *tb;
 
+	preempt_disable();
+	tb = this_cpu_ptr(&tlb_batch);
 	tb->active = 1;
 }
 
@@ -64,6 +66,7 @@ void arch_leave_lazy_mmu_mode(void)
 	if (tb->tlb_nr)
 		flush_tlb_pending();
 	tb->active = 0;
+	preempt_enable();
 }
 
 static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,


