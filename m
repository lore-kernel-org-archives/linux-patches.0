Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594C51D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD119C433C8;
	Tue, 25 Jul 2023 11:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283161;
	bh=ktQjvKFFB87qeMfDXpFlhXlm2dTpneebVLuCdbCqCMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tv+T/NkutQ+bGHGejVq1qvrWlItnDbFTO0PosWQTP9Fo3NAZXjVL4oMna3JqP51nI
	 z7t+rdLhpXICu4Oad7+QRjTqDPp8t6SbsCPTxXSDXZoSEt/xUCQK+Uqg5wY0zfoz5A
	 uCU2Qj++Cx06rfJAwSGkTiFjQAIFIJySl/o8EH8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/183] bpf, arm64: Fix BTI type used for freplace attached functions
Date: Tue, 25 Jul 2023 12:45:59 +0200
Message-ID: <20230725104512.652372777@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit a3f25d614bc73b45e8f02adc6769876dfd16ca84 ]

When running an freplace attached bpf program on an arm64 system w were
seeing the following issue:
  Unhandled 64-bit el1h sync exception on CPU47, ESR 0x0000000036000003 -- BTI

After a bit of work to track it down I determined that what appeared to be
happening is that the 'bti c' at the start of the program was somehow being
reached after a 'br' instruction. Further digging pointed me toward the
fact that the function was attached via freplace. This in turn led me to
build_plt which I believe is invoking the long jump which is triggering
this error.

To resolve it we can replace the 'bti c' with 'bti jc' and add a comment
explaining why this has to be modified as such.

Fixes: b2ad54e1533e ("bpf, arm64: Implement bpf_arch_text_poke() for arm64")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/168926677665.316237.9953845318337455525.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8f16217c111c8..14134fd34ff79 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -322,7 +322,13 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	 *
 	 */
 
-	emit_bti(A64_BTI_C, ctx);
+	/* bpf function may be invoked by 3 instruction types:
+	 * 1. bl, attached via freplace to bpf prog via short jump
+	 * 2. br, attached via freplace to bpf prog via long jump
+	 * 3. blr, working as a function pointer, used by emit_call.
+	 * So BTI_JC should used here to support both br and blr.
+	 */
+	emit_bti(A64_BTI_JC, ctx);
 
 	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
 	emit(A64_NOP, ctx);
-- 
2.39.2



