Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D116537F8B2;
	Sat, 12 Sep 2026 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207875; cv=none; b=cfx1Wj56KeBlnEn6GeDRN9Ra/PIK65SBb9K/ev8ot5ezx8uaFpyIGv/KGCLr7A/w3gsYR1VCQx2hRN9S/mp9Wk96LsXCGWMEPi1x0h1R8/4P1DLi4Bj5+vCgO7hhAR8cF/UWJZI8Kq+Ysu8M6i1XeIbQ6IYkBXQFKoulaOvcFTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207875; c=relaxed/simple;
	bh=qH+Nsv8+Hmr2hNJ8/0ufiJIT++mgogd7z9eBXVxrHis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5SFsWEoEDbkJVdtTC5ukBWydqsvRZ/1l1rEwEMbXlIxxTHPc6EFsp9Kz5XcTwEOP1VRb4cJ7KBP4BJNA/6S0uX82zpwuVdzd2uWMKS3iCqGZ+sQYP5yzwtaQUDShzZP5Fra2mvNtH+P3IMTgKyRKsJf7uK38PVMZFk67QA8cBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOR1Qlje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOR1Qlje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E751F000FF;
	Sat, 12 Sep 2026 10:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207873;
	bh=98y5xieykSukXW+QuFBOqJ3LXWwALU8D5VimDJ4TIXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOR1Qljen6YRWuMVVR59JY7LcjsoS7e8+2CnoAX+g58BzrAc/LmNxAeg7xbK6YqQv
	 pCWVvt1xaJVfkh02pomTr9Q1Jr8UwtpAqmTYWNhFopFPgykYSKwOcn5TnZua2QDbvc
	 kJ5aQat/Tg7fjgTq79nzkWvkKBGOMOEVOPzNCba8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0500/1518] riscv, bpf: Fix memory leak in bpf_jit_free
Date: Sat, 12 Sep 2026 08:44:29 +0200
Message-ID: <20260912065634.754865666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 369e4635d04801f394d5bd42556f21029e95ff93 ]

When bpf_int_jit_compile() is called for subprograms, it returns early
during the first pass (!prog->is_func || extra_pass is false), keeping
ctx->offset alive for the subsequent extra pass.

If JIT compilation fails for a later subprogram, the BPF core aborts
and calls bpf_jit_free() to clean up the first subprogram. However,
bpf_jit_free() fails to free jit_data->ctx.offset, which causes a
memory leak of the JIT context offsets array.

Fix this by adding the missing kfree(jit_data->ctx.offset) in
bpf_jit_free().

Fixes: 48a8f78c50bd ("bpf, riscv: use prog pack allocator in the BPF JIT")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20260708064436.2971933-3-pulehui@huaweicloud.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index e4ab5bb9c9f64..09bd4eaac63e8 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -251,6 +251,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 */
 		if (jit_data) {
 			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
+			kfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
-- 
2.53.0



