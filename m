Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BC22F9480;
	Tue, 17 Jun 2025 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177562; cv=none; b=dK05/OY+oPBHRwjgVKP2o4BbgPVn3CpklUqOSVZ85cQKY5IvBT1RjFsIXhY86kVHfxYxjh+AIZNEZ4cF+3wCipBIstS5OnhuHGP/IFxxIG3M9JBWj9NeLBM1gKWEyxpYFnTPs6xDAZtt1xasPXXXfwXq0nAh9FA6GgG5vKACIj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177562; c=relaxed/simple;
	bh=Go42wSt0BNIH07fc2nZnSFUtVKFDYrIoNnFVNtu+phQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dedOFXHOhivHLxlofgjghl5UYJMNdWfUxAl7g+/YqJgBe/TVflefxEtkapjG/UEyt4LqE1vk9hP9ZtUByFkGyaULOCJi88owJUUfi22W8ruPXJgJ/9IBYlltU87ZXu5svv8TggziBChjbz9wX1Keen+uuGfVt96Mw+CWIOy1LAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T145qwEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T145qwEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68A6C4CEE3;
	Tue, 17 Jun 2025 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177562;
	bh=Go42wSt0BNIH07fc2nZnSFUtVKFDYrIoNnFVNtu+phQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T145qwEEn1/M0QP2fwlV6nzyX0c2g2Gt2lTl3WaeWcbNafHWg6miLs3Yx241vXUYr
	 iacfkJewVHLWLHgGiOT52bwKET+Ff5Dd0rO3RePaLYxwvqnv/u9P2z+x0wlSjHYYv5
	 T+vbDBmvublb/W0Iph43b3nec1NiG/z3w0tCoyAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0903f6d7f285e41cdf10@syzkaller.appspotmail.com,
	KaFai Wan <mannkafai@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 324/780] bpf: Avoid __bpf_prog_ret0_warn when jit fails
Date: Tue, 17 Jun 2025 17:20:32 +0200
Message-ID: <20250617152504.645728973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a3e5716884211..c20babbf998f4 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2474,7 +2474,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	/* In case of BPF to BPF calls, verifier did all the prep
 	 * work with regards to JITing, etc.
 	 */
-	bool jit_needed = false;
+	bool jit_needed = fp->jit_requested;
 
 	if (fp->bpf_func)
 		goto finalize;
-- 
2.39.5



