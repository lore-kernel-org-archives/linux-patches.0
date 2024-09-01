Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1CB208A7;
	Sun,  1 Sep 2024 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209716; cv=none; b=k4G0ujjomzhYIlg+Xsc6CMyNE7fne9Iy3flfImvIf4ZTzWRrCRmc+vRl2MjVzM8WyRRc/+bsG7AGZk66wnTBO49Sh6m6CiCZVUYisoSi1cuvdn9fq5S+Jal2fKnPi4xJAfCgotvBAF/JPr3saRdWAQRD8tPr5oIqKl5mzGtj270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209716; c=relaxed/simple;
	bh=VLP7m2rMthDPVEBLWn0IhGII9JlVA0Y/34xuh9pcEvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DR5+JgSimd8k1o3N54akYba/QN1BE/QF29LdZk5Lsyr0ab1r3QnRzjyotDFvVKfiRLv8JFqZa2WU0diARjeOFk2Gsjm33qq7xSQenkP+ZVBTqNOhzCohZ5X9jclULne8E/GLSPMeV9GTmLemHBMmc7Gicv9JHRjQYlvuG31k0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wakVpiWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wakVpiWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F42C4CEC3;
	Sun,  1 Sep 2024 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209716;
	bh=VLP7m2rMthDPVEBLWn0IhGII9JlVA0Y/34xuh9pcEvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wakVpiWMG8HJOUJTG6NY7pNHBR5i6aNGnZL84Le0lqohcDc3ACpqkoMS8m9vg+x56
	 OqlybDZ8pCfri6WPx7/Tahc67bdH/3ycZJLvy9xa8hLxVr44xMHS+mQj0H+Q3wRFwY
	 5GbKf5EA2338rCkcJVZkRkVNkJGTq/ZG5/8f9rS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Kees Cook <keescook@chromium.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 122/151] KVM: arm64: Dont use cbz/adr with external symbols
Date: Sun,  1 Sep 2024 18:18:02 +0200
Message-ID: <20240901160818.698905436@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Sami Tolvanen <samitolvanen@google.com>

commit dbaee836d60a8e1b03e7d53a37893235662ba124 upstream.

allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
linker errors:

  ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
  relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
  [-1048576, 1048575]; references hyp_panic
  >>> defined in vmlinux.o

  ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
  relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
  [-1048576, 1048575]; references hyp_panic
  >>> defined in vmlinux.o

This is because with LTO, the compiler ends up placing hyp_panic()
more than 1MB away from __guest_enter(). Use an unconditional branch
and adr_l instead to fix the issue.

Link: https://github.com/ClangBuiltLinux/linux/issues/1317
Reported-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210305202124.3768527-1-samitolvanen@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/entry.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -85,8 +85,10 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_
 
 	// If the hyp context is loaded, go straight to hyp_panic
 	get_loaded_vcpu x0, x1
-	cbz	x0, hyp_panic
+	cbnz	x0, 1f
+	b	hyp_panic
 
+1:
 	// The hyp context is saved so make sure it is restored to allow
 	// hyp_panic to run at hyp and, subsequently, panic to run in the host.
 	// This makes use of __guest_exit to avoid duplication but sets the
@@ -94,7 +96,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_
 	// current state is saved to the guest context but it will only be
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
-	adr	x1, hyp_panic
+	adr_l	x1, hyp_panic
 	str	x1, [x0, #CPU_XREG_OFFSET(30)]
 
 	get_vcpu_ptr	x1, x0


