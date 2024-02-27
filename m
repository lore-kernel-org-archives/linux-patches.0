Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9F013B2A2;
	Tue, 27 Feb 2024 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042701; cv=none; b=P7QL7g44Iig8aD6usVwW08/F7ul+Tf6NaDPwBXCf3EZUFsaWkHNOXyofaD4M2Art884kaYm77tUanR3dO79+HjYzPUzValBq7N6iOG8def2I2ZDNPJvRbmkfmpkIbB7WDEm0l4SPXzacWBOJ/1mqCCHwQSDf0UppvC3IjBHDS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042701; c=relaxed/simple;
	bh=IVmoN8oaRaBekEtMQjwcTe1k9hLzO957nYAr8w/ZXSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmkMJXuRUq8jBTLgs9EAc6DIE+aJ8s4HVwiDOx8bnS0x317GI5eoDTtexacKjCY0QRaXdP1u8XrVM70IK1t2uyFOtyIcph24pGo3+Ek2sc58UQtEsHz+dL1jAO2hrDHfuCWmiDvXTkAuSLMu5+xUZnvu09WPqcEXpDd5RzAs4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lcmi/vJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lcmi/vJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47866C433C7;
	Tue, 27 Feb 2024 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042701;
	bh=IVmoN8oaRaBekEtMQjwcTe1k9hLzO957nYAr8w/ZXSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lcmi/vJ183iAycKYP08yWamrOMD4jp5ogBynCiZnkzC2tEekfIV8zTm6MFQvPGc6H
	 UNw0Qt8RJqaEqinO1xSL2jPtk/3svKMXKQcMICO1NNCLPTD85Hu5XTe+5aKQKxLj5b
	 UqUbnYANZsLJQNnsp6uCKEDC5TC43nx4aE6utlrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 088/245] Revert "x86/ftrace: Use alternative RET encoding"
Date: Tue, 27 Feb 2024 14:24:36 +0100
Message-ID: <20240227131618.084327879@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

This reverts commit 3eb602ad6a94a76941f93173131a71ad36fa1324.

Revert the backport of upstream commit

  1f001e9da6bb ("x86/ftrace: Use alternative RET encoding")

in favor of a proper backport after backporting the commit which adds
__text_gen_insn().

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -311,7 +311,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
+#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -367,12 +367,7 @@ create_trampoline(struct ftrace_ops *ops
 		goto fail;
 
 	ip = trampoline + size;
-
-	/* The trampoline ends with ret(q) */
-	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
-	else
-		memcpy(ip, retq, sizeof(retq));
+	memcpy(ip, retq, RET_SIZE);
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {


