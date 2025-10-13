Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ACB3101C7;
	Mon, 13 Oct 2025 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368010; cv=none; b=uC29h0RieTABmehGiPSzl6yaQf3by7xf+rdqDU6uM1cglKo85Pp9e7pbThjgo8Tmxtt3tmv4+WCxkf1Oxzl4FSMm3/YvC4QAlUUbf3QspKgzq+NOwmcIc+Eio3k4CQQT65JlZYFnPuaUZqxp5C+UoWMb32AuHGHDWfIusihzAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368010; c=relaxed/simple;
	bh=RyH7hujMbH/aRd+ssv+Psrsu0+FDg/g6HXmRLn7V7rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbK0KXTPawo6HPXiTUXyixaht0h/DW1Q6s4+U1Z8hb6Ouhh/5DZSZcLXumDNJ9f3rb1FlDchxf5RqjY+B3NGZz+gZY7HBKZILIqCB0uYMHAX7IOdUf9OAHUxoixxPMwI14xMTnD9NgK3zcSF28u9eesInQJhbwCiNF5MPLZ/kCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O0rg21B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O0rg21B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94245C4CEE7;
	Mon, 13 Oct 2025 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368010;
	bh=RyH7hujMbH/aRd+ssv+Psrsu0+FDg/g6HXmRLn7V7rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O0rg21BVjhpcoSnWEfkUrOepou3D2l/U+4PyhmrTZPIDOCnTmxJX+navTHI6uIFO
	 Y2tulecqO89QqpVGp9i/KWr/Ia8MrEUUQ53JOlXvpH61dBVAXbkxzuuJwmIQwI8cFI
	 0JsHJUZfAcRD10nCGm6NY7PvuorJ3ke0ulw2pgK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/262] x86/vdso: Fix output operand size of RDPID
Date: Mon, 13 Oct 2025 16:42:35 +0200
Message-ID: <20251013144326.605712193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d6411c659205..00cefbb59fa98 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -244,7 +244,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned int p;
+	unsigned long p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -254,10 +254,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
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



