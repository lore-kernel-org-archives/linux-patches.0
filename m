Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20BE24A06D;
	Wed, 25 Feb 2026 01:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983814; cv=none; b=qME6Y6bP2Ssh3m9/BLUTFHWmZ8knM/gvSYiw7yUgy4rwCfAGx2IG1YxLSfF9SSVTSFhEhBCej52fvxgYxImRXQDazppO0WFvsRpkmLErGYabhSkdVXW+viVadd6F0F2iH6xEKDF3ekJ/vDP9mvzlk+Q6ngRX7h3kSwlPdZDxdtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983814; c=relaxed/simple;
	bh=SzMfllMWqY3bLf5AdGJ7zDZP/NmF/s8hbQk/KGSgDMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv9r7ihc017KMsJX4hMPuXFFi0ZaKf13HnQLXBtM0YZePXPBc/Bkn0A8xQTnfYg2fv6Z0YAgekU0UqkB0G6X3wJmjjPaGEG6/aADO4sBu/QhfU8fjtVcVRtoqq1kdJnzmoz7u/8aJvf4EPeN3I8ubfi0NsP+86Qvr4HJ+LXDynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQfm/+n3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQfm/+n3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83048C19423;
	Wed, 25 Feb 2026 01:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983814;
	bh=SzMfllMWqY3bLf5AdGJ7zDZP/NmF/s8hbQk/KGSgDMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQfm/+n3h27VCIEJluPOZrNIkBeJqMemUGv0q0lreK4XrvnOymY4mNOf8WKM7MHUd
	 oZdNAj+5Uu0eMZpWI3gbSNxct1VSNqnEC/wRsNHz2ETWUnTUTQyCoshlHLD1t8EMjI
	 /og9WX53i2bRKLNkKR8ZMFvKQGkIRX7UhpvjzjJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/641] x86/fgraph: Fix return_to_handler regs.rsp value
Date: Tue, 24 Feb 2026 17:17:05 -0800
Message-ID: <20260225012351.508799951@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 8bc11700e0d23d4fdb7d8d5a73b2e95de427cabc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ftrace_64.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 823dbdd0eb410..ae94f7b0fdf16 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -354,6 +354,9 @@ SYM_CODE_START(return_to_handler)
 	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 
+	/* Store original rsp for pt_regs.sp value. */
+	movq %rsp, %rdi
+
 	/* Restore return_to_handler value that got eaten by previous ret instruction. */
 	subq $8, %rsp
 	UNWIND_HINT_FUNC
@@ -364,7 +367,7 @@ SYM_CODE_START(return_to_handler)
 	movq %rax, RAX(%rsp)
 	movq %rdx, RDX(%rsp)
 	movq %rbp, RBP(%rsp)
-	movq %rsp, RSP(%rsp)
+	movq %rdi, RSP(%rsp)
 	movq %rsp, %rdi
 
 	call ftrace_return_to_handler
-- 
2.51.0



