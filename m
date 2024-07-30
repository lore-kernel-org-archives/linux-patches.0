Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B191A76D4;
	Tue, 30 Jul 2024 17:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359765; cv=none; b=GDzQ7md0JK5CRzqoYCCxZaG9XZn/ZknrQT81K8iCK/3Rc9teaUuLgV42k72Mmc5QzVlpBwUFauZ3D0KWck60Jery60G12/d3dxbdpAnZxljvWAcWqBfrZn0nnJrAOE7hz6DUDlnpZNK/V3TCrDCo2MDoiiLBgZvCObwO19FWSO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359765; c=relaxed/simple;
	bh=HhWgQsg9uJpQsfycDU18WGuGyBUl5nO34UU/NaQd9L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXjJpvds7slr8IHOuw72lj99Ao0MwCR0Qv/peg9KnCdcKRJHUb34CglBLZvYdXkZBAEvmXzPpyfTzK6bZNd59Fr23YKX0v4hX62oOslou/buy/IB+mzdR0ubobI5HvBxGX30Wn4eQcoXSvzSlwfkbDYcCaQ0bMQk+7PfUkiPLMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAzvl5EW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAzvl5EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51620C32782;
	Tue, 30 Jul 2024 17:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359765;
	bh=HhWgQsg9uJpQsfycDU18WGuGyBUl5nO34UU/NaQd9L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAzvl5EWvtAiERuhLmNkHnUtPOpp6yuDgAMm7At48T8H2duptvAuUAvaU5XdtZedT
	 dqnDi+kqrmuHnoWLktqwRkEH/6z/IzMJm71/d0tkQAYRX5PEY2wDPFU/dkXJdSJ9MO
	 u/rjEo6uq74EMVPdpe1qilCo25rGlNvsk0ghw98U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Krister Johansen <kjlx@templeofstupid.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 533/568] bpf, events: Use prog to emit ksymbol event for main program
Date: Tue, 30 Jul 2024 17:50:40 +0200
Message-ID: <20240730151700.988381052@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 0be9ae5486cd9e767138c13638820d240713f5f1 ]

Since commit 0108a4e9f358 ("bpf: ensure main program has an extable"),
prog->aux->func[0]->kallsyms is left as uninitialized. For BPF programs
with subprogs, the symbol for the main program is missing just as shown
in the output of perf script below:

 ffffffff81284b69 qp_trie_lookup_elem+0xb9 ([kernel.kallsyms])
 ffffffffc0011125 bpf_prog_a4a0eb0651e6af8b_lookup_qp_trie+0x5d (bpf...)
 ffffffff8127bc2b bpf_for_each_array_elem+0x7b ([kernel.kallsyms])
 ffffffffc00110a1 +0x25 ()
 ffffffff8121a89a trace_call_bpf+0xca ([kernel.kallsyms])

Fix it by always using prog instead prog->aux->func[0] to emit ksymbol
event for the main program. After the fix, the output of perf script
will be correct:

 ffffffff81284b96 qp_trie_lookup_elem+0xe6 ([kernel.kallsyms])
 ffffffffc001382d bpf_prog_a4a0eb0651e6af8b_lookup_qp_trie+0x5d (bpf...)
 ffffffff8127bc2b bpf_for_each_array_elem+0x7b ([kernel.kallsyms])
 ffffffffc0013779 bpf_prog_245c55ab25cfcf40_qp_trie_lookup+0x25 (bpf...)
 ffffffff8121a89a trace_call_bpf+0xca ([kernel.kallsyms])

Fixes: 0108a4e9f358 ("bpf: ensure main program has an extable")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Yonghong Song <yonghong.song@linux.dev>
Reviewed-by: Krister Johansen <kjlx@templeofstupid.com>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20240714065533.1112616-1-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 32723d53b970b..1b728f3f4b539 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9273,21 +9273,19 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 	bool unregister = type == PERF_BPF_EVENT_PROG_UNLOAD;
 	int i;
 
-	if (prog->aux->func_cnt == 0) {
-		perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF,
-				   (u64)(unsigned long)prog->bpf_func,
-				   prog->jited_len, unregister,
-				   prog->aux->ksym.name);
-	} else {
-		for (i = 0; i < prog->aux->func_cnt; i++) {
-			struct bpf_prog *subprog = prog->aux->func[i];
-
-			perf_event_ksymbol(
-				PERF_RECORD_KSYMBOL_TYPE_BPF,
-				(u64)(unsigned long)subprog->bpf_func,
-				subprog->jited_len, unregister,
-				subprog->aux->ksym.name);
-		}
+	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF,
+			   (u64)(unsigned long)prog->bpf_func,
+			   prog->jited_len, unregister,
+			   prog->aux->ksym.name);
+
+	for (i = 1; i < prog->aux->func_cnt; i++) {
+		struct bpf_prog *subprog = prog->aux->func[i];
+
+		perf_event_ksymbol(
+			PERF_RECORD_KSYMBOL_TYPE_BPF,
+			(u64)(unsigned long)subprog->bpf_func,
+			subprog->jited_len, unregister,
+			subprog->aux->ksym.name);
 	}
 }
 
-- 
2.43.0



