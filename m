Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC0C2E718E;
	Tue, 15 Jul 2025 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587153; cv=none; b=nOAKlW9/Sjd4Ho6PRN47ZiUkrN1ZEKsgpXyQQSZl5roHSsszIg8U8nYy4Y15FP18/J7LCq2IuEkxzah15Ue/Rvoc1bB9QXe/Z3sgnoJ3HfRNKy+EOFUL8tAmqdUDeuLaEbHnweUNbEiNQX6SNEnTK8TmJsaP7nKlzDoCYcxdBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587153; c=relaxed/simple;
	bh=phthB0gpB5RQ3d8QFdSr7f/9vZVRQZpSRXp4s+cl9HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjyULW06vV0JXTMZ8venqqNOGTcdl4oNAO3sp3czDdyXtF12UI+tDm6X1Wdig5TCcuQ8/TmfC2I+6cOy8Nzu0/e5mdBqUUykwTB0mSVqX0rMe2ngmR/46rRqr6f2XnDhMHh6a6u+InWNKzFO+Zl31bWSpLSIFSXJAikRuMrFUeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbbK6H2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbbK6H2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF20C4CEF1;
	Tue, 15 Jul 2025 13:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587153;
	bh=phthB0gpB5RQ3d8QFdSr7f/9vZVRQZpSRXp4s+cl9HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbbK6H2Z4O3pc6L+IKlzLlESwKuO+Agy5WgGSz6Ov7xCAqUlWJgE3CbPZlbTIyUPi
	 z4vJ+KqIpAYOzpHHoCeNwfswg+FBxO8O8CPAG3ZYUlXBP23bRbRpjJEMDCQ/+1ejm2
	 YIUVa7EZGxq69bCFPC3lL7qoHWOFJeDaft5G6x7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Fangrui Song <i@maskray.me>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 185/192] riscv: vdso: Exclude .rodata from the PT_DYNAMIC segment
Date: Tue, 15 Jul 2025 15:14:40 +0200
Message-ID: <20250715130822.347377440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangrui Song <i@maskray.me>

[ Upstream commit e0eb1b6b0cd29ca7793c501d5960fd36ba11f110 ]

.rodata is implicitly included in the PT_DYNAMIC segment due to
inheriting the segment of the preceding .dynamic section (in both GNU ld
and LLD).  When the .rodata section's size is not a multiple of 16
bytes on riscv64, llvm-readelf will report a "PT_DYNAMIC dynamic table
is invalid" warning.  Note: in the presence of the .dynamic section, GNU
readelf and llvm-readelf's -d option decodes the dynamic section using
the section.

This issue arose after commit 8f8c1ff879fab60f80f3a7aec3000f47e5b03ba9
("riscv: vdso.lds.S: remove hardcoded 0x800 .text start addr"), which
placed .rodata directly after .dynamic by removing .eh_frame.

This patch resolves the implicit inclusion into PT_DYNAMIC by explicitly
specifying the :text output section phdr.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2093
Signed-off-by: Fangrui Song <i@maskray.me>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250602-riscv-vdso-v1-1-0620cf63cff0@maskray.me
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/vdso.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index 8e86965a8aae4..646e268ede443 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -30,7 +30,7 @@ SECTIONS
 		*(.data .data.* .gnu.linkonce.d.*)
 		*(.dynbss)
 		*(.bss .bss.* .gnu.linkonce.b.*)
-	}
+	}						:text
 
 	.note		: { *(.note.*) }		:text	:note
 
-- 
2.39.5



