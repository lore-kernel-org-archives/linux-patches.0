Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E718D630;
	Thu, 15 Aug 2024 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730084; cv=none; b=td2FibY8PzpuDTFDpoNfLJ3UqEXl930vESfCuc8q6z1q/gr1CdrVrCjwUsQr7P1qqSmfIPBBGqG+hXYE29DbV9P/KEYGgcVjN+kAZ06Sq07cPxlQuyZVuSYUttnO/286j4FLSROO75lCBVlLrMp6sab9M7aucNikqBVbGz6b6M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730084; c=relaxed/simple;
	bh=GT2SSdGaTUmbNR6ukWX73Q98KDBPoTkHd32XV8bgqKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEcm19ux7h3Twpguus9S66H8rU6RXzl0NCGKo7b36Hrw2jUbAAMWr7DJMG1O/7+AdFK7JVrbebZGDQA+otrXQSapDSFxwKZMDZ/n2hLuSO0Ak9NoFjD9zt5rU9OyEIEAqfny1UiHVjQCuYmIE0rAsw3LRQnX73+R0pV62ECXB4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXYZV44y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXYZV44y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D57FC32786;
	Thu, 15 Aug 2024 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730084;
	bh=GT2SSdGaTUmbNR6ukWX73Q98KDBPoTkHd32XV8bgqKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXYZV44ynB5z0RNWm6QnJu54MQ1ecaw+KFn9tr/9FKWj22eMgL8j5wsW7ugXNy/xJ
	 cJlFTXzOtDAut1L+IrXBezRFH7FKhmY1m1+5swJOORhICJG7mfAxFBdzke0sXdYqK+
	 0/zhQd2uwXh32iq0IO+5kYxKvHp8QyplUFRhHb9U=
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
Subject: [PATCH 5.15 269/484] bpf, events: Use prog to emit ksymbol event for main program
Date: Thu, 15 Aug 2024 15:22:07 +0200
Message-ID: <20240815131951.793192871@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/events/core.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9194,21 +9194,19 @@ static void perf_event_bpf_emit_ksymbols
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
+	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF,
+			   (u64)(unsigned long)prog->bpf_func,
+			   prog->jited_len, unregister,
+			   prog->aux->ksym.name);
 
-			perf_event_ksymbol(
-				PERF_RECORD_KSYMBOL_TYPE_BPF,
-				(u64)(unsigned long)subprog->bpf_func,
-				subprog->jited_len, unregister,
-				subprog->aux->ksym.name);
-		}
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
 


