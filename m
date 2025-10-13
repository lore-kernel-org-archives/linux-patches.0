Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1136310620;
	Mon, 13 Oct 2025 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368044; cv=none; b=LiDhXWvLYFvC6CC3jNrWd2AvnSBhgPFQvpSg+8+2haTyyJi99gKML1sDD3Y5VVfZ31XcbxTuNQ+SAuR8ouvxqbUzwT97tvUlqP5zGYEpxZ352alSu0FinKJDUG41mXtJo1UNpqmeLMsuo7yAkGzRLckFjeD4ys19k589CRNkeBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368044; c=relaxed/simple;
	bh=MZqDF+eFA91d5Xv74q3X55WuHfWGrrgN5sPNodntr6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIm3wkG6sM015BSWWAOQochnbdrs3O4/Jv2ArMN0kbq+AwnjC5ATJ4Af/3L8V3JJv4dY7AsSjCinFcvEwJ9h2qKgAEroeXcGEYMaHw3D/SsAQU2etS7uZCPXCD07KI75cR8v4z73X5cifMMn9vLKq1GX2fIE8MP2ze6wgU0iYOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwpJGUlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwpJGUlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2E5C4CEE7;
	Mon, 13 Oct 2025 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368044;
	bh=MZqDF+eFA91d5Xv74q3X55WuHfWGrrgN5sPNodntr6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwpJGUlZFDwCssB/IfzFao6Zcf8OsuND02ogIpo2OhL55drqHbi7MOC6QYKYVsv4P
	 AwRptsqmYOcx6bccIrKCs6063Z9IGW9UBWkavpfXwCmIaXfBtqkYu7s+F3lRmLx2xy
	 3hH3Mrb8MSmMm3Ri+Q1eLGaItIrcR5q79bE3KUOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/262] s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL
Date: Mon, 13 Oct 2025 16:42:46 +0200
Message-ID: <20251013144327.003386087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index ead8d9ba9032c..a88d53fe87743 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1775,13 +1775,6 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
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
@@ -1807,6 +1800,22 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
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



