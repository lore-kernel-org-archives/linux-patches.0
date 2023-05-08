Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D5B171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F74C433D2;
	Mon,  8 May 2023 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545878;
	bh=OrrDlX8tSZIijlYQCB+sDHbrKW8r9LXYPulAZiQagNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4ett6P6R184jcnUdcWxX6b1l6hVS35szFQQ7G2UdZdPnzYWTT3s08VnC9pyp6sSA
	 g0PImus05V7/Xl8nVgdO5nuXH+ic2h0gD4OCa+vT9oIAllBNvSs3RNXuSKDPqAVfzA
	 bfmJz45183VlpyxRw6E/0wjHRF5YsIoNL65pQsVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <quentin@isovalent.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/371] bpftool: Fix bug for long instructions in program CFG dumps
Date: Mon,  8 May 2023 11:46:24 +0200
Message-Id: <20230508094819.405650495@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 67cf52cdb6c8fa6365d29106555dacf95c9fd374 ]

When dumping the control flow graphs for programs using the 16-byte long
load instruction, we need to skip the second part of this instruction
when looking for the next instruction to process. Otherwise, we end up
printing "BUG_ld_00" from the kernel disassembler in the CFG.

Fixes: efcef17a6d65 ("tools: bpftool: generate .dot graph from CFG information")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/r/20230405132120.59886-3-quentin@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/xlated_dumper.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index f1f32e21d5cd0..b91c62d0a7d62 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -369,8 +369,15 @@ void dump_xlated_for_graph(struct dump_data *dd, void *buf_start, void *buf_end,
 	struct bpf_insn *insn_start = buf_start;
 	struct bpf_insn *insn_end = buf_end;
 	struct bpf_insn *cur = insn_start;
+	bool double_insn = false;
 
 	for (; cur <= insn_end; cur++) {
+		if (double_insn) {
+			double_insn = false;
+			continue;
+		}
+		double_insn = cur->code == (BPF_LD | BPF_IMM | BPF_DW);
+
 		printf("% 4d: ", (int)(cur - insn_start + start_idx));
 		print_bpf_insn(&cbs, cur, true);
 		if (cur != insn_end)
-- 
2.39.2



