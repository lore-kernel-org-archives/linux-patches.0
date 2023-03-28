Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB88476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19246C433D2;
	Tue, 28 Mar 2023 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015263;
	bh=DJ0CbK1NqKRNGloDc3w5YezRfW2KvfTJEJX1fXL9Vs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl/Agg5JTkNkb1BMqe68pEjs8l/QivoGvnG367N61mrgXkpwMLcns23/GZ715oSZT
	 7kSVHZGIJqUTw52Sx7NQ9iwhzn4kyKS4sulhwEjrVyYvS0lZMZXGcUe0wQ6AYi/6eb
	 YFbZ9So2+1YktI+y1QLKJIZJZXgkcWGJqCeGLxc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Jhong <dylan@andestech.com>,
	Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 225/240] riscv: mm: Fix incorrect ASID argument when flushing TLB
Date: Tue, 28 Mar 2023 16:43:08 +0200
Message-Id: <20230328142629.107774069@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dylan Jhong <dylan@andestech.com>

commit 9a801afd3eb95e1a89aba17321062df06fb49d98 upstream.

Currently, we pass the CONTEXTID instead of the ASID to the TLB flush
function. We should only take the ASID field to prevent from touching
the reserved bit field.

Fixes: 3f1e782998cd ("riscv: add ASID-based tlbflushing methods")
Signed-off-by: Dylan Jhong <dylan@andestech.com>
Reviewed-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Link: https://lore.kernel.org/r/20230313034906.2401730-1-dylan@andestech.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/tlbflush.h |    2 ++
 arch/riscv/mm/context.c           |    2 +-
 arch/riscv/mm/tlbflush.c          |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -12,6 +12,8 @@
 #include <asm/errata_list.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long asid_mask;
+
 static inline void local_flush_tlb_all(void)
 {
 	__asm__ __volatile__ ("sfence.vma" : : : "memory");
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -22,7 +22,7 @@ DEFINE_STATIC_KEY_FALSE(use_asid_allocat
 
 static unsigned long asid_bits;
 static unsigned long num_asids;
-static unsigned long asid_mask;
+unsigned long asid_mask;
 
 static atomic_long_t current_version;
 
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -42,7 +42,7 @@ static void __sbi_tlb_flush_range(struct
 	/* check if the tlbflush needs to be sent to other CPUs */
 	broadcast = cpumask_any_but(cmask, cpuid) < nr_cpu_ids;
 	if (static_branch_unlikely(&use_asid_allocator)) {
-		unsigned long asid = atomic_long_read(&mm->context.id);
+		unsigned long asid = atomic_long_read(&mm->context.id) & asid_mask;
 
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);


