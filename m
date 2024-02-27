Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D81419B3;
	Tue, 27 Feb 2024 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044164; cv=none; b=DrI1UEJ9Wt2kgV4wF0h4kpWW3FvFfwJ7FyHvfBslwfiEqBqDbW4dMntXG9v1+KRVCwUmi/qQ0XxyNdfET3uiTz3kIKqAxT6PkWFcubuZjMQmtWVbS9/NQFTdgjlrpbVmJGtjb7k48JzyzIKRP0ZrtPJ2CnyAp/gY6YLlU6iwNlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044164; c=relaxed/simple;
	bh=KwWWl6NIQbGezQxLvsZMqEUKRpjwbEBZoMRoIcvCHh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTeFbcil+Ib77btSzutA+YEODx3hZtLosN+nZrAK2hxMswAo9tQ2GG4iYDhp6ZYSGa58x0foqEk4PqSAF2WeDz1nafwHfZz1Fi8Ix5/8seODy3VWtwxB7wLME34+ZsW5xQxsoAiIruUyY+MYbSK3ibUfg0L+0TE7nyOnNRA7ykk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRyRFz0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRyRFz0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C669EC43390;
	Tue, 27 Feb 2024 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044164;
	bh=KwWWl6NIQbGezQxLvsZMqEUKRpjwbEBZoMRoIcvCHh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRyRFz0UYXSGtt3w0hza0U/ln/NlJaP8UyPtjl9UdXrE80Wv9MW5OyOR8BrdN5xSi
	 fQTrj0bmA+PRTcQNkuAey4A1am8Y54q/ymj61XxA6jBluoTozyK0woWMxDy/58ahnf
	 7BrfGjZmOD8gxVY3amMTsjNY71XnwUyK2KkyZT0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 086/122] x86/ftrace: Use alternative RET encoding
Date: Tue, 27 Feb 2024 14:27:27 +0100
Message-ID: <20240227131601.520374031@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


