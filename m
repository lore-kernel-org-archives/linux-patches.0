Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71613184549;
	Tue, 30 Jul 2024 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358631; cv=none; b=j9pNRxBGbPAb0T1g9gWMBmE9t7hRiLuJqgOvigx+bAo1XXMb3Pnqm6Ebw3CXxBZaKJyuW8xJqFqIthp9nTWKQ+BSzu32YCL+PZzcD8B/G2nIYAvSeWOPB447WN2CK1Dk3GuaqUSBXliU4aF14gZqddU68TdH2Ltt9tXTgz7soL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358631; c=relaxed/simple;
	bh=Rvic1+ZSOSKOX0iZo5Aj1KVFve6F7xPV1dN5jbr0rX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyVWYpTeyM70VyEJJjIocwD0A3JcaFqBI5v23QBvvjiJWxMufysfmnB/RUgnrG408zAKaJISYMs6gxl48mTr1E6cEJo4HVyPKPIRV9uc6gKjLyUcyG7VO7/3XnvMnaHOBOYJ8OdfmDoJZdo0449jZgBPk2loa+jaV61MFE36dpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZq5DIo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZq5DIo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F1C32782;
	Tue, 30 Jul 2024 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358631;
	bh=Rvic1+ZSOSKOX0iZo5Aj1KVFve6F7xPV1dN5jbr0rX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZq5DIo6CrM/lsy0Kd3tLqTdkRjUOjVdJhmBpVjAgFkhs2lzfsTrBeKItY5PbtlX5
	 RuWQx8q6p5VnPuINX9mcoMyaVLDLjRaIbXj5wZ1Bne1Ok3oeGe/eIGR0DLJnMnWG/n
	 x8JlViSagrEhllGyluc7iMFtlVqDUkz/NbX1yi2M=
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
Subject: [PATCH 6.1 408/440] bpf, events: Use prog to emit ksymbol event for main program
Date: Tue, 30 Jul 2024 17:50:41 +0200
Message-ID: <20240730151631.731617291@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b8333b8e6a782..d92ee56a2a768 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9097,21 +9097,19 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
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



