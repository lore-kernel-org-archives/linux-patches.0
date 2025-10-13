Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A733148D7;
	Mon, 13 Oct 2025 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369215; cv=none; b=rhY6zgVoUcSMjlZyZpTmryY3yiCHU0JbT6RyvjvltmBPOGPqDaFyMUVE/rMcabD69kBR0461Cb34kyOw++6TqQ48B9rT5yDuZbKnmFrl7e/omA686E/44wx81xv079TEk/Okp96VnYAMxH31smYxV/GunTqxXjtkr0Y6IxHvKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369215; c=relaxed/simple;
	bh=qJNnwHh4TW4CXJM21WouBtMzg1ZUoK4S/96mCozTEHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jK+kn5j7YmB0fefm9VCcy4UXvAd5N3lC3VskW9cTDhIVg5ytmMIvK/Qtth/Os/e8tNkgyfDtU+ezpgJkk0D3idcdPoI4ci77FHdZwGaHh3sgZQd/3+gC624GbynTN3+D8QcW0e5xT3/WVX9MjuLyK2fLNfP2hB7fXZWRKj98pFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVnmFzqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVnmFzqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275AEC116D0;
	Mon, 13 Oct 2025 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369215;
	bh=qJNnwHh4TW4CXJM21WouBtMzg1ZUoK4S/96mCozTEHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVnmFzqtXdQL4UJaWP4Euav4din/z4D3JrTcD3mbRAu7CfdZejRx5fKcgwAyXcIgV
	 4IpKR3GKnoxK8CDGGmoIPRBAzJmxE2Cjo8URpbgaswOzn5ijN8v6S7MgQyKkcG7mU5
	 G1Iz6eZ1jPLigZ2e5eXO8Q2/XTefwWIiIjBcH4y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 161/563] riscv, bpf: Sign extend struct ops return values properly
Date: Mon, 13 Oct 2025 16:40:22 +0200
Message-ID: <20251013144417.123146495@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit fd2e08128944a7679e753f920e9eda72057e427c ]

