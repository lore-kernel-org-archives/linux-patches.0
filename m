Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7193876D3;
	Tue, 10 Mar 2026 11:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141948; cv=none; b=qaE0vNuCYeoPakc8zhZrdZGqiShqG86uxKUVJ4VPkW+R00qg+PmY7hK1/48aL4eePcfSRRN3pGARDSV9H08NaL2mEx3dPDzTnA6K7pQHynA3tTcyr18IB9uQeol6gWrS7m/dUTF0CrElvEwNHsgDe0HMRbvPRIZU1KwiySCmUAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141948; c=relaxed/simple;
	bh=6TaNmaBga9bzs9klqSe8ihl1LzLGBdtrxJdWFnvYwRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5KWzbQaOvBigoMeJKOtr6vbaViyAeb3O8iTQ9BakxQerwbaeipUUrupRw1TXnYuPUrnXUG3SA8KIHb8Hgz5V6PS4xU8ZhRflIn8hlim47ByVtTrll7W/V67HZ/C9q60Geghc29+lQWX2c5wE3/rJ0GR59sF/B95vfLOJHjblLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOGBPf/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOGBPf/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC41EC2BC86;
	Tue, 10 Mar 2026 11:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141948;
	bh=6TaNmaBga9bzs9klqSe8ihl1LzLGBdtrxJdWFnvYwRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOGBPf/L1xOegiJ+tOlytxkNvKVt/gprHizvfkrFh3BWMVxVLEfoHq2y+pzulNgIL
	 CpZaOvl975Z/IyesBDoLFm/W2mSyeywOpuCVHYHqA5HVrQVzgTFgJqJM4zzA0cB/iS
	 yCTPYxfG2sQycKMRjdHN3y+upD/J9gZmSBPiliS8QzCmJpjlYyGQPvqMXligIXrzQD
	 TiHSBssmu5qwLywym6jsR/oQtFgUpLlMKlqQLN642MnjL+cYu/7Q+hLMRoONl3MZIm
	 FJh5aNUQ+/HmkpXjAXfgswFPhBgg/M0ufLbBTdXTIbQJyxcqVddrYEPuM+GtozPIjU
	 9O3UIUrbcITvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paul Chaignon <paul.chaignon@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Marco Schirrmeister <mschirrmeister@gmail.com>,
	Harishankar Vishwanathan <harishankar.vishwanathan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/314] bpf: Improve bounds when tnum has a single possible value
Date: Tue, 10 Mar 2026 07:15:31 -0400
Message-ID: <eccd1f88c1c3482df6fbfcf40119b2a1b56ac22d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit efc11a667878a1d655ff034a93a539debbfedb12 ]

We're hitting an invariant violation in Cilium that sometimes leads to
BPF programs being rejected and Cilium failing to start [1]. The
following extract from verifier logs shows what's happening:

  from 201 to 236: R1=0 R6=ctx() R7=1 R9=scalar(smin=umin=smin32=umin32=3584,smax=umax=smax32=umax32=3840,var_off=(0xe00; 0x100)) R10=fp0
  236: R1=0 R6=ctx() R7=1 R9=scalar(smin=umin=smin32=umin32=3584,smax=umax=smax32=umax32=3840,var_off=(0xe00; 0x100)) R10=fp0
  ; if (magic == MARK_MAGIC_HOST || magic == MARK_MAGIC_OVERLAY || magic == MARK_MAGIC_ENCRYPT) @ bpf_host.c:1337
  236: (16) if w9 == 0xe00 goto pc+45   ; R9=scalar(smin=umin=smin32=umin32=3585,smax=umax=smax32=umax32=3840,var_off=(0xe00; 0x100))
  237: (16) if w9 == 0xf00 goto pc+1
  verifier bug: REG INVARIANTS VIOLATION (false_reg1): range bounds violation u64=[0xe01, 0xe00] s64=[0xe01, 0xe00] u32=[0xe01, 0xe00] s32=[0xe01, 0xe00] var_off=(0xe00, 0x0)

We reach instruction 236 with two possible values for R9, 0xe00 and
0xf00. This is perfectly reflected in the tnum, but of course the ranges
are less accurate and cover [0xe00; 0xf00]. Taking the fallthrough path
at instruction 236 allows the verifier to reduce the range to
[0xe01; 0xf00]. The tnum is however not updated.

With these ranges, at instruction 237, the verifier is not able to
deduce that R9 is always equal to 0xf00. Hence the fallthrough pass is
explored first, the verifier refines the bounds using the assumption
that R9 != 0xf00, and ends up with an invariant violation.

This pattern of impossible branch + bounds refinement is common to all
invariant violations seen so far. The long-term solution is likely to
rely on the refinement + invariant violation check to detect dead
branches, as started by Eduard. To fix the current issue, we need
something with less refactoring that we can backport.

This patch uses the tnum_step helper introduced in the previous patch to
detect the above situation. In particular, three cases are now detected
in the bounds refinement:

