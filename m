Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F94101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B670FC433EF;
	Mon, 15 May 2023 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173436;
	bh=53YffIpCKJJArZLDQiOeo/YoB/OhL7KayjvtOlSRLe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5rt6eFMhj8+abIgUc1N1hCZGgI5IEb61f4vjlRZWT3BlhHpO479jgnyqjgL9yf0n
	 LA5uIQS3NM1N55E7Yzff/0vjzB/lYzTgi8SyFWRPoULR2Xu9T0L6xRxbg/xAVBQFmS
	 qdC9LqgmnxWjGaPO8pLw6ms+TtYdQxwRfrNigSWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <quentin@isovalent.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/282] bpftool: Fix bug for long instructions in program CFG dumps
Date: Mon, 15 May 2023 18:27:51 +0200
Message-Id: <20230515161725.052390064@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
index 5b91ee65a0802..762ca450d1980 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -363,8 +363,15 @@ void dump_xlated_for_graph(struct dump_data *dd, void *buf_start, void *buf_end,
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