The ns_bpf_qdisc selftest triggers a kernel panic:

    Unable to handle kernel paging request at virtual address ffffffffa38dbf58
    Current test_progs pgtable: 4K pagesize, 57-bit VAs, pgdp=0x00000001109cc000
    [ffffffffa38dbf58] pgd=000000011fffd801, p4d=000000011fffd401, pud=000000011fffd001, pmd=0000000000000000
    Oops [#1]
    Modules linked in: bpf_testmod(OE) xt_conntrack nls_iso8859_1 [...] [last unloaded: bpf_testmod(OE)]
    CPU: 1 UID: 0 PID: 23584 Comm: test_progs Tainted: G        W  OE       6.17.0-rc1-g2465bb83e0b4 #1 NONE
    Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
    Hardware name: Unknown Unknown Product/Unknown Product, BIOS 2024.01+dfsg-1ubuntu5.1 01/01/2024
    epc : __qdisc_run+0x82/0x6f0
     ra : __qdisc_run+0x6e/0x6f0
    epc : ffffffff80bd5c7a ra : ffffffff80bd5c66 sp : ff2000000eecb550
     gp : ffffffff82472098 tp : ff60000096895940 t0 : ffffffff8001f180
     t1 : ffffffff801e1664 t2 : 0000000000000000 s0 : ff2000000eecb5d0
     s1 : ff60000093a6a600 a0 : ffffffffa38dbee8 a1 : 0000000000000001
     a2 : ff2000000eecb510 a3 : 0000000000000001 a4 : 0000000000000000
     a5 : 0000000000000010 a6 : 0000000000000000 a7 : 0000000000735049
     s2 : ffffffffa38dbee8 s3 : 0000000000000040 s4 : ff6000008bcda000
     s5 : 0000000000000008 s6 : ff60000093a6a680 s7 : ff60000093a6a6f0
     s8 : ff60000093a6a6ac s9 : ff60000093140000 s10: 0000000000000000
     s11: ff2000000eecb9d0 t3 : 0000000000000000 t4 : 0000000000ff0000
     t5 : 0000000000000000 t6 : ff60000093a6a8b6
    status: 0000000200000120 badaddr: ffffffffa38dbf58 cause: 000000000000000d
    [<ffffffff80bd5c7a>] __qdisc_run+0x82/0x6f0
    [<ffffffff80b6fe58>] __dev_queue_xmit+0x4c0/0x1128
    [<ffffffff80b80ae0>] neigh_resolve_output+0xd0/0x170
    [<ffffffff80d2daf6>] ip6_finish_output2+0x226/0x6c8
    [<ffffffff80d31254>] ip6_finish_output+0x10c/0x2a0
    [<ffffffff80d31446>] ip6_output+0x5e/0x178
    [<ffffffff80d2e232>] ip6_xmit+0x29a/0x608
    [<ffffffff80d6f4c6>] inet6_csk_xmit+0xe6/0x140
    [<ffffffff80c985e4>] __tcp_transmit_skb+0x45c/0xaa8
    [<ffffffff80c995fe>] tcp_connect+0x9ce/0xd10
    [<ffffffff80d66524>] tcp_v6_connect+0x4ac/0x5e8
    [<ffffffff80cc19b8>] __inet_stream_connect+0xd8/0x318
    [<ffffffff80cc1c36>] inet_stream_connect+0x3e/0x68
    [<ffffffff80b42b20>] __sys_connect_file+0x50/0x88
    [<ffffffff80b42bee>] __sys_connect+0x96/0xc8
    [<ffffffff80b42c40>] __riscv_sys_connect+0x20/0x30
    [<ffffffff80e5bcae>] do_trap_ecall_u+0x256/0x378
    [<ffffffff80e69af2>] handle_exception+0x14a/0x156
    Code: 892a 0363 1205 489c 8bc1 c7e5 2d03 084a 2703 080a (2783) 0709
    ---[ end trace 0000000000000000 ]---

The bpf_fifo_dequeue prog returns a skb which is a pointer. The pointer
is treated as a 32bit value and sign extend to 64bit in epilogue. This
behavior is right for most bpf prog types but wrong for struct ops which
requires RISC-V ABI.

So let's sign extend struct ops return values according to the function
model and RISC-V ABI([0]).

  [0]: https://riscv.org/wp-content/uploads/2024/12/riscv-calling.pdf

Fixes: 25ad10658dc1 ("riscv, bpf: Adapt bpf trampoline to optimized riscv ftrace framework")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/bpf/20250908012448.1695-1-hengqi.chen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 42 ++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 9883a55d61b5b..f1efa4d6b27f3 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -765,6 +765,39 @@ static int emit_atomic_rmw(u8 rd, u8 rs, const struct bpf_insn *insn,
 	return 0;
 }
 
+/*
+ * Sign-extend the register if necessary
+ */
+static int sign_extend(u8 rd, u8 rs, u8 sz, bool sign, struct rv_jit_context *ctx)
+{
+	if (!sign && (sz == 1 || sz == 2)) {
+		if (rd != rs)
+			emit_mv(rd, rs, ctx);
+		return 0;
+	}
+
+	switch (sz) {
+	case 1:
+		emit_sextb(rd, rs, ctx);
+		break;
+	case 2:
+		emit_sexth(rd, rs, ctx);
+		break;
+	case 4:
+		emit_sextw(rd, rs, ctx);
+		break;
+	case 8:
+		if (rd != rs)
+			emit_mv(rd, rs, ctx);
+		break;
+	default:
+		pr_err("bpf-jit: invalid size %d for sign_extend\n", sz);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
 #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
 #define REG_DONT_CLEAR_MARKER	0	/* RV_REG_ZERO unused in pt_regmap */
@@ -1226,8 +1259,15 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 		restore_args(min_t(int, nr_arg_slots, RV_MAX_REG_ARGS), args_off, ctx);
 
 	if (save_ret) {
-		emit_ld(RV_REG_A0, -retval_off, RV_REG_FP, ctx);
 		emit_ld(regmap[BPF_REG_0], -(retval_off - 8), RV_REG_FP, ctx);
+		if (is_struct_ops) {
+			ret = sign_extend(RV_REG_A0, regmap[BPF_REG_0], m->ret_size,
+					  m->ret_flags & BTF_FMODEL_SIGNED_ARG, ctx);
+			if (ret)
+				goto out;
+		} else {
+			emit_ld(RV_REG_A0, -retval_off, RV_REG_FP, ctx);
+		}
 	}
 
 	emit_ld(RV_REG_S1, -sreg_off, RV_REG_FP, ctx);
-- 
2.51.0



