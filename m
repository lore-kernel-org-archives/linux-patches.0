Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A6227E95;
	Tue, 29 Apr 2025 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950450; cv=none; b=XbA8bwYyRp/9fzin5zLOTdP2l4VamLpUhqhOkWwngermnIYaS96T6bRlWHu/UzAb6Sm5oX5kTYinlpnJnLk5To2onVyuy/GvJiRQKYY8t5I0Mp/ppjhulD6dP4C7+xJFa/AJh4InE7sjtweqekJ0hjP1R+xiRlnjQ8zkPTe98hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950450; c=relaxed/simple;
	bh=61x824ZcWTCXzKT1V+iWVUrtPBIyo+/PecYAGsdntx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2mf1UEGjga5tGRwF3VLtjnppcvdmjbbpvox/f669oG7nBJ7ye3quzQcCHhKp73Dq0ftnlkmqzOB7ZbAY+3Sm6El9fad2FATG7JyqbbEF5VoN8zaBEv0ZsoplCZ9LxclN/pdYDTb2krAM0fiq6QqYr1Cp0Jx4pwRSH963Zdk8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJOuwegj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJOuwegj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69D9C4CEE3;
	Tue, 29 Apr 2025 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950450;
	bh=61x824ZcWTCXzKT1V+iWVUrtPBIyo+/PecYAGsdntx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJOuwegjHIP1XWAmx0zqEQgq4pSHlyT3Wln5nm+1itpAM6cgBpE4J7pp4GYYVYsnS
	 drDAwBeiDaonigUE158JXGWQ9Kk0DPYKMcVgah7MEusoXXQA+FlsCeKlEhEvsqXEgB
	 YFI/V59+QKjBwtQQEMt4ROpP02kxcWR33QQxkKwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/204] LoongArch: Make regs_irqs_disabled() more clear
Date: Tue, 29 Apr 2025 18:42:38 +0200
Message-ID: <20250429161102.292249177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit bb0511d59db9b3e40c8d51f0d151ccd0fd44071d ]

In the current code, the definition of regs_irqs_disabled() is actually
"!(regs->csr_prmd & CSR_CRMD_IE)" because arch_irqs_disabled_flags() is
defined as "!(flags & CSR_CRMD_IE)", it looks a little strange.

Define regs_irqs_disabled() as !(regs->csr_prmd & CSR_PRMD_PIE) directly
to make it more clear, no functional change.

While at it, the return value of regs_irqs_disabled() is true or false,
so change its type to reflect that and also make it always inline.

Fixes: 803b0fc5c3f2 ("LoongArch: Add process management")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/ptrace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/ptrace.h b/arch/loongarch/include/asm/ptrace.h
index f3ddaed9ef7f0..a5b63c84f8541 100644
--- a/arch/loongarch/include/asm/ptrace.h
+++ b/arch/loongarch/include/asm/ptrace.h
@@ -33,9 +33,9 @@ struct pt_regs {
 	unsigned long __last[];
 } __aligned(8);
 
-static inline int regs_irqs_disabled(struct pt_regs *regs)
+static __always_inline bool regs_irqs_disabled(struct pt_regs *regs)
 {
-	return arch_irqs_disabled_flags(regs->csr_prmd);
+	return !(regs->csr_prmd & CSR_PRMD_PIE);
 }
 
 static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
-- 
2.39.5



