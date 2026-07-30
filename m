Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C543E095;
	Thu, 30 Jul 2026 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422200; cv=none; b=L2xqckfKwwACYuqNuMzH0ubPAIC8LNvthVWSBUqcE6JAOhvxhclsYLlnX6ozMs+IlOr92fCLpS0kgBxoYINJahJhSxpHQhYHLSIECS+dfkUAO85VQuAE0xXBXWIBdpdTl7LjLU6B6CZOobT0QvZr9r0WmPnIaeZnDp7klWutRXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422200; c=relaxed/simple;
	bh=YTxHgmhK2+wbIf1xC4zUnUNGHWOlgAb6SYqQerq2lww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQQlgR+Y7uj0TDCCFd9GtMEFrF8NZtHMiBcc7bTt1Pftxugdk/NYB8vWCJZxoObI0JdGeJxQKxwg8fsNk6tL28+qb6HDhqYnTvVhmOeT48QgY2l/PkZFlocxqqTeqa9A6hCM1lWVYXCqsvtL165kz7gAgLu8eSN9pMgno+RrslE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU8DhE47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU8DhE47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64FF1F000E9;
	Thu, 30 Jul 2026 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422199;
	bh=IenCo4MPLY5FCGTeOR5Oo5pR0jiIKSNRb5TycNK51k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vU8DhE47/3mXdE1/kSydmBYFMVzKGdhmz9Vp/Ge/q1zOlmjdVua/ep3zeJo7VaoG4
	 A/rt6HdItRlO1hbhYIiCx6Rol25f03VoRuY+TrEGnqDypphGfxprSZ4cLN18XAX8eZ
	 hfIxQ1837/QPnxqh/nhAGK40DFbKuBQD0/+1oBJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Pu Lehui <pulehui@huawei.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 356/744] LoongArch: BPF: Fix memory leak in bpf_jit_free()
Date: Thu, 30 Jul 2026 16:10:29 +0200
Message-ID: <20260730141451.851791242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 47e20d4b3da97ef3881d1e55e43545c22424f3fc ]

When bpf_int_jit_compile() is called for subprograms, it returns early
during the first pass (!prog->is_func || extra_pass is false), keeping
ctx->offset alive for the subsequent extra pass.

If JIT compilation fails for a later subprogram, the BPF core aborts and
calls bpf_jit_free() to clean up the first subprogram. However,
bpf_jit_free() fails to free jit_data->ctx.offset, which causes a memory
leak of the JIT context offsets array.

So fix this by adding the missing kvfree(jit_data->ctx.offset) in
bpf_jit_free().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4ab17e762b34 ("LoongArch: BPF: Use BPF prog pack allocator")
Acked-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 22c03c02dae6ed..4933869b2c11fb 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -2347,6 +2347,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 */
 		if (jit_data) {
 			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
+			kvfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
-- 
2.53.0



