Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E1A11193;
	Mon,  4 Mar 2024 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588782; cv=none; b=r/wqa/ugLILe0Qs+YCnl6bTVPlrh7yIw9cA8/NBoT9Wzo2sr69R9dUx2jzXFRGPsDjAhWBn4ynC9Jnrh8Z/L2iVrsE8wcaIPgBLyAV+cbtJB5CjixxrTlXnZaPZH1OZ3ABzLJ9L+QODgpHEeGKV/Wcwjf8488aufzWbSg2AF2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588782; c=relaxed/simple;
	bh=c5qA1cZgyhViFFWouX5E7j+Thl/HIxiq6gSq3ZeMAO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZO/03nIlWB7JEKtgbX6xpgOF7yrudbimQNYW3B2zSu85xSKBpLVGQ7CpFk2hYrIv2FHv4swCxbGiy8aQ7mxRKRRBYo1xzvr+UVft+bzilNiYOJCkdKIrp1epROzriNjI2tCs/dUiUB1kMBYDnCN/YP/W1OD8Mrj3fxsYCQqgNYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldyLRwUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldyLRwUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBAEC433F1;
	Mon,  4 Mar 2024 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588782;
	bh=c5qA1cZgyhViFFWouX5E7j+Thl/HIxiq6gSq3ZeMAO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldyLRwUJsZeuy9K2bN88j5j+QyzWU0d+Cq1c6VhLqtgQ6iU8VEfSNfcRLEAvusZyz
	 EJVnvsLkWwq8RvQ6LVdeP/aj3VRArdy2r2qPIUVeBKkOvAbE1MF6u2CNGzlJ8LiRP/
	 7Vuu6XYRpyV5b0Ko3xJDzEUqA45VPOxwGPrx28XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Dimitris Vlachos <dvlachos@ics.forth.gr>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/215] riscv: Sparse-Memory/vmemmap out-of-bounds fix
Date: Mon,  4 Mar 2024 21:22:13 +0000
Message-ID: <20240304211559.205772451@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Dimitris Vlachos <dvlachos@ics.forth.gr>

[ Upstream commit a11dd49dcb9376776193e15641f84fcc1e5980c9 ]

Offset vmemmap so that the first page of vmemmap will be mapped
to the first page of physical memory in order to ensure that
vmemmap’s bounds will be respected during
pfn_to_page()/page_to_pfn() operations.
The conversion macros will produce correct SV39/48/57 addresses
for every possible/valid DRAM_BASE inside the physical memory limits.

v2:Address Alex's comments

Suggested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Dimitris Vlachos <dvlachos@ics.forth.gr>
Reported-by: Dimitris Vlachos <dvlachos@ics.forth.gr>
Closes: https://lore.kernel.org/linux-riscv/20240202135030.42265-1-csd4492@csd.uoc.gr
Fixes: d95f1a542c3d ("RISC-V: Implement sparsemem")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240229191723.32779-1-dvlachos@ics.forth.gr
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 59bb53da473dd..63055c6ad2c25 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -79,7 +79,7 @@
  * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
  * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
  */
-#define vmemmap		((struct page *)VMEMMAP_START)
+#define vmemmap		((struct page *)VMEMMAP_START - (phys_ram_base >> PAGE_SHIFT))
 
 #define PCI_IO_SIZE      SZ_16M
 #define PCI_IO_END       VMEMMAP_START
-- 
2.43.0



