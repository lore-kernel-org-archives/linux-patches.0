Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE54E35AC03;
	Fri,  4 Sep 2026 05:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500930; cv=none; b=hfHTfJCzxqexTfxYkUlFiUnsprV2ajr1xifgqa/VpxZp/G2Xxao3BAe/2JT9JSBuscHe6GSwxCWHbsJjE4M9KbtKsLuHV9BpuhasABk91Nvk+JyLecpQGEJ2TnXYwP53vhlbqp+63WL+WrhFHdive4LahnTP7UXNK+DP7uSSpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500930; c=relaxed/simple;
	bh=1YupkRkSyP4DtkvGZ8MaKhFwifABCgb/t/pJhxUP4uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBhZFC1hQd0jVd3AsAO6CS+hM7P2xqk5c12QePZtsiNp6R1OGOdPb2OylqAQ3wCh0Z6JTujerKoabuz87wKXcuKfkUcZexzv6iA50jux1CFYEEWakHXcqNzQbF6ZftWAZONZtzGV8yr2bRq/wkzlAJ6cz8eBFDt1d96btY7+pSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6FkHvrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6FkHvrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DB21F00A3D;
	Fri,  4 Sep 2026 05:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500929;
	bh=EENnBTjHg4uHV4PiGQPmZXSGuUh5maMaOF1dVBrs3yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6FkHvrIZTM1tbaXi+p2YR5fCePXMQVb6D6xEttht82k0Z67jX0+TyzKhfyxiWHmr
	 LkJy593YN7AjDJ9WGBtXSVifdwiYb5I2kcYINCQWTAHWIE+NUUBWyPWAIb1WhV75QB
	 j+6bDm9YNwPVlw1SuhgAcEKI0AKbps/MU5gtvWb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vineet.gupta@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>
Subject: [PATCH 6.18 230/552] bpf, x86: Fix per-CPU address resolution into an extended register
Date: Fri,  4 Sep 2026 06:56:27 +0200
Message-ID: <20260904045754.703462058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1756,7 +1756,7 @@ static int do_jit(struct bpf_prog *bpf_p
 				EMIT_mov(dst_reg, src_reg);
 #ifdef CONFIG_SMP
 				/* add <dst>, gs:[<off>] */
-				EMIT2(0x65, add_1mod(0x48, dst_reg));
+				EMIT2(0x65, add_2mod(0x48, 0, dst_reg));
 				EMIT3(0x03, add_2reg(0x04, 0, dst_reg), 0x25);
 				EMIT((u32)(unsigned long)&this_cpu_off, 4);
 #endif


