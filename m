Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1562527781E;
	Tue, 12 Aug 2025 19:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025758; cv=none; b=YkwvJwyqh+9Gmgb2BaDak1BH2E1uNxTRb6Phgxf9fJ7dYXptqDTkLl9qMaygatrGRH3a1Y8KCdjhj7/PMzKRdBOoBEKOb3nIPPPuxf21zXqqP9V6kNJi07rPW4VMGKFtvZSV0VyCPHyyebqURsnIg+vWlLmEDjo+88Eh/e72NY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025758; c=relaxed/simple;
	bh=3I1GjrN00Gjwm+SL8vQTzCwF/um5XQ1YSFocNWdjNFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fglsAEWXx/WmZ5s0d7jvNtGKa8J/CwYBZa7qrNNqHDIF2bngWj1Qk5Oe4QZWcLCWIE3M/lijsAPtHb3gMqQgXRjkLl2tJGwgYYCV2sCc4p7/zOfGN57HiZcW1k590nm/NJM4/FWNmDiw/PD0LllUYkMhlQGPNimYH2BGXsruoWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3eoAIXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3eoAIXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E51C4CEF0;
	Tue, 12 Aug 2025 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025755;
	bh=3I1GjrN00Gjwm+SL8vQTzCwF/um5XQ1YSFocNWdjNFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3eoAIXrS4dGT7cWsVqGnvJjrGHyRIT7Q2esyj2S7cAOWvacotco4pULX3mc/P+aI
	 MhOpiLbJco3MdVkIrXJ4Lfqsyhr/l2MiFGDGonf+RamnlchcFFvZAIJ/fpXu97Woku
	 5hDEcOzmiXByg0EoInxSc0T4RRhgOG9VaoUv7Fmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/480] bpf: Ensure RCU lock is held around bpf_prog_ksym_find
Date: Tue, 12 Aug 2025 19:45:42 +0200
Message-ID: <20250812174403.055602307@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit d090326860096df9dac6f27cff76d3f8df44d4f1 ]

Add a warning to ensure RCU lock is held around tree lookup, and then
fix one of the invocations in bpf_stack_walker. The program has an
active stack frame and won't disappear. Use the opportunity to remove
unneeded invocation of is_bpf_text_address.

Fixes: f18b03fabaa9 ("bpf: Implement BPF exceptions")
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20250703204818.925464-5-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c    |  5 ++++-
 kernel/bpf/helpers.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c20babbf998f..93e49b0c218b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -778,7 +778,10 @@ bool is_bpf_text_address(unsigned long addr)
 
 struct bpf_prog *bpf_prog_ksym_find(unsigned long addr)
 {
-	struct bpf_ksym *ksym = bpf_ksym_find(addr);
+	struct bpf_ksym *ksym;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	ksym = bpf_ksym_find(addr);
 
 	return ksym && ksym->prog ?
 	       container_of(ksym, struct bpf_prog_aux, ksym)->prog :
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 52d02bc0abb2..3312442bc389 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2864,9 +2864,16 @@ static bool bpf_stack_walker(void *cookie, u64 ip, u64 sp, u64 bp)
 	struct bpf_throw_ctx *ctx = cookie;
 	struct bpf_prog *prog;
 
-	if (!is_bpf_text_address(ip))
-		return !ctx->cnt;
+	/*
+	 * The RCU read lock is held to safely traverse the latch tree, but we
+	 * don't need its protection when accessing the prog, since it has an
+	 * active stack frame on the current stack trace, and won't disappear.
+	 */
+	rcu_read_lock();
 	prog = bpf_prog_ksym_find(ip);
+	rcu_read_unlock();
+	if (!prog)
+		return !ctx->cnt;
 	ctx->cnt++;
 	if (bpf_is_subprog(prog))
 		return true;
-- 
2.39.5



