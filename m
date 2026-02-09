Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795003033D2;
	Mon,  9 Feb 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648994; cv=none; b=GZ4EZZuehgb2ZW/ZIGP+R2HQXQGF5A+PuvZwjfbpJB3za+nmlwMPu9BF/X4wF1fNuG3fPVBm6QkIN1/3vmn5H9ZTsoNzJKYng2stpyicfBlF/agkOPhGTksczrJ67IzngCHPrScZ6CQI7eNuBwoa3TS0PywF88xCE/WbaWPeFyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648994; c=relaxed/simple;
	bh=M1OklRuXXj45WCJhUFGOJfHJDt233UfVORyw70YYTF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNlgiNrZRsJ6YW/shy9zwesAW1yT+OGdgEwhNXVIh++VEUYTcPk224bgUoHYulD0qYWcA/z60VtsFxu+Guc5n3wEl+GnLcPDU8SIwRQPf5IBVTBzSsyvFpjzWhCr1eMk7+CkpPY9CR1DoLbBMeRxvweal34bN43j5V0+AHLE/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQyHhsko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQyHhsko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E48C16AAE;
	Mon,  9 Feb 2026 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648994;
	bh=M1OklRuXXj45WCJhUFGOJfHJDt233UfVORyw70YYTF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQyHhsko7n78g+9c/1qYNpoy4U3gnhPhBOzVU799vxWofldLOKCRwPmftEe5CUwJp
	 0zaduExpOqRiuCJ1ZoidZ598g8pcYCvqKfUFaFHsNdYnizZ7iEIKmU65s6jrDoQiSg
	 V6No0TAhLzfJZqTUZmxJMZ2z13SvHmEeadR7dVYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 5.15 61/75] riscv: uprobes: Add missing fence.i after building the XOL buffer
Date: Mon,  9 Feb 2026 15:24:58 +0100
Message-ID: <20260209142304.041269485@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

commit 7d1d19a11cfbfd8bae1d89cc010b2cc397cd0c48 upstream.

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
@@ -161,6 +161,7 @@ void arch_uprobe_copy_ixol(struct page *
 	/* Initialize the slot */
 	void *kaddr = kmap_atomic(page);
 	void *dst = kaddr + (vaddr & ~PAGE_MASK);
+	unsigned long start = (unsigned long)dst;
 
 	memcpy(dst, src, len);
 
@@ -170,13 +171,6 @@ void arch_uprobe_copy_ixol(struct page *
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


