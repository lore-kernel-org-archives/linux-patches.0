Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1F22C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE568C433EF;
	Tue,  7 Feb 2023 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775674;
	bh=jEIoTRgOzjgIaneIfD0c2qqBpwTDDmZO80CD6QZlwjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtY6tzOaqz9yCtO+IlMQ1SomFsteusDJpCfERKM9Bnrb7BLT5vcrrIjmMIoUh/n2U
	 N9wRjhSW90ejKYKXEUazY+LbkWa8pZxNzyarz2lC7xtw96mQqJDma/2AwB/cXyiECw
	 OfBw0iLhkOS46yTXAWp8uRHL6bJEuBcMVqv+P3ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com,
	Hao Sun <sunhao.th@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.15 120/120] bpf: Skip invalid kfunc call in backtrack_insn
Date: Tue,  7 Feb 2023 13:58:11 +0100
Message-Id: <20230207125623.896876762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Sun <sunhao.th@gmail.com>

commit d3178e8a434b58678d99257c0387810a24042fb6 upstream.

The verifier skips invalid kfunc call in check_kfunc_call(), which
would be captured in fixup_kfunc_call() if such insn is not eliminated
by dead code elimination. However, this can lead to the following
warning in backtrack_insn(), also see [1]:

  ------------[ cut here ]------------
  verifier backtracking bug
  WARNING: CPU: 6 PID: 8646 at kernel/bpf/verifier.c:2756 backtrack_insn
  kernel/bpf/verifier.c:2756
	__mark_chain_precision kernel/bpf/verifier.c:3065
	mark_chain_precision kernel/bpf/verifier.c:3165
	adjust_reg_min_max_vals kernel/bpf/verifier.c:10715
	check_alu_op kernel/bpf/verifier.c:10928
	do_check kernel/bpf/verifier.c:13821 [inline]
	do_check_common kernel/bpf/verifier.c:16289
  [...]

So make backtracking conservative with this by returning ENOTSUPP.

  [1] https://lore.kernel.org/bpf/CACkBjsaXNceR8ZjkLG=dT3P=4A8SBsg0Z5h5PWLryF5=ghKq=g@mail.gmail.com/

Reported-by: syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20230104014709.9375-1-sunhao.th@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2261,6 +2261,12 @@ static int backtrack_insn(struct bpf_ver
 		if (opcode == BPF_CALL) {
 			if (insn->src_reg == BPF_PSEUDO_CALL)
 				return -ENOTSUPP;
+			/* kfunc with imm==0 is invalid and fixup_kfunc_call will
+			 * catch this error later. Make backtracking conservative
+			 * with ENOTSUPP.
+			 */
+			if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL && insn->imm == 0)
+				return -ENOTSUPP;
 			/* regular helper call sets R0 */
 			*reg_mask &= ~1;
 			if (*reg_mask & 0x3f) {


