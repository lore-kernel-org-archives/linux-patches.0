Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA692572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D77C433EF;
	Tue, 18 Apr 2023 12:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821789;
	bh=T56x003GmgG+Wn2UewwsZMQpg9ril0zeHstqYDHIV2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ce614aL4y6/9p/6Cdk2w9YxpbAFBh9LWaHhp4oFxJ8CU+U70FJdsXz2sDtYnR56zF
	 I/YJG+CdGamBO/dNI+5ZODYjPMM2h+u3pmWGIiDdn4UtVw6fAhK7mmdOgMAAKw4mK9
	 cbPwO1kL8ukpPuNIM7fXakK8YWH1o06mFWTH5CnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Guo <guodongtai@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	WANG Xuerui <git@xen0n.name>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/134] LoongArch, bpf: Fix jit to skip speculation barrier opcode
Date: Tue, 18 Apr 2023 14:21:36 +0200
Message-Id: <20230418120314.335916209@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

[ Upstream commit a6f6a95f25803500079513780d11a911ce551d76 ]

Just skip the opcode(BPF_ST | BPF_NOSPEC) in the BPF JIT instead of
failing to JIT the entire program, given LoongArch currently has no
couterpart of a speculation barrier instruction. To verify the issue,
use the ltp testcase as shown below.

Also, Wang says:

  I can confirm there's currently no speculation barrier equivalent
  on LonogArch. (Loongson says there are builtin mitigations for
  Spectre-V1 and V2 on their chips, and AFAIK efforts to port the
  exploits to mips/LoongArch have all failed a few years ago.)

Without this patch:

  $ ./bpf_prog02
  [...]
  bpf_common.c:123: TBROK: Failed verification: ??? (524)
  [...]
  Summary:
  passed   0
  failed   0
  broken   1
  skipped  0
  warnings 0

With this patch:

  $ ./bpf_prog02
  [...]
  Summary:
  passed   0
  failed   0
  broken   0
  skipped  0
  warnings 0

Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: WANG Xuerui <git@xen0n.name>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/bpf/20230328071335.2664966-1-guodongtai@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 2467bfb8889a9..82b4402810da0 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -955,6 +955,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 		emit_atomic(insn, ctx);
 		break;
 
+	/* Speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
+
 	default:
 		pr_err("bpf_jit: unknown opcode %02x\n", code);
 		return -EINVAL;
-- 
2.39.2



