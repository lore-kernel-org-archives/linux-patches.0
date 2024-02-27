Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BC13B2BA;
	Tue, 27 Feb 2024 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042754; cv=none; b=pNmgcRs9Gb4tlxVD0qQy2CH3aszyo/TnVtbWSBzgnvhYbcuM+d0E8168h1UHvlxAghB7PIIs2b3tJt0kzphgexpadqZIN+O6LjFzbAJ/aPpzHrfjGFPqUfTss+dvL4X98APZAE/XmCBmsznhQNNMP5w5LzEPwYTSHoqKBJ3julo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042754; c=relaxed/simple;
	bh=y+U2muLKmQITe4dLSnwDdcZViXq/ZE26fVBsc5gKsNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHOwpAXfQvclQWRpRo6jXVETJKB3E9PuZspKI8vQQ6iFPY6BtOblUjrjtynuzTUuHOpXTniXIB+Sr7LlA0jSyX1s2aycJ72dpe42nwuYz1VnfKw0QOZ7mqqFjZ38iB9N1va01mJYpkJcu4HJ0JI14jWSGw1RL/uygGLSU2bAjpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCRWmKZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCRWmKZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4059C433F1;
	Tue, 27 Feb 2024 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042754;
	bh=y+U2muLKmQITe4dLSnwDdcZViXq/ZE26fVBsc5gKsNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCRWmKZBuYUFYEx5SqyfSNlSfx/jH0cfIWC+XRl7aYZcwd8k9N6C3msNK2PQB1Pyp
	 piRu64u+/XAiJn03fMFXGZZ98aD5ghlVorsjL499M8AxRwGbjcKNKsy01vqyUoyQ5D
	 qAGnGLseeyM9/NEXA1nS9aPppagspb7J0h1pskGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 091/245] x86/ftrace: Use alternative RET encoding
Date: Tue, 27 Feb 2024 14:24:39 +0100
Message-ID: <20240227131618.183360714@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

Upstream commit: 1f001e9da6bbf482311e45e48f53c2bd2179e59c

Use the return thunk in ftrace trampolines, if needed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -311,7 +311,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
+#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -367,7 +367,10 @@ create_trampoline(struct ftrace_ops *ops
 		goto fail;
 
 	ip = trampoline + size;
-	memcpy(ip, retq, RET_SIZE);
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+		__text_gen_insn(ip, JMP32_INSN_OPCODE, ip, &__x86_return_thunk, JMP32_INSN_SIZE);
+	else
+		memcpy(ip, retq, sizeof(retq));
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {


