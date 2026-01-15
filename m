Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3282B3BF302;
	Thu, 15 Jan 2026 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496953; cv=none; b=YHmjln36d5w80Tahgmg3pTT6nFMUlgEb3FsuLpturMGAglVySsEITj7WmxgQm18jhxov7msMi4WPvEOWTbHnteGD+2Ogu/8soEtAcnAs1KOgSb3k5uiTrLaJW2Lj7v2JT6FI5YPqNA7Me9lFUlQbQAIayVPwSebLe/TgPgsWaM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496953; c=relaxed/simple;
	bh=XCeY9sfrCSUzPx7+f4vowDDonEcxRWrh9JBGKqTzD8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=su1lt5Q/t6B1lK+hwq63bwVFr1NTtPBmJ62rgPw0jUdEUOToLiMglLgrureo8e6GDNq2DpbWR3ipmO9S4D1TE4HPY0PiLUYvnwmiv2IjsDhdkDjO5MN/KSIonD8If2vnQcS7u4NEPHVTqq00CyEYSrWj9k7YT9CZs9DjmXzzyvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoJzzv3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoJzzv3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0509C116D0;
	Thu, 15 Jan 2026 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496952;
	bh=XCeY9sfrCSUzPx7+f4vowDDonEcxRWrh9JBGKqTzD8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoJzzv3LbmEcHqlr/WcTK9LohnFzdQDlXtzJrY4SRzoQP/j7eZQbxo2mUelD4+WnG
	 k6KF9/ZhBW/GrxQR2w5FF5UOh88BiFz7wCDF3C4WwQxO1xfAgXS/kp2WhJXl9nKJJG
	 1A5F7F5iDe2fqHis9dRl9hWPYKBdR15VyQrLIjRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 72/88] riscv: uprobes: Add missing fence.i after building the XOL buffer
Date: Thu, 15 Jan 2026 17:48:55 +0100
Message-ID: <20260115164148.923640604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/uprobes.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -167,6 +167,7 @@ void arch_uprobe_copy_ixol(struct page *
 	/* Initialize the slot */
 	void *kaddr = kmap_atomic(page);
 	void *dst = kaddr + (vaddr & ~PAGE_MASK);
+	unsigned long start = (unsigned long)dst;
 
 	memcpy(dst, src, len);
 
@@ -176,13 +177,6 @@ void arch_uprobe_copy_ixol(struct page *
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


