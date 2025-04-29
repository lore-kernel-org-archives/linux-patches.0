Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35231FE468;
	Tue, 29 Apr 2025 17:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946317; cv=none; b=WEKQg3G1U/PtlsHv08e16O6T2Y+avDDegSP9aL04grAUHLxlvmvvoY+BkM+2/uMY+mroa6lbxP2BDKtWm4TOCSFbgzK2Vgpv+Z84aSstXBItDbWAureoYKnoGxsDfe/SMSUJXg2hAIfNRn0VqQK1wfbrw4LeODRHugfi9b9TQ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946317; c=relaxed/simple;
	bh=DP+5ObCn55GgYXwxrzHcEwEPGMEDOIHPtWgQ1Mbi4Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+aGILUCAQ+5d56LM1o3snWcJT/ROMWrDF9qqzoXakhTk6L9dMbqgeriy6mWkwKQ5vJIEUhjBDMCpDi+IRW5Oz7vJDJEptlXBCqB/LZpvVcna4tJfnpf0FPf6eTHTDP/650vvQyPyhEsbfRFEjbgTp9SPh9Xa4wQnJwP9L1p5XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qe6vsQiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qe6vsQiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BB7C4CEE9;
	Tue, 29 Apr 2025 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946316;
	bh=DP+5ObCn55GgYXwxrzHcEwEPGMEDOIHPtWgQ1Mbi4Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe6vsQivV6nYDkc+98yxAc/F28f2nn7To21vR/rA+PPTZKQ0iyPhDBl4kzkzIzJ9O
	 x9Fm5a0IY4TmFIdeUZRSLotuPGKBolmkcpbd4VdJfuHQGxnkyyTS+6R4706ehtxIR3
	 5/ktbYZTckBnz0vChM5i5h00RcCuZ8eXdIOnCwwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 227/311] riscv: tracing: Fix __write_overflow_field in ftrace_partial_regs()
Date: Tue, 29 Apr 2025 18:41:04 +0200
Message-ID: <20250429161130.333346626@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

[ Upstream commit bba547810c66434475d8800b3411c59ef71eafe9 ]

The size of &regs->a0 is unknown, causing the error:

../include/linux/fortify-string.h:571:25: warning: call to
'__write_overflow_field' declared with attribute warning: detected write
beyond size of field (1st parameter); maybe use struct_group()?
[-Wattribute-warning]

Fix this by wrapping the required registers in pt_regs with
struct_group() and reference the group when doing the offending
memcpy().

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250224-fix_ftrace_partial_regs-v1-1-54b906417e86@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/ftrace.h |  2 +-
 arch/riscv/include/asm/ptrace.h | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index 2636ee00ccf0f..9704a73e515a5 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -207,7 +207,7 @@ ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
 {
 	struct __arch_ftrace_regs *afregs = arch_ftrace_regs(fregs);
 
-	memcpy(&regs->a0, afregs->args, sizeof(afregs->args));
+	memcpy(&regs->a_regs, afregs->args, sizeof(afregs->args));
 	regs->epc = afregs->epc;
 	regs->ra = afregs->ra;
 	regs->sp = afregs->sp;
diff --git a/arch/riscv/include/asm/ptrace.h b/arch/riscv/include/asm/ptrace.h
index b5b0adcc85c18..2910231977cb7 100644
--- a/arch/riscv/include/asm/ptrace.h
+++ b/arch/riscv/include/asm/ptrace.h
@@ -23,14 +23,16 @@ struct pt_regs {
 	unsigned long t2;
 	unsigned long s0;
 	unsigned long s1;
-	unsigned long a0;
-	unsigned long a1;
-	unsigned long a2;
-	unsigned long a3;
-	unsigned long a4;
-	unsigned long a5;
-	unsigned long a6;
-	unsigned long a7;
+	struct_group(a_regs,
+		unsigned long a0;
+		unsigned long a1;
+		unsigned long a2;
+		unsigned long a3;
+		unsigned long a4;
+		unsigned long a5;
+		unsigned long a6;
+		unsigned long a7;
+	);
 	unsigned long s2;
 	unsigned long s3;
 	unsigned long s4;
-- 
2.39.5



