Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632C25D546;
	Mon, 13 Oct 2025 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367084; cv=none; b=G/yY5ahK7CIyGW5Tw0+ZG9pVodSjyh2fa2ZpwVoSQ0f6oun91FM5TsIQdH7FPGQbuj0dcp/JSLPmYNPzg622gBKPSKvylBp16xzTca9v4THEWuNPGpTBEhuqKT1ab1/m/rKep25JLkffhwEG9V8yTvmUwreDCSrIIXECPzS6yvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367084; c=relaxed/simple;
	bh=IyBhUDrKO56TU9EmzBoXJy9Oe7VOxmb/Mm3pminJuYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgINs8zjsI83jCP5W0DBLPSxUJoQ8XrTEzr7kHk3ciGD9TvsicCR3BQii5OBXP6zMn2AhIOifzD2ckzLaYwfc3uG6vCutnF1Cs1D8HwSbTCY9oJzLABL0dltCgmoSuNFY8WniMk+xT2nhp08y0LxTXsUntlH/4t8Ut1wgN8V6/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kT2mLkrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kT2mLkrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ADEC4CEE7;
	Mon, 13 Oct 2025 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367084;
	bh=IyBhUDrKO56TU9EmzBoXJy9Oe7VOxmb/Mm3pminJuYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kT2mLkrETkvEVugHXxJTdZSpVqkujvZoDqol5a7qljUyMkKfgUTuyEYXd0EBkGqXE
	 +U4xIip2NqrYtl44iX9lQrg5ezKKKgJzcXRsE7tG6DhX1zCYXzEbO6TKhiTCkEkN+L
	 Lb4wK8W+CDHcqOeF5jBCS2P2mOIKeb9VydCzPf+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/196] x86/vdso: Fix output operand size of RDPID
Date: Mon, 13 Oct 2025 16:43:46 +0200
Message-ID: <20251013144316.503831851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit ac9c408ed19d535289ca59200dd6a44a6a2d6036 ]

RDPID instruction outputs to a word-sized register (64-bit on x86_64 and
32-bit on x86_32). Use an unsigned long variable to store the correct size.

LSL outputs to 32-bit register, use %k operand prefix to always print the
32-bit name of the register.

Use RDPID insn mnemonic while at it as the minimum binutils version of
2.30 supports it.

  [ bp: Merge two patches touching the same function into a single one. ]

Fixes: ffebbaedc861 ("x86/vdso: Introduce helper functions for CPU and node number")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250616095315.230620-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/segment.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 2e7890dd58a47..7865f180eb087 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -243,7 +243,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned int p;
+	unsigned long p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -253,10 +253,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 	 *
 	 * If RDPID is available, use it.
 	 */
-	alternative_io ("lsl %[seg],%[p]",
-			".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
+	alternative_io ("lsl %[seg],%k[p]",
+			"rdpid %[p]",
 			X86_FEATURE_RDPID,
-			[p] "=a" (p), [seg] "r" (__CPUNODE_SEG));
+			[p] "=r" (p), [seg] "r" (__CPUNODE_SEG));
 
 	if (cpu)
 		*cpu = (p & VDSO_CPUNODE_MASK);
-- 
2.51.0



