Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625160;
	b=p2XStdOe0LqB0ie28vtG40Fqnoyvg185BEwcBpqfMep1PSIv+1+59sTSLre69gJ2Gxga
	 r7SR3Uq5aKYSVZT7G9U0p7FCKfibdlNKa1XhArUp+McDU9UlsT6+ez9h8rmtePQfdWgOG
	 y6KCGvZ3xaDIpzX50yVgmX9OwCnmrPosttiS+D3+dCDp0osKzie7n7VgUoKomvFLn8QS/
	 kR8P5yHFGwOU2s8QElNzDGaCmfW+cwtxQkUtZlxTZ67yQ9voXXNY3VhRnH7IcI5PVI2+o
	 X4FUomImVpBGBj0+lSzMv4T/cZkPv0V48dUuExX6LZMob3/hl+uC1GTqUo2Ca5+SHvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=is8NU7Wl0JZGOfZ3kCQ8isUbB120Y8lvp76qi/xJZ5c=;
	b=aPsX40e5wyrobXzMLSdDUUGu1JWt1TFVlMIXUAAmXMNP4GpwFvOcDdjHl1pSh5qkJX3p
	 4M32/an+UXJDAyoabI4AsoGYwHDsagIaJpqKldrQJz2K6ivZsdLtiVA14Ryi/mUDNaWL6
	 pn5dNCAmCNGUgVRphs4CuttOk80nZpzx4rxD8NYoNcqS7DaFuIYXCNUcXsPmYGHaeuXMo
	 Uq+YHmtskIXmvZlJ/cDHYP5hpBtMEF0VIXQusAo3WMcqVCuxC3JtBO8t2MYg3zvyi0uqv
	 nGDgKTp1u+Yy3PJgDfIKRUZZ2G9Yia3YhX/lsstLNibPbqDnF8t03Of1vVO5xlNaU/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=II8At2Sb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B897F606A33A;
	Wed, 25 Nov 2026 16:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=II8At2Sb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACA61F000D0;
	Wed, 25 Nov 2026 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625160;
	bh=is8NU7Wl0JZGOfZ3kCQ8isUbB120Y8lvp76qi/xJZ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=II8At2SbEuw8pbuOIW74vPm7tjRCB2wSd3uQMYMIlE9N+pHeQ62Sh5wHAX0kujhGr
	 xJC+0nZZchEM8JalXzsWFAv4GPCaZM2kAq32mIfyB88+Q+BM5UIXqydsALGlj8rKEC
	 EZzAOuB2LnqGoRPJYJo1gU8YzhZzHXq+Al1YG5CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/816] bpf: Fix uninit read for non-fetch atomics on partially spilled slots
Date: Wed, 25 Nov 2026 15:32:55 +0100
Message-ID: <20261125143859.078648487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit 5a84b4424db8ae07f0ac682ab031c37a91dce50b ]

check_stack_read_fixed_off() skips partial spill checks for non-fetch
atomics; the following prog can be loaded:

0: (b7) r1 = 1                        ; R1=1
1: (63) *(u32 *)(r10 -8) = r1         ; R1=1 R10=fp0 fp-8=????1
2: (db) lock *(u64 *)(r10 -8) += r1   ; R1=1 R10=fp0 fp-8=mmmmmmmm
3: (79) r0 = *(u64 *)(r10 -8)         ; R0=scalar() R10=fp0 fp-8=mmmmmmmm
4: (77) r0 >>= 32                     ; R0=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
5: (95) exit

When test run:
	retval=4294967295

Note fp-8 is ????1 at #1, yet it becomes fp-8=mmmmmmmm after the
non-fetching atomic add at #2; hence the high 32 bits are leaked.

Fix by applying the partial load check; after the patch, the
prog is rejected:

Verification failed: Memory Safety: Uninitialized stack read

Reason:
  This rejected read uses 8 bytes at stack offset -8, but byte 4 in that range is uninitialized on
  this path. Programs loaded with CAP_PERFMON can be allowed to read uninitialized stack bytes, but
  this program is being rejected without that allowance.

At:
  ...
      0 | (b7) r1 = 1
      1 | (63) *(u32 *)(r10 -8) = r1
  >>> 2 | (db) lock *(u64 *)(r10 -8) += r1
      3 | (79) r0 = *(u64 *)(r10 -8)
      4 | (77) r0 >>= 32

This affects CAP_BPF only.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Link: https://lore.kernel.org/bpf/20260924131342.934290-1-sunhao.th@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
[ sashal: Moved the dst_regno < 0 early return after the partial-spill checks, keeping the existing mark_reg_read() and copy_register_state()/subreg_def code and splitting the subreg_def declaration. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b66d0487444f1..63bb703e0a64d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5140,15 +5140,18 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 			}
 
 			mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
-			if (dst_regno < 0)
-				return 0;
 
 			if (size <= spill_size &&
 			    bpf_stack_narrow_access_ok(off, size, spill_size)) {
+				s32 subreg_def;
+
+				if (dst_regno < 0)
+					return 0;
+
 				/* The earlier check_reg_arg() has decided the
 				 * subreg_def for this insn.  Save it first.
 				 */
-				s32 subreg_def = state->regs[dst_regno].subreg_def;
+				subreg_def = state->regs[dst_regno].subreg_def;
 
 				copy_register_state(&state->regs[dst_regno], reg);
 				state->regs[dst_regno].subreg_def = subreg_def;
@@ -5180,6 +5183,9 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 					return -EACCES;
 				}
 
+				if (dst_regno < 0)
+					return 0;
+
 				if (spill_cnt == size &&
 				    tnum_is_const(reg->var_off) && reg->var_off.value == 0) {
 					__mark_reg_const_zero(env, &state->regs[dst_regno]);
-- 
2.53.0



