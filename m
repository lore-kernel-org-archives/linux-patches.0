Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ACD30568A;
	Fri, 15 May 2026 16:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861049; cv=none; b=jLsfuLBIuSeKjb1hYrP02rM+RcX3DHaTgPlLStBeO6KNvRDcnHvcnNc0bk2kjwN/GZqde0b1gfDgnkNFmrzM564gIi/XEelLwVjmBgg/1EcOogcKewMuQvEW1zKRjE0OdNsqXFQugK8MwHCoxicuO4rQJ3ZLUEiZbKPNF2NJCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861049; c=relaxed/simple;
	bh=ZxFmOIZdlH01ics5gM/E74B6CoGM7SUa6p05nfdLAUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5ap+bhAt/7cTuEfY32RTv5gNZFWG4lJaOiJ50Fff/7/m7ZS9jgyHniwVaGI/fSrsKQusMXXqdwnKUfeRwM05RKw5faQ1ihTf2jvOLPimPO0Ws34NHQmZKCqUaOBSgxWlyyWyxT/DzbnK70dg8mBhBn01vsSsfdh82S81IPm0ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNWXT9Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNWXT9Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658DAC2BCB0;
	Fri, 15 May 2026 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861048;
	bh=ZxFmOIZdlH01ics5gM/E74B6CoGM7SUa6p05nfdLAUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNWXT9Zu5nKfk90vTNcJx7Moe53bcUGVd3eimQ4gT3k2j6pBhlY6x5TPtTgTOl4GD
	 2q6SDr/PndWRcYrCkwb/9PndnXinM6NnLRgIabqLHtZdQgSgvWhjvW0Q5XFqKFEbkA
	 0+AgcCMX9QuSjyNZaT8EiNHoSaBVY1CgdjtaMDE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/474] selftests/bpf: validate precision logic in partial_stack_load_preserves_zeros
Date: Fri, 15 May 2026 17:44:48 +0200
Message-ID: <20260515154718.897467136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 064e0bea19b356c5d5f48a4549d80a3c03ce898b ]

Enhance partial_stack_load_preserves_zeros subtest with detailed
precision propagation log checks. We know expect fp-16 to be spilled,
initially imprecise, zero const register, which is later marked as
precise even when partial stack slot load is performed, even if it's not
a register fill (!).

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-10-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_spill_fill.c    | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index 41fd61299eab0..df4920da34728 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -495,6 +495,22 @@ char single_byte_buf[1] SEC(".data.single_byte_buf");
 SEC("raw_tp")
 __log_level(2)
 __success
+/* make sure fp-8 is all STACK_ZERO */
+__msg("2: (7a) *(u64 *)(r10 -8) = 0          ; R10=fp0 fp-8_w=00000000")
+/* but fp-16 is spilled IMPRECISE zero const reg */
+__msg("4: (7b) *(u64 *)(r10 -16) = r0        ; R0_w=0 R10=fp0 fp-16_w=0")
+/* and now check that precision propagation works even for such tricky case */
+__msg("10: (71) r2 = *(u8 *)(r10 -9)         ; R2_w=P0 R10=fp0 fp-16_w=0")
+__msg("11: (0f) r1 += r2")
+__msg("mark_precise: frame0: last_idx 11 first_idx 0 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r2 stack= before 10: (71) r2 = *(u8 *)(r10 -9)")
+__msg("mark_precise: frame0: regs= stack=-16 before 9: (bf) r1 = r6")
+__msg("mark_precise: frame0: regs= stack=-16 before 8: (73) *(u8 *)(r1 +0) = r2")
+__msg("mark_precise: frame0: regs= stack=-16 before 7: (0f) r1 += r2")
+__msg("mark_precise: frame0: regs= stack=-16 before 6: (71) r2 = *(u8 *)(r10 -1)")
+__msg("mark_precise: frame0: regs= stack=-16 before 5: (bf) r1 = r6")
+__msg("mark_precise: frame0: regs= stack=-16 before 4: (7b) *(u64 *)(r10 -16) = r0")
+__msg("mark_precise: frame0: regs=r0 stack= before 3: (b7) r0 = 0")
 __naked void partial_stack_load_preserves_zeros(void)
 {
 	asm volatile (
-- 
2.53.0