1. The u64 range and the tnum only overlap in umin.
   u64:  ---[xxxxxx]-----
   tnum: --xx----------x-

2. The u64 range and the tnum only overlap in the maximum value
   represented by the tnum, called tmax.
   u64:  ---[xxxxxx]-----
   tnum: xx-----x--------

3. The u64 range and the tnum only overlap in between umin (excluded)
   and umax.
   u64:  ---[xxxxxx]-----
   tnum: xx----x-------x-

To detect these three cases, we call tnum_step(tnum, umin), which
returns the smallest member of the tnum greater than umin, called
tnum_next here. We're in case (1) if umin is part of the tnum and
tnum_next is greater than umax. We're in case (2) if umin is not part of
the tnum and tnum_next is equal to tmax. Finally, we're in case (3) if
umin is not part of the tnum, tnum_next is inferior or equal to umax,
and calling tnum_step a second time gives us a value past umax.

This change implements these three cases. With it, the above bytecode
looks as follows:

  0: (85) call bpf_get_prandom_u32#7    ; R0=scalar()
  1: (47) r0 |= 3584                    ; R0=scalar(smin=0x8000000000000e00,umin=umin32=3584,smin32=0x80000e00,var_off=(0xe00; 0xfffffffffffff1ff))
  2: (57) r0 &= 3840                    ; R0=scalar(smin=umin=smin32=umin32=3584,smax=umax=smax32=umax32=3840,var_off=(0xe00; 0x100))
  3: (15) if r0 == 0xe00 goto pc+2      ; R0=3840
  4: (15) if r0 == 0xf00 goto pc+1
  4: R0=3840
  6: (95) exit

In addition to the new selftests, this change was also verified with
Agni [3]. For the record, the raw SMT is available at [4]. The property
it verifies is that: If a concrete value x is contained in all input
abstract values, after __update_reg_bounds, it will continue to be
contained in all output abstract values.

Link: https://github.com/cilium/cilium/issues/44216 [1]
Link: https://pchaigno.github.io/test-verifier-complexity.html [2]
Link: https://github.com/bpfverif/agni [3]
Link: https://pastebin.com/raw/naCfaqNx [4]
Fixes: 0df1a55afa83 ("bpf: Warn on internal verifier errors")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Tested-by: Marco Schirrmeister <mschirrmeister@gmail.com>
Co-developed-by: Harishankar Vishwanathan <harishankar.vishwanathan@gmail.com>
Signed-off-by: Harishankar Vishwanathan <harishankar.vishwanathan@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/ef254c4f68be19bd393d450188946821c588565d.1772225741.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 449997aa77a06..e37ff28e3cd9d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2347,6 +2347,9 @@ static void __update_reg32_bounds(struct bpf_reg_state *reg)
 
 static void __update_reg64_bounds(struct bpf_reg_state *reg)
 {
+	u64 tnum_next, tmax;
+	bool umin_in_tnum;
+
 	/* min signed is max(sign bit) | min(other bits) */
 	reg->smin_value = max_t(s64, reg->smin_value,
 				reg->var_off.value | (reg->var_off.mask & S64_MIN));
@@ -2356,6 +2359,33 @@ static void __update_reg64_bounds(struct bpf_reg_state *reg)
 	reg->umin_value = max(reg->umin_value, reg->var_off.value);
 	reg->umax_value = min(reg->umax_value,
 			      reg->var_off.value | reg->var_off.mask);
+
+	/* Check if u64 and tnum overlap in a single value */
+	tnum_next = tnum_step(reg->var_off, reg->umin_value);
+	umin_in_tnum = (reg->umin_value & ~reg->var_off.mask) == reg->var_off.value;
+	tmax = reg->var_off.value | reg->var_off.mask;
+	if (umin_in_tnum && tnum_next > reg->umax_value) {
+		/* The u64 range and the tnum only overlap in umin.
+		 * u64:  ---[xxxxxx]-----
+		 * tnum: --xx----------x-
+		 */
+		___mark_reg_known(reg, reg->umin_value);
+	} else if (!umin_in_tnum && tnum_next == tmax) {
+		/* The u64 range and the tnum only overlap in the maximum value
+		 * represented by the tnum, called tmax.
+		 * u64:  ---[xxxxxx]-----
+		 * tnum: xx-----x--------
+		 */
+		___mark_reg_known(reg, tmax);
+	} else if (!umin_in_tnum && tnum_next <= reg->umax_value &&
+		   tnum_step(reg->var_off, tnum_next) > reg->umax_value) {
+		/* The u64 range and the tnum only overlap in between umin
+		 * (excluded) and umax.
+		 * u64:  ---[xxxxxx]-----
+		 * tnum: xx----x-------x-
+		 */
+		___mark_reg_known(reg, tnum_next);
+	}
 }
 
 static void __update_reg_bounds(struct bpf_reg_state *reg)
-- 
2.51.0

