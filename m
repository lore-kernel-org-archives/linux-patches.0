Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72AC148;
	Tue, 29 Apr 2025 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948744; cv=none; b=k7xY+7aqBJdfA0zuobCrcAvPMTrCCwPEqk8cQrS7HnP5XGcOvVbdJPcU5YSL4+Uvp/V0khaXVeF8T5HamyF2bNm41lixP3h7JDACRL70UztMvGWQyfFXixzaLXQk887V0fZDICpPvpOrO6WW4yn5jCy8klQymdvayQiWf88q9YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948744; c=relaxed/simple;
	bh=pGxhaAonveYvM6G8y/pJmrpemooHBMa2c249jP57/2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oj6oXHPO6cWduVXXY5ZuZEzDngdGNDekJtxgq1kc7XkJfDWQ6xdUnigStYttmRCBW5+y6O/fjl132K+5HKxbHxybAHZ+xkPrdOsfgBCi8qz2w9OiC7cHr3l2d5GJgg4O8JafXJkHXpc9owGFcLIiZAkoXCxy/0+uw9ZXI7OOACE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaqtUEMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaqtUEMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F148C4CEE3;
	Tue, 29 Apr 2025 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948743;
	bh=pGxhaAonveYvM6G8y/pJmrpemooHBMa2c249jP57/2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaqtUEMVgmfSL3oq0rsUqtu2V/sCUPVbdb8QxE0ioBPXN0aDrPTSdV1D/HTO9tzuF
	 oS2foAV9uaaNJDkFJh9HZtJMVhXxgI0Ym6jhL1YCuXIVGALNFaeCQGSqroieBBhJ6h
	 U1OIG0/NqqTMYV26cRKLLEJ8voyFlwRS1jBqKaU4=
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
Subject: [PATCH 5.15 099/373] sparc/mm: disable preemption in lazy mmu mode
Date: Tue, 29 Apr 2025 18:39:36 +0200
Message-ID: <20250429161127.230365868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


