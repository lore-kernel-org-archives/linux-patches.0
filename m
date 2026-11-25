Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622448;
	b=JGbcjG4W6OMN3VL/Wvokcqo4YMfyAHuYy/c4q2jfxYqz8D8nWU91NCigACmFKUbQDXTA
	 byqqHeAWhXMMG818/e38/uE8jZRPnllrWVWAoHu4P1/FC/ufUEoQj3A2hcPBv8A2AKb7K
	 CmuwvrQfbGR3i1XeEbj0/J/mmzu7TjIE91eo6/ApODGkT3Z4q4rCtG3FfX9uUJkZok2X4
	 LhwhZNtmJe0bh/fCzF2SpMzavjyBsTRaKawuDZS+tZgf5N/JQcPrs7Xb4Ie7PpF71CtaJ
	 oJHyzPoqGlbaFD1uwV4FvpLeEYnr1YMfjE/jR4ebNs0LXlC4HSJxEiBUUKgEdGuJ3GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wbAIgrXYsDz5NTYdhiXOhNOh+b8pv/iQiCIZSUCIokc=;
	b=ky5X9oGbX1im2X+77eQU+tLYFWMl2bB4BAEOvQI3ehrISQDHu/tDI5Sx/uKbtyDzgJtH
	 DF/7JbghI9v0OPyVcCPPxzgsXIdgN/Gb5owCF8E9H6kWGaliHwXqpKDkPmuMQib8WuLB5
	 gv5ePIw869Ojv9b+79W1MFYHkhwKVq1tPyh664q7FAzvipdc548kb8uflZGZU2t7HdSh0
	 F9orcs4OVuzQmp+9cb8yOs3reevQkEA5yc7iJp+/lsYWcymqVnBS/3UaBZRK0bNhbb2eK
	 RBWsidq/2HYcaKrPK/j/fkLFSN1KkF85ebuPPGccHJH84r5l39yOrtGIUCjPvmP7ziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DuAqxCFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3576D606A321;
	Wed, 25 Nov 2026 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DuAqxCFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEC51F000C0;
	Wed, 25 Nov 2026 16:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622447;
	bh=wbAIgrXYsDz5NTYdhiXOhNOh+b8pv/iQiCIZSUCIokc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuAqxCFafgTXGFS52byFLw14gEkYO/ioOgUIeN7xSgDLcz+NEGM97BiJT2XnoR8gI
	 Zs4ftFrXrHfn08gUAduBw9HobjXTU8hp9fwmdAtdvkjHRggr8RX0gGppcAgPUnrvUm
	 kLEuk8tjnONBcJO8vR4m78PgX03BvHYn6tcExjYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 539/990] bpf: Fix uninit read for non-fetch atomics on partially spilled slots
Date: Wed, 25 Nov 2026 15:31:46 +0100
Message-ID: <20261125143834.719866646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Context lines differ because the target tree has an older subreg_def comment block where upstream has a get_reg_width() check; the patch was applied by hand with identical added and removed lines. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2c1afef34070d..c8a72c96e227a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5508,11 +5508,11 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 				return -EACCES;
 			}
 
-			if (dst_regno < 0)
-				return 0;
-
 			if (size <= spill_size &&
 			    bpf_stack_narrow_access_ok(off, size, spill_size)) {
+				if (dst_regno < 0)
+					return 0;
+
 				/* The earlier check_reg_arg() has decided the
 				 * subreg_def for this insn.  Save it first.
 				 */
@@ -5548,6 +5548,9 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
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



