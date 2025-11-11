Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57561C6FE1;
	Tue, 11 Nov 2025 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822750; cv=none; b=NrUYLFLf7CG/m6nflSEtKcmVkINQuX9nKV7nWyH0yDf9nHOQdKq66jnc8Z0tuNFE00GFI+UG5+h7gS416T8j0oWWr2dEA2i242XChhEY6dxwnFjBs8tC6IQ9N3xEw2ZX9C9eL0J4DutU0Kcm8sC/1TuCHuRXdcnFfRUx8OEhBfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822750; c=relaxed/simple;
	bh=6zd7PZaJIFG/f7bozA2FNM1s5nefXO885to1mMZrTgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzjxLgrB85xR66hLlM+edAh41lfDhRglEEg2Rw7sSGv1NyfnvdinNES2V84miLTv77jcWkHiXrnPmifVNaVNpQSdfGilaMGrWf7zhe0YO8J6fIyVA7P7kDDvL4QAbFvxE65nEONXcbWZeSeBObO8Lzb9xjRx8XrtB6U7wZmiJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuEFdw2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuEFdw2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4681DC19422;
	Tue, 11 Nov 2025 00:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822750;
	bh=6zd7PZaJIFG/f7bozA2FNM1s5nefXO885to1mMZrTgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuEFdw2iAPALV3ru427yI4diEAtguk2v3LrBKq5Gqwqwa4mGHuG/tfV/q7btCeSxF
	 fa0yiTberJUjC1azXe4Iu4NZddQlpi/ZEfcM/PvTlOL6hcGbe7YUa+yUvhT69yXQdk
	 u6kefqPTZ7gzljMkoc7Mp6ExxWSoiZGykf5U3vZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/565] bpf: Use tnums for JEQ/JNE is_branch_taken logic
Date: Tue, 11 Nov 2025 09:39:14 +0900
Message-ID: <20251111004529.160970243@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit f41345f47fb267a9c95ca710c33448f8d0d81d83 ]

In the following toy program (reg states minimized for readability), R0
and R1 always have different values at instruction 6. This is obvious
when reading the program but cannot be guessed from ranges alone as
they overlap (R0 in [0; 0xc0000000], R1 in [1024; 0xc0000400]).

  0: call bpf_get_prandom_u32#7  ; R0_w=scalar()
  1: w0 = w0                     ; R0_w=scalar(var_off=(0x0; 0xffffffff))
  2: r0 >>= 30                   ; R0_w=scalar(var_off=(0x0; 0x3))
  3: r0 <<= 30                   ; R0_w=scalar(var_off=(0x0; 0xc0000000))
  4: r1 = r0                     ; R1_w=scalar(var_off=(0x0; 0xc0000000))
  5: r1 += 1024                  ; R1_w=scalar(var_off=(0x400; 0xc0000000))
  6: if r1 != r0 goto pc+1

Looking at tnums however, we can deduce that R1 is always different from
R0 because their tnums don't agree on known bits. This patch uses this
logic to improve is_scalar_branch_taken in case of BPF_JEQ and BPF_JNE.

This change has a tiny impact on complexity, which was measured with
the Cilium complexity CI test. That test covers 72 programs with
various build and load time configurations for a total of 970 test
cases. For 80% of test cases, the patch has no impact. On the other
test cases, the patch decreases complexity by only 0.08% on average. In
the best case, the verifier needs to walk 3% less instructions and, in
the worst case, 1.5% more. Overall, the patch has a small positive
impact, especially for our largest programs.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/be3ee70b6e489c49881cb1646114b1d861b5c334.1755694147.git.paul.chaignon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tnum.h  | 3 +++
 kernel/bpf/tnum.c     | 8 ++++++++
 kernel/bpf/verifier.c | 4 ++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/tnum.h b/include/linux/tnum.h
index 3c13240077b87..191baf3a8d832 100644
--- a/include/linux/tnum.h
+++ b/include/linux/tnum.h
@@ -49,6 +49,9 @@ struct tnum tnum_xor(struct tnum a, struct tnum b);
 /* Multiply two tnums, return @a * @b */
 struct tnum tnum_mul(struct tnum a, struct tnum b);
 
+/* Return true if the known bits of both tnums have the same value */
+bool tnum_overlap(struct tnum a, struct tnum b);
+
 /* Return a tnum representing numbers satisfying both @a and @b */
 struct tnum tnum_intersect(struct tnum a, struct tnum b);
 
diff --git a/kernel/bpf/tnum.c b/kernel/bpf/tnum.c
index 9dbc31b25e3d0..8e6d0ac713731 100644
--- a/kernel/bpf/tnum.c
+++ b/kernel/bpf/tnum.c
@@ -138,6 +138,14 @@ struct tnum tnum_mul(struct tnum a, struct tnum b)
 	return tnum_add(TNUM(acc_v, 0), acc_m);
 }
 
+bool tnum_overlap(struct tnum a, struct tnum b)
+{
+	u64 mu;
+
+	mu = ~a.mask & ~b.mask;
+	return (a.value & mu) == (b.value & mu);
+}
+
 /* Note that if a and b disagree - i.e. one has a 'known 1' where the other has
  * a 'known 0' - this will return a 'known 1' for that bit.
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 709151d33e5e4..218c238d61398 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14772,6 +14772,8 @@ static int is_scalar_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_sta
 		 */
 		if (tnum_is_const(t1) && tnum_is_const(t2))
 			return t1.value == t2.value;
+		if (!tnum_overlap(t1, t2))
+			return 0;
 		/* non-overlapping ranges */
 		if (umin1 > umax2 || umax1 < umin2)
 			return 0;
@@ -14796,6 +14798,8 @@ static int is_scalar_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_sta
 		 */
 		if (tnum_is_const(t1) && tnum_is_const(t2))
 			return t1.value != t2.value;
+		if (!tnum_overlap(t1, t2))
+			return 1;
 		/* non-overlapping ranges */
 		if (umin1 > umax2 || umax1 < umin2)
 			return 1;
-- 
2.51.0



