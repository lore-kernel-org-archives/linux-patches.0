Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97342FF155;
	Tue, 12 Aug 2025 18:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024155; cv=none; b=PqwS5zsttbDyaKNp1LrFAdEUOs7xQ+8qEuq/4HxbZjlNgnFa+5sgJ6rjexVuxH0BZOA9sweBOfUaalwEyf0WjD2Yke3dAQ2W1rQFkMg7gmVzJsJyfZ9+G1H7aoTI2kRBlktYWOUsXNC2HUszff4vrFUPCA4bLssvzp+uvHP8vSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024155; c=relaxed/simple;
	bh=j/sTsKDOYgzM7Ydem+iPCQ3n1Flqdltsmq5/ce7g4ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSXrcSaLhbhY+IxtRxmxJmC/fMlikqPwMEbBJuw4bsqIASS5QT5fLUobXH0gKIW09lCxSZUF6APCHbj1BXXtYcqFKlEgM4/fKG9XDrbsUZb03RZYxVMyUf32DhF5hv+BGF2DcHk8FAS1Y93W3aSIwSm2fRwaEntKsMmnOJYttVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg3JyfvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg3JyfvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CD3C4CEF0;
	Tue, 12 Aug 2025 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024155;
	bh=j/sTsKDOYgzM7Ydem+iPCQ3n1Flqdltsmq5/ce7g4ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg3JyfvKvjbvHcSGuzQ4qPfSh9VQGU1SYausD6Q8zandtd5pbPDUfnjX4tmeJrYZ8
	 Bd1NMaLPSW8MA4K+7z/LU5A5V3OT2rYTabfRvMvyiNwovIZCtsBsEOuwk3+EoBlW8e
	 ELdrPVbelqJ46WBB0vChCuBgr5juHZwlfl/ed6+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Xu Kuohai <xukuohai@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 291/627] bpf, arm64: Fix fp initialization for exception boundary
Date: Tue, 12 Aug 2025 19:29:46 +0200
Message-ID: <20250812173430.382383795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit b114fcee766d5101eada1aca7bb5fd0a86c89b35 ]

In the ARM64 BPF JIT when prog->aux->exception_boundary is set for a BPF
program, find_used_callee_regs() is not called because for a program
acting as exception boundary, all callee saved registers are saved.
find_used_callee_regs() sets `ctx->fp_used = true;` when it sees FP
being used in any of the instructions.

For programs acting as exception boundary, ctx->fp_used remains false
even if frame pointer is used by the program and therefore, FP is not
set-up for such programs in the prologue. This can cause the kernel to
crash due to a pagefault.

Fix it by setting ctx->fp_used = true for exception boundary programs as
fp is always saved in such programs.

Fixes: 5d4fa9ec5643 ("bpf, arm64: Avoid blindly saving/restoring all callee-saved registers")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/bpf/20250722133410.54161-2-puranjay@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index da8b89dd2910..58f838b310bc 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -412,6 +412,7 @@ static void push_callee_regs(struct jit_ctx *ctx)
 		emit(A64_PUSH(A64_R(23), A64_R(24), A64_SP), ctx);
 		emit(A64_PUSH(A64_R(25), A64_R(26), A64_SP), ctx);
 		emit(A64_PUSH(A64_R(27), A64_R(28), A64_SP), ctx);
+		ctx->fp_used = true;
 	} else {
 		find_used_callee_regs(ctx);
 		for (i = 0; i + 1 < ctx->nr_used_callee_reg; i += 2) {
-- 
2.39.5



