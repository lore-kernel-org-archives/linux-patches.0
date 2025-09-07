Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3B720E005;
	Sun,  7 Sep 2025 20:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277964; cv=none; b=TIl5+QK9QtqsyTtEatFraZ/dS9CyvtusnzWQdoOoRMHY7GhMt80jP6yGXIZ5mElQ5bGJDxg8KTAYTF0fQRDTg4IspGQbwlZ6ilMpGKsvMv5nwVX6MeLn/JXZomAmtE63U/SQulEA9yYJsWyt+bt796ES6E6hC8Q7YUZ66D5T79E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277964; c=relaxed/simple;
	bh=aTvNTnOTpzHTBDQ8hz/RcNP4xYS5S2H/MxbfTAfE2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o66ASh53GdRLWab6x6g8O/4xrDqcHkw6CTEKNZfwWOyEm0fmriSYLPIyhqZ1qukDHywVOBOzqI2S/yqvpVyHg3NYFJSI729+2D46fGK9c5IL08AvAGdRhQLbkZZNGWb0x+MQves3Ql9fHcbw/fFAe0odBDfQwhP05GGpcQfxB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hul/wgAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hul/wgAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D703FC4CEF0;
	Sun,  7 Sep 2025 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277964;
	bh=aTvNTnOTpzHTBDQ8hz/RcNP4xYS5S2H/MxbfTAfE2oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hul/wgAc7vmzauvaYCPrAcyLmcrQ85wha/A3Qkbyxpnz3cD1nPpitOpl9grymHxBK
	 sotaeeX3FvVgJDZhEhsuu+FmgvF/AHk82ADuLrclg+GNl9Fa0ggeJ66T+XNm21AdHZ
	 lpfLJnyYqOTxsrgcMZb57tCTgr1iTjzzIZdJBaJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Pu Lehui <pulehui@huawei.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 179/183] riscv, bpf: use lw when reading int cpu in bpf_get_smp_processor_id
Date: Sun,  7 Sep 2025 22:00:06 +0200
Message-ID: <20250907195620.082318213@linuxfoundation.org>
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

commit 8a16586fa7b8a01360890d284896b90c217dca44 upstream.

emit_ld is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: 2ddec2c80b44 ("riscv, bpf: inline bpf_get_smp_processor_id()")
Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20250812090256.757273-4-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/net/bpf_jit_comp64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1763,7 +1763,7 @@ int bpf_jit_emit_insn(const struct bpf_i
 		 */
 		if (insn->src_reg == 0 && insn->imm == BPF_FUNC_get_smp_processor_id) {
 			/* Load current CPU number in R0 */
-			emit_ld(bpf_to_rv_reg(BPF_REG_0, ctx), offsetof(struct thread_info, cpu),
+			emit_lw(bpf_to_rv_reg(BPF_REG_0, ctx), offsetof(struct thread_info, cpu),
 				RV_REG_TP, ctx);
 			break;
 		}


