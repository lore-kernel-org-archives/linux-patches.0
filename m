Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD071A00F0;
	Mon, 23 Mar 2026 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278653; cv=none; b=iCLDpjaVTEmUH3vEM6gTwyzlXMTW40Qp7paBofVpVjh+M2HdcQh8ReiVLEVddX4cRWXXnGC4tnw56KvNHk68G7g1k81xf8xQt1XMOak8w3r09wm46JHmZPdGmAscqgvrnfcusvq4KtyaVqqKSw3aWUygV+qrYgn8rwr+qPM++Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278653; c=relaxed/simple;
	bh=v44Aew+DQO4lBE5bbMmfbKXbAuj5rgMPWtMIwH0CGDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5XYTkAzAPzOIHRZKfilZjWNZJMlQQRa+jwh2yhbswM1s/AmiAK6mM0GNEccUQYqiwnmxAojiesAN4+fpnYqDo4ckjHZ0JzvO8Dx/ZN95LcQ+fxZACkM61PaY/r0bjjjHxClMFDfSHfUN5o4iXWVPD1cv8bliLaiFpxN3tF2Bag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6rwR0BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6rwR0BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72B2C4CEF7;
	Mon, 23 Mar 2026 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278653;
	bh=v44Aew+DQO4lBE5bbMmfbKXbAuj5rgMPWtMIwH0CGDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6rwR0BNvboGv2UfRnl+AguFJQ2eentLoBAyNV+t+gyh88J6VnmAwfJThLqmnATYh
	 4ZSksTvrcXmcsHYINCImeRMBUnxqgkDKbsw5uza73lMV1yTBNlS3VYyGNxX0yv2v7s
	 fK9vmydA/iLrVSz83Z9jNLvX3L9N7TsMtY8A/CXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Will Deacon <will@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 323/567] arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation
Date: Mon, 23 Mar 2026 14:44:03 +0100
Message-ID: <20260323134541.823390415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit c25c4aa3f79a488cc270507935a29c07dc6bddfc upstream.

Commit 143937ca51cc ("arm64, mm: avoid always making PTE dirty in
pte_mkwrite()") changed pte_mkwrite_novma() to only clear PTE_RDONLY
when PTE_DIRTY is set. This was to allow writable-clean PTEs for swap
pages that haven't actually been written.

However, this broke kexec and hibernation for some platforms. Both go
through trans_pgd_create_copy() -> _copy_pte(), which calls
pte_mkwrite_novma() to make the temporary linear-map copy fully
writable. With the updated pte_mkwrite_novma(), read-only kernel pages
(without PTE_DIRTY) remain read-only in the temporary mapping.
While such behaviour is fine for user pages where hardware DBM or
trapping will make them writeable, subsequent in-kernel writes by the
kexec relocation code will fault.

Add PTE_DIRTY back to all _PAGE_KERNEL* protection definitions. This was
the case prior to 5.4, commit aa57157be69f ("arm64: Ensure
VM_WRITE|VM_SHARED ptes are clean by default"). With the kernel
linear-map PTEs always having PTE_DIRTY set, pte_mkwrite_novma()
correctly clears PTE_RDONLY.

Fixes: 143937ca51cc ("arm64, mm: avoid always making PTE dirty in pte_mkwrite()")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: stable@vger.kernel.org
Reported-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Link: https://lore.kernel.org/r/20251204062722.3367201-1-jianpeng.chang.cn@windriver.com
Cc: Will Deacon <will@kernel.org>
Cc: Huang, Ying <ying.huang@linux.alibaba.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-prot.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -45,11 +45,11 @@
 
 #define _PAGE_DEFAULT		(_PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
 
-#define _PAGE_KERNEL		(PROT_NORMAL)
-#define _PAGE_KERNEL_RO		((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY)
-#define _PAGE_KERNEL_ROX	((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY)
-#define _PAGE_KERNEL_EXEC	(PROT_NORMAL & ~PTE_PXN)
-#define _PAGE_KERNEL_EXEC_CONT	((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
+#define _PAGE_KERNEL		(PROT_NORMAL | PTE_DIRTY)
+#define _PAGE_KERNEL_RO		((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY | PTE_DIRTY)
+#define _PAGE_KERNEL_ROX	((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY | PTE_DIRTY)
+#define _PAGE_KERNEL_EXEC	((PROT_NORMAL & ~PTE_PXN) | PTE_DIRTY)
+#define _PAGE_KERNEL_EXEC_CONT	((PROT_NORMAL & ~PTE_PXN) | PTE_CONT | PTE_DIRTY)
 
 #define _PAGE_SHARED		(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
 #define _PAGE_SHARED_EXEC	(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_WRITE)


