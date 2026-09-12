Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F4147B439;
	Sat, 12 Sep 2026 12:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215876; cv=none; b=mbw4dVWfipa9yKroeEuG0aSN12HasG5cHGO+CqDBxWJ/ttBFXMxeOpJrM5pMuuSd7HBNH/O1c9v8tCCp8hPBF2xIuFaw1KfMg0jursuq+Mzy5e5GLdRwQJy9vph0zU9RqA7KopTLXN95fXnOp5pReJC9Am3/wo6+mzKaA8nNiag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215876; c=relaxed/simple;
	bh=sIIXsAiFOpl+1a68PGdnK/9z1fhF0Rvue6DR7Dc9Dyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrLN1Lb0Vvlc+2rgBBGzAsv9XGyfo8kjH5TqOcphxaPgUptq21sJZHSlerkh3xIqF6hIhMcCiMxLAZcMAiVXHAYY1RJIbdjpYoFUPvXA0Jx4WdWgV3BlI5hpomFYDPMB2VbG1Y3F35wnEB44fjSG7kh1FIyuJ3y+J/vXOKRyxR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TT8VJBmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TT8VJBmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7C91F000FF;
	Sat, 12 Sep 2026 12:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215872;
	bh=jY6AkOEy2ZtAyhiRx7qNdNLDzn2Qzcqe9dkCq8FKRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TT8VJBmt+nizEGjJ2rTGEtKChJd9OoIRkcicxnyw/dNXOUzOSimcpvL/MzSBYbPlO
	 BAgNiiuTW+YN61oYCw7Qo/1EJ6/vQyay42dXyMPTc+P/u8NRJI0qdb4xayZrnyUgZD
	 P+FY2ud0U7tDDHdsfbtcev+TBWSiV0vSN/Nw+1oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0622/1376] riscv, bpf: Fix memory leak in bpf_jit_free
Date: Sat, 12 Sep 2026 08:50:48 +0200
Message-ID: <20260912065621.407314195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f2af89ab4dfe..43cba6b657b72 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -259,6 +259,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 */
 		if (jit_data) {
 			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
+			kfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
-- 
2.53.0



