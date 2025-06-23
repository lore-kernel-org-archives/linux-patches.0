Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188591ACEDA;
	Mon, 23 Jun 2025 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713111; cv=none; b=nNH4/9GK2hF7FUY+YNu9TJTUGkP/A9b8tLTAF7acf8xc3Tdqzl9XsTvxaURFABGtYpFR31XBcQpmXjDC+2FZSyz2KJvRnPMPKSY5dRxqYf5bA8YJXHbdL2xevqSYnfceUbenTXo9iKWEwl03mljLArvKgJrt6884qu8Rhn7Eyoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713111; c=relaxed/simple;
	bh=Nk5500ky838XpibLHOrhzdjmTvVDrPt3MazQ2N5dzaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmVcccl+RTAm7j1JkcPeKF17ntmOYAoEb7WL0fFPTsk00Bvmrzi0Q4uVzwKZ6ZG3amlgCJzsaZk5MhirYk+S+JB3W5Y/Wv/1qdxmEXhherTsgJAXGOPKAOIJXkRnPhsuhjZPHmaHVw1wWWtepzcwAPAPQRIibbf6qRfx1AT2jDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvpALvsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvpALvsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32B7C4CEEA;
	Mon, 23 Jun 2025 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713111;
	bh=Nk5500ky838XpibLHOrhzdjmTvVDrPt3MazQ2N5dzaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvpALvsAUcfthZ0dEBDewwLRmCBlqdGHJm7rp+FIjG+nZ2myxgpVqiku6sTxJOFkQ
	 ya/qj3gG8mu53llbNo15p9LAd1x1FQjWiYTl1+8Y3sCN0o/gXJ8jOre94Tj23RvJ9a
	 CR2giLdLWPkI6Y01aF8V2AoB9jL3sUg+Wy0WcNKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0903f6d7f285e41cdf10@syzkaller.appspotmail.com,
	KaFai Wan <mannkafai@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/508] bpf: Avoid __bpf_prog_ret0_warn when jit fails
Date: Mon, 23 Jun 2025 15:02:23 +0200
Message-ID: <20250623130647.682689238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: KaFai Wan <mannkafai@gmail.com>

[ Upstream commit 86bc9c742426a16b52a10ef61f5b721aecca2344 ]

syzkaller reported an issue:

WARNING: CPU: 3 PID: 217 at kernel/bpf/core.c:2357 __bpf_prog_ret0_warn+0xa/0x20 kernel/bpf/core.c:2357
Modules linked in:
CPU: 3 UID: 0 PID: 217 Comm: kworker/u32:6 Not tainted 6.15.0-rc4-syzkaller-00040-g8bac8898fe39
RIP: 0010:__bpf_prog_ret0_warn+0xa/0x20 kernel/bpf/core.c:2357
Call Trace:
 <TASK>
 bpf_dispatcher_nop_func include/linux/bpf.h:1316 [inline]
 __bpf_prog_run include/linux/filter.h:718 [inline]
 bpf_prog_run include/linux/filter.h:725 [inline]
 cls_bpf_classify+0x74a/0x1110 net/sched/cls_bpf.c:105
 ...

When creating bpf program, 'fp->jit_requested' depends on bpf_jit_enable.
This issue is triggered because of CONFIG_BPF_JIT_ALWAYS_ON is not set
and bpf_jit_enable is set to 1, causing the arch to attempt JIT the prog,
but jit failed due to FAULT_INJECTION. As a result, incorrectly
treats the program as valid, when the program runs it calls
`__bpf_prog_ret0_warn` and triggers the WARN_ON_ONCE(1).

Reported-by: syzbot+0903f6d7f285e41cdf10@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/6816e34e.a70a0220.254cdc.002c.GAE@google.com
Fixes: fa9dd599b4da ("bpf: get rid of pure_initcall dependency to enable jits")
Signed-off-by: KaFai Wan <mannkafai@gmail.com>
Link: https://lore.kernel.org/r/20250526133358.2594176-1-mannkafai@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c281f5b8705e1..2ed1d00bede0b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2209,7 +2209,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	/* In case of BPF to BPF calls, verifier did all the prep
 	 * work with regards to JITing, etc.
 	 */
-	bool jit_needed = false;
+	bool jit_needed = fp->jit_requested;
 
 	if (fp->bpf_func)
 		goto finalize;
-- 
2.39.5



