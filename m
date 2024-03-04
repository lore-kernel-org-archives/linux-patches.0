Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F119DDCB;
	Mon,  4 Mar 2024 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588162; cv=none; b=eO54MvxqsePeRnxjtVVgAPk3CLZrR1kJMqyPCcEJZcLjKZiouaDm2/NybgbRehORqncfTBURtWGGUUcpvvLnW8atA2LGGA8O5cTK6FaIx94++YU7h9Qz3mrRnEAoBB6GQ8aBpsSRl1DwVNBy8XjrGrmjRZ+q1MJvGZu3i68nF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588162; c=relaxed/simple;
	bh=XXCQWMb2LuZsWQ9t+gNKfIjpgAAgL8VwO93HjfyGUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFZqn57PS8O8JT/BObBu2Y/K718JprqSJmbJ51p3Q/voI70qSw8NlshR5Tmub0jOFJ5aBrEDvKNeFFDly+mO7i8VOgKJ36+vMY+FuJqGi81wwbaKgpYY2tpvn1+LGOV8YnTLzEpnTW5WfxzafhhVm16ugdPs0RggIfwp9ldvNxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khGNq9IM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khGNq9IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6342C433C7;
	Mon,  4 Mar 2024 21:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588162;
	bh=XXCQWMb2LuZsWQ9t+gNKfIjpgAAgL8VwO93HjfyGUIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khGNq9IMXoNrJZGsTLwk2InkH6UktXp0ygGdp9Vs1AhwH4CGyXIM5hsRwc+yybwYW
	 RZVsQEO2arVDD89Wap8WrFi4MM3ZB6mfcddho+mj8rFg5vXwZIInsM6oDHVtmK4T7s
	 P9MGVGBUMH+qW1DSWKUoDhxqdxtSDLg5Lh4Y6Qnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Dimitris Vlachos <dvlachos@ics.forth.gr>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/42] riscv: Sparse-Memory/vmemmap out-of-bounds fix
Date: Mon,  4 Mar 2024 21:23:48 +0000
Message-ID: <20240304211538.340100085@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b16304fdf4489..5ab13570daa53 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -44,7 +44,7 @@
  * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
  * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
  */
-#define vmemmap		((struct page *)VMEMMAP_START)
+#define vmemmap		((struct page *)VMEMMAP_START - (phys_ram_base >> PAGE_SHIFT))
 
 #define PCI_IO_SIZE      SZ_16M
 #define PCI_IO_END       VMEMMAP_START
-- 
2.43.0



