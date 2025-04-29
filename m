Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DB5215060;
	Tue, 29 Apr 2025 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945936; cv=none; b=KtZXCcRhuHjwWT6ggWNhLzvWdGtYEhNb8fkH7m03KK8G1b3x7VN51lZ6+qPPrCDagrJj/OgQkYJoBTZEPBlLOsQKYQMkymb/mJKTTU3inHP3sdChvu3l+2GMONGb7njkMsiX3bM9lKa3a6RfJyzf/20oSsKO4ZXHgOWwG65MZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945936; c=relaxed/simple;
	bh=7V14beKryKiEyQsF/f1vLKaXByvfDatq2d/puiPpB+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlq9zWMR7JFkniLmTI7Ymn3wa1FxK3FAS42/B66xUn1ZIIrpBn+y1p1pyYshIHm+fqXsXQJgTMFe4D/3En83JbYPWOkkiEVcRlsZ3Vz+b5lZ849FPmIU3+h1rmHWBIOzh2Z762P8Hn8Ng6SPlEAtyVvsrKDPc4zkboT3Sn5VSU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMxIZIKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMxIZIKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E59EC4CEE3;
	Tue, 29 Apr 2025 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945936;
	bh=7V14beKryKiEyQsF/f1vLKaXByvfDatq2d/puiPpB+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMxIZIKGYp2UQ7NlkHdfACmfi477Wwfgn6LiHhT40fObNWYfVLGH8EqtTe1q4B97Z
	 Vbb0D0oOdTIva0cWWoo2F2ywtcj4wbNdOB9DuEuNLVRSxULX/+cMUY+ZTwp3vnTCpI
	 jg1S3ptBQgbwKy4zbA9klHXnsrV8JniYe0QXh7p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 100/311] LoongArch: Make regs_irqs_disabled() more clear
Date: Tue, 29 Apr 2025 18:38:57 +0200
Message-ID: <20250429161125.136143852@linuxfoundation.org>
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



