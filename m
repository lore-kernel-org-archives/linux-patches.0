Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A1F16F8EF;
	Mon, 28 Oct 2024 06:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098056; cv=none; b=ed48WmQ84tqx0BkWCZ50Q6jvlv5TcwekILROp6jVaboqVYbMu9+GVxOBE3Hrgf0AbWYUnlM4jDLu4rW36fP+8gsvTCzYtQ8Qnt6KMTm7a6gPLJYf48EdgnI3BVAGd93RZMd25hXgSoORMtzmJnsjGvt77gyHf0/K+FydOIP4yQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098056; c=relaxed/simple;
	bh=n1cbzfZ/Fnl7XBL3aryZrJkdAadiNllM1dScZTUXXZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXraj0zyqfGxYFvtL34w51n5wym9TI7YpcbqsJx5Itf2e6iSLjBKaa5hXj88s6Gqkz4SFisjonWDXu/2nIr6Wy5mOrH30goCSl02TTqUscW4ZrQfvboT/px0b/HzPkkLa85peB7VNTODTtvu/53Ik5wwPhnTTs9Q3tLyfThojJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9YL9Neh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9YL9Neh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3B7C4CEC3;
	Mon, 28 Oct 2024 06:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098056;
	bh=n1cbzfZ/Fnl7XBL3aryZrJkdAadiNllM1dScZTUXXZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9YL9NehKVIpHhU9ebVajaj8BvJDkQ6+G5hbIs5nG0Ss7qjSOgwhE+tiE3v360d8q
	 /13042qbGbgPttQAa4VvP0xVUuTA19JsgzTKTlcIGbxJIaaLk0ibhEIyXMw4xW7oIE
	 u+/1B3HDKsJ/Wao7DqOp81YYbJGEsSyJKFrl9His=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 021/261] riscv, bpf: Fix possible infinite tailcall when CONFIG_CFI_CLANG is enabled
Date: Mon, 28 Oct 2024 07:22:43 +0100
Message-ID: <20241028062312.543684002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 30a59cc79754fd9ff3f41b7ee2eb21da85988548 ]

When CONFIG_CFI_CLANG is enabled, the number of prologue instructions
skipped by tailcall needs to include the kcfi instruction, otherwise the
TCC will be initialized every tailcall is called, which may result in
infinite tailcalls.

Fixes: e63985ecd226 ("bpf, riscv64/cfi: Support kCFI + BPF on riscv64")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20241008124544.171161-1-pulehui@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 99f34409fb60f..91bd5082c4d8e 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -18,6 +18,7 @@
 #define RV_MAX_REG_ARGS 8
 #define RV_FENTRY_NINSNS 2
 #define RV_FENTRY_NBYTES (RV_FENTRY_NINSNS * 4)
+#define RV_KCFI_NINSNS (IS_ENABLED(CONFIG_CFI_CLANG) ? 1 : 0)
 /* imm that allows emit_imm to emit max count insns */
 #define RV_MAX_COUNT_IMM 0x7FFF7FF7FF7FF7FF
 
@@ -271,7 +272,8 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 	if (!is_tail_call)
 		emit_addiw(RV_REG_A0, RV_REG_A5, 0, ctx);
 	emit_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
-		  is_tail_call ? (RV_FENTRY_NINSNS + 1) * 4 : 0, /* skip reserved nops and TCC init */
+		  /* kcfi, fentry and TCC init insns will be skipped on tailcall */
+		  is_tail_call ? (RV_KCFI_NINSNS + RV_FENTRY_NINSNS + 1) * 4 : 0,
 		  ctx);
 }
 
-- 
2.43.0



