Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B48051C31;
	Mon,  8 Jan 2024 15:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EImZGVI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A628C433C9;
	Mon,  8 Jan 2024 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728485;
	bh=yBSx4cy+ZfdkKzx2Es7bVi16KEwjobxCHyaQijirVWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EImZGVI7Omjy36tPRSXBFqrMwHw2Yd87KoWYFZHMyO28I3MCiDTVRku2hZjTYtOky
	 Ljy6YIw+irJiHM/B/EuZZ50qKwkke5XRn/OqXmG947PJabq44lEqWy0U5FZmUgFiO2
	 qXdFIaw8A0eS3HuS0XyEOewxH6KPRbVFwTCdAuWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <imagedong@tencent.com>,
	Yonghong Song <yhs@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/150] bpf, x86: save/restore regs with BPF_DW size
Date: Mon,  8 Jan 2024 16:35:13 +0100
Message-ID: <20240108153514.094910283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit 02a6dfa8ff43efb1c989f87a4d862aedf436088a ]

As we already reserve 8 byte in the stack for each reg, it is ok to
store/restore the regs in BPF_DW size. This will make the code in
save_regs()/restore_regs() simpler.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20230713040738.1789742-2-imagedong@tencent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 2b5dcb31a19a ("bpf, x64: Fix tailcall infinite loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 87cea23f2da16..84c695ae1940f 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1755,57 +1755,34 @@ st:			if (is_imm8(insn->off))
 static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 		      int stack_size)
 {
-	int i, j, arg_size;
-	bool next_same_struct = false;
+	int i;
 
 	/* Store function arguments to stack.
 	 * For a function that accepts two pointers the sequence will be:
 	 * mov QWORD PTR [rbp-0x10],rdi
 	 * mov QWORD PTR [rbp-0x8],rsi
 	 */
-	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
-		/* The arg_size is at most 16 bytes, enforced by the verifier. */
-		arg_size = m->arg_size[j];
-		if (arg_size > 8) {
-			arg_size = 8;
-			next_same_struct = !next_same_struct;
-		}
-
-		emit_stx(prog, bytes_to_bpf_size(arg_size),
-			 BPF_REG_FP,
+	for (i = 0; i < min(nr_regs, 6); i++)
+		emit_stx(prog, BPF_DW, BPF_REG_FP,
 			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
 			 -(stack_size - i * 8));
-
-		j = next_same_struct ? j : j + 1;
-	}
 }
 
 static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 			 int stack_size)
 {
-	int i, j, arg_size;
-	bool next_same_struct = false;
+	int i;
 
 	/* Restore function arguments from stack.
 	 * For a function that accepts two pointers the sequence will be:
 	 * EMIT4(0x48, 0x8B, 0x7D, 0xF0); mov rdi,QWORD PTR [rbp-0x10]
 	 * EMIT4(0x48, 0x8B, 0x75, 0xF8); mov rsi,QWORD PTR [rbp-0x8]
 	 */
-	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
-		/* The arg_size is at most 16 bytes, enforced by the verifier. */
-		arg_size = m->arg_size[j];
-		if (arg_size > 8) {
-			arg_size = 8;
-			next_same_struct = !next_same_struct;
-		}
-
-		emit_ldx(prog, bytes_to_bpf_size(arg_size),
+	for (i = 0; i < min(nr_regs, 6); i++)
+		emit_ldx(prog, BPF_DW,
 			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
 			 BPF_REG_FP,
 			 -(stack_size - i * 8));
-
-		j = next_same_struct ? j : j + 1;
-	}
 }
 
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
-- 
2.43.0



