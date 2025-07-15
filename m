Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A772D948B;
	Tue, 15 Jul 2025 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586806; cv=none; b=plB51XUYsTr0j1CpptXv4SGNsN6WY4nYsyWyPsqorUt+KMFUlC+gJpASvuuN+0bOYcD9jwPPBp4qeU+dmtkApYrDWWht9tIv4gEr0kGuNyE7/5/j1oFcEmr3cev0R1vUHXX88/EAdU22qoA+axEMlJv2sbNy95qjcripWhAs4CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586806; c=relaxed/simple;
	bh=YkG1tMgNhDZLeaZ2EIfL/PciDtBhQMWkgzIleFxDPSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmyCMxkikty5gU6g5N3dXHEg5r77OKNqmuwRA+unfZcaqXZtYuPHD3hkFYcUSJ9n09z54LsE+vdN5wAqcYsBLadkRVaeKGTGwyms9eGBCWNilTWI1ja4idMuOiV/2L4YlOmpf/tth0EQshUGj5+xex5u7soJumyF/q7AYdGBRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ma86qcds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ma86qcds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3899CC4CEE3;
	Tue, 15 Jul 2025 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586806;
	bh=YkG1tMgNhDZLeaZ2EIfL/PciDtBhQMWkgzIleFxDPSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma86qcds/0u43WaDhkWn9fsOMgoK7uDyZF/3c1BXtJPhZGLa2oW8v+suy0rXa1IaH
	 TPsAjezAGa7ha9OIMp4rDedStGqw9t0f91vzp9bhDuXt4kCrA9HchOEwG1nCXOKDn8
	 bHLgrdaATUrQR3fmXf3iSbG0UEVPC06bG/q8IVp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 024/192] arm64: poe: Handle spurious Overlay faults
Date: Tue, 15 Jul 2025 15:11:59 +0200
Message-ID: <20250715130815.834699217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Kevin Brodsky <kevin.brodsky@arm.com>

[ Upstream commit 22f3a4f6085951eff28bd1e44d3f388c1d9a5f44 ]

We do not currently issue an ISB after updating POR_EL0 when
context-switching it, for instance. The rationale is that if the old
value of POR_EL0 is more restrictive and causes a fault during
uaccess, the access will be retried [1]. In other words, we are
trading an ISB on every context-switching for the (unlikely)
possibility of a spurious fault. We may also miss faults if the new
value of POR_EL0 is more restrictive, but that's considered
acceptable.

However, as things stand, a spurious Overlay fault results in
uaccess failing right away since it causes fault_from_pkey() to
return true. If an Overlay fault is reported, we therefore need to
double check POR_EL0 against vma_pkey(vma) - this is what
arch_vma_access_permitted() already does.

As it turns out, we already perform that explicit check if no
Overlay fault is reported, and we need to keep that check (see
comment added in fault_from_pkey()). Net result: the Overlay ISS2
bit isn't of much help to decide whether a pkey fault occurred.

Remove the check for the Overlay bit from fault_from_pkey() and
add a comment to try and explain the situation. While at it, also
add a comment to permission_overlay_switch() in case anyone gets
surprised by the lack of ISB.

[1] https://lore.kernel.org/linux-arm-kernel/ZtYNGBrcE-j35fpw@arm.com/

Fixes: 160a8e13de6c ("arm64: context switch POR_EL0 register")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Link: https://lore.kernel.org/r/20250619160042.2499290-2-kevin.brodsky@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/process.c |  5 +++++
 arch/arm64/mm/fault.c       | 30 +++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 42faebb7b7123..4bc70205312e4 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -638,6 +638,11 @@ static void permission_overlay_switch(struct task_struct *next)
 	current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
 	if (current->thread.por_el0 != next->thread.por_el0) {
 		write_sysreg_s(next->thread.por_el0, SYS_POR_EL0);
+		/*
+		 * No ISB required as we can tolerate spurious Overlay faults -
+		 * the fault handler will check again based on the new value
+		 * of POR_EL0.
+		 */
 	}
 }
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index ec0a337891ddf..11eb8d1adc841 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -487,17 +487,29 @@ static void do_bad_area(unsigned long far, unsigned long esr,
 	}
 }
 
-static bool fault_from_pkey(unsigned long esr, struct vm_area_struct *vma,
-			unsigned int mm_flags)
+static bool fault_from_pkey(struct vm_area_struct *vma, unsigned int mm_flags)
 {
-	unsigned long iss2 = ESR_ELx_ISS2(esr);
-
 	if (!system_supports_poe())
 		return false;
 
-	if (esr_fsc_is_permission_fault(esr) && (iss2 & ESR_ELx_Overlay))
-		return true;
-
+	/*
+	 * We do not check whether an Overlay fault has occurred because we
+	 * cannot make a decision based solely on its value:
+	 *
+	 * - If Overlay is set, a fault did occur due to POE, but it may be
+	 *   spurious in those cases where we update POR_EL0 without ISB (e.g.
+	 *   on context-switch). We would then need to manually check POR_EL0
+	 *   against vma_pkey(vma), which is exactly what
+	 *   arch_vma_access_permitted() does.
+	 *
+	 * - If Overlay is not set, we may still need to report a pkey fault.
+	 *   This is the case if an access was made within a mapping but with no
+	 *   page mapped, and POR_EL0 forbids the access (according to
+	 *   vma_pkey()). Such access will result in a SIGSEGV regardless
+	 *   because core code checks arch_vma_access_permitted(), but in order
+	 *   to report the correct error code - SEGV_PKUERR - we must handle
+	 *   that case here.
+	 */
 	return !arch_vma_access_permitted(vma,
 			mm_flags & FAULT_FLAG_WRITE,
 			mm_flags & FAULT_FLAG_INSTRUCTION,
@@ -635,7 +647,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 		goto bad_area;
 	}
 
-	if (fault_from_pkey(esr, vma, mm_flags)) {
+	if (fault_from_pkey(vma, mm_flags)) {
 		pkey = vma_pkey(vma);
 		vma_end_read(vma);
 		fault = 0;
@@ -679,7 +691,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 		goto bad_area;
 	}
 
-	if (fault_from_pkey(esr, vma, mm_flags)) {
+	if (fault_from_pkey(vma, mm_flags)) {
 		pkey = vma_pkey(vma);
 		mmap_read_unlock(mm);
 		fault = 0;
-- 
2.39.5



