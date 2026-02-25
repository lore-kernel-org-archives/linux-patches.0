Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AEF242D9B;
	Wed, 25 Feb 2026 01:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982934; cv=none; b=EttuCBKANlLpArICF7Z0+OgOI6rOyjclV4z0Fthl7WFedBeFDS36TVLly7KMWYHyohFoeZSXyb87cWYjgGs3ldgxgLItp8ZMsgVUDLLa5CEXca7aA3n0nHbN3gk29ChSPXdHwD9Io2+vc4crYIfbB4xOagKPcpuW5t6St/peOAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982934; c=relaxed/simple;
	bh=1RSpnshWRazYQOZWQjDe7ggH6pWBXphy8N1KjdhNSjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FT+aL8MhMZHEEcl+aSUwBD4wsdIzlHM185OcCI+zGjyF3AsMqrmfPzZRKA+l1WGZsxvNyK+HnGn8/vzxeVAFJlBDFCg4iv5M5kYE/inPCO+enzrNTdVnUtiQW66kk9DCedvr/eaeg70TNGShVH7ltJpYQsVQY72q2awZCAkIDkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9MLnpeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9MLnpeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C01DC116D0;
	Wed, 25 Feb 2026 01:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982934;
	bh=1RSpnshWRazYQOZWQjDe7ggH6pWBXphy8N1KjdhNSjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9MLnpeR4zQ1UU7DTDPK9tR2CRvH3JS186cems+jKayPzRhviev2hpaEBmvpba9Dv
	 hH+/16S1DX8DNQ5HzGSnkPMUAa0hMSFGnpXh7SoQHKrhhq6QZnvh92iUn37L6p1jhu
	 BHQwuXGzthb/Nowi+D+kwnbYlGaVgARnSSDVw9KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 111/781] x86/fgraph: Fix return_to_handler regs.rsp value
Date: Tue, 24 Feb 2026 17:13:40 -0800
Message-ID: <20260225012402.402093716@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a132608265f6c..62c1c93aa1c6a 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -364,6 +364,9 @@ SYM_CODE_START(return_to_handler)
 	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 
+	/* Store original rsp for pt_regs.sp value. */
+	movq %rsp, %rdi
+
 	/* Restore return_to_handler value that got eaten by previous ret instruction. */
 	subq $8, %rsp
 	UNWIND_HINT_FUNC
@@ -374,7 +377,7 @@ SYM_CODE_START(return_to_handler)
 	movq %rax, RAX(%rsp)
 	movq %rdx, RDX(%rsp)
 	movq %rbp, RBP(%rsp)
-	movq %rsp, RSP(%rsp)
+	movq %rdi, RSP(%rsp)
 	movq %rsp, %rdi
 
 	call ftrace_return_to_handler
-- 
2.51.0



