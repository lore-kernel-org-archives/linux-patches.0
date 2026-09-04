Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375CD4078C0;
	Fri,  4 Sep 2026 05:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499161; cv=none; b=kPAwXxtPGNsUGn+f60+34A99hGamnoYLigHkaCXYNo97abP/dW4hXYjzZwub/l9s7Yli1m1Lpg9OSXw6WmWggIYUOTjtMde7282pgC31nKIz6Ef6PkT4o5oGccS9BiMuqlX9kKDiG06l6kqCskWnpcc5mg9P+Oo64rEW/kZLvcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499161; c=relaxed/simple;
	bh=URm4uzP3psJXV5Cth26O/aN5L0xLhU8ht438pXuq/H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHQPd/E46D/stam2jqa5Lv30dc2CYYx5qNy6ubcp7iOZ4J9Dt+pFoP4TPKH8VgTHdM3hcl322zo3Jfay8VI3K4WBzNWz1ddVJEcK3DkJ+ssFysGZ3QE6iJBLk/kPTTQWe0Xz6IrsFZ6PXcFCIg4DdTCUpsH4bZJI/9F3T9DAhm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFC+srOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFC+srOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9189A1F00A3D;
	Fri,  4 Sep 2026 05:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499160;
	bh=AOoySWRp15bYF0ZpAt/0vyWETWQsfMN/00Cm+Z65d9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFC+srOT/WGLZIBeG64we2EHY0wSj8lZYWIOI71WRHW55POlfHpmicgPzk+P89OiV
	 FAGlv61DomlOj9UaCVMcLG/z3HwfJL+uYGzNj8x8iC18tXzgssLTBhutXI3PQMw/1G
	 JMphfKMPNlDPcSTkww63qzc1wijTqRVX5eOR82m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vineet.gupta@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>
Subject: [PATCH 7.2 320/713] bpf, x86: Fix per-CPU address resolution into an extended register
Date: Fri,  4 Sep 2026 06:54:48 +0200
Message-ID: <20260904045811.003752006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vineet.gupta@linux.dev>

commit 5bbbce02e500d47d8e259a45be5a7be9741d0533 upstream.

The destination of the per-CPU address MOV is encoded in ModRM.reg,
which is extended by REX.R, but the REX prefix is built with
add_1mod(), which sets REX.B. REX.B extends ModRM.rm and SIB.base, and
this instruction addresses memory as disp32 with no base, so the bit
has no effect at all and the high register bit is simply lost.

Every is_ereg() destination therefore resolves to the wrong register,
picking whichever one shares the low three bits:

  R5 -> RAX    R7 -> RBP    R8 -> RSI    R9 -> RDI

With BPF_REG_5, whose reg2hex is 0, the emitted

  65 49 03 04 25 <off>	add %gs:<off>,%rax

adds the per-CPU offset to RAX rather than R8. The destination keeps
the unadjusted address and RAX is clobbered, so the program goes on to
dereference a pointer that was never made per-CPU:

  BUG: unable to handle page fault for address: 0000607e386a8894
  RIP: bpf_prog_707837aafd2aa9ae_update_percpu_data+0x93/0xc9
  Call Trace:
   __bpf_prog_test_run_raw_tp+0x2dc/0x7d0
   __flush_smp_call_function_queue+0x1e9/0xc80
  Kernel panic - not syncing: Fatal exception in interrupt

R5 is the mildest of the four, aliasing a scratch register and faulting
at the store. R7 aliases RBP and would corrupt the frame pointer, R8
and R9 alias the argument registers.

Use add_2mod() so the register goes through REX.R, matching how
add_2reg() places it in ModRM.reg and how emit_priv_frame_ptr()
hardcodes 0x4c for the same instruction with R9. Encodings for the
non-extended registers are unchanged.

Problem showed up when trying to resurrect BPF_GCC CI (selftests built
with BPF_GCC).

This has gone unnoticed because clang reloads the address into R1
before each per-CPU access, so the destination is never an extended
register. GCC keeps several per-CPU addresses live at once, and
test_progs-bpf_gcc panics the kernel in global_percpu_data/init, where
the address of a .percpu variable ends up in R5.

Fixes: 7bdbf7446305 ("bpf: add special internal-only MOV instruction to resolve per-CPU addrs")
Signed-off-by: Vineet Gupta <vineet.gupta@linux.dev>
Reviewed-by: Eduard Zingerman <eddyz87@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260814220254.3797467-2-vineet.gupta@linux.dev
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1887,7 +1887,7 @@ static int do_jit(struct bpf_verifier_en
 				EMIT_mov(dst_reg, src_reg);
 #ifdef CONFIG_SMP
 				/* add <dst>, gs:[<off>] */
-				EMIT2(0x65, add_1mod(0x48, dst_reg));
+				EMIT2(0x65, add_2mod(0x48, 0, dst_reg));
 				EMIT3(0x03, add_2reg(0x04, 0, dst_reg), 0x25);
 				EMIT((u32)(unsigned long)&this_cpu_off, 4);
 #endif


