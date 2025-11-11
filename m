Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E467262A;
	Tue, 11 Nov 2025 01:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822972; cv=none; b=tYjFUWyxrkr+A07E8x/lF32AwdvF5BCyS8MI+v4lv1MDDL8M4RAMhrKukaLTIcG/EFVMrHIZ0ZolBMkhkJO+F9Knuk6ys/0mT85WvLxE0C00W/wLMYH4Wjq52MfMTWUo0wNviF5WQFwur0UP2s3R5wUXXWHTwZ/Rt9wbH472IME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822972; c=relaxed/simple;
	bh=fX8ndYhZlgl51+iGVdj3PmsOoBKd0Ios6w4VL5zYr4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnK8ZEBw9DQfeqWWFTh7eHUGVtnzs/OQy2luTFICXYe9h/cnR54q/o1kGkTiigypAcMyZzMYTNX+y0zzUM0SfrvbR3gfYjVzj6Wrk+6hzz/L8toVu4c+r+zy49qjYMPoh3Z6iZLWLZZupVc0NXFZMwSuDnuTVvvyzUvLiwQqj/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV6z2dpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV6z2dpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C74C116B1;
	Tue, 11 Nov 2025 01:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822972;
	bh=fX8ndYhZlgl51+iGVdj3PmsOoBKd0Ios6w4VL5zYr4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV6z2dpBUhir5d0wxT3WNCrNy8PpOrMl9MjL5OwZWecTVIuZru5aevRXy3iBZgrnm
	 YtSn2xeu2YCl821q0+QWsRpYKfFbXAsulP9cMv7QEh+cCbuFdYykYZGpQO0/MfSSz7
	 PuglWEfu9hLt/gRrtPSecYQXmhnoYO09idNbpmnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 204/849] riscv: bpf: Fix uninitialized symbol retval_off
Date: Tue, 11 Nov 2025 09:36:14 +0900
Message-ID: <20251111004541.371410650@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghao Duan <duanchenghao@kylinos.cn>

[ Upstream commit d0bf7cd5df18466d969bb60e8890b74cf96081ca ]

In the __arch_prepare_bpf_trampoline() function, retval_off is only
meaningful when save_ret is true, so the current logic is correct.
However, in the original logic, retval_off is only initialized under
certain conditions; for example, in the fmod_ret logic, the compiler is
not aware that the flags of the fmod_ret program (prog) have set
BPF_TRAMP_F_CALL_ORIG, which results in an uninitialized symbol
compilation warning.

So initialize retval_off unconditionally to fix it.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20250922062244.822937-2-duanchenghao@kylinos.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index f1efa4d6b27f3..bad8c47ed4a7f 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1112,10 +1112,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	stack_size += 16;
 
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
-	if (save_ret) {
+	if (save_ret)
 		stack_size += 16; /* Save both A5 (BPF R0) and A0 */
-		retval_off = stack_size;
-	}
+	retval_off = stack_size;
 
 	stack_size += nr_arg_slots * 8;
 	args_off = stack_size;
-- 
2.51.0



