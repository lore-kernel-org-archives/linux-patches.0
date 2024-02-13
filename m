Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5707D5FF0C;
	Tue, 13 Feb 2024 17:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845488; cv=none; b=vDOiX3R2PMHYCNTgx2eb6CHMa6tEa4+Y7FMMgf0ldzLe3qpETlSCrjfZ8aWNTZRXTOz7hJDw7111+XMtYGLVkrDN4TgVbr8KaseasJzLK7qU6t2fNHNZjcRlpXGMD6GPPaMHi5vWTT2eVQey/9PHDakObQJCdkupY9VTRrRgSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845488; c=relaxed/simple;
	bh=lzrTaNbcS/oVZZc4e2Vx4tK0RdZ6TwLXvTQi277+J2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPx2VZwLc88MYV3+8bzhTNBmrUWR+lYYgZUceRyn/TQKpRvmFjFGcGRVH1myF7XXx/lbPYim2Dp8/lXgB3fxxmpylO1QUptcAHEm5lgdyVa5Gu2VXAg6NVH111kWIPWTHjub5MP7Hdq2bvBr1XadcSlkm6d7Gv1MRkAudUgBtSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcXWumLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcXWumLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB3DC433F1;
	Tue, 13 Feb 2024 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845487;
	bh=lzrTaNbcS/oVZZc4e2Vx4tK0RdZ6TwLXvTQi277+J2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcXWumLYMiGJqy5VSmgG1pOtd7FasHjCafstm2U57n1UWMJFdOPpO9dPfRUaSfK++
	 wTBf4pi59y7qyAz0gUIOFlnbiDKps1pML77vRGLUDVmu7loKretSxBkOQ/Tyo7caIk
	 xSTKKbXn6agnFTd6CyOn8uBRnk1S8dmo0IxHEXFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/121] riscv: Flush the tlb when a page directory is freed
Date: Tue, 13 Feb 2024 18:21:42 +0100
Message-ID: <20240213171855.706765912@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 97cf301fa42e8ea6e0a24de97bc0abcdc87d9504 ]

The riscv privileged specification mandates to flush the TLB whenever a
page directory is modified, so add that to tlb_flush().

Fixes: c5e9b2c2ae82 ("riscv: Improve tlb_flush()")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20240128120405.25876-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/tlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/tlb.h b/arch/riscv/include/asm/tlb.h
index 1eb5682b2af6..50b63b5c15bd 100644
--- a/arch/riscv/include/asm/tlb.h
+++ b/arch/riscv/include/asm/tlb.h
@@ -16,7 +16,7 @@ static void tlb_flush(struct mmu_gather *tlb);
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 #ifdef CONFIG_MMU
-	if (tlb->fullmm || tlb->need_flush_all)
+	if (tlb->fullmm || tlb->need_flush_all || tlb->freed_tables)
 		flush_tlb_mm(tlb->mm);
 	else
 		flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end,
-- 
2.43.0



