Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1670013F428;
	Wed, 19 Jun 2024 13:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804084; cv=none; b=sOrbEEClAFzB5YVzh967MSYhWpJ0BzlahjKOKwj0xT1dRnr3nnHrLfBFIj16HJgwxhrINeqhBTjtUH/YkINis/ecu2w0iz1auFxoc7KpBxsZMYuklZI92N/KHVzxZHIlRt5Xw3Mp6YdtPneD1qq1SbfLkW0Vchzabp3mTKjJaC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804084; c=relaxed/simple;
	bh=0sS7c4A7pJ3M6XxMuI0UuUqjFmqBUMz+7tCPn3Gc/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meI6TQUGI8KhqEKd8x62GrIhnjeXYA8B2aLasLslqHb6MOO/VhFepwnzeRvzqb1PeWA08GLSPIVl6669etor8U/hy6/aTosm1erGhXiyP0+y7MhU8xJ7/9Ca8UNXORwizSWSb2HK2Y0UKjKKSKjfL5BwscTDANmFy3ZA2qxjGbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbr7Who8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbr7Who8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2F3C2BBFC;
	Wed, 19 Jun 2024 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804083;
	bh=0sS7c4A7pJ3M6XxMuI0UuUqjFmqBUMz+7tCPn3Gc/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbr7Who8vJUK3wV6ol7RroUGU81iN8NrPdCQPVhn4jYE4RWAwgbM4sY6LcifWIdta
	 ZAQqrEs8biXsP+jXywC7mJkmfNmd0GyuauZsQ4IZXd1ViyTATRTrqGZpr1bP8U0ffl
	 l0CyeuAkbPGPGV3EBp0VWhA9vakh9WuLS/O/saZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 172/217] riscv: fix overlap of allocated page and PTR_ERR
Date: Wed, 19 Jun 2024 14:56:55 +0200
Message-ID: <20240619125603.325351148@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 994af1825a2aa286f4903ff64a1c7378b52defe6 upstream.

On riscv32, it is possible for the last page in virtual address space
(0xfffff000) to be allocated. This page overlaps with PTR_ERR, so that
shouldn't happen.

There is already some code to ensure memblock won't allocate the last page.
However, buddy allocator is left unchecked.

Fix this by reserving physical memory that would be mapped at virtual
addresses greater than 0xfffff000.

Reported-by: Björn Töpel <bjorn@kernel.org>
Closes: https://lore.kernel.org/linux-riscv/878r1ibpdn.fsf@all.your.base.are.belong.to.us
Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: <stable@vger.kernel.org>
Tested-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Link: https://lore.kernel.org/r/20240425115201.3044202-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -213,18 +213,19 @@ static void __init setup_bootmem(void)
 	if (!IS_ENABLED(CONFIG_XIP_KERNEL))
 		phys_ram_base = memblock_start_of_DRAM();
 	/*
-	 * memblock allocator is not aware of the fact that last 4K bytes of
-	 * the addressable memory can not be mapped because of IS_ERR_VALUE
-	 * macro. Make sure that last 4k bytes are not usable by memblock
-	 * if end of dram is equal to maximum addressable memory.  For 64-bit
-	 * kernel, this problem can't happen here as the end of the virtual
-	 * address space is occupied by the kernel mapping then this check must
-	 * be done as soon as the kernel mapping base address is determined.
+	 * Reserve physical address space that would be mapped to virtual
+	 * addresses greater than (void *)(-PAGE_SIZE) because:
+	 *  - This memory would overlap with ERR_PTR
+	 *  - This memory belongs to high memory, which is not supported
+	 *
+	 * This is not applicable to 64-bit kernel, because virtual addresses
+	 * after (void *)(-PAGE_SIZE) are not linearly mapped: they are
+	 * occupied by kernel mapping. Also it is unrealistic for high memory
+	 * to exist on 64-bit platforms.
 	 */
 	if (!IS_ENABLED(CONFIG_64BIT)) {
-		max_mapped_addr = __pa(~(ulong)0);
-		if (max_mapped_addr == (phys_ram_end - 1))
-			memblock_set_current_limit(max_mapped_addr - 4096);
+		max_mapped_addr = __va_to_pa_nodebug(-PAGE_SIZE);
+		memblock_reserve(max_mapped_addr, (phys_addr_t)-max_mapped_addr);
 	}
 
 	min_low_pfn = PFN_UP(phys_ram_base);


