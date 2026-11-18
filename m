Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020848;
	b=yY0UcQtJ61Jgl/y42o+E39ZGc5IUOWsZG1ECVv22wJUaYRsfBW2biT2m7dFBfSV8oTCg
	 3RcxyvHNQPlLsMjIOoPt1fw2r1v+U1Zh3bI5T9KSmiMoy49OhOLwc63LOvwnsM3YUrX2Q
	 JRC88FXypK+XUqtRoddsoxYd0mf/slN9D8FieJYfX0S83bifLTMuZKZMEo9TCJVBnLZwb
	 0NYKJSrM1MmtQkWswIjCdFYMvU6IbtsWqCYlaLv9+62ODI782JMThK5q7YN0zOVlG35wl
	 LbsACAD4uiM9pgnjeNLQ1E/Yp/UEavisyH2hS51KX+IiwcHNpiGvbG+flTogeUsiSmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xS7NPjtRPV6sT3PU5PJCQHuirJCEXF3RN8SYNNaCYE4=;
	b=dFF26p9CsZaQtrWGL0FXU/0+z4LY7+k76aB5yeNgA+9v6e0Ar9ew6EJMzA+REtO1Soxv
	 uWrgSydKW3ajL31O6ECZEOuaZRMoN0YmNp69QWuTWc5wnZgz8rKD7vyotcdYSGbfO44rC
	 w6rqBMB9MktYtR+AIMB7dLCRnrcJ+/DODqfvtd4HgFIfp9O3UBEe+C1Ufx9DAfsNPgsZc
	 kJ7l4L93ejAvl3m26L5HOaUAYhigSxI8hMqwSt6WpILOEuBJiVahLyndg4oms2cW1VbWm
	 e+DXlz7snO1s+xtqUQsbjrMLnfCS8+OH1JMnXd2z8jwnGybm5JWXjaBeh6IH0IqZ2yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE8oFOxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E260A2630;
	Wed, 18 Nov 2026 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE8oFOxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEA31F000C4;
	Wed, 18 Nov 2026 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020847;
	bh=xS7NPjtRPV6sT3PU5PJCQHuirJCEXF3RN8SYNNaCYE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vE8oFOxAPpU1lUcWL9cunMhEydGa0c3H1DAR+4v3QE3rgJsycJYlePINKFOvRhOy2
	 O9VnVHDRPb63s4YbSEHn1DKsEo96p4QnC9hxti7xIiqJbq/b2IQfinc7E7vAxWu8Md
	 aVd45sT2FqFJjCHFWYSCyzxNcU6dxi1WnUlCrpx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2095/2651] bpf: Look at all 64 bits of a BPF_JSET mask on 32-bit
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150401.429121092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1dea0faaffcc3..9b2f20392d075 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16716,7 +16716,7 @@ static void regs_refine_cond_op(struct bpf_reg_state *reg1, struct bpf_reg_state
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



