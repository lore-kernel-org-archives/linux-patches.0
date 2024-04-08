Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E00A80023;
	Mon,  8 Apr 2024 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583163; cv=none; b=obraU5kGXwzFk3dodsTYqHfh7gTSIE2p8qEXiH4xGGK2KCMS9DcI/1EniEr759SO6pv2SphhRvYgmfOvh9ScsOH0CTmuGg9v/VTYM45M+MjmpdF+tLahSAkUE2+IpNyXS8f3MlJaohIRtF4OGCXhZgNC4f64tL3hSJjNvKMeeTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583163; c=relaxed/simple;
	bh=lVFvH+NLq8qT154B9G8JEIz/JGg9s1/pnkJUuwr+JXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9DwsgAIRUeKaEHLzGp7Ka9MeQ82+/eYed9OLTkZTZjWbrPTuvqZZFqGs5IxM+ct3bHBe8c79Cw1C/ueXcV7Lc1lV8dG5BxRyODq/kwHg5+Xh/wDkRwn7aeMvvptArU72kuoKqwIaxdtm6UwWuIZ28KBVdRaZxj+7vH2zQJ0ofM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvRnP+9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvRnP+9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C82C43390;
	Mon,  8 Apr 2024 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583163;
	bh=lVFvH+NLq8qT154B9G8JEIz/JGg9s1/pnkJUuwr+JXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvRnP+9owflGYx6WmvGIi4EetBBovZNbM0yt57E33pTDYMhfy+H33To+fJtbBATGr
	 IBLg57i6CAb6+SsZey6tXEjgFgC+m0usniLPIycszi8TNYGlyXF903mfK/yoeaqz9y
	 ao8p7hPuwliHDDMd7IdszMDQMHjDSHqvfAKU0wMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 147/273] riscv: mm: Fix prototype to avoid discarding const
Date: Mon,  8 Apr 2024 14:57:02 +0200
Message-ID: <20240408125313.852384716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 674bc0168e6b68070c75df22e97ab63b6eb60d89 ]

__flush_tlb_range() does not modify the provided cpumask, so its cmask
parameter can be pointer-to-const. This avoids the unsafe cast of
cpu_online_mask.

Fixes: 54d7431af73e ("riscv: Add support for BATCHED_UNMAP_TLB_FLUSH")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240301201837.2826172-1-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/tlbflush.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 893566e004b73..07d743f87b3f6 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -99,7 +99,7 @@ static void __ipi_flush_tlb_range_asid(void *info)
 	local_flush_tlb_range_asid(d->start, d->size, d->stride, d->asid);
 }
 
-static void __flush_tlb_range(struct cpumask *cmask, unsigned long asid,
+static void __flush_tlb_range(const struct cpumask *cmask, unsigned long asid,
 			      unsigned long start, unsigned long size,
 			      unsigned long stride)
 {
@@ -200,7 +200,7 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	__flush_tlb_range((struct cpumask *)cpu_online_mask, FLUSH_TLB_NO_ASID,
+	__flush_tlb_range(cpu_online_mask, FLUSH_TLB_NO_ASID,
 			  start, end - start, PAGE_SIZE);
 }
 
-- 
2.43.0



