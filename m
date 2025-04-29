Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC92140C03;
	Tue, 29 Apr 2025 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949850; cv=none; b=HS3Gfxtv2V7Vm7uEPPD/IsPsTFNc5OoCBGKMTMGhL+o9M4f5zkEAolTeSbDlYisI2jhWxXpnWoq7sAPVpBFxdTQj/YgMM6XvEa+iMdn7yjW5DqLGKGZnP+jPrmycRM0evJGm2RNFBPF8j6D5tFJbt9+U2qaCc/riBozM0vCx70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949850; c=relaxed/simple;
	bh=4UgokZSMM9YD3jmw3T9OtKDf5FIKHW5BDmp64hyi0GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDzzaQ8vjvECQODICc0knzM473yLxi9SV4vCmbRxF0dVpLt61o7ZIQ+iPToginzLMIMXa6BYMBKapaxg7oUtWE7kVUCVn0tiFWR9ftitH0KY+Ym4RVreXpfMEz9pz7V7pEd8QzknE/9VH+hULu/SCbAj4hWatQ3bJNvNO/N7/zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyH9o5D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyH9o5D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5A4C4CEE3;
	Tue, 29 Apr 2025 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949849;
	bh=4UgokZSMM9YD3jmw3T9OtKDf5FIKHW5BDmp64hyi0GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyH9o5D+he2F9KDC1Sw3EVswzM6sQ1XG9H27CXVD9ng/YrVCSKHSKz2n1+/x7Eb5C
	 DFePvo8vJPRW0r5nWTa+5EqfgszHIoUpfQ9rTHL2eYy7+UZWN90Hkf1wUriwx+1OM2
	 d+wb2nzBek9ntzhG4Jp8OlLIOCBk8igI9hyaDdug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/167] LoongArch: Make regs_irqs_disabled() more clear
Date: Tue, 29 Apr 2025 18:42:47 +0200
Message-ID: <20250429161054.156855044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 59c4608de91db..f5d9096d18aa1 100644
--- a/arch/loongarch/include/asm/ptrace.h
+++ b/arch/loongarch/include/asm/ptrace.h
@@ -32,9 +32,9 @@ struct pt_regs {
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



