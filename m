Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD8646AA70;
	Tue, 21 Jul 2026 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648130; cv=none; b=kdUt7izKwJRYtLSsr8J3oAtMsEmHuuhTI6ozL5Lqqpk27bvIjNO+8/H6qo4BjhsT8s01npRDryHQAA23ZtPLGu0cF/W3iMvF6vMWjOtqOqFw2L5hmX8Pt6FVAHpxlnADspVoI1hcAm01UTz3qF3zOM4fPsqGzWFh/DhKeUApG+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648130; c=relaxed/simple;
	bh=qINcM+HE7CO1Xa8qNZvLSXNwPZUmA06AU/DVm7w3olI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LY2w780SRu3f+9CktEE5NEQHYTmyCAgu037vMJ8lD3HdRqpmu1wBO7b78iY+eWlau8o/oTl0h0mGD+oBmQO8u1MfQ6BnatLDcq54UcHjgBMfK0P77O60PFIxUzbrGLZ7XSFZ/vfrht2nnrDuyDM26RPEOVB+pk0ZtC43QEUfBpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvhLULMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvhLULMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7091F000E9;
	Tue, 21 Jul 2026 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648129;
	bh=6lxz6lcKVfPe8lNjLI26ljqWwrCgmG8YFVaqWjyFnr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvhLULMFOdqkDvoIIHNUG0PMEKvP8XHD0KgeI+QKyQJXfaITf4nBveUkWcV/enWO9
	 Rz5/MOxJO+S56XdLtU6wHldTwRM3+uEQ6BqvwVYRQ/Ea6T+oPy1Xr5lQBldDsdbvld
	 rnIloTIe6xt8iopj/vYhXSQ5euOvl951yMaejCJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0081/2077] x86/bug: Add printf() validation to HAVE_ARCH_BUG_FORMAT_ARGS WARNs
Date: Tue, 21 Jul 2026 16:55:54 +0200
Message-ID: <20260721152554.605666676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 40c4b47f41b95dff743c841536cb64014e65ef0c ]

Add explicit printf() validation for x86-64's newfangled WARN
implementation, as most (all?) compilers fail to detect basic formatting
issues without the annotation.  E.g. even goofs like printing a u64 as a
string aren't detected:

  WARN_ONCE(1, "Bad message, %s", vcpu->arch.last_guest_tsc);

32-bit x86 doesn't support HAVE_ARCH_BUG_FORMAT_ARGS and uses generic
implementations that provide printf() validation. This means there's
now a big blind spot is code that is strictly x86-64. Inconveniently,
new features are also frequently x86-64-only.

Fix the blind 64-bit blind spot.

[ dhansen: changelog tweaks to flesh out the 64-bit-only details ]

Fixes: 5b472b6e5bd9 ("x86_64/bug: Implement __WARN_printf()")
Fixes: 11bb4944f014 ("x86/bug: Implement WARN_ONCE()")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/adc1IrD8uqWdaOKv@yzhao56-desk.sh.intel.com
Link: https://patch.msgid.link/20260423145419.459988-2-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/bug.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 80c1696d8d5978..bf3c802654d18a 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -153,6 +153,7 @@ struct arch_va_list {
 	struct sysv_va_list args;
 };
 extern void *__warn_args(struct arch_va_list *args, struct pt_regs *regs);
+static __always_inline __printf(1, 2) void __WARN_validate_printf(const char *fmt, ...) { }
 #endif /* __ASSEMBLER__ */
 
 #define __WARN_bug_entry(flags, format) ({				\
@@ -172,6 +173,7 @@ extern void *__warn_args(struct arch_va_list *args, struct pt_regs *regs);
 #define __WARN_print_arg(flags, format, arg...)				\
 do {									\
 	int __flags = (flags) | BUGFLAG_WARNING | BUGFLAG_ARGS ;	\
+	__WARN_validate_printf(format, ## arg);				\
 	static_call_mod(WARN_trap)(__WARN_bug_entry(__flags, format), ## arg); \
 	asm (""); /* inhibit tail-call optimization */			\
 } while (0)
-- 
2.53.0



