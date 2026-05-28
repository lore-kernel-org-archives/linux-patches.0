Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3112C15AC;
	Thu, 28 May 2026 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000412; cv=none; b=R8QxPa7PBKzzjFB/aN/botoYzddSbgNOF1uH88INeUFCSk1Mrxb+3rmL68K1369pmCDaBc0yXwA3ZqLAxzedDSUqSez2e6hBqy94TJUZr2ywhdC2PIfQIIPIvu9BTSoDRK/iTLeOtIydcj42s6BSKujwUYfT0BG6ZUaz1/dbT5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000412; c=relaxed/simple;
	bh=iAB3NO0zk1Jyz/6+g0mEJ4bhn/sZnibdxwME8yYbAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGs0zIL2Y5alaRBNQpjQxWI9C2Fq7gUqm8P42lo2XuVGD39ZBNLMVg4k2JFg+w1tQ3gov06Eip0MdPKW87IBIEcRGJEVF88hr9+kddH1Obi50DaOMtzql17imHnv81LrJqyF1gCg4x7M9S5jp96Cbp0MsOH6aWA/+x3Ed3jV/fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JT0p3got; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JT0p3got"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A8E1F00ACF;
	Thu, 28 May 2026 20:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000410;
	bh=/3AQhB3tqfXYF2URNfd49+zbNGdvFt27JYdLT4IxXwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JT0p3got5FWp/ETGDuySD9KAAxXLWezlKOsV0MJd6ihp9F+hszhPVp4tZHt7T6oHC
	 XICGrGhZdU3F+X71FKte5UMY7vmfun0DbmJVHEuAdzcATPfafcppJzhH6foqFXsbiA
	 r3gqJ4uz9uB90lWtuhRSX0yVTyk/K0diDS4g4b3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/272] x86/fgraph: Fix return_to_handler regs.rsp value
Date: Thu, 28 May 2026 21:46:49 +0200
Message-ID: <20260528194630.368142111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit 8bc11700e0d23d4fdb7d8d5a73b2e95de427cabc upstream.

The previous change (Fixes commit) messed up the rsp register value,
which is wrong because it's already adjusted with FRAME_SIZE, we need
the original rsp value.

This change does not affect fprobe current kernel unwind, the !perf_hw_regs
path perf_callchain_kernel:

        if (perf_hw_regs(regs)) {
                if (perf_callchain_store(entry, regs->ip))
                        return;
                unwind_start(&state, current, regs, NULL);
        } else {
                unwind_start(&state, current, NULL, (void *)regs->sp);
        }

which uses pt_regs.sp as first_frame boundary (FRAME_SIZE shift makes
no difference, unwind stil stops at the right frame).

This change fixes the other path when we want to unwind directly from
pt_regs sp/fp/ip state, which is coming in following change.

Fixes: 20a0bc10272f ("x86/fgraph,bpf: Fix stack ORC unwind from kprobe_multi return probe")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/bpf/20260126211837.472802-2-jolsa@kernel.org
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ftrace_64.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 8a3cff618692c..143fc62bf6f88 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -349,6 +349,9 @@ SYM_CODE_START(return_to_handler)
 	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 
+	/* Store original rsp for pt_regs.sp value. */
+	movq %rsp, %rdi
+
 	/* Restore return_to_handler value that got eaten by previous ret instruction. */
 	subq $8, %rsp
 	UNWIND_HINT_FUNC
@@ -359,7 +362,7 @@ SYM_CODE_START(return_to_handler)
 	movq %rax, RAX(%rsp)
 	movq %rdx, RDX(%rsp)
 	movq %rbp, RBP(%rsp)
-	movq %rsp, RSP(%rsp)
+	movq %rdi, RSP(%rsp)
 	movq %rsp, %rdi
 
 	call ftrace_return_to_handler
-- 
2.53.0



