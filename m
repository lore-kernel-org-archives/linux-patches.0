Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDD0A93C;
	Tue, 13 Feb 2024 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845862; cv=none; b=j6NHkNil1x3veDafOuvRYuk2FY7WxsRCR76oZZ2ygsTO9pj0lM6+vm/GTFP0+L1kyTUF82i2okkXPreY4CPJHwWqrzWHWnxXAgiCyI6MwMMYnJpAnbPo3IGbjotxDS3210K3KqEa3ItRGzJM4I2YCnwUNL/Bux1BO+NB3mesaz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845862; c=relaxed/simple;
	bh=445BF313cd1nnkZRY/JjI6k4gDBwW8s+DYV5xR6SVGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjM+6T7ZgjN0KU8ft5HtLHTvJIMIA3XEKgWPfcG/2+jDGNDoRpgKiZBDNjw8/D0oMsiidznW9P26freZWH3+00HYZaKFQHX/ez2nfYECdGuAEZacQcBntm6u5iS5klTYi7+4LZTulLVGwTlrjk59NsVRGZvNDG4tp+Tp3tc675o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opnsFsP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opnsFsP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17F1C433C7;
	Tue, 13 Feb 2024 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845862;
	bh=445BF313cd1nnkZRY/JjI6k4gDBwW8s+DYV5xR6SVGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opnsFsP+KZj6DJuUKOFhOXqaCI18iHsgXMSyCwGXngTntsbzgBkfDQN7aHcrjCooj
	 JFpq+4Pvvs65C5AhcM3XLs81R9ciWTJLjshy823StLhhbICunCqe+Enb1IdS0svgcn
	 +Mp/fxbR16hb4GmVx+lpbUa824ywEcXD95IkHMhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 078/124] riscv: Flush the tlb when a page directory is freed
Date: Tue, 13 Feb 2024 18:21:40 +0100
Message-ID: <20240213171856.015384955@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



