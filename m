Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4302932E152;
	Mon, 27 Oct 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590985; cv=none; b=KtvfErHntCXGTghc7LfcbCsZ7wwW2vYmLmDHHF9/Suc0ZbRWNnUeUuV1vqrja57lx4tqDQ0BY3eIBth9gvq/k4RMyAosxOwPQJedGRRjoTm2s315jB+HPuxpfAgd+ezdt1lNRGDUl8V+cNyK5jZ86Z8er2ShKB/oNqloxG+zZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590985; c=relaxed/simple;
	bh=dTCzaBfFfd5vgihOAdmsazHVr64+ac++PtHwihussB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqGv2jUZ+HJ0O+V6b6yU0eRTrD4bF7P1LPi/9tWJxjQ/rgi2ZhOLN4xmxWiDWLi48YZp5fkzx+0QdXIn+OxXqqXc4sGk4lLTl9fdq950LZ+T+45FAzHXKwQlebUTl5HkTRTS8eTV6Oud1S5KpN6QyoNwGR2dEv66hXiXymXq5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrfcPu0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrfcPu0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95089C4CEF1;
	Mon, 27 Oct 2025 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590984;
	bh=dTCzaBfFfd5vgihOAdmsazHVr64+ac++PtHwihussB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrfcPu0VqEow14s0eesAlszRuKXVMi4t5ZL48ZVk72vW8yR5acgTi5sg4BXkBZ8SV
	 bBj5L9/6aI7nKxXrWkZNg60OGzNoKSkMelspQ7jw8/+cjccex1fOHPx6rr4SLPPkn3
	 bKMsqCeEPoX3la/NrQ9sbyCfonXRrdlajihXguWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/332] x86/vdso: Fix output operand size of RDPID
Date: Mon, 27 Oct 2025 19:31:16 +0100
Message-ID: <20251027183525.232781437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 72044026eb3c2..8686f5cfbc6b7 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -242,7 +242,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned int p;
+	unsigned long p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -252,10 +252,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
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



