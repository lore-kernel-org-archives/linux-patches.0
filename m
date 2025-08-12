Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD8191F98;
	Tue, 12 Aug 2025 18:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023781; cv=none; b=rD7DO7muayIW4Y0FYi4EV5dvu/ARLyTltUfx4K1Dec+X6W0BZx5G964fCCRK/8+uGWJo5pKxUPdEvEXxqMckuRIi/feJd0jApQ2p67Zad/qHWyi+d0Ifthg/nrWAEOtc+43N9p9+9+xdzhrhNAP+7ue/Of6J4rCl8sXOeT0+dWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023781; c=relaxed/simple;
	bh=9SI4eOEPRQim2rUh7ZaIndqwfHH1eVvyujKbyWkB3IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXzpVwrw9QbMKh1yNxAiiwYShK52mQOaQl7BAO2UZ3DAjg6WYF7v3EZL/065rGkxd1HYPlXH5wNo0mdOMyN8SddOBSyNBH5OzckWxYlm/keH9Pz28TE1guQxdMN0MbfUUXeSmfp8a3dDV6iNnss+wE9HSfmum4SsntjuZB1vk50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwoLiqWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwoLiqWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405EDC4CEF0;
	Tue, 12 Aug 2025 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023781;
	bh=9SI4eOEPRQim2rUh7ZaIndqwfHH1eVvyujKbyWkB3IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwoLiqWwZA5vqYZgDO4l+sgWaEtV1ILYS/Ya28fOQxs/4rLMb9EsNF6pOiEaUT4S0
	 ZAb+EcdOfWGFAUOjk3Nrr8xqMPhpONs4+sx/MFpM9NzBk4nMXt4Cs4xCSzoQmSNqSx
	 /jSgvj9RXcaxGr7luYCjnX+wfYHSBQ2OgOtlUsVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 180/627] bpf: Ensure RCU lock is held around bpf_prog_ksym_find
Date: Tue, 12 Aug 2025 19:27:55 +0200
Message-ID: <20250812173426.128627677@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index ad6df48b540c..fdf8737542ac 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2943,9 +2943,16 @@ static bool bpf_stack_walker(void *cookie, u64 ip, u64 sp, u64 bp)
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



