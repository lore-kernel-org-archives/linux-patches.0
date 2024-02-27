Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17414690A;
	Tue, 27 Feb 2024 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044156; cv=none; b=CeV+Oj3VTuDmJEpT8t6y7/Q+5hEnX30x1J85SDSCoFjKNSikRpeJ1sGA4S/sov+RKuSg+s8gVYm0N4p86tekOLcmR43s86qrbbLwez/X++lb1/fGmmfoVsWqBETfBpoiEMaEqVnqPI1OCfOe3saTtmXhMiecbjA35H4aGR0MnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044156; c=relaxed/simple;
	bh=syD7NxbW8LaxVz2YfDjv7jQZqqbUDqrf6yP+fqbHQM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeOWodHRBMzdqj/al8kh7AtMzR79uxh+ZNQ4aVllhufQeO2d5cIi6vTGYOWSm5VFOk/WAeTizsDxB3wsqM8MZFGH5ntebwNQOmObt8jEJZyru/ykzaibXLVYmjTLol0gbEYalUloNUe001iqpObFER63NjLKfNmfDEm9GDGTIaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmmgYT3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmmgYT3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7866DC43390;
	Tue, 27 Feb 2024 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044155;
	bh=syD7NxbW8LaxVz2YfDjv7jQZqqbUDqrf6yP+fqbHQM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmmgYT3KA27AzbHeLWpxdGsRFrO2Hal79JkAEgAKWtADOohTB5j0azEekcauvXT/a
	 DkEh6PTKXl6tGZh5l9BUG8Y9cck++M4MVffTL+J69nhiUYAVGYBJ2vZLBI6ti+u+DM
	 RpCxLw6APh25kSKJbepxkR8zfuQmgzlO5xWSlU+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 083/122] Revert "x86/ftrace: Use alternative RET encoding"
Date: Tue, 27 Feb 2024 14:27:24 +0100
Message-ID: <20240227131601.423307712@linuxfoundation.org>
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


