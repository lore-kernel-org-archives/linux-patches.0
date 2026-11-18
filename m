Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032291;
	b=ub/yP+0tSKzGoJbBRRFpgqsUV7eLsbt/i2C9zcmhrzlGi2dSbHp2hpsXgG4mqA4aSRac
	 Bf10wOJ2w7ARpLqXhTlvWdISrbOllt/i1WZ6Glh79BtNnYBUDuaoQgGtcwaLHIkx3baph
	 x0SmTZN8qG7MlRZiBkNig8kXaqBselz2gMDuOozL9enX/CzJgUVKACycvuLvCrdgONy9u
	 in+HhWdLkcHHG4v9HKfBlAAs8Sak14MVVwyqPTfetF1wLChJSHnAzsTw3zIpsa/q3lKWb
	 VZ3icN/fuBpvO9GACt/WVzLzeoh7syDA6OwJIY0WfCpVcoVupmqbq2Wx2B1mexeC+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGMEP8h7Ev15H+c8/2+TmX9v17SQZfftYZjZO8IcaBA=;
	b=4aVvarPtOCXBPLPJKjDhY8UMHVB7hu02/DVxBvtb027oCyfs3Zv31I78yPoLEGpIA+WL
	 TAU+9z+O6cSSUXBpFA2w8sFQbZKVFRDHg6SFSFOsOopFpMafjmo7NhIggssb2nuTdTuH1
	 yBa+Tkw2vOXu671cCn+hxsy32mXDbdVWnlwQr8w/691Qx9yCPHdYa8ooVTcP04A9m5cV0
	 zYnxmWpTLWsR7qJs0On/n3Br+/FcVcYQg2a6hCARUsrJb3rDYr20zOVwG8jQuLANJQcWt
	 0GsAIrNWmWuwYqwFNWJolDITliEc3fXJzaGVpa2erDfUvpBvPceJLBZePxSTQI7nIEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ymWkTaEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D609D606A331;
	Wed, 18 Nov 2026 20:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ymWkTaEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A931F000C4;
	Wed, 18 Nov 2026 20:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032291;
	bh=SGMEP8h7Ev15H+c8/2+TmX9v17SQZfftYZjZO8IcaBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymWkTaEWcARMwjjHPQQ751ZjV7VUQ5tCSLZASwwuCGhnjk6auV/gC+RYA2yaTuWXX
	 oQmoziUpww1TuoKfhxE1Mkwdc2QmxoaREZudx4ivdrUChLggw/uYBWdNDD/JA/6wQq
	 zpnlXGJv7ombQh35OYs7D0DIPfPWpjJS/DaSd05g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1359/1756] bpf: Look at all 64 bits of a BPF_JSET mask on 32-bit
Date: Wed, 18 Nov 2026 15:58:06 +0100
Message-ID: <20261118150103.382088526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ee4f44e0e3c8125eebe9ac967b6984bc9253d489 ]

In the branch of a BPF_JSET which is taken, the verifier can learn
something about the register only if the mask has a single bit: then this
bit is set. regs_refine_cond_op() tests this with is_power_of_2(val) and
then ORs val into var_off.

val is a u64, but is_power_of_2() takes an unsigned long. On a 32-bit
kernel it only sees the lower half of the mask. For

	if r1 & 0xffffffff80000000 goto l

which is a BPF_JSET | BPF_K with an immediate of 0x80000000, the lower
half is a power of two. So the verifier takes all 33 bits for set at l,
while the branch is taken if any of them is. A mask of 0x100000001 from a
register does the same for bit 0.

The log of an i386 kernel, for r6 = bpf_get_prandom_u32() << 31:

	3: (45) if r6 & 0x80000000 goto pc+2
	from 3 to 6: R6=0xffffffff80000000 R10=fp0
	6: (77) r6 >>= 63                     ; R6=1

When the program runs, r6 >> 63 is 0.

>From then on the verifier works with known bits which the register does
not have at run time. It accepts, for example, an offset into a map value
which it derives from these bits and believes to be constant, and the
program can access memory outside of the map value.

Count the bits of the whole value.

Only 32-bit kernels are affected. On a 64-bit kernel unsigned long holds
the whole mask, and this patch changes nothing.

Fixes: 960ea056561a ("bpf: verifier: teach the verifier to reason about the BPF_JSET instruction")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-8-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7d29b6b77f4ea..71d6f14cc1cf8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15500,7 +15500,7 @@ static void regs_refine_cond_op(struct bpf_reg_state *reg1, struct bpf_reg_state
 		 * this restriction. I.e., !(r1 & 0x3) means neither bit 0 nor
 		 * bit 1 is set, which we can readily use in adjustments.
 		 */
-		if (!is_power_of_2(val))
+		if (hweight64(val) != 1)
 			break;
 		if (is_jmp32) {
 			t = tnum_or(tnum_subreg(reg1->var_off), tnum_const(val));
-- 
2.53.0



