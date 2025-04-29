Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2C3248191;
	Tue, 29 Apr 2025 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945991; cv=none; b=cLBpeDmhfkE7IK5GyEk7saemJOOPynOyE8OSYmsZE5wkMI+H1jUSRSyzB9EeuGAue309w8c48MXkkxO7LhPsHCxv66uNhJndBVXXoOpuCp8Gr4eQmg+QjTRS6k9f+91nC4GxmM4MiLZol9OHMbOaJ9BuTmVaFKJZylBFDgg2Kq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945991; c=relaxed/simple;
	bh=AfTLJywSWey6NKRBypRiXDXt68AlqedOpy9ATMUTzAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQ+9NPJJxwSzrImpOxG6K7Kj23JCMmcbFLVDcPl5NlDmscoe40cDbq4UBburJkWkZowqIxyBsQXTgfOaVkEA1DVCnjdSPBpOJBCRtEe58elvFCcqz2zb+WFtnZSCpm3XJnN4z8rrZbL/ybc/SCn5CLy06sdPgEztBTNXaz5nnLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IN5uNSYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IN5uNSYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66442C4CEE3;
	Tue, 29 Apr 2025 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945990;
	bh=AfTLJywSWey6NKRBypRiXDXt68AlqedOpy9ATMUTzAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IN5uNSYLh2P5NnxZZt1d2WmWryX6gYMReLCbiesCVbEqSdnYIgnAwNpSF2x88waR6
	 isNi+nkNuGSooKl7Qo5DzwjqB53Gbs6euO+nlar888UtXfstJSwGiAE9L/N3i06p1I
	 B9H8g0tcgBxzGlw9d8hv9aDUf2O+e9xPnYC+/3xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 087/311] riscv: uprobes: Add missing fence.i after building the XOL buffer
Date: Tue, 29 Apr 2025 18:38:44 +0200
Message-ID: <20250429161124.612294220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 7d1d19a11cfbfd8bae1d89cc010b2cc397cd0c48 ]

The XOL (execute out-of-line) buffer is used to single-step the
replaced instruction(s) for uprobes. The RISC-V port was missing a
proper fence.i (i$ flushing) after constructing the XOL buffer, which
can result in incorrect execution of stale/broken instructions.

This was found running the BPF selftests "test_progs:
uprobe_autoattach, attach_probe" on the Spacemit K1/X60, where the
uprobes tests randomly blew up.

Reviewed-by: Guo Ren <guoren@kernel.org>
Fixes: 74784081aac8 ("riscv: Add uprobes supported")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20250419111402.1660267-2-bjorn@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/uprobes.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kernel/probes/uprobes.c b/arch/riscv/kernel/probes/uprobes.c
index 4b3dc8beaf77d..cc15f7ca6cc17 100644
--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -167,6 +167,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 	/* Initialize the slot */
 	void *kaddr = kmap_atomic(page);
 	void *dst = kaddr + (vaddr & ~PAGE_MASK);
+	unsigned long start = (unsigned long)dst;
 
 	memcpy(dst, src, len);
 
@@ -176,13 +177,6 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 		*(uprobe_opcode_t *)dst = __BUG_INSN_32;
 	}
 
+	flush_icache_range(start, start + len);
 	kunmap_atomic(kaddr);
-
-	/*
-	 * We probably need flush_icache_user_page() but it needs vma.
-	 * This should work on most of architectures by default. If
-	 * architecture needs to do something different it can define
-	 * its own version of the function.
-	 */
-	flush_dcache_page(page);
 }
-- 
2.39.5



