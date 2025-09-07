Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4CC125B2;
	Sun,  7 Sep 2025 20:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277961; cv=none; b=rq+QJfuR6TYVgYk74zyxBok99xqUAg0G8KJ+nePmqZidl74m7ROILnwiPrO5RF94VHnSN8gtO1YTR2s5yEMAM/YhjtDtKH5jCTTbxN1BaP5eTcgIZzJ3SS9zo1k8va2nq5uSSTU9wmEWLBa5uFXB9rNYpw3h5r5phBZkFXig/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277961; c=relaxed/simple;
	bh=xoG5rAzIfcoRvorLz/n4vnblIqjtl5TWBIsFnC9tn+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXQk9NYVMitf9JrNvIfNgeomQoSxS8MW4IHjmDvh0ojfBgUTxQxxrWSR73LqkOylggSX49Z/Hkl1rKBc+FhoyIMTHbksWUUkE+eZlbu/lOXKw3c3TYdZVi6os77j+jqQDMCZRxhrrTzEUvVZ2CJL1Z9PzJ0o23JFFUAxqGK0s/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDXWQLK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDXWQLK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F46C4CEF0;
	Sun,  7 Sep 2025 20:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277961;
	bh=xoG5rAzIfcoRvorLz/n4vnblIqjtl5TWBIsFnC9tn+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDXWQLK3Zcvih2XeFrx3NoEL05Sbsp0NPf+e20HES8Sqe9QeHfjhmUFigWwL852hF
	 YiJFe+6IY5i6d2zP4P3/NHs75+z/srmDk42k6FkzDdOczN8jtXEP5woDFUAvJNUwj+
	 Ua5+HhXloTneGYhucyhvBkIEHtcty9/cbO7kSIXc=
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
Subject: [PATCH 6.16 178/183] riscv, bpf: use lw when reading int cpu in BPF_MOV64_PERCPU_REG
Date: Sun,  7 Sep 2025 22:00:05 +0200
Message-ID: <20250907195620.056651157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1356,7 +1356,7 @@ int bpf_jit_emit_insn(const struct bpf_i
 				emit_mv(rd, rs, ctx);
 #ifdef CONFIG_SMP
 			/* Load current CPU number in T1 */
-			emit_ld(RV_REG_T1, offsetof(struct thread_info, cpu),
+			emit_lw(RV_REG_T1, offsetof(struct thread_info, cpu),
 				RV_REG_TP, ctx);
 			/* Load address of __per_cpu_offset array in T2 */
 			emit_addr(RV_REG_T2, (u64)&__per_cpu_offset, extra_pass, ctx);


