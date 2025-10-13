Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A33081CA;
	Mon, 13 Oct 2025 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367454; cv=none; b=g3xcWr84g2VabbjpHzAofCSPW7OGgQLy/6ExShoSh41Pc97VMfxMcMDAjIU/f4URSVBlRYwsWMSmEejimeNaqBHYp8c4+FQ+PodO46pjlW+HtjuIpinUtDQjxe7YMIqLhfXQsFyYeMflVwVc6vefWzFLO7MxbYZQqmJz+Lxy9CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367454; c=relaxed/simple;
	bh=o6YJmH/S3MqOzaATzJyzJGJFEYtjrHSzPhdqFVdl/WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4tbndzKnM7/UWj2A9N95bShziGNRqNfvF6BO+zlF/0UyQu7OlNoRyBleJ39H36goeboRG8+9doUoaCb8zrvvTfCnLOYyJgX5HwBpx5W5Ju7L5BWhRFlOAvYSy2NMlmBjRlmqXOcgt/TmTPoXoyE0t74C8mBOGPFJMTs4vMUJF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ashYBfat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ashYBfat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38EC4CEE7;
	Mon, 13 Oct 2025 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367454;
	bh=o6YJmH/S3MqOzaATzJyzJGJFEYtjrHSzPhdqFVdl/WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ashYBfat2WYcsR7BDg4aFdtH3SeA88KB0YAVs0bQgrjy2Ur3iQGrmBzbl8KSSJ8Vd
	 3WgRmmU1GY8Wu/7T986Ufj+yc9lEzOlkpCFx1atjqU9bOQchHeARaujNJR7jLJzw0i
	 9cqr2x5S5vdPuKwRUudQ17JzyISsFaDG05Cf9KDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/196] s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL
Date: Mon, 13 Oct 2025 16:43:29 +0200
Message-ID: <20251013144315.855528374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit c861a6b147137d10b5ff88a2c492ba376cd1b8b0 ]

The tailcall_bpf2bpf_hierarchy_1 test hangs on s390. Its call graph is
as follows:

  entry()
    subprog_tail()
      bpf_tail_call_static(0) -> entry + tail_call_start
    subprog_tail()
      bpf_tail_call_static(0) -> entry + tail_call_start

entry() copies its tail call counter to the subprog_tail()'s frame,
which then increments it. However, the incremented result is discarded,
leading to an astronomically large number of tail calls.

Fix by writing the incremented counter back to the entry()'s frame.

Fixes: dd691e847d28 ("s390/bpf: Implement bpf_jit_supports_subprog_tailcalls()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250813121016.163375-3-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 2d8facfd4e425..31a4bbd2e7dc4 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1425,13 +1425,6 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		jit->seen |= SEEN_FUNC;
 		/*
 		 * Copy the tail call counter to where the callee expects it.
-		 *
-		 * Note 1: The callee can increment the tail call counter, but
-		 * we do not load it back, since the x86 JIT does not do this
-		 * either.
-		 *
-		 * Note 2: We assume that the verifier does not let us call the
-		 * main program, which clears the tail call counter on entry.
 		 */
 		/* mvc STK_OFF_TCCNT(4,%r15),N(%r15) */
 		_EMIT6(0xd203f000 | STK_OFF_TCCNT,
@@ -1457,6 +1450,22 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		call_r1(jit);
 		/* lgr %b0,%r2: load return value into %b0 */
 		EMIT4(0xb9040000, BPF_REG_0, REG_2);
+
+		/*
+		 * Copy the potentially updated tail call counter back.
+		 */
+
+		if (insn->src_reg == BPF_PSEUDO_CALL)
+			/*
+			 * mvc frame_off+tail_call_cnt(%r15),
+			 *     tail_call_cnt(4,%r15)
+			 */
+			_EMIT6(0xd203f000 | (jit->frame_off +
+					     offsetof(struct prog_frame,
+						      tail_call_cnt)),
+			       0xf000 | offsetof(struct prog_frame,
+						 tail_call_cnt));
+
 		break;
 	}
 	case BPF_JMP | BPF_TAIL_CALL: {
-- 
2.51.0



