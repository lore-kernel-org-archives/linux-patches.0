Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47445315D54;
	Sun,  7 Sep 2025 20:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277385; cv=none; b=Fai4grZe47E26ddJvgdu9f71iMyyc9TtGgw6sCJrIPSbNQSDHdtagHTEnARkCVoBMfL6XQDuraxLsyrjVDpjijEJCvAIq6/ZhVS3wdL2obnHRYbosrbQ+4sixkXuBmYRUwY2wtaay7DHFPJhvML3V2x0SS+KT9N8QgUu9nneaJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277385; c=relaxed/simple;
	bh=6AKIt5Br+2o+/DaC/UHzssqP4Tz5bLCwQydWDEtnjWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVDSPI4HADMPTQXqfSyiOMpdeeSnRs7esv9ngZvKCiK2WJA0RVJVAL/aij+0h0kDTSjNfvaNbQu6JGqcOAg/CxvgUHqsXY+Ysw3mga6UaNMBH2oKIcyAA6klGokRza7hcDAUXbL3IwK7K6Fn3s2lzccPweSKj4Q/YB9f2/5IIV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm5kJLbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm5kJLbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC67C4CEF0;
	Sun,  7 Sep 2025 20:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277385;
	bh=6AKIt5Br+2o+/DaC/UHzssqP4Tz5bLCwQydWDEtnjWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm5kJLbd6Wlx2x1/4EkIVh+BdjTxW7Av9YfNwQta0eobCUmdmiZVRbbenUvrqV5Ga
	 B4qFFmwWj+rG/kSIQx/KaeEQKQncZ98r+hfPSPc1aqVQ44JNjOrwjw/YFcQXjB/L//
	 hBgcyHSZZ5b04RmdUuwMBmBQpCTxuHd5KgJ6I438=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>
Subject: [PATCH 6.12 172/175] riscv, bpf: use lw when reading int cpu in BPF_MOV64_PERCPU_REG
Date: Sun,  7 Sep 2025 21:59:27 +0200
Message-ID: <20250907195618.929896132@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Radim Krčmář <rkrcmar@ventanamicro.com>

commit ad5348c765914766a98ad26cf7a8c28d51a16bdd upstream.

emit_ld is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: 19c56d4e5be1 ("riscv, bpf: add internal-only MOV instruction to resolve per-CPU addrs")
Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Tested-by: Björn Töpel <bjorn@rivosinc.com> # QEMU
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250812090256.757273-3-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/net/bpf_jit_comp64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1150,7 +1150,7 @@ int bpf_jit_emit_insn(const struct bpf_i
 				emit_mv(rd, rs, ctx);
 #ifdef CONFIG_SMP
 			/* Load current CPU number in T1 */
-			emit_ld(RV_REG_T1, offsetof(struct thread_info, cpu),
+			emit_lw(RV_REG_T1, offsetof(struct thread_info, cpu),
 				RV_REG_TP, ctx);
 			/* Load address of __per_cpu_offset array in T2 */
 			emit_addr(RV_REG_T2, (u64)&__per_cpu_offset, extra_pass, ctx);


