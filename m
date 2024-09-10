Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F85914D280;
	Tue, 10 Sep 2024 10:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964671; cv=none; b=b41gkAMtPHkYzCOULbYoP0hQaUrn/02v3G8wAPgws21fN8ztd6TDkbrEi5Ta3HNEZkqxHFmY3vYPO7S1dbK5U/vYmbP7V4vLdxUJv5OiBGD+W8wjuOpFSRFuISCQSVM0ZdFH4xmMHNGh/33HZcW9QixqH2TAV91Y4zbqd1nbmZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964671; c=relaxed/simple;
	bh=xb0XZKo4HDKKsuLISmlcigBvs5EA8wKsVRM0aW/6tdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9SgTPmQFxDaYOhAeMP2lQzc5fpE5Jgmd4GZfb3nka8VSqnxF8pkKNo2POgyFs/n3ca7glyAwahwsCFNhaWcFtOz/u6bj+9vmN4s+mGRXFfxv8CqH9/lMvKpjU1fFj28JWHe0Q4Tif48AnYAHVUd4Fx4773BNN+RcGUMUCXPrvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyycQ8DW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyycQ8DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B8DC4CEC3;
	Tue, 10 Sep 2024 10:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964671;
	bh=xb0XZKo4HDKKsuLISmlcigBvs5EA8wKsVRM0aW/6tdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyycQ8DWjvDU79GzsF2uJ0Ld1GyVuRrenXaNWTXSFJaZpnUh3endY/1ZxiNNcXUx8
	 Cf4JWPZtRNO3dk+XwOlp0QxBAcVKqZgwxUHGJyzNxUQKA9/F+S+SJKwxD8qoMbFIvX
	 lUsF6nCmljERX/LpizXsNNmV5LFUrl628dDj+6/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/269] riscv: Do not restrict memory size because of linear mapping on nommu
Date: Tue, 10 Sep 2024 11:34:08 +0200
Message-ID: <20240910092617.070549600@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

[ Upstream commit 5f771088a2b5edd6f2c5c9f34484ca18dc389f3e ]

It makes no sense to restrict physical memory size because of linear
mapping size constraints when there is no linear mapping, so only do
that when mmu is enabled.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-riscv/CAMuHMdW0bnJt5GMRtOZGkTiM7GK4UaLJCDMF_Ouq++fnDKi3_A@mail.gmail.com/
Fixes: 3b6564427aea ("riscv: Fix linear mapping checks for non-contiguous memory regions")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240827065230.145021-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index abe7a7a7686c..3245bb525212 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -235,7 +235,7 @@ static void __init setup_bootmem(void)
 	 * The size of the linear page mapping may restrict the amount of
 	 * usable RAM.
 	 */
-	if (IS_ENABLED(CONFIG_64BIT)) {
+	if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_MMU)) {
 		max_mapped_addr = __pa(PAGE_OFFSET) + KERN_VIRT_SIZE;
 		memblock_cap_memory_range(phys_ram_base,
 					  max_mapped_addr - phys_ram_base);
-- 
2.43.0



