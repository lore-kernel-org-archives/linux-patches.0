Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C419A288;
	Fri, 24 Apr 2026 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038071; cv=none; b=MNcsRg63cGCimUCgtzphB0dnJ4J6oDWPUVNc8BqfCCiP08LvQ51tr5oj2dDZqc6VGntATM9iyosuAOhhvD4WmNnAYkze+lHeTjel3xWiisPvFrf3OsDXX3Gc7xoMOu/Bap04BN8E3yWk3qJnLC5p/8ToLHViYPTWkQaSjItoJ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038071; c=relaxed/simple;
	bh=gOecAhoDEJKvnvy6MXwxDOY+f9bTUkOlleRDmSfqBow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxY8BZ+J0sZ4h3oGtjd+34KdTSoEyKpRMXZmcIbYfCg15/uLWWTuPsaD/b/dX+iJjj/G/nyJq78Q/EJv58EQhP2weU8QCkASJpgu6xOtVtytjzkFY7Rd4kte5vOXjAufVavF/1tpQ1D/jegVRF6peyDv793eOwQ+O9/tRuNMX+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuIwVvpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuIwVvpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A18C19425;
	Fri, 24 Apr 2026 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038071;
	bh=gOecAhoDEJKvnvy6MXwxDOY+f9bTUkOlleRDmSfqBow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuIwVvpnqAA+8zC+1EhjjCSZWGHeWl9ZgnNkachqldU3UWTmXA2xwEh79ZNubE5gw
	 TDguXcQbQ9RP9VoSejRlL2GWwmAThjFOfKhJ+yeZy0R1TqBOF3wG1f67k8gbl5oYW7
	 pPLjCRQscSSRJCJGvDNnO2hoX1mFIYk0QgB1ahfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 13/55] arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()
Date: Fri, 24 Apr 2026 15:30:52 +0200
Message-ID: <20260424132432.939643136@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit d9fb08ba946a6190c371dcd9f9e465d0d52c5021 upstream.

The mm structure will be used for workarounds that need limiting to
specific tasks.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/tlbflush.h |    8 ++++----
 arch/arm64/kernel/sys_compat.c    |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -185,7 +185,7 @@ do {										\
  * Complete broadcast TLB maintenance issued by the host which invalidates
  * stage 1 information in the host's own translation regime.
  */
-static inline void __tlbi_sync_s1ish(void)
+static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
@@ -310,7 +310,7 @@ static inline void flush_tlb_mm(struct m
 	asid = __TLBI_VADDR(0, ASID(mm));
 	__tlbi(aside1is, asid);
 	__tlbi_user(aside1is, asid);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(mm);
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
 
@@ -337,7 +337,7 @@ static inline void flush_tlb_page(struct
 				  unsigned long uaddr)
 {
 	flush_tlb_page_nosync(vma, uaddr);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(vma->vm_mm);
 }
 
 static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
@@ -492,7 +492,7 @@ static inline void __flush_tlb_range(str
 {
 	__flush_tlb_range_nosync(vma->vm_mm, start, end, stride,
 				 last_level, tlb_level);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(vma->vm_mm);
 }
 
 static inline void flush_tlb_range(struct vm_area_struct *vma,
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -37,7 +37,7 @@ __do_compat_cache_op(unsigned long start
 			 * We pick the reserved-ASID to minimise the impact.
 			 */
 			__tlbi(aside1is, __TLBI_VADDR(0, 0));
-			__tlbi_sync_s1ish();
+			__tlbi_sync_s1ish(current->mm);
 		}
 
 		ret = caches_clean_inval_user_pou(start, start + chunk);


