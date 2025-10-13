Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F6530C35E;
	Mon, 13 Oct 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367893; cv=none; b=ere3waa6cjHtB6ccoKVCFP7JpRtAhhzn6CsZdj28JDzIK5t1W1cF0vU2X+Tj3jSExSqRBgo+oQk1Wf2Kxjjoc+HvE6hCPMyUHIJMjIGOlxt6agwqQb+aFuRvdiv09pF+y4LBSIpf8gR16qDh2TsExQq5nrg5WaNY9MpZBpqdK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367893; c=relaxed/simple;
	bh=g5WA7B0uezhDbC3rYoOn7VUZCO25W1g9MD6xBjfi7cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vpnhui+BVJlIfm7gLxizLLAFuOXu/k5bZgKkUv6w7UrNtANiYF5XasZwc/OcTKMoTAaTGQVODdLHsYpwg/Bxzo8klnDaQ9b4NnJCcEhhyNTHgmG4hrt8rnwvI4omjGPGBXsWAYi09Atl397/rmY14Y6tfzPJIcZgUGozBK71CdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW4Ej4IJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW4Ej4IJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2756CC4CEE7;
	Mon, 13 Oct 2025 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367893;
	bh=g5WA7B0uezhDbC3rYoOn7VUZCO25W1g9MD6xBjfi7cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW4Ej4IJ/I1ZJZVPM0Yq0DnrGO0WmauwSjCsUauYYU8/gKAK4Ynw+pWsucPsbFwy3
	 vf0N6194JulJm5SpEphLNuxek33lLZnL+fRz7UkeIs51d4O+EKswCbshY2gFBcD2hm
	 NhtTsAESL3ia5fP9s3Q1gAR9u9LAs49a5dc8cSTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Yuan <shenghaoyuan0928@163.com>,
	Tianci Cao <ziye@zju.edu.cn>,
	Yazhou Tang <tangyazhou518@outlook.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/196] bpf: Reject negative offsets for ALU ops
Date: Mon, 13 Oct 2025 16:45:59 +0200
Message-ID: <20251013144321.388130472@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazhou Tang <tangyazhou518@outlook.com>

[ Upstream commit 55c0ced59fe17dee34e9dfd5f7be63cbab207758 ]

When verifying BPF programs, the check_alu_op() function validates
instructions with ALU operations. The 'offset' field in these
instructions is a signed 16-bit integer.

The existing check 'insn->off > 1' was intended to ensure the offset is
either 0, or 1 for BPF_MOD/BPF_DIV. However, because 'insn->off' is
signed, this check incorrectly accepts all negative values (e.g., -1).

This commit tightens the validation by changing the condition to
'(insn->off != 0 && insn->off != 1)'. This ensures that any value
other than the explicitly permitted 0 and 1 is rejected, hardening the
verifier against malformed BPF programs.

Co-developed-by: Shenghao Yuan <shenghaoyuan0928@163.com>
Signed-off-by: Shenghao Yuan <shenghaoyuan0928@163.com>
Co-developed-by: Tianci Cao <ziye@zju.edu.cn>
Signed-off-by: Tianci Cao <ziye@zju.edu.cn>
Signed-off-by: Yazhou Tang <tangyazhou518@outlook.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Fixes: ec0e2da95f72 ("bpf: Support new signed div/mod instructions.")
Link: https://lore.kernel.org/r/tencent_70D024BAE70A0A309A4781694C7B764B0608@qq.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a6f825b7fbe6c..5e644b1b12aaa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13727,7 +13727,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	} else {	/* all other ALU ops: and, sub, xor, add, ... */
 
 		if (BPF_SRC(insn->code) == BPF_X) {
-			if (insn->imm != 0 || insn->off > 1 ||
+			if (insn->imm != 0 || (insn->off != 0 && insn->off != 1) ||
 			    (insn->off == 1 && opcode != BPF_MOD && opcode != BPF_DIV)) {
 				verbose(env, "BPF_ALU uses reserved fields\n");
 				return -EINVAL;
@@ -13737,7 +13737,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			if (err)
 				return err;
 		} else {
-			if (insn->src_reg != BPF_REG_0 || insn->off > 1 ||
+			if (insn->src_reg != BPF_REG_0 || (insn->off != 0 && insn->off != 1) ||
 			    (insn->off == 1 && opcode != BPF_MOD && opcode != BPF_DIV)) {
 				verbose(env, "BPF_ALU uses reserved fields\n");
 				return -EINVAL;
-- 
2.51.0



